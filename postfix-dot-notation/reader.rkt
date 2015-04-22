#lang sweet-exp racket/base

provide make-postfix-dot-readtable
        wrap-reader

require racket/match
        syntax/parse/define
        syntax/srcloc

define-simple-macro
  readtable* orig-rt:expr
    key:expr mode:expr action:expr
    ...
  let* ([rt orig-rt]
        [rt make-readtable(orig-rt key mode action)]
        ...)
    rt

define-simple-macro
  def x:id (~datum =) b:expr
  define x b

define make-postfix-dot-readtable([orig-rt current-readtable()])
  define proc
    make-postfix-dot-proc(orig-rt)
  readtable* orig-rt
    #f 'non-terminating-macro proc

define make-postfix-dot-proc(orig-rt)
  define proc(c in src ln col pos)
    define stx
      read-syntax/recursive(src in c orig-rt)
    if identifier?(stx)
       parse-id(stx)
       stx
  proc

define parse-id(stx)
  def col = syntax-column(stx)
  def pos = syntax-position(stx)
  match symbol->string(syntax-e(stx))
    regexp[#px"^(.+)[.]([^.]+)$" list(_ a-str b-str)]
      def a-spn = string-length(a-str)
      def a-srcloc =
        update-source-location stx
          #:span a-spn
      def b-srcloc =
        update-source-location stx
          #:column {col + a-spn + 1}
          #:position {pos + a-spn + 1}
          #:span string-length(b-str)
      def a-id = datum->syntax(stx string->symbol(a-str) a-srcloc stx)
      def b-id = datum->syntax(stx string->symbol(b-str) b-srcloc stx)
      datum->syntax stx `(,b-id ,parse-id(a-id)) stx stx
    else
      stx

define wrap-reader(p)
  lambda args
    parameterize ([current-readtable make-postfix-dot-readtable()])
      apply(p args)

