#lang scribble/manual

@(require scribble/eval
          (for-label postfix-dot-notation
                     (except-in racket #%top)
                     racket/extflonum
                     racket/format))

@title{postfix-dot-notation}

source code: @url["https://github.com/AlexKnauth/postfix-dot-notation"]

@section{#lang postfix-dot-notation}

@defmodule[postfix-dot-notation #:lang]{
A meta-language like @racketmodname[at-exp] that adds postfix-dot-notation to a
language at the reader level.
}

Code like @racket[a.b] is read as @racket[(b a)], @racket[a.b.c] is read as
@racket[(c (b a))], and so on.

If you want to use an identifier that is supposed to have a dot in it, there are
two cases where dot notation is disabled:
@itemize[
@item{When an identifier is wrapped in @litchar{||}, it is treated just like a
      normal identifier wrapped in @litchar{||}. This means you can still use
      identifiers like @code{|~.a|} from @racketmodname[racket/format] or
      @code{|pi.t|} from @racketmodname[racket/extflonum].}
@item{When an identifier begins with a @litchar{.}, it is treated as a normal
      Identifier.  This means that identifiers like @racket[...]
      and @racket[....] work as normal.}
]

@codeblock{
#lang postfix-dot-notation racket
(define x "hello-world")
x.string->symbol ; 'hello-world
(struct foo (a b c))
(define y (foo 1 2 3))
y.foo-a ; 1
y.foo-b.number->string ; "2"
(parameterize ([error-print-width 10]) ; "(I am a..."
  (|~.a| '(I am a long list that spans more than (error-print-width))))
(match '(1 2 3) ; '(2 3)
  [(list 1 rst ...) rst])
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

