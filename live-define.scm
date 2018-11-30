(module live-define (define)
(import (rename scheme (define define0)) (chicken syntax) (chicken memory representation))
(import-for-syntax matchable (chicken base) (chicken memory representation))

(begin-for-syntax
  (define bound?
    (let ((unbound-sym (gensym)))
       (lambda (sym)
         (not (eq? (block-ref sym 0) (block-ref unbound-sym 0))))))
  (define (procedure-sym? s)
    (let ((sym (strip-syntax s)))
      (or (and (bound? sym) (procedure? (block-ref sym 0)))
          (and-let* ((p (assq sym (##sys#current-environment)))
                     (qsym (cdr p)))
         (procedure? (block-ref qsym 0)))))))

(define-syntax define
  (ir-macro-transformer
    (lambda (sexp inject compare)
      (match sexp
        ((_ ((and name (? procedure-sym?)) . args) . body)
         `(mutate-procedure! ,name (lambda (old) (lambda ,args ,@body))))
        ((_ (and name (? procedure-sym?)) ((? (cut compare 'lambda <>)) args . body))
         `(mutate-procedure! ,name (lambda (old) (lambda ,args ,@body))))
        (else
          `(define0 ,@(cdr sexp))))))))
