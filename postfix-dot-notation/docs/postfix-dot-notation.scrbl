#lang scribble/manual

@(require scribble/eval
          (for-label (except-in racket #%top) postfix-dot-notation))

@title{postfix-dot-notation}

source code: @url["https://github.com/AlexKnauth/postfix-dot-notation"]

@section{#lang postfix-dot-notation}

@defmodule[postfix-dot-notation #:lang]{
A meta-language like @racketmodname[at-exp] that adds postfix-dot-notation to a
language at the reader level.
}

Code like @racket[a.b] is read as @racket[(b a)], @racket[a.b.c] is read as
@racket[(c (b a))], and so on.

@codeblock{
#lang postfix-dot-notation racket
(define x "hello-world")
x.string->symbol ; 'hello-world
(struct foo (a b c))
(define y (foo 1 2 3))
x.foo-a ; 1
x.foo-b.number->string ; "2"
}

@section{postfix-dot-notation for require}

@defmodule[postfix-dot-notation #:link-target? #f]{
This works through @racket[#%top], not at the reader level, so it only works
when there is an undefined identifier with a dot in it.
}

@with-eval-preserve-source-locations[@examples[
  (require postfix-dot-notation racket/local)
  (let  ([x "hello-world"])
    x.string->symbol)
  (local [(struct foo (a b c))
          (define x (foo 1 2 3))]
    (values x.foo-a
            x.foo-b.number->string))
]]

@defform[(#%top . id)]{
The form that converts undefined identifiers that have dots in them, such as
@racket[a.b] to @racket[(b a)], if @racket[b] is defined and @racket[a] is
either defined or another identifier with a dot that can be converted like this.
}

