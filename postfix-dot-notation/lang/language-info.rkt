#lang racket/base

(provide get-language-info)

(define (get-language-info data)
  (lambda (key default)
    (case key
      [(configure-runtime)
       '(#[postfix-dot-notation/lang/runtime-config configure #f])]
      [else default])))

