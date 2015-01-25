#lang racket/base

(provide (rename-out [top #%top]))

(require (for-syntax racket/base
                     racket/match
                     syntax/parse
                     racket/syntax
                     syntax/srcloc
                     ))
(module+ test (require (submod "..") rackunit))

(begin-for-syntax
  (define original-for-check-syntax 'original-for-check-syntax)
  (define (orig stx)
    (syntax-property stx original-for-check-syntax #t))
  (define-syntax-class bd-id
    [pattern id:id #:when (identifier-binding #'id)])
  (define-syntax-class dot-id
    [pattern id:bd-id #:with norm #'id]
    [pattern id:id #:when (regexp-match? #px"^(.+)[.]([^.]+)$" (symbol->string (syntax-e #'id)))
             #:do [(match-define (pregexp #px"^(.+)[.]([^.]+)$"
                                          (list _ a-str b-str))
                     (symbol->string (syntax-e #'id)))]
             #:do [(define a-col  (syntax-column #'id))
                   (define a-pos  (syntax-position #'id))
                   (define a-span (string-length a-str))
                   (define b-col  (+ a-col a-span 1))
                   (define b-pos  (+ a-pos a-span 1))
                   (define b-span (string-length b-str))
                   (define a-src (update-source-location #'id #:column a-col #:position a-pos
                                                         #:span a-span))
                   (define b-src (update-source-location #'id #:column b-col #:position b-pos
                                                         #:span b-span))]
             #:with a:dot-id (orig (format-id #'id "~a" a-str #:source a-src))
             #:with b:bd-id  (orig (format-id #'id "~a" b-str #:source b-src))
             #:with norm (orig (syntax/loc #'id (b a.norm)))]))

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
