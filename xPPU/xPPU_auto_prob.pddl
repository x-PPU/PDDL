;need to wait about 1 min
(define (problem Auto_mode) (:domain xPPU)
    
    (:objects
        WP1 WP2 WP3 WP4 - WorkPiece
        stack - stack
        stamp - stamp
        conveyor - conveyor
        P1 P2 P3 P4 P5 - Conv1
        PA PB - Conv2
        R1 - R1
        R2 - R2
        R3 - R3
        R4 - R4
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

    ;conveyor intial state
    (available1)
    (available2)

    ;define special points
    (= (position P1) 1)
    (= (position P2) 6)
    (= (position P3) 11)
    (= (position P4) 16)
    (= (position P5) 21)

    (= (position PA) 1)
    (= (position PB) 3)
    
    (next P1 P2)
    (next P2 P3)
    (next P3 P4)
    (next P4 P5)
    (next P5 P1)
    (begin P1)

    (begin PA)
    (next PA PB)

    ;product intial state
    (in_stack WP1)
    (in_stack WP2)
    (in_stack WP3)
    (in_stack WP4)

    (not_on WP1 P1)
    (not_on WP1 P2)
    (not_on WP1 P3)
    (not_on WP1 P4)
    (not_on WP1 P5)
    (not_on WP1 PA)
    (not_on WP1 PB)

    (not_on WP2 P1)
    (not_on WP2 P2)
    (not_on WP2 P3)
    (not_on WP2 P4)
    (not_on WP2 P5)
    (not_on WP2 PA)
    (not_on WP2 PB)

    (not_on WP3 P1)
    (not_on WP3 P2)
    (not_on WP3 P3)
    (not_on WP3 P4)
    (not_on WP3 P5)
    (not_on WP3 PA)
    (not_on WP3 PB)

    (not_on WP4 P1)
    (not_on WP4 P2)
    (not_on WP4 P3)
    (not_on WP4 P4)
    (not_on WP4 P5)
    (not_on WP4 PA)
    (not_on WP4 PB)
    )

    (:goal (and
            (in WP1 R4)
            (stamp_finished WP1)

            (in WP2 R3)

            (in WP3 R2)
            (stamp_finished WP3)

            (in WP4 R1)
        )
    )
)