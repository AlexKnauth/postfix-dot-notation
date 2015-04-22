#lang racket/base

(provide configure)

(require (only-in postfix-dot-notation/reader make-postfix-dot-readtable))

(define (configure data)
  (current-readtable (make-postfix-dot-readtable)))

