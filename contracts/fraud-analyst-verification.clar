;; Fraud Analyst Verification Contract
;; This contract validates payment fraud analysts

(define-data-var admin principal tx-sender)

;; Map to store verified analysts
(define-map verified-analysts principal bool)

;; Error codes
(define-constant ERR-NOT-AUTHORIZED u100)
(define-constant ERR-ALREADY-VERIFIED u101)
(define-constant ERR-NOT-VERIFIED u102)

;; Check if caller is admin
(define-private (is-admin)
  (is-eq tx-sender (var-get admin)))

;; Verify a new analyst
(define-public (verify-analyst (analyst principal))
  (begin
    (asserts! (is-admin) (err ERR-NOT-AUTHORIZED))
    (asserts! (is-none (map-get? verified-analysts analyst)) (err ERR-ALREADY-VERIFIED))
    (ok (map-set verified-analysts analyst true))))

;; Revoke analyst verification
(define-public (revoke-verification (analyst principal))
  (begin
    (asserts! (is-admin) (err ERR-NOT-AUTHORIZED))
    (asserts! (is-some (map-get? verified-analysts analyst)) (err ERR-NOT-VERIFIED))
    (ok (map-delete verified-analysts analyst))))

;; Check if an analyst is verified
(define-read-only (is-verified (analyst principal))
  (default-to false (map-get? verified-analysts analyst)))

;; Transfer admin rights
(define-public (transfer-admin (new-admin principal))
  (begin
    (asserts! (is-admin) (err ERR-NOT-AUTHORIZED))
    (ok (var-set admin new-admin))))
