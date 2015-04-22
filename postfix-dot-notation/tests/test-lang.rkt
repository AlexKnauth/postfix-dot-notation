#lang postfix-dot-notation sweet-exp racket

require rackunit

define lst.fst ; stort for (fst lst) or fst(lst)
  first(lst)

check-equal?
  let ([lst '(1 2 3)])
    lst.fst
  1

define lst.rmv(x) ; short for ((rmv lst) x) or rmv(lst)(x)
  remove(x lst)

check-equal?
  let ([lst '(1 2 3)])
    lst.rmv(2)
  '(1 3)

check-equal?
  ((rmv '(1 2 3)) 2)
  '(1 3)

define x "hello-world"
check-equal? x.string->symbol
             'hello-world
struct foo (a b c)
define y (foo 1 2 3)
check-equal? y.foo-a 1
check-equal? y.foo-b 2
check-equal? y.foo-c 3
check-equal? y.foo-a.number->string "1"

