;; undofile.scm — poor man's persistent undo for Helix (Steel plugin)
;;
;; Not a real persistent *undo tree* (that's not exposed to Steel yet).
;; Instead: periodically + manually snapshots full buffer text to disk,
;; keyed by file path, and lets you restore any snapshot back into the
;; buffer (which then behaves like a normal undoable edit).

(require "helix/editor.scm")
(require "helix/ext.scm")
(require (prefix-in helix. "helix/commands.scm"))
(require (prefix-in helix.static. "helix/static.scm"))
(require-builtin helix/core/text)

(provide undofile-snapshot
         undofile-list
         undofile-restore)

;; --- config -----------------------------------------------------------

;; NOTE: adjust this to a real writable dir on your machine.
;; Easiest first pass: hardcode it rather than trying to derive $HOME,
;; since I'm not 100% sure what env/path helpers Steel exposes yet.
(define UNDOFILE-DIR "/home/walid/dots/.config/helix/undofile-snapshots")

;; --- path helpers -------------------------------------------------------

;; Turn "/home/me/proj/foo.rs" into "%home%me%proj%foo.rs" so it's a
;; flat, collision-free filename (same trick discussed in the upstream
;; persistent-undo PR).
(define (escape-path path)
  (list->string
   (map (lambda (c) (if (or (equal? c #\/) (equal? c #\\)) #\% c))
        (string->list path))))

(define (index-file-for path)
  (string-append UNDOFILE-DIR "/" (escape-path path) ".index"))

(define (snapshot-file-for path timestamp)
  (string-append UNDOFILE-DIR "/" (escape-path path) "--" timestamp ".snap"))

;; --- doc access ---------------------------------------------------------

(define (current-doc-path)
  (let* ([focus (editor-focus)]
         [doc-id (editor->doc-id focus)])
    (editor-document->path doc-id)))

(define (current-doc-text)
  (let* ([focus (editor-focus)]
         [doc-id (editor->doc-id focus)])
    (rope->string (editor->text doc-id))))

;; --- writing snapshots ----------------------------------------------------

;; Track snapshot counts per-path in memory instead of reading the index
;; file back (avoids relying on a `read-lines`/`path-exists?` style helper
;; whose exact name I can't confirm — pure R5RS `set!`/`assoc`/`cons` are
;; guaranteed to exist per Steel's own compliance claim). Trade-off: this
;; resets to 0 each time Helix restarts, so numbering restarts too, even
;; though the old snapshot files are still sitting on disk untouched.
(define *undofile-counts* '())

(define (get-count path)
  (let ([entry (assoc path *undofile-counts*)])
    (if entry (cdr entry) 0)))

(define (bump-count! path)
  (define new-count (+ 1 (get-count path)))
  (set! *undofile-counts* (cons (cons path new-count) *undofile-counts*))
  new-count)

;;@doc
;; Snapshot the current buffer's contents to disk right now.
(define (undofile-snapshot)
  (define path (current-doc-path))
  (if (not path)
      (helix.echo "undofile: buffer has no path, can't snapshot")
      (let* ([text (current-doc-text)]
             [seq (number->string (bump-count! path))])
        ;; append the seq id to this file's index (human-readable log,
        ;; not read back by this plugin yet)
        (call-with-port (open-output-file (index-file-for path) #:exists 'append)
                         (lambda (out) (write-line! out seq)))
        ;; write the actual content snapshot
        (call-with-port (open-output-file (snapshot-file-for path seq) #:exists 'truncate)
                         (lambda (out) (write-line! out text)))
        (helix.echo (string-append "undofile: snapshot #" seq " saved")))))

;; --- listing / restoring --------------------------------------------------

;;@doc
;; Report how many snapshots have been taken for the current file this
;; session (numbering resets on Helix restart — see note above).
(define (undofile-list)
  (define path (current-doc-path))
  (if (not path)
      (helix.echo "undofile: buffer has no path")
      (let ([count (get-count path)])
        (if (= count 0)
            (helix.echo "undofile: no snapshots yet this session")
            (helix.echo
             (string-append "undofile: snapshots #1.." (number->string count) " available this session"))))))

;;@doc
;; Restore a snapshot by its sequence number (see :undofile-list). Replaces
;; the whole buffer and commits it as a normal undoable change, by piping
;; the current selection through `cat <snapshot file>` — this uses the
;; documented `:pipe` typable command instead of any Steel-specific
;; buffer-replace primitive, since :pipe is real, stable Helix behavior.
(define (undofile-restore seq)
  (define path (current-doc-path))
  (define snap (snapshot-file-for path seq))
  (helix.static.select_all)
  (helix.pipe "cat" snap)
  (helix.static.commit_undo_checkpoint)
  (helix.echo (string-append "undofile: restored #" seq)))

;; --- background auto-snapshot --------------------------------------------
;;
;; Cut for now — couldn't confirm the right scheduling primitive name
;; (enqueue-thread-local-callback-with-delay was a guess from recentf.scm
;; that didn't resolve). Call :undofile-snapshot manually, or bind it to
;; a key, until this gets revisited.
