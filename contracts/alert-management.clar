;; Alert Management Contract
;; This contract manages fraud alerts

(define-data-var admin principal tx-sender)

;; Map to store alerts
(define-map alerts uint { tx-id: (buff 32), pattern-id: uint, reporter: principal, timestamp: uint, status: uint })
(define-data-var alert-count uint u0)

;; Alert status constants
(define-constant STATUS-OPEN u1)
(define-constant STATUS-INVESTIGATING u2)
(define-constant STATUS-RESOLVED u3)
(define-constant STATUS-FALSE-POSITIVE u4)

;; Error codes
(define-constant ERR-NOT-AUTHORIZED u100)
(define-constant ERR-ALERT-NOT-FOUND u101)
(define-constant ERR-INVALID-STATUS u102)

;; Check if caller is admin
(define-private (is-admin)
  (is-eq tx-sender (var-get admin)))

;; Create a new alert
(define-public (create-alert (tx-id (buff 32)) (pattern-id uint) (timestamp uint))
  (let ((alert-id (var-get alert-count)))
    (begin
      (map-set alerts alert-id {
        tx-id: tx-id,
        pattern-id: pattern-id,
        reporter: tx-sender,
        timestamp: timestamp,
        status: STATUS-OPEN
      })
      (var-set alert-count (+ alert-id u1))
      (ok alert-id))))

;; Update alert status
(define-public (update-alert-status (alert-id uint) (new-status uint))
  (let ((alert (map-get? alerts alert-id)))
    (begin
      (asserts! (is-some alert) (err ERR-ALERT-NOT-FOUND))
      (asserts! (or (is-admin) (is-eq tx-sender (get reporter (unwrap-panic alert)))) (err ERR-NOT-AUTHORIZED))
      (asserts! (and (>= new-status STATUS-OPEN) (<= new-status STATUS-FALSE-POSITIVE)) (err ERR-INVALID-STATUS))
      (ok (map-set alerts
                  alert-id
                  (merge (unwrap-panic alert) { status: new-status }))))))

;; Get alert details
(define-read-only (get-alert (alert-id uint))
  (map-get? alerts alert-id))

;; Get total alert count
(define-read-only (get-alert-count)
  (var-get alert-count))
