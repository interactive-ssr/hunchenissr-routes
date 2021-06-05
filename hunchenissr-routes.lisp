(in-package #:hunchenissr-routes)

(defmacro defroute (pattern args &body body)
  (multiple-value-bind (body declarations doc-string)
      (alexandria:parse-body body :documentation t)
    (let* ((split (cl-ppcre:split "/" pattern :omit-unmatched-p t))
           (parts (map 'list
                       (lambda (part)
                         (if (and (< 0 (length part))
                                  (char= #\? (elt part 0)))
                             (intern (string-upcase part))
                             part))
                       split))
           (vars (remove-if
                  'null
                  (map 'list
                       (lambda (part)
                        (when (and (< 1 (length part))
                                   (char= #\? (elt part 0)))
                          (intern (string-upcase (subseq part 1 (length part))))))
                       split)))
           (unified (gensym)))
      `(hunchentoot:define-easy-handler
           (,(intern pattern)
            :uri (lambda (request)
                   (handler-case
                       (unify ',parts (cl-ppcre:split "/" (hunchentoot:script-name request)))
                     (t () nil))))
           ,args
         ,doc-string ,declarations
         (let ((,unified (unify ',parts
                                 (cl-ppcre:split "/" (hunchentoot:script-name*)))))
           (let ,(map 'list
                      (lambda (var part)
                        (list var `(v? ',part ,unified)))
                  vars (remove-if 'stringp parts))
             ,(hunchenissr::treat-page
               (map 'list (lambda (var)
                            (if (consp var)
                                (first var)
                                var))
                    args)
               body)))))))
