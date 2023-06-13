(define (problem xPPU_new_porb) (:domain xPPU_new)
    
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
    (spot_is_free stack)
    (spot_is_free stamp)
    (spot_is_free conveyor)

    ;define distance between reached loc by carrier
    (= (distance stack stamp) 2)
    (= (distance stamp stack) 2)
    (= (distance stack conveyor) 1)
    (= (distance conveyor stack) 1)
    (= (distance stamp conveyor) 1)
    (= (distance conveyor stamp) 1)

    ;stamp intial state
    (cy_stamp_extended)

    ;product initial state
    (in_stack WP1)
    (in_stack WP2)
    )

    (:goal (and
            (in_ramp WP1)
            ;(stamp_finished WP1)
            (in_ramp WP2)
            (stamp_finished WP2)
        )
    )
)