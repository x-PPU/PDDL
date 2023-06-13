; in this file also discribe the LSC and PAC in Figure 5.16 on P.54
; the workpiece is different definited
(define (problem Transport_prob) (:domain Transport)
(:objects 
    WP1 WP2 - WorkPiece
    Conv1 Conv2 - Conveyor
    PA1 PA2 PA3 PA4 PA5 PB1 PB2 - Point
)

(:init
    ; product predicates
    (position WP1 PA1)
    (position WP2 PB2)

    ; component state predicates
    (moveforward Conv1)
    (moveforward Conv2)

    ;map constracture
    ;bidirection
    ; (connect PA2 PA1 Conv1)
    ; (connect PA3 PA2 Conv1)
    ; (connect PA4 PA3 Conv1)
    ; (connect PA5 PA4 Conv1)
    ; (connect PB1 PA3 Conv2)
    ; (connect PB2 PB1 Conv2)

    ;one direction
    (next PA1 PA2 Conv1)
    (next PA2 PA3 Conv1)
    (next PA3 PA4 Conv1)
    (next PA4 PA5 Conv1)
    (next PB1 PB2 Conv2)

    (before PA2 PA1 Conv1)
    (before PA3 PA2 Conv1)
    (before PA4 PA3 Conv1)
    (before PA5 PA4 Conv1)
    (before PB1 PA3 Conv2)
    (before PB2 PB1 Conv2)

    (connect PA3 PB1)
)

(:goal (and
    (position WP1 PB2)
    (position WP2 PA3)
    ; the strategy could be generated, but in this seneraio is unreasonable
    ; this mothed could be used in the situation in section 4.2.3
    ; but the example here is conveyor which belongs to APRM(see table 4.2 on P.32)
))

)