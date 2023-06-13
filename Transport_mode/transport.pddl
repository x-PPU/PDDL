; run by both planners
; this domain is to evaluate transport model 3 mapping
(define (domain Transport)
(:requirements :strips :typing)

(:types
    WorkPiece
    Point
    Conveyor
)

(:predicates
    ;product predicate
    (position ?WP - WorkPiece ?Point - Point)

    ;component state predicate
    (moveforward ?Conv - Conveyor)
    (movebackward ?Conv - Conveyor)

    ; map building predicate
    (next ?P1 ?P2 - Point ?Conv - Conveyor)
    (before ?P2 ?P1 - Point ?Conv - Conveyor)
    (connect ?P1 ?P2 - Point)
)

(:action start_moveforward
    :parameters (?Conv - Conveyor)
    :precondition (and 
        (movebackward ?Conv)
    )
    :effect (and 
        (not (movebackward ?Conv))
        (moveforward ?Conv)
    )
)

(:action start_movebackward
    :parameters (?Conv - Conveyor)
    :precondition (and 
        (moveforward ?Conv)
    )
    :effect (and 
        (not (moveforward ?Conv))
        (movebackward ?Conv)
    )
)

(:action moveforward
    :parameters (?WP - WorkPiece ?Conv - Conveyor ?P1 ?P2 - Point)
    :precondition (and 
        (position ?WP ?P1)
        (moveforward ?Conv)
        (next ?P1 ?p2 ?Conv)
    )
    :effect (and 
        (not (position ?WP ?P1))
        (position ?WP ?P2)
    )
)

(:action movebackward
    :parameters (?WP - WorkPiece ?Conv - Conveyor ?P1 ?P2 - Point)
    :precondition (and 
        (position ?WP ?P1)
        (movebackward ?Conv)
        (before ?P1 ?p2 ?Conv)
    )
    :effect (and 
        (not (position ?WP ?P1))
        (position ?WP ?P2)
    )
)

(:action change_conv
    :parameters (?WP - WorkPiece ?P1 ?P2 - Point)
    :precondition (and 
        (position ?WP ?P1)
        (connect ?P1 ?P2)
    )
    :effect (and 
        (not (position ?WP ?P1))
        (position ?WP ?P2)
    )
)

)