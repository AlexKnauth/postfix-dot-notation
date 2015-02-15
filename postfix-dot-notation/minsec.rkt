#lang racket/base

(provide t/min
         t/sec
         top/min
         (for-syntax minsec
                     ))

(require syntax/parse/define
         (for-syntax racket/base
                     syntax/parse
                     racket/match
                     postfix-dot-notation/top-utils
                     ))
(module+ test
  (require rackunit (rename-in (submod "..") [top/min #%top])))

(begin-for-syntax
  (define-syntax-class minsec #:description "minutes:seconds"
    [pattern (~id-regexp #px"^(\\d+):(\\d\\d)$"
                         (list _ (app string->number min) (app string->number sec)))
             #:when (and min sec)
             #:with t/min #`#,(+ min (/ sec 60))
             #:with t/sec #`#,(+ (* 60 min) sec)]))

(define-simple-macro (t/min t:minsec) t.t/min)
(define-simple-macro (t/sec t:minsec) t.t/sec)

(define-syntax top/min
  (syntax-parser
    [(top . t:minsec) #'t.t/min]
    [(top . id:id) #'(#%top . id)]))

(module+ test
  (check-equal? 0:00 0)
  (check-equal? 0:20 1/3)
  (check-equal? 1:20 4/3)
  )
