#lang racket

(provide (all-defined-out))

(require racket/draw)
(require "common.scm")

(define (draw-by-ifs canvas config)
  (define *width* '())
  (define *height* '())
  (define *dots* '())
  (define *ifs* '())
  (define a '())
  (define b '())
  (define c '())
  (define d '())
  (define e '())
  (define f '())
  (define p '())
  (define point '())
  (define (load-config config)
    (set! *width* (get-assoc-value config 'width))
    (set! *height* (get-assoc-value config 'height))
    (set! *dots* (get-assoc-value config 'dots))
    (set! *ifs* (get-assoc-value config 'ifs)))
  (define (choose-ifs index sum random-number)
    (define len (- (length *ifs*) 1))
    (define ifs (list-ref *ifs* (min index len)))
    (if (> sum random-number) ifs
        (choose-ifs (+ index 1) (+ sum (car ifs)) random-number)))
  (define (transX x)
    (* (/ (- x -1.0) 2.0) *width*))
  (define (transY y)
    (* (/ (- y 1.0) -2.0) *height*))
  (define (next-point)
    (define u (car point))
    (define v (cdr point))
    (define ifs (cadr (choose-ifs 0 (car (list-ref *ifs* 0)) (random))))
    (set! a (list-ref ifs 0))
    (set! b (list-ref ifs 1))
    (set! c (list-ref ifs 2))
    (set! d (list-ref ifs 3))
    (set! e (list-ref ifs 4))
    (set! f (list-ref ifs 5))
    (cons (+ (* a u) (* b v) e) (+ (* c u) (* d v) f)))
  (define (perform-draw dc)
    (send dc draw-point (transX (car point)) (transY (cdr point)))
    (set! point (next-point)))
  (define (draw-fractal dc dots)
    (if (<= dots 0) '()
        (begin
          (perform-draw dc)
          (draw-fractal dc (- dots 1)))))
  (load-config config)
  (set! point (cons 0 0))
  (draw-fractal (send canvas get-dc) *dots*))

