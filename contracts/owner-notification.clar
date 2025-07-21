;; Owner Notification Contract
;; Manages notifications between pet finders and owners

;; Constants
(define-constant CONTRACT-OWNER tx-sender)
(define-constant ERR-NOT-AUTHORIZED (err u200))
(define-constant ERR-NOTIFICATION-NOT-FOUND (err u201))
(define-constant ERR-INVALID-INPUT (err u202))
(define-constant ERR-ALREADY-CONTACTED (err u203))

;; Data Variables
(define-data-var next-notification-id uint u1)

;; Data Maps
(define-map notifications
  { notification-id: uint }
  {
    pet-id: uint,
    finder: principal,
    finder-contact: (string-ascii 100),
    found-location: (string-ascii 100),
    found-date: uint,
    message: (string-ascii 300),
    status: (string-ascii 15),
    created-at: uint
  }
)

(define-map pet-notifications
  { pet-id: uint }
  { notification-ids: (list 20 uint) }
)

(define-map owner-notifications
  { owner: principal }
  { notification-ids: (list 100 uint) }
)

;; Private Functions
(define-private (is-valid-notification-status (status (string-ascii 15)))
  (or
    (is-eq status "pending")
    (is-eq status "contacted")
    (is-eq status "resolved")
    (is-eq status "invalid")
  )
)

;; Public Functions
(define-public (create-notification
  (pet-id uint)
  (finder-contact (string-ascii 100))
  (found-location (string-ascii 100))
  (message (string-ascii 300))
)
  (let
    (
      (notification-id (var-get next-notification-id))
      (finder tx-sender)
    )
    ;; Validate inputs
    (asserts! (> (len finder-contact) u0) ERR-INVALID-INPUT)
    (asserts! (> (len found-location) u0) ERR-INVALID-INPUT)
    (asserts! (> pet-id u0) ERR-INVALID-INPUT)

    ;; Create notification record
    (map-set notifications
      { notification-id: notification-id }
      {
        pet-id: pet-id,
        finder: finder,
        finder-contact: finder-contact,
        found-location: found-location,
        found-date: block-height,
        message: message,
        status: "pending",
        created-at: block-height
      }
    )

    ;; Update pet notifications list
    (let
      (
        (current-notifications (default-to { notification-ids: (list) } (map-get? pet-notifications { pet-id: pet-id })))
        (updated-notifications (unwrap! (as-max-len? (append (get notification-ids current-notifications) notification-id) u20) ERR-INVALID-INPUT))
      )
      (map-set pet-notifications { pet-id: pet-id } { notification-ids: updated-notifications })
    )

    ;; Increment notification ID counter
    (var-set next-notification-id (+ notification-id u1))

    (ok notification-id)
  )
)

(define-public (update-notification-status
  (notification-id uint)
  (new-status (string-ascii 15))
)
  (let
    (
      (notification-data (unwrap! (map-get? notifications { notification-id: notification-id }) ERR-NOTIFICATION-NOT-FOUND))
    )
    ;; Verify caller is finder or contract owner
    (asserts! (or
      (is-eq tx-sender (get finder notification-data))
      (is-eq tx-sender CONTRACT-OWNER)
    ) ERR-NOT-AUTHORIZED)

    ;; Validate status
    (asserts! (is-valid-notification-status new-status) ERR-INVALID-INPUT)

    ;; Update notification
    (map-set notifications
      { notification-id: notification-id }
      (merge notification-data { status: new-status })
    )

    (ok true)
  )
)

(define-public (mark-as-contacted (notification-id uint))
  (let
    (
      (notification-data (unwrap! (map-get? notifications { notification-id: notification-id }) ERR-NOTIFICATION-NOT-FOUND))
    )
    ;; Check current status
    (asserts! (is-eq (get status notification-data) "pending") ERR-ALREADY-CONTACTED)

    (update-notification-status notification-id "contacted")
  )
)

(define-public (resolve-notification (notification-id uint))
  (update-notification-status notification-id "resolved")
)

(define-public (add-owner-notification
  (owner principal)
  (notification-id uint)
)
  (let
    (
      (current-notifications (default-to { notification-ids: (list) } (map-get? owner-notifications { owner: owner })))
      (updated-notifications (unwrap! (as-max-len? (append (get notification-ids current-notifications) notification-id) u100) ERR-INVALID-INPUT))
    )
    ;; Only contract owner can add owner notifications
    (asserts! (is-eq tx-sender CONTRACT-OWNER) ERR-NOT-AUTHORIZED)

    (map-set owner-notifications { owner: owner } { notification-ids: updated-notifications })
    (ok true)
  )
)

;; Read-only Functions
(define-read-only (get-notification (notification-id uint))
  (map-get? notifications { notification-id: notification-id })
)

(define-read-only (get-pet-notifications (pet-id uint))
  (map-get? pet-notifications { pet-id: pet-id })
)

(define-read-only (get-owner-notifications (owner principal))
  (map-get? owner-notifications { owner: owner })
)

(define-read-only (get-pending-notifications-count)
  (var-get next-notification-id)
)
