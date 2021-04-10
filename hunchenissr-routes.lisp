(in-package #:hunchenissr-routes)

(push (defrest:create-rest-table-dispatcher) hunchentoot:*dispatch-table*)

(defmacro defroute (pattern varlist &body body)
  (multiple-value-bind (bindings query-params)
      (defrest::parse-varlist varlist)
    (let* ((query-names (map 'list 'first query-params))
           (letlist (mapcar #'(lambda (var)
			                    (if (member var query-names)
                                    `(,var (hunchentoot:get-parameter
                                            ,(string-downcase
                                              (symbol-name var))))
                                    `(,var (gethash ,(symbol-name var) map))))
                            bindings)))
      `(setf (gethash (cons :get ,pattern) defrest::*rest-dispatcher-table*)
	         (defrest::create-rest-dispatcher
              ,pattern :get
              (mapcar (lambda (x)
					    (list (first x) (apply #'defrest::create-query-param-parser x)))
					  ',query-params)
			  (lambda (map)
			    (declare (ignorable map)) ; we dont want a not-used warning on empty lambda-list defrest's
			    (let ,letlist
				  ,(hunchenissr::treat-page body))))))))
