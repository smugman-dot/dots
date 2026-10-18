#!/usr/bin/env python3
# Lightweight screenshot picker for Hyprland.
# Freezes the screen, you drag a region, on release the box expands over the
# whole screen while everything fades out, then the process exits.
# Needs: python-gobject, gtk4, gtk4-layer-shell, grim, wl-clipboard, libnotify
# Run:   /usr/bin/python picker.py     (bind it to Win+S)
import os, sys, json, subprocess, threading, time, math
from pathlib import Path

# layer-shell must be preloaded before libwayland; re-exec once with it set
LIB = "/usr/lib/libgtk4-layer-shell.so"      # adjust if yours lives elsewhere
if LIB not in os.environ.get("LD_PRELOAD", ""):
    os.environ.update(LD_PRELOAD=LIB, GSK_RENDERER="cairo", GTK_A11Y="none")
    os.execv(sys.executable, [sys.executable] + sys.argv)

# freeze the screen right away, before the slow GTK imports and before any overlay exists
FREEZE = "/tmp/picker-freeze.png"
MON = next(m["name"] for m in json.loads(subprocess.check_output(["hyprctl", "-j", "monitors"])) if m["focused"])
subprocess.run(["grim", "-l", "0", "-o", MON, FREEZE], check=True)

import cairo, gi
gi.require_version("Gtk", "4.0")
gi.require_version("Gtk4LayerShell", "1.0")
from gi.repository import Gtk, Gdk, GLib, Gtk4LayerShell as LS

# ---- tweakables ----
ACCENT = (0.796, 0.651, 0.969)   # #cba6f7
DIM = 0.5
CLOSE_MS = 380
RADIUS = 8


def ease(p):                      # InOutCubic
    return 4 * p ** 3 if p < 0.5 else 1 - (-2 * p + 2) ** 3 / 2


def rounded(cr, x, y, w, h, r):
    cr.new_sub_path()
    cr.arc(x + w - r, y + r, r, -math.pi / 2, 0)
    cr.arc(x + w - r, y + h - r, r, 0, math.pi / 2)
    cr.arc(x + r, y + h - r, r, math.pi / 2, math.pi)
    cr.arc(x + r, y + r, r, math.pi, 3 * math.pi / 2)
    cr.close_path()


class Picker(Gtk.Window):
    def __init__(self, app):
        super().__init__(application=app)
        self.remove_css_class("background")
        LS.init_for_window(self)
        LS.set_layer(self, LS.Layer.OVERLAY)
        LS.set_namespace(self, "picker")
        LS.set_keyboard_mode(self, LS.KeyboardMode.EXCLUSIVE)
        LS.set_exclusive_zone(self, -1)
        for edge in (LS.Edge.TOP, LS.Edge.BOTTOM, LS.Edge.LEFT, LS.Edge.RIGHT):
            LS.set_anchor(self, edge, True)
        mons = Gdk.Display.get_default().get_monitors()
        for i in range(mons.get_n_items()):
            if mons.get_item(i).get_connector() == MON:
                LS.set_monitor(self, mons.get_item(i))

        self.img = cairo.ImageSurface.create_from_png(FREEZE)
        os.remove(FREEZE)
        self.a = self.b = None            # drag start / current point
        self.closing = False
        self.e, self.alpha = 0.0, 1.0     # box expansion / overall opacity
        self.t0 = self.target = self.thread = None

        self.area = Gtk.DrawingArea()
        self.area.set_cursor_from_name("crosshair")
        self.area.set_draw_func(self.draw)
        drag = Gtk.GestureDrag()
        drag.connect("drag-begin", self.on_begin)
        drag.connect("drag-update", self.on_update)
        drag.connect("drag-end", self.on_end)
        self.area.add_controller(drag)
        self.area.add_tick_callback(self.tick)
        key = Gtk.EventControllerKey()
        key.connect("key-pressed", self.on_key)
        self.add_controller(key)
        self.set_child(self.area)

    # ---- selection ----
    def sel(self):
        if not self.a:
            return None
        (x0, y0), (x1, y1) = self.a, self.b
        return (min(x0, x1), min(y0, y1), abs(x1 - x0), abs(y1 - y0))

    def rect(self):
        s = self.sel()
        if not s or not self.closing:
            return s
        return tuple(a + (b - a) * self.e for a, b in zip(s, self.target))

    # ---- input ----
    def on_begin(self, g, x, y):
        if not self.closing:
            self.a = self.b = (x, y)

    def on_update(self, g, dx, dy):
        if self.closing or not self.a:
            return
        W, H = self.area.get_width(), self.area.get_height()
        self.b = (min(max(self.a[0] + dx, 0), W), min(max(self.a[1] + dy, 0), H))
        self.area.queue_draw()

    def on_end(self, g, dx, dy):
        s = self.sel()
        if self.closing or not s:
            return
        if s[2] < 3 or s[3] < 3:          # a plain click, not a drag
            self.a = None
            self.area.queue_draw()
            return
        self.begin_close(True)

    def on_key(self, ctl, keyval, keycode, state):
        if keyval == Gdk.KEY_Escape:
            self.begin_close(False)
            return True
        return False

    # ---- closing animation + saving ----
    def begin_close(self, save):
        if self.closing:
            return
        s = self.sel()
        W, H = self.area.get_width(), self.area.get_height()
        self.target = (0, 0, W, H) if save else s
        if save:
            self.thread = self.save(s, W, H)
        self.closing, self.t0 = True, None

    def save(self, s, W, H):
        fx, fy = self.img.get_width() / W, self.img.get_height() / H
        x, y, w, h = (round(v) for v in (s[0] * fx, s[1] * fy, s[2] * fx, s[3] * fy))
        crop = cairo.ImageSurface(cairo.FORMAT_ARGB32, w, h)
        c = cairo.Context(crop)
        c.set_source_surface(self.img, -x, -y)
        c.paint()

        def work():
            d = Path.home() / "Pictures" / "Screenshots"
            d.mkdir(parents=True, exist_ok=True)
            p = d / time.strftime("%F_%H-%M-%S.png")
            crop.write_to_png(str(p))
            with open(p, "rb") as f:
                subprocess.run(["wl-copy", "--type", "image/png"], stdin=f)
            subprocess.run(["notify-send", "-a", "picker", "-i", str(p),
                            "Screenshot taken", "Copied to clipboard"])

        t = threading.Thread(target=work)
        t.start()
        return t

    def tick(self, area, clock):
        if not self.closing:
            return GLib.SOURCE_CONTINUE
        t = clock.get_frame_time()
        if self.t0 is None:
            self.t0 = t
        p = min((t - self.t0) / 1000 / CLOSE_MS, 1.0)
        self.e = ease(p)
        self.alpha = 1 - p ** 3
        area.queue_draw()
        if p >= 1:
            if self.thread:
                self.thread.join()
            self.get_application().quit()
            return GLib.SOURCE_REMOVE
        return GLib.SOURCE_CONTINUE

    # ---- drawing ----
    def paint_img(self, cr, w, h):
        cr.save()
        cr.scale(w / self.img.get_width(), h / self.img.get_height())
        cr.set_source_surface(self.img, 0, 0)
        cr.paint()
        cr.restore()

    def draw(self, area, cr, w, h):
        cr.push_group()
        self.paint_img(cr, w, h)
        cr.set_source_rgba(0, 0, 0, DIM)
        cr.paint()
        r = self.rect()
        if r and r[2] > 0 and r[3] > 0:
            x, y, rw, rh = r
            rounded(cr, x, y, rw, rh, min(RADIUS * (1 - self.e), rw / 2, rh / 2))
            cr.save()
            cr.clip_preserve()            # un-dim the selection
            self.paint_img(cr, w, h)
            cr.restore()
            cr.set_source_rgb(*ACCENT)
            cr.set_line_width(2)
            cr.stroke()
        cr.pop_group_to_source()
        cr.paint_with_alpha(self.alpha)


def activate(app):
    css = Gtk.CssProvider()
    css.load_from_data(b"window { background: transparent; }")
    Gtk.StyleContext.add_provider_for_display(
        Gdk.Display.get_default(), css, Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION)
    Picker(app).present()


app = Gtk.Application(application_id="local.picker")
app.connect("activate", activate)
app.run()
