(define (problem Recovery_2_first_prob) (:domain Recovery_2_first)
(:objects 
    WP1 WP2 - WorkPiece
    PA0 PA1 PA2 PA3 PA4 PA5 PAe - Conv1
    PB0 PB1 PB2 PBe - Conv2
    R1 - ramp1
    R2 - ramp2
    R3 - ramp3
    R4 - ramp4
)

(:init
    (point_sequence PA0 PA1 PA2 PA3 PA4 PA5 PAe)
    (point_sequence_2 PB0 PB1 PB2 PBe)
    (on WP1 PA1)
    (on WP2 PA2)
)

(:goal (and
    (in WP1 R4)
    (in WP2 R1)
))
)