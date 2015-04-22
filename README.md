postfix-dot-notation [![Build Status](https://travis-ci.org/AlexKnauth/postfix-dot-notation.png?branch=master)](https://travis-ci.org/AlexKnauth/postfix-dot-notation)
===
A racket meta-language for postfix dot notation

```racket
#lang postfix-dot-notation racket
(define x "hello-world")
x.string->symbol ; 'hello-world
(struct foo (a b c))
(define y (foo 1 2 3))
x.foo-a ; 1
x.foo-b.number->string ; "2"
```

