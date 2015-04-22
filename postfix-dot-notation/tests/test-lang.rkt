#lang postfix-dot-notation sweet-exp racket

require rackunit

define lst.fst
  first(lst)

check-equal?
  let ([lst '(1 2 3)])
    lst.fst
  1

define lst.rmv(x)
  remove(x lst)

check-equal?
  let ([lst '(1 2 3)])
    lst.rmv(2)
  '(1 3)

check-equal?
  ((rmv '(1 2 3)) 2)
  '(1 3)

