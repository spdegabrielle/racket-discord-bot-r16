#lang racket

(require racket/sandbox)
(provide run)

(define (format-response value stderr)
  (format "~a~a"
          (if (void? value) "" value)
          (if (non-empty-string? stderr)
              (string-append "\n:warning: stderr:\n" stderr)
              "")))

(define (test) (random 5))

(define (init-evaluator text)
  (parameterize ([sandbox-output #f]
                 [sandbox-error-output 'string]
                 [sandbox-propagate-exceptions #f])
    (make-evaluator
     'racket
     `(define message-contents ,text))))

(define (run code text)
  (let* ((evaluator (init-evaluator text))
         (result (evaluator code))
         (stderr (get-error-output evaluator)))
    (kill-evaluator evaluator)
    (format-response result stderr)))