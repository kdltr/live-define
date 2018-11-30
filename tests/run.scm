(module test-module (bar)
(import scheme)
(define (bar) #f))

(import (chicken load) test test-module)

(load-relative "../live-define")
(import live-define)

(define (indirect f) (lambda () (f)))
(define (foo) #f)
(define ifoo (indirect foo))
(define (foo) #t)

(test-assert "redefining a toplevel symbol" (ifoo))

(define ibar (indirect bar))
(define (bar) #t)

(test-assert "redefining a module symbol" (ibar))

(test-exit)
