#lang racket

(provide (all-defined-out))

(require picturing-programs)
(require "common.scm")

(define (draw-mandelbrot canvas config)
  (define *width* '())
  (define *height* '())
  (define *iteration* '())
  (define *scale-weight* '())
  (define *scale-offset* '())
  (define *color-depth* '())
  (define (load-config config)
    (set! *width* (get-assoc-value config 'width))
    (set! *height* (get-assoc-value config 'height))
    (set! *iteration* (get-assoc-value config 'iteration))
    (set! *scale-weight* (get-assoc-value config 'scale-weight))
    (set! *scale-offset* (get-assoc-value config 'scale-offset))
    (set! *color-depth* (eval (get-assoc-value config 'color-depth))))
  (define canvas-dc (send canvas get-dc))
  (define (scaled-x x) (- (* (car *scale-weight*) (/ x *width*)) (car *scale-offset*)))
  (define (scaled-y y) (- (* (cdr *scale-weight*) (/ y *height*)) (cdr *scale-offset*)))
  (define (iterate a z iteration)
    (define z′ (+ (* z z) a))
    (if (or (>= iteration *iteration*) (> (magnitude z′) 2))
        iteration
        (iterate a z′ (+ iteration 1))))
  (define (depth->color depth)
    (let ((c (*color-depth* depth)))
      (make-color (car c) (cadr c) (caddr c))))
  (define (mandelbrot-image)
    (map-image
     (lambda (x y c)
       (let* ([depth (iterate (make-rectangular (scaled-x x) (scaled-y y)) 0 0)]
              [clr (*color-depth* depth)])
         (make-color (car clr) (cadr clr) (caddr clr))))
     (rectangle *width* *height* 'solid 'grey)))
  (load-config config)
  (send canvas-dc draw-bitmap (send (mandelbrot-image) get-bitmap) 0 0))