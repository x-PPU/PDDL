(define (problem xPPU_old_pro) (:domain xPPU_old )
    
    (:objects
        WP1 WP2 WP3 - WorkPiece
        stack - stack
        stamp - stamp
        conveyor - conveyor
    )

    (:init
    ; stack initial state
    (Separator_extended)

    ; workpiece type
    (WP_metal WP1)
    (WP_light WP2)

    ;crane initial state
    (crane_at stamp)
    (avaliable)
    (hand_empty)
    (loc_empty stack)
    (loc_empty stamp)
    (loc_empty conveyor)

    ; product initial state
    (in_stack WP1)
    (in_stack WP2)
    (in_stack WP3)
    )

    (:goal (and
            (in_ramp WP1)
            (in_ramp WP2)
            (in_ramp WP3)
        )
    )
)