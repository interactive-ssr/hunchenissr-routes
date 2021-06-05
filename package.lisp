(defpackage hunchenissr-routes
  (:use #:cl)
  (:import-from #:hunchenissr
                #:*id*
                #:*first-time*
                #:-clients-
                #:clean
                #:ensure-ids
                #:generate-id)
  (:import-from #:cl-unification
                #:v?
                #:unify)
  (:export #:defroute))

  
