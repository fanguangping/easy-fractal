#lang racket

(provide (all-defined-out))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; stack
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define (make-stack)
  (let ((stack '()))
    (lambda (msg . args)
      (cond 
        [(eq? msg 'pop!)
         (if (null? stack) '()
             (let ((element (car stack)))
               (set! stack (cdr stack))
               element))]
        [(eq? msg 'push!) (set! stack (append (reverse args) stack))]
        [(eq? msg 'stack) stack]
        [else "Not valid message!"]))))

(define (push! stack element)
  (stack 'push! element))

(define (pop! stack)
  (stack 'pop!))

(define (stack-empty? stack)
  (null? (stack 'stack)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; read config
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define (read-config file-path)
  (if file-path (eval (read (open-input-string (file->string file-path))))
      '()))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; get assoc value
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define (get-assoc-value alist key)
  (define p (assoc key alist))
  (if (pair? p) (cdr p)
      p))
