# postfix-dot-notation
postfix dot notation for racket using #%top

```racket
> (require postfix-dot-notation)
> (define x "hello-world")
> x.string->symbol
'hello-world
> (struct foo (a b c))
> (define y (foo 1 2 3))
> y.foo-a
1
> y.foo-b
2
> y.foo-c
3
> y.foo-a.number->string
"1"
```
