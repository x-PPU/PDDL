;this can run in both planners
;limitation: in real mashine the special are not even distribution on conveyor 
;here assume they are even
(define (domain Recovery_2_second)

(:requirements :strips :typing)

(:types 
    WorkPiece
    Conv1 Conv2 - Point
    R1 R3 - ramp
)

(:predicates
    ;product state predicate
    (on ?WP - WorkPiece ?P - Point)
    (not_on ?WP - WorkPiece ?P - Point)
    (in ?WP - WorkPiece ?R - ramp)

    ;point feature predicates
    (next ?P0 ?P1 - Point)
    (begin ?P0 - Point)
    (end ?Pe - Point)
)

(:action LSC_moveforward
    :parameters (?WP - WorkPiece ?P1 ?P2 ?P3 ?P4 ?P5 - Conv1)
    :precondition (and 
        (begin ?P1)
        (next ?P1 ?P2)
        (next ?P2 ?P3)
        (next ?P3 ?P4)
        (next ?P4 ?P5)
        (end ?P5)
        (forall (?WP - WorkPiece)
            (not_on ?WP ?P5))
    )
    :effect (and
        (not (begin ?P1))
        (begin ?P5)
        (not (end ?P5))
        (end ?P4)
    )
)

(:action LSC_movebackward
    :parameters (?WP - WorkPiece ?P1 ?P2 ?P5 - Conv1)
    :precondition (and 
        (begin ?P1)
        (next ?P1 ?P2)
        (end ?P5)
        (forall (?WP - WorkPiece)
            (not_on ?WP ?P1))
    )
    :effect (and
        (not (begin ?P1))
        (begin ?P2)
        (not (end ?P5))
        (end ?P1)
    )
)

(:action LSC_to_PAC
    :parameters (?WP - WorkPiece ?P1 ?P2 ?P3 ?P4 ?P5 - Conv1 ?PA ?PB - Conv2)
    :precondition (and 
        (begin ?P1)
        (next ?P1 ?P2)
        (next ?P2 ?P3)
        (next ?P3 ?P4)
        (next ?P4 ?P5)
        (end ?P5)
        (begin ?PA)
        (end ?PB)
        (on ?WP ?P3)
    )
    :effect (and 
        (on ?WP ?PA)
        (not(on ?WP ?P3))
    )
)

(:action PAC_to_LSC
    :parameters (?WP - WorkPiece ?P1 ?P2 ?P3 ?P4 ?P5 - Conv1 ?PA ?PB - Conv2)
    :precondition (and 
        (begin ?P1)
        (next ?P1 ?P2)
        (next ?P2 ?P3)
        (next ?P3 ?P4)
        (next ?P4 ?P5)
        (end ?P5)
        (begin ?PA)
        (end ?PB)
        (on ?WP ?PA)
    )
    :effect (and 
        (on ?WP ?P3)
        (not(on ?WP ?PA))
    )
)

(:action push_ramp1
    :parameters (?WP - WorkPiece ?P1 - Conv1 ?R - R1)
    :precondition (and 
        (end ?P1)
        (on ?WP ?P1)
    )
    :effect (and 
        (in ?WP ?R)
    )
)

(:action push_ramp3
    :parameters (?WP - WorkPiece ?P1 ?P2 ?P3 ?P4 ?P5 - Conv1 ?R - R3)
    :precondition (and 
        (begin ?P1)
        (next ?P1 ?P2)
        (next ?P2 ?P3)
        (next ?P3 ?P4)
        (next ?P4 ?P5)
        (end ?P5)
        (on ?WP ?P2)
    )
    :effect (and 
        (in ?WP ?R)
    )
)

(:action PAC_moveforward
    :parameters (?WP - WorkPiece ?P1 ?P2 - Conv2)
    :precondition (and 
        (begin ?P1)
        (end ?P2)
        (forall (?WP - WorkPiece)
            (not_on ?WP ?P2))
    )
    :effect (and
        (not (begin ?P1))
        (begin ?P2)
        (not (end ?P2))
        (end ?P1)
    )
)

(:action PAC_movebackward
    :parameters (?WP - WorkPiece ?P1 ?P2 - Conv2)
    :precondition (and 
        (begin ?P1)
        (end ?P2)
        (forall (?WP - WorkPiece)
            (not_on ?WP ?P1))
    )
    :effect (and
        (not (begin ?P1))
        (begin ?P2)
        (not (end ?P2))
        (end ?P1)
    )
)

)