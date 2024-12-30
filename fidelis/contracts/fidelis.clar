;; Token-based Loyalty Program Smart Contract

;; Error Constants
(define-constant ERR-UNAUTHORIZED (err u100))
(define-constant ERR-LOW-BALANCE (err u101))
(define-constant ERR-INVALID-QUANTITY (err u102))
(define-constant ERR-REWARD-UNAVAILABLE (err u103))
(define-constant ERR-INVALID-RECIPIENT (err u104))
(define-constant ERR-INVALID-NAME (err u105))

;; Data Maps
(define-map token_balances principal uint)
(define-map reward_catalog uint {name: (string-ascii 50), cost: uint, available: uint})

;; Contract Variables
(define-data-var loyalty_token_name (string-ascii 50) "LoyaltyToken")
(define-data-var loyalty_token_symbol (string-ascii 10) "LYT")
(define-data-var contract_owner principal tx-sender)
(define-data-var reward_id_counter uint u0)

;; Read-only functions
(define-read-only (get-name)
  (ok (var-get loyalty_token_name))
)

(define-read-only (get-symbol)
  (ok (var-get loyalty_token_symbol))
)

(define-read-only (get-balance (user_account principal))
  (ok (default-to u0 (map-get? token_balances user_account)))
)

(define-read-only (get-reward (reward_id uint))
  (map-get? reward_catalog reward_id)
)

;; Public functions
(define-public (transfer (amount uint) (from_account principal) (to_account principal))
  (let ((from_account-balance (default-to u0 (map-get? token_balances from_account))))
    (asserts! (is-eq tx-sender from_account) (err ERR-UNAUTHORIZED))
    (asserts! (<= amount from_account-balance) (err ERR-LOW-BALANCE))
    (asserts! (> amount u0) (err ERR-INVALID-QUANTITY))
    (asserts! (not (is-eq from_account to_account)) (err ERR-INVALID-RECIPIENT))
    
    (map-set token_balances from_account (- from_account-balance amount))
    (map-set token_balances to_account 
      (+ (default-to u0 (map-get? token_balances to_account)) amount))
    (ok true)
  )
)

(define-public (mint (amount uint) (to_account principal))
  (let ((current-balance (default-to u0 (map-get? token_balances to_account))))
    (asserts! (is-eq tx-sender (var-get contract_owner)) (err ERR-UNAUTHORIZED))
    (asserts! (> amount u0) (err ERR-INVALID-QUANTITY))
    
    (map-set token_balances to_account (+ current-balance amount))
    (ok true)
  )
)

(define-public (add-reward (name (string-ascii 50)) (cost uint) (quantity_available uint))
  (let ((reward_id (var-get reward_id_counter)))
    (asserts! (is-eq tx-sender (var-get contract_owner)) (err ERR-UNAUTHORIZED))
    (asserts! (> cost u0) (err ERR-INVALID-QUANTITY))
    (asserts! (> quantity_available u0) (err ERR-INVALID-QUANTITY))
    (asserts! (> (len name) u0) (err ERR-INVALID-NAME))
    
    (map-set reward_catalog reward_id {name: name, cost: cost, available: quantity_available})
    (var-set reward_id_counter (+ reward_id u1))
    (ok reward_id)
  )
)

(define-public (redeem-reward (reward_id uint))
  (let (
    (reward (unwrap! (map-get? reward_catalog reward_id) (err ERR-REWARD-UNAVAILABLE)))
    (user-balance (default-to u0 (map-get? token_balances tx-sender)))
  )
    (asserts! (>= user-balance (get cost reward)) (err ERR-LOW-BALANCE))
    (asserts! (> (get available reward) u0) (err ERR-REWARD-UNAVAILABLE))
    
    (map-set token_balances tx-sender (- user-balance (get cost reward)))
    (map-set reward_catalog reward_id 
      (merge reward {available: (- (get available reward) u1)})
    )
    (ok true)
  )
)

;; Initialize contract
(begin
  (var-set contract_owner tx-sender)
)