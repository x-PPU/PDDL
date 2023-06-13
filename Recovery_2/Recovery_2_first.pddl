;this can only run in LPG-td
;this method is a variants of [RNF18]


;the RAM is over limit, can not run 2 conveyor
(define (domain Recovery_2_first)

(:requirements :strips :typing :negative-preconditions)

(:types 
    WorkPiece
    Conv1 Conv2 Conv3 Conv4 False - Point
    ramp1 ramp2 ramp3 ramp4 - Ramp
)

(:predicates ;todo: define predicates here
    (point_sequence ?P0 ?P1 ?P2 ?P3 ?P4 ?P5 ?Pe - Conv1)
    (point_sequence_2 ?P0 ?P1 ?P2 ?Pe - Conv2)

    (on ?WP - WorkPiece ?P - Point)
    (in ?WP - WorkPiece ?ramp - Ramp)
)

(:action Conv1_forward
    :parameters (?P0 ?P1 ?P2 ?P3 ?P4 ?P5 ?Pe - Conv1)
    :precondition (and 
        (point_sequence ?P0 ?P1 ?P2 ?P3 ?P4 ?P5 ?Pe)
        (forall (?WP - WorkPiece) 
            (not (on ?WP ?Pe)))
    )
    :effect (and 
        (point_sequence ?Pe ?P0 ?P1 ?P2 ?P3 ?P4 ?P5)
    )
)

(:action Conv1_backward
    :parameters (?P0 ?P1 ?P2 ?P3 ?P4 ?P5 ?Pe - Conv1)
    :precondition (and 
        (point_sequence ?P0 ?P1 ?P2 ?P3 ?P4 ?P5 ?Pe)
        (forall (?WP - WorkPiece) 
            (not (on ?WP ?P0)))
    )
    :effect (and 
        (point_sequence ?P1 ?P2 ?P3 ?P4 ?P5 ?Pe ?P0)
    )
)

(:action push_ramp1
    :parameters (?WP - WorkPiece ?P0 ?P1 ?P2 ?P3 ?P4 ?P5 ?Pe - Conv1 ?R - Ramp1)
    :precondition (and 
        (point_sequence ?P0 ?P1 ?P2 ?P3 ?P4 ?P5 ?Pe)
        (on ?WP ?Pe)
    )
    :effect (and 
        (in ?WP ?R)
    )
)

; (:action push_ramp2
;     :parameters (?WP - WorkPiece ?P0 ?P1 ?P2 ?P3 ?P4 ?P5 ?Pe - Conv1 ?R - Ramp2)
;     :precondition (and 
;         (point_sequence ?P0 ?P1 ?P2 ?P3 ?P4 ?P5 ?Pe)
;         (on ?WP ?P5)
;     )
;     :effect (and 
;         (in ?WP ?R)
;     )
; )

; (:action push_ramp3
;     :parameters (?WP - WorkPiece ?P0 ?P1 ?P2 ?P3 ?P4 ?P5 ?Pe - Conv1 ?R - Ramp3)
;     :precondition (and 
;         (point_sequence ?P0 ?P1 ?P2 ?P3 ?P4 ?P5 ?Pe)
;         (on ?WP ?P3)
;     )
;     :effect (and 
;         (in ?WP ?R)
;     )
; )

(:action Conv1_to_Conv2
    :parameters (?WP - WorkPiece ?P10 ?P11 ?P12 ?P13 ?P14 ?P15 ?P1e - Conv1 ?P20 ?P21 ?P22 ?P2e - Conv2)
    :precondition (and 
        (point_sequence ?P10 ?P11 ?P12 ?P13 ?P14 ?P15 ?P1e)
        (point_sequence_2 ?P20 ?P21 ?P22 ?P2e)
        (on ?WP ?P13)
    )
    :effect (and 
        (on ?WP ?P21)
        (not (on ?WP ?P13))
    )
)

; (:action Conv2_to_Conv1
;     :parameters (?WP - WorkPiece ?P10 ?P11 ?P12 ?P13 ?P14 ?P15 ?P1e - Conv1 ?P20 ?P21 ?P22 ?P2e - Conv2)
;     :precondition (and 
;         (point_sequence ?P10 ?P11 ?P12 ?P13 ?P14 ?P15 ?P1e)
;         (point_sequence_2 ?P20 ?P21 ?P22 ?P2e)
;         (on ?WP ?P20)
;     )
;     :effect (and 
;         (on ?WP ?P14)
;         (not (on ?WP ?P20))
;     )
; )

; (:action Conv2_forward
;     :parameters (?P0 ?P1 ?P2 ?Pe - Conv2)
;     :precondition (and 
;         (point_sequence_2 ?P0 ?P1 ?P2 ?Pe)
;         (forall (?WP - WorkPiece) 
;             (not (on ?WP ?Pe)))
;     )
;     :effect (and 
;         (point_sequence_2 ?Pe ?P0 ?P1 ?P2)
;     )
; )

; (:action Conv2_backward
;     :parameters (?P0 ?P1 ?P2 ?Pe - Conv2)
;     :precondition (and 
;         (point_sequence_2 ?P0 ?P1 ?P2 ?Pe)
;         (forall (?WP - WorkPiece) 
;             (not (on ?WP ?P0)))
;     )
;     :effect (and 
;         (point_sequence_2 ?P1 ?P2 ?Pe ?P0)
;     )
; )

(:action push_ramp4
    :parameters (?WP - WorkPiece ?P0 ?P1 ?P2 ?Pe - Conv2 ?R - Ramp4)
    :precondition (and 
        (point_sequence_2 ?P0 ?P1 ?P2 ?Pe)
        (on ?WP ?P1)
    )
    :effect (and 
        (in ?WP ?R)
    )
)

)