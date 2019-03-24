# live-define
Hack to simplify some cases of interactive development.

## Installation
This repository is a [Chicken Scheme](https://call-cc.org/) egg.

It is part of the [Chicken egg index](https://eggs.call-cc.org/5) and can be installed with `chicken-install live-define`.

## Requirements
- matchable

## Documentation
    [macro] (define name (lambda arguments body ...))
    [macro] (define (name arguments) body ...)

A macro that replaces the standard Scheme `define` with one that, when it detects that a procedure is bound to `name`, mutates that procedure in place instead of binding the name to a new procedure.

This is useful in situations where you pass the procedure `name` as an argument to another and want to change it’s behavior while the program is running. For example by using your text editor’s facility to send code to a running instance of csi.

**Please note that this is only intented to be used within the interpreter and will probably break in various ways if used in compiled code**

## Examples
This is a pretty contrived example, but it shows the modified behavior quite well.

Run it with `csi -s example.scm`

``` scheme
(import srfi-18)

;; try commenting this next line to see the standard behavior
(import live-define)

(define (thread-proc thunk)
  (lambda ()
    (let lp ()
      (thread-sleep! 1)
      (thunk)
      (lp))))

(define (the-thunk)
  (print "hi!"))

(thread-start! (thread-proc the-thunk))
;; -> prints "hi!" every second

(thread-sleep! 5)

(define (the-thunk)
  (print "coucou !"))
;; -> thread now prints "coucou !" every second

(thread-sleep! 5)
```

## Version History
### Version 1.1
30 November 2018

- Fix a bug that prevented the redefinition of a symbol imported from a module

### Version 1.0
30 November 2018

- Original release

## Source repository
Source available in [a git repository](https://www.upyum.com/cgit.cgi/live-define/)

Bug reports and patches welcome! Bugs can be reported to kooda@upyum.com

## Authors
Adrien (Kooda) Ramos

## License
Public Domain
