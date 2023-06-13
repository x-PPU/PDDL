(define (problem Recovery_2_fourth_prob) (:domain Recovery_2_fourth)
(:objects 
    WP1 WP2 WP3 - WorkPiece
    P1 P2 P3 P4 P5 - Conv1
    PA PB - Conv2
    R1 - R1
    R2 - R2
    R3 - R3
    R4 - R4
)

(:init
    ;component initial state
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
    
    ;product initial state
    (not_on WP1 P1)
    (not_on WP1 P2)
    (not_on WP1 P3)
    (not_on WP1 P4)
    (not_on WP1 P5)
    (not_on WP1 PA)
    (on WP1 PB)

    (on WP2 P1)
    (not_on WP2 P2)
    (not_on WP2 P3)
    (not_on WP2 P4)
    (not_on WP2 P5)
    (not_on WP2 PA)
    (not_on WP2 PB)

    (not_on WP3 P1)
    (on WP3 P2)
    (not_on WP3 P3)
    (not_on WP3 P4)
    (not_on WP3 P5)
    (not_on WP3 PA)
    (not_on WP3 PB)
)

(:goal (and
    (in WP1 R1)
    (in WP2 R3)
    (in WP3 R4)
))

)
