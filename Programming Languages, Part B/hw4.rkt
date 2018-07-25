
#lang racket

(provide (all-defined-out)) ;; so we can put tests in a second file

;; put your code below
(define sequence (lambda (low high stride)
                   (cond
                   [(> low high) '()]
                   [#t (cons low (sequence (+ low stride) high stride))])))

(define string-append-map (lambda (xs suffix)
                            (map (lambda (x) (string-append x suffix)) xs)))

(define list-nth-mod (lambda (xs n)
                       (letrec ([take (lambda (x lst)
                                        (cond
                                          [(= x 0) (car lst)]
                                          [#t (take (- x 1) (cdr lst))]))])
                         (cond
                           [(< n 0) (error "list-nth-mod: negative number")]
                           [(= (length xs) 0) (error "list-nth-mod: empty list")]
                           [#t (take (remainder n (length xs)) xs)]))))

(define stream-for-n-steps (lambda (s n)
                             (let ([v (s)])
                               (cond
                                 [(= n 0) null]
                                 [#t (cons (car v) (stream-for-n-steps (cdr v) (- n 1)))]))))

(define funny-number-stream
  (letrec ([f (lambda (n) (cons
                           (cond
                             [(= (remainder n 5) 0) (- n)]
                             [#t n])
                           (lambda () (f (+ n 1)))))])
    (lambda ()(f 1))))

(define dan-then-dog
  (letrec ([f (lambda (n)
                (cons
                 (cond
                   [(= (remainder n 2) 0) "dog.jpg"]
                   [#t "dan.jpg"])
                 (lambda () (f (+ n 1)))))])
    (lambda ()(f 1))))

(define stream-add-zero (lambda (s)
                          (lambda ()
                            (let ([v (s)])
                              (cons (cons 0 (car v)) (stream-add-zero (cdr v)))))))

(define cycle-lists
  (lambda (xs ys)
    (letrec ([f (lambda (n)
                  (cons
                   (cons (list-nth-mod xs n) (list-nth-mod ys n))
                   (lambda () (f (+ n 1)))))])
      (lambda () (f 0)))))

(define vector-assoc
  (lambda (v vec)
    (letrec ([scan (lambda (n)
                     (cond
                       [(= n (vector-length vec)) #f]
                       [(not (pair? (vector-ref vec n))) (scan (+ n 1))]
                       [(equal? v (car (vector-ref vec n))) (vector-ref vec n)]
                       [#t (scan (+ n 1))]))])
      (scan 0))))

(define cached-assoc
  (lambda (xs n)
      (letrec ([cache (make-vector n)]
               [pos 0]
               [take (lambda (x lst)
                       (cond
                         [(= x 0) (car lst)]
                         [#t (take (- x 1) (cdr lst))]))])
        (lambda (v)
          (letrec ([cv (vector-assoc v cache)]
                [scan (lambda (n)
                       (cond
                         [(= n (length xs)) #f]
                         [(not (pair? (take n xs))) (scan (+ n 1))]
                         [(equal? v (car (take n xs))) (take n xs)]
                         [#t (scan (+ n 1))]))])
            (cond
              [(equal? #f cv) (let ([rs (scan 0)])
                                (vector-set! cache pos rs)
                                (cond
                                  [(= pos (- (length xs) 1)) (set! pos 0)]
                                  [#t (set! pos (+ pos 1))]) rs)]
              [#t cv]))))))
        
(define-syntax while-less
  (syntax-rules (do)
    [(while-less e1 do e2)
     (letrec ([wl (lambda (one two)
                    (cond
                      [(>= (two) one) #t]
                      [#t (wl one two)]))])
       (wl e1 (lambda () e2)))]))
       
                             