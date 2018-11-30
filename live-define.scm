(module live (define)
(import (rename scheme (define define0)) chicken)
(import-for-syntax matchable chicken)

(define-for-syntax ((procedure-sym? inj) s)
  (procedure? (block-ref (inj s) 0)))

(define-syntax define
  (ir-macro-transformer
    (lambda (sexp inject compare)
      (match sexp
        ((_ ((and name (? (procedure-sym? inject))) . args) . body)
         `(mutate-procedure! ,name (lambda (old) (lambda ,args ,@body))))
        ((_ (and name (? (procedure-sym? inject))) ((? (cut compare 'lambda <>)) args . body))
         `(mutate-procedure! ,name (lambda (old) (lambda ,args ,@body))))
        (else
          `(define0 ,@(cdr sexp))))
         )))
)
(import live)
