(define (problem Recovery_1) (:domain xPPU )
    (:objects
        WP1 WP2 - WorkPiece
        stack - stack
        stamp - stamp
        conveyor - conveyor
    )

    (:init
    ;stack initial state
    (Separator_extended)
    (available stack)

    ;crane initial state
    (available_crane)
    (crane_at stamp)
    (hand_empty)
    (spot_is_free conveyor)

    ;define distance between reached loc by carrier
    (= (distance stack stamp) 2)
    (= (distance stamp stack) 2)
    (= (distance stack conveyor) 1)
    (= (distance conveyor stack) 1)
    (= (distance stamp conveyor) 1)
    (= (distance conveyor stamp) 1)

    ;product initial state
    (wp_current_position WP1 stack)
    (wp_current_position WP2 stamp)
    )

    (:goal (and
        (s_wpisprovided wp2 stamp)
        (s_wpisprovided wp1 stack)
        )
    )

)