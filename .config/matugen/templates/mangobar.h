#ifndef CONFIG_H
#define CONFIG_H

static const char *fontstr = "Maple Mono:style=Bold:size=13";
static const int bar_height = 24;
static const int buffer_scale = 1;
static const int max_title_len = 60;

#define TAG_COUNT 9
static const char *tag_names[TAG_COUNT] = {
    " 1 ", " 2 ", " 3 ", " 4 ", " 5 ", " 6 ", " 7 ", " 8 ", " 9 "
};

/* modules */
#define show_tags            1
#define show_layout          1
#define show_title           1
#define show_cpu             1
#define show_mem             1
#define show_clock           1
#define show_keymode         0
#define show_keyboardlayout  0

#define show_only_occupied_tags 1

#define separator_str "  ·  "

/* ---------- Tags ---------- */

#define active_fg_color_hex     0x{{colors.primary.default.rgba | upper}}
#define active_bg_color_hex     0x{{colors.on_primary.default.rgba | upper}}

#define occupied_fg_color_hex   0x{{colors.on_secondary_container.default.rgba | upper}}
#define occupied_bg_color_hex   0x{{colors.secondary_container.default.rgba | upper}}

#define inactive_fg_color_hex   0x{{colors.outline.default.rgba | upper}}
#define inactive_bg_color_hex   0x{{colors.surface.default.rgba | upper}}

#define empty_fg_color_hex      0x{{colors.outline_variant.default.rgba | upper}}
#define empty_bg_color_hex      0x{{colors.surface.default.rgba | upper}}

#define urgent_fg_color_hex     0x{{colors.on_error.default.rgba | upper}}
#define urgent_bg_color_hex     0x{{colors.error.default.rgba | upper}}

/* ---------- Layout ---------- */

#define layout_fg_color_hex     0x{{colors.secondary.default.rgba | upper}}
#define layout_bg_color_hex     0x{{colors.surface.default.rgba | upper}}

/* ---------- Title ---------- */

#define title_fg_color_hex      0x{{colors.on_surface.default.rgba | upper}}
#define title_bg_color_hex      0x{{colors.surface.default.rgba | upper}}

/* ---------- Right modules ---------- */

#define cpu_fg_color_hex        0x{{colors.primary.default.rgba | upper}}
#define cpu_bg_color_hex        0x{{colors.surface.default.rgba | upper}}

#define mem_fg_color_hex        0x{{colors.tertiary.default.rgba | upper}}
#define mem_bg_color_hex        0x{{colors.surface.default.rgba | upper}}

#define clock_fg_color_hex      0x{{colors.secondary.default.rgba | upper}}
#define clock_bg_color_hex      0x{{colors.surface.default.rgba | upper}}

#define keymode_fg_color_hex    0x{{colors.primary.default.rgba | upper}}
#define keymode_bg_color_hex    0x{{colors.surface.default.rgba | upper}}

#define keyboardlayout_fg_color_hex 0x{{colors.tertiary.default.rgba | upper}}
#define keyboardlayout_bg_color_hex 0x{{colors.surface.default.rgba | upper}}

/* ---------- Overview ---------- */

#define overview_fg_color_hex   0x{{colors.on_primary_container.default.rgba | upper}}
#define overview_bg_color_hex   0x{{colors.primary_container.default.rgba | upper}}

/* ---------- Separators ---------- */

#define separator_fg_color_hex  0x{{colors.outline_variant.default.rgba | upper}}
#define separator_bg_color_hex  0x{{colors.surface.default.rgba | upper}}

/* ---------- Middle ---------- */

#define middle_bg_color_hex      0x{{colors.surface.default.rgba | upper}}
#define middle_bg_sel_color_hex  0x{{colors.surface_container.default.rgba | upper}}

#endif
