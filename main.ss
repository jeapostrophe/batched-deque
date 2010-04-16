#lang scheme
;; Based on http://planet.plt-scheme.org/package-source/soegaard/galore.plt/2/2/batched-deque.scm
;;; batched-dequeue.scm  --  Jens Axel Søgaard

;;; DOUBLE ENDED BATCHED QUEUE

; Reference: Exercise 5.1 in [Oka]. (Hoogerwoord 92)

(define-struct deque (front rear)
  #:property
  prop:sequence
  (lambda (d)
    (make-do-sequence
     (lambda ()
       (values deque-first
               deque-shift
               d
               (lambda (d) (not (deque-empty? d)))
               (lambda (v) #t)
               (lambda (d v) #t))))))

; Invariants
;   1.  q empty         <=>  (empty? (deque-front q))
;   2.  (size q) >= 2   <=>  (and (not (empty? (deque-front q)))
;                                 (not (empty? (deque-rear q)))
;   3.  elements of q  =  (append (deque-front q) (reverse (deque-rear q)))

(define deque-empty (make-deque '() '()))

(define (deque-empty? q)
  (empty? (deque-front q)))

(define (deque-internal-take n f r)
  (if (= n 0)
      (list (reverse f) r)
      (deque-internal-take (sub1 n) (cons (first r) f) (rest r))))

(define (deque-split l)
  (define n (length l))
  (deque-internal-take (quotient n 2) empty l))

(define (check-invariant q)
  (match q
    [(struct deque (f r))
     (cond
       [(and (or (empty? f) 
                 (empty? (rest f))) 
             (empty? r))
        q]
       [(empty? f)
        (let* ([h  (deque-split r)]
               [fh (first h)]
               [sh (second h)])
          (make-deque (reverse sh) fh))]
       ; TODO: This brach is not covered by the test suite !!!
       [(empty? r)
        (let* ([h  (deque-split f)]                    
               [fh (first h)]
               [sh (second h)])
          (make-deque fh (reverse sh)))]
       [else
        q])]))

(define (deque-unshift x q)
  (check-invariant 
   (make-deque (cons x (deque-front q)) 
               (deque-rear q))))

(define (deque-push x q)
  (check-invariant 
   (make-deque (deque-front q) 
               (cons x (deque-rear q)))))

(define (deque-shift q)
  (check-invariant 
   (make-deque (rest (deque-front q))
               (deque-rear q))))

(define (deque-pop q)
  (if (empty? (deque-rear q))
      (check-invariant 
       (deque-shift q))
      (check-invariant 
       (make-deque (deque-front q)
                   (rest (deque-rear q))))))   

(define (deque-last q)
  (cond
    [(empty? (deque-rear q))
     (deque-first q)]
    [else
     (first (deque-rear q))]))

(define (deque-first q)
  (first (deque-front q)))

(define (deque-elements q)
  (append (deque-front q) (reverse (deque-rear q))))

(define (list->deque l)
  (make-deque l empty))

(define (deque-map f q)
  (match q
    [(struct deque (front rear))
     (make-deque (map f front) (map f rear))]))

(define (deque-length d)
  (+ (length (deque-front d))
     (length (deque-rear d))))

(define non-empty-deque/c
  (and/c deque? (not/c deque-empty?)))

(provide/contract
 [deque? (any/c . -> . boolean?)]
 [non-empty-deque/c contract?]
 [deque-empty deque?]
 [deque-empty? (deque? . -> . boolean?)]
 [deque-unshift (any/c deque? . -> . non-empty-deque/c)]
 [deque-push (any/c deque? . -> . non-empty-deque/c)]
 [deque-shift (non-empty-deque/c . -> . deque?)]
 [deque-pop (non-empty-deque/c . -> . deque?)]
 [deque-last (non-empty-deque/c . -> . any/c)]
 [deque-first (non-empty-deque/c . -> . any/c)]
 [deque-elements (deque? . -> . (listof any/c))]
 [deque-map ((any/c . -> . any/c) deque? . -> . deque?)]
 [deque-length (deque? . -> . exact-nonnegative-integer?)])