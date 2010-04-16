#lang scribble/manual
@(require (for-label scheme/base
                     scheme/gui
                     scheme/contract
                     "main.ss"))

@title{Functional Batched Deque}
@author{@(author+email "Jay McCarthy" "jay@plt-scheme.org")}

A functional deque based on Okasaki's work and Jens Axel Søgaard's code.

@defmodule[(planet jaymccarthy/batched-deque)]

@defproc[(deque? [v any/c]) boolean?]

Tests deque-ness.

@defthing[non-empty-deque/c contract?]

A contract for non-empy deques.

@defthing[deque-empty deque?]

An empty deque.

@defproc[(deque-empty? [dq deque?]) boolean?]

Returns true if @scheme[dq] is empty.

@defproc[(deque-unshift [v any/c] [dq deque?]) non-empty-deque/c]

Returns a deque that is the same as @scheme[dq] except that it starts with @scheme[v].

@defproc[(deque-push [v any/c] [dq deque?]) non-empty-deque/c]

Returns a deque that is the same as @scheme[dq] except that it end with @scheme[v].

@defproc[(deque-shift [dq non-empty-deque/c]) deque?]

Returns a deque that is the same as @scheme[dq] except it is missing the first element.

@defproc[(deque-pop [dq non-empty-deque/c]) deque?]

Returns a deque that is the same as @scheme[dq] except it is missing the last element.

@defproc[(deque-last [dq non-empty-deque/c]) any/c]

Returns the last element of @scheme[dq].

@defproc[(deque-first [dq non-empty-deque/c]) any/c]

Returns the first element of @scheme[dq].

@defproc[(deque-elements [dq deque?]) (listof any/c)]

Returns elements of @scheme[dq] as a list.

@defproc[(deque-map [f (-> any/c any/c)] [dq deque?]) deque?]

Maps @scheme[f] over @scheme[dq], returning a new deque.

@defproc[(deque-length [dq deque?]) exact-nonnegative-integer?]

Returns the number of elements in @scheme[dq].