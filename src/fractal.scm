#lang racket

(require racket/gui)
(require racket/file)
(require "common.scm")
(require "lindenmayer-system.scm")
(require "iterated-function-system.scm")
(require "escape-time.scm")
(require "julia.scm")
(require "mandelbrot.scm")

(define (draw menu-item event)
  (define file-path (get-file "open fractal config file" main-frame))
  (define config (read-config file-path))
  (cond
    ((equal? file-path #f)
     '())
    ((equal? (path-get-extension file-path) #".ls")
     (draw-by-lindenmayer-system canvas config))
    ((equal? (path-get-extension file-path) #".ifs")
     (draw-by-iterated-function-system canvas config))
    ((equal? (path-get-extension file-path) #".et")
     (draw-by-escape-time canvas config))
    ((equal? (path-get-extension file-path) #".jl")
     (draw-julia canvas config))
    ((equal? (path-get-extension file-path) #".mb")
     (draw-mandelbrot canvas config))
    (else "Not valid file!")))

(define main-frame
  (new frame%
       [label "Fractal"]
       [width 800]
       [height 600]))

(define panel-canvas
  (new vertical-panel%
       [parent main-frame]
       [style '(border)]
       [alignment '(left top)]))

(define canvas
  (new canvas%
       [parent panel-canvas]))

(define menubar
  (new menu-bar%
       [parent main-frame]))

(define menu-file
  (new menu%
       [label "File"]
       [parent menubar]))
(define menu-item-open
  (new menu-item%
       [label "Open"]
       [parent menu-file]
       [callback draw]))
(define menu-item-exit
  (new menu-item%
       [label "Exit"]
       [parent menu-file]
       [callback
        (lambda (item event)
          (send main-frame on-exit))]))

(send main-frame show #t)
