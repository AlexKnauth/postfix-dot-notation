# postfix-dot-notation
postfix dot notation for racket using #%top

```racket
> (require postfix-dot-notation)
> (struct foo (a b c))
> (define x (foo 1 2 3))
> x.foo-a
1
> x.foo-b
2
> x.foo-c
3
> x.foo-a.number->string
"1"
```
