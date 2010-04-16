#lang scheme
(require tests/eli-tester
         "main.ss")

(define-syntax deque-seq
  (syntax-rules (push unshift)
    [(_) deque-empty]
    [(_ [push v] . rest)
     (deque-push v (deque-seq . rest))]
    [(_ [unshift v] . rest)
     (deque-unshift v (deque-seq . rest))]))

(define (deque-elements* q)
  (for/list ([v q])
    v))

(test
 (deque-empty? deque-empty) => #t
 (deque-empty? (deque-push 1 deque-empty)) => #f
 (deque-empty? (deque-unshift 1 deque-empty)) => #f
 
 (deque-pop deque-empty) =error> "contract"
 (deque-shift deque-empty) =error> "contract"
 (deque-empty? (deque-pop (deque-push 1 deque-empty))) => #t
 (deque-empty? (deque-pop (deque-unshift 1 deque-empty))) => #t
 (deque-empty? (deque-shift (deque-push 1 deque-empty))) => #t
 (deque-empty? (deque-shift (deque-unshift 1 deque-empty))) => #t
 
 (deque-length deque-empty) => 0
 (deque-length (deque-seq [push 1] [push 2] [push 3])) => 3

 (deque-first (deque-seq [push 1] [push 2] [push 3])) => 3
 (deque-first (deque-seq [unshift 1] [unshift 2] [unshift 3])) => 1
 (deque-first (deque-seq [push 1] [unshift 4] [push 2] [push 3])) => 4
 (deque-first (deque-seq [unshift 1] [push 4] [unshift 2] [unshift 3])) => 1
 (deque-first (deque-seq [push 1] [unshift 4] [push 2] [unshift 5] [push 3])) => 4
 (deque-first (deque-seq [unshift 1] [push 4] [unshift 2] [push 5] [unshift 3])) => 1

 (deque-last (deque-seq [push 1] [push 2] [push 3])) => 1
 (deque-last (deque-seq [unshift 1] [unshift 2] [unshift 3])) => 3
 (deque-last (deque-seq [push 1] [unshift 4] [push 2] [push 3])) => 1
 (deque-last (deque-seq [unshift 1] [push 4] [unshift 2] [unshift 3])) => 4
 (deque-last (deque-seq [push 1] [unshift 4] [push 2] [unshift 5] [push 3])) => 1
 (deque-last (deque-seq [unshift 1] [push 4] [unshift 2] [push 5] [unshift 3])) => 4

 (deque-elements (deque-seq [push 1] [push 2] [push 3])) => (list 3 2 1)
 (deque-elements (deque-seq [unshift 1] [unshift 2] [unshift 3])) => (list 1 2 3)
 (deque-elements (deque-seq [push 1] [unshift 4] [push 2] [push 3])) => (list 4 3 2 1)
 (deque-elements (deque-seq [unshift 1] [push 4] [unshift 2] [unshift 3])) => (list 1 2 3 4)
 (deque-elements (deque-seq [push 1] [unshift 4] [push 2] [unshift 5] [push 3])) => (list 4 5 3 2 1)
 (deque-elements (deque-seq [unshift 1] [push 4] [unshift 2] [push 5] [unshift 3])) => (list 1 2 3 5 4)

 (deque-elements* (deque-seq [push 1] [push 2] [push 3])) => (list 3 2 1)
 (deque-elements* (deque-seq [unshift 1] [unshift 2] [unshift 3])) => (list 1 2 3)
 (deque-elements* (deque-seq [push 1] [unshift 4] [push 2] [push 3])) => (list 4 3 2 1)
 (deque-elements* (deque-seq [unshift 1] [push 4] [unshift 2] [unshift 3])) => (list 1 2 3 4)
 (deque-elements* (deque-seq [push 1] [unshift 4] [push 2] [unshift 5] [push 3])) => (list 4 5 3 2 1)
 (deque-elements* (deque-seq [unshift 1] [push 4] [unshift 2] [push 5] [unshift 3])) => (list 1 2 3 5 4)

 (deque-elements (deque-shift (deque-seq [push 1] [push 2] [push 3]))) => (list 2 1)
 (deque-elements (deque-shift (deque-seq [unshift 1] [unshift 2] [unshift 3]))) => (list 2 3)
 (deque-elements (deque-shift (deque-seq [push 1] [unshift 4] [push 2] [push 3]))) => (list 3 2 1)
 (deque-elements (deque-shift (deque-seq [unshift 1] [push 4] [unshift 2] [unshift 3]))) => (list 2 3 4)
 (deque-elements (deque-shift (deque-seq [push 1] [unshift 4] [push 2] [unshift 5] [push 3]))) => (list 5 3 2 1)
 (deque-elements (deque-shift (deque-seq [unshift 1] [push 4] [unshift 2] [push 5] [unshift 3]))) => (list 2 3 5 4)

 (deque-elements (deque-pop (deque-seq [push 1] [push 2] [push 3]))) => (list 3 2)
 (deque-elements (deque-pop (deque-seq [unshift 1] [unshift 2] [unshift 3]))) => (list 1 2)
 (deque-elements (deque-pop (deque-seq [push 1] [unshift 4] [push 2] [push 3]))) => (list 4 3 2)
 (deque-elements (deque-pop (deque-seq [unshift 1] [push 4] [unshift 2] [unshift 3]))) => (list 1 2 3)
 (deque-elements (deque-pop (deque-seq [push 1] [unshift 4] [push 2] [unshift 5] [push 3]))) => (list 4 5 3 2)
 (deque-elements (deque-pop (deque-seq [unshift 1] [push 4] [unshift 2] [push 5] [unshift 3]))) => (list 1 2 3 5)

 )