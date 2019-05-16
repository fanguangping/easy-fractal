#lang racket

(provide (all-defined-out))

(require picturing-programs)
(require "common.scm")

(define (draw-by-escape-time canvas config)
  (define *width* '())
  (define *height* '())
  (define *iterations* '())
  (define *plane-type* '())
  (define *iterate* '())
  (define *boundary* '())
  (define *background* '())
  (define (load-config config)
    (set! *width* (get-assoc-value config 'width))
    (set! *height* (get-assoc-value config 'height))
    (set! *iterations* (get-assoc-value config 'iterations))
    (set! *plane-type* (get-assoc-value config 'plane-type))
    (set! *iterate* (eval (get-assoc-value config 'iterate)))
    (set! *boundary* (eval (get-assoc-value config 'boundary)))
    (set! *background* (rectangle *width* *height* 'solid 'white)))
  (define canvas-dc (send canvas get-dc))
  (define (escape x y n)
    (let ((p (*iterate* x y)))
      (if (or (>= n *iterations*) (*boundary* (car p) (cdr p))) n
          (escape (car p) (cdr p) (+ n 1)))))
  (define (draw-fractal)
    (map-image
     (lambda (x y c)
       (let* ([ref (escape (/ x *width*) (/ y *height*) 0)])
         (cond [(= ref *iterations*) (name->color 'black)]
               [else (name->color 'white)]) ))
     *background*))
  (load-config config)
  (send canvas-dc clear)
  (send canvas-dc draw-bitmap (send (draw-fractal) get-bitmap) 0 0))