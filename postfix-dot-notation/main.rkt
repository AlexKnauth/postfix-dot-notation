#lang racket/base

(provide (rename-out [top #%top]))

(require (for-syntax racket/base
                     racket/match
                     syntax/parse
                     racket/syntax
                     syntax/srcloc
                     "top-utils.rkt"
                     ))
(module+ test (require (submod "..") rackunit))

(begin-for-syntax
  (define-syntax-class dot-id
    [pattern id:bd-id #:with norm #'id]
    [pattern (~id-regexp #px"^(.+)[.]([^.]+)$" (list _ a-str b-str))
             #:do [(define a-col  (syntax-column this-syntax))
                   (define a-pos  (syntax-position this-syntax))
                   (define a-span (string-length a-str))
                   (define b-col  (+ a-col a-span 1))
                   (define b-pos  (+ a-pos a-span 1))
                   (define b-span (string-length b-str))
                   (define a-src (update-source-location this-syntax #:column a-col #:position a-pos
                                                         #:span a-span))
                   (define b-src (update-source-location this-syntax #:column b-col #:position b-pos
                                                         #:span b-span))]
             #:with a:dot-id (orig (format-id this-syntax "~a" a-str #:source a-src))
             #:with b:bd-id  (orig (format-id this-syntax "~a" b-str #:source b-src))
             #:with norm (orig (syntax/loc this-syntax (b a.norm)))]))

(define-syntax top
  (syntax-parser
    [(top . id:dot-id) #'id.norm]
    [(top . id:id) #'(#%top . id)]))

(module+ test
  (struct foo (a b c))
  (define x (foo 1 2 3))
  (check-equal? x.foo-a 1)
  (check-equal? x.foo-b 2)
  (check-equal? x.foo-c 3)
  (check-equal? x.foo-a.number->string.string->symbol '|1|)
  )
