(require "helix/configuration.scm")
(require "cogs/undofile.scm")
(define-lsp "steel-language-server" (command "steel-language-server") (args '()))
(define-language "scheme" (language-servers '("steel-language-server")))
