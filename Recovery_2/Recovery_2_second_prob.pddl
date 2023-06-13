(define (problem Recovery_2_second_prob) (:domain Recovery_2_second)
(:objects 
    WP1 WP2 - WorkPiece
    PA1 PA2 PA3 PA4 PA5 - Conv1
    PB1 PB2 - Conv2
    R1 - R1
    R3 - R3
)

(:init
    ; Product initial state
    (on WP1 PA1)
    (not_on WP1 PA2)
    (not_on WP1 PA3)
    (not_on WP1 PA4)
    (not_on WP1 PA5)
    (not_on WP1 PB1)
    (not_on WP1 PB2)

    (on WP2 PB2)
    (not_on WP2 PA1)
    (not_on WP2 PA2)
    (not_on WP2 PA3)
    (not_on WP2 PA4)
    (not_on WP2 PA5)
    (not_on WP2 PB1)

    ; points features
    (next PA1 PA2)
    (next PA2 PA3)
    (next PA3 PA4)
    (next PA4 PA5)
    (next PA5 PA1)
    (begin PA1)
    (end PA5)

    (begin PB1)
    (end PB2)
)

(:goal (and
    (in WP1 R1)
    (in WP2 R3)
))

)
