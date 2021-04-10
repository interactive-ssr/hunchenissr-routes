(defpackage hunchenissr-routes
  (:use #:cl)
  (:import-from #:hunchenissr
                *id*
                *first-time*
                -clients-
                clean
                ensure-ids
                generate-id)
  (:export defroute))

  
