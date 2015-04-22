(module reader racket/base
  (require syntax/module-reader
           (only-in "../reader.rkt" make-postfix-dot-readtable wrap-reader))
  
  (provide (rename-out [postfix-dot-read read]
                       [postfix-dot-read-syntax read-syntax]
                       [postfix-dot-get-info get-info]))
  
  (define-values (postfix-dot-read postfix-dot-read-syntax postfix-dot-get-info)
    (make-meta-reader
     'postfix-dot-notation
     "language path"
     (lambda (bstr)
       (let* ([str (bytes->string/latin-1 bstr)]
              [sym (string->symbol str)])
         (and (module-path? sym)
              (vector
               ;; try submod first:
               `(submod ,sym reader)
               ;; fall back to /lang/reader:
               (string->symbol (string-append str "/lang/reader"))))))
     wrap-reader
     (lambda (orig-read-syntax)
       (define read-syntax (wrap-reader orig-read-syntax))
       (lambda args
         (syntax-property (apply read-syntax args)
                          'module-language
                          '#(postfix-dot-notation/lang/language-info get-language-info #f))))
     (lambda (proc)
       (lambda (key defval)
         (define (fallback) (if proc (proc key defval) defval))
         (case key
           [else (fallback)]))))))
