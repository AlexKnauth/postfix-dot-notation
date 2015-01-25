#lang scribble/manual

@(require scribble/eval
          (for-label (except-in racket #%top) postfix-dot-notation))

@defmodule[postfix-dot-notation]

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
the form that converts undefined identifiers that have dots in them, such as
@racket[a.b] to @racket[(b a)], if @racket[b] is defined and @racket[a] is
either defined or another identifier with a dot that can be converted like this.

So @racket[a.b] expands to @racket[(b a)] if @racket[b] and @racket[a] are defined,
@racket[a.b.c] expands to @racket[(c (b a))] if @racket[c], @racket[b] and
@racket[a] are defined, and so on.
}
