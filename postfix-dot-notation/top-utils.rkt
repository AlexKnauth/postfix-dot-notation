#lang racket/base

(provide (all-defined-out))

(require syntax/parse
         racket/match
         (for-syntax racket/base
                     syntax/parse
                     ))

(define original-for-check-syntax 'original-for-check-syntax)

(define (orig stx)
  (syntax-property stx original-for-check-syntax #t))

(define-syntax-class bd-id
  [pattern id:id #:when (identifier-binding #'id)])

(define-syntax ~id-regexp
  (pattern-expander
   (lambda (stx)
     (syntax-parse stx
       [(id-regexp rx pat)
        #'(~and id:id
                (~do (define str (symbol->string (syntax-e #'id)))
                     (define mtch (regexp-match rx str)))
                (~fail #:unless mtch)
                (~do (match-define pat mtch)))]))))
  
