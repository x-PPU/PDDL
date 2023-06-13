;this can only run in Optic
;need to wait abou 30s
;limitation: two conveyors could not run at the same time
(define (domain Recovery_2_third)

(:requirements :strips :fluents :durative-actions :typing)

(:types
    WorkPiece
    Conv1 Conv2 - Point
    R1 R2 R3 R4 - Ramp    
)

(:predicates 
    ;product predicate
    (in ?WP - WorkPiece ?R - Ramp)
    (on ?WP - WorkPiece ?P - Point)
    (not_on ?WP - WorkPiece ?P - Point)

    ;point features predicate
    (next ?P0 ?P1 - Point)
    (begin ?P0 - Point)

    ;component state predicate
    (available)
)

(:functions
    (position ?P - Point)
)

(:durative-action LSC_moveforward
    :parameters (?P1 ?P2 ?P3 ?P4 ?P5 - Conv1)
    :duration (= ?duration 1)
    :condition (and 
        (at start (and
            (begin ?P1)
            (next ?P1 ?P2)
            (next ?P2 ?P3)
            (next ?P3 ?P4)
            (next ?P4 ?P5)
            (available)
            (forall (?P - Conv1)
            (< (position ?P) 25))
            (forall (?P - Conv1)
            (> (position ?p) 0))
        ))
    )
    :effect (and 
        (at start (not (available)))
        (at end(and
            (available)
            (increase (position ?P1) 1)
            (increase (position ?P2) 1)
            (increase (position ?P3) 1)
            (increase (position ?P4) 1)
            (increase (position ?P5) 1)
        ))  
    )
)

(:durative-action change_LSC_order_end
    :parameters (?P - Conv1)
    :duration (= ?duration 1)
    :condition (and 
        (at start (and 
            (= (position ?P) 25)
            (forall (?WP - WorkPiece)
                (not_on ?WP ?P))
        ))
    )
    :effect (at end 
        (decrease (position ?P) 24)
    )
)

(:durative-action LSC_movebackward
    :parameters (?P1 ?P2 ?P3 ?P4 ?P5 - Conv1)
    :duration (= ?duration 1)
    :condition (and 
        (at start (and
            (available)
            (begin ?P1)
            (next ?P1 ?P2)
            (next ?P2 ?P3)
            (next ?P3 ?P4)
            (next ?P4 ?P5)
            (forall (?P - Conv1)
            (< (position ?P) 25))
            (forall (?P - Conv1)
            (> (position ?p) 0))
        ))
    )
    :effect (and
        (at start (not (available)))
        (at end (and 
            (available)
            (decrease (position ?P1) 1)
            (decrease (position ?P2) 1)
            (decrease (position ?P3) 1)
            (decrease (position ?P4) 1)
            (decrease (position ?P5) 1)
        ))
    )
)

(:durative-action change_LSC_order_start
    :parameters (?P - Conv1)
    :duration (= ?duration 1)
    :condition (and 
        (at start (and 
            (= (position ?P) 0)
            (forall (?WP - WorkPiece)
                (not_on ?WP ?P))
        ))
    )
    :effect (at end 
        (increase (position ?P) 24)
    )
)

(:durative-action push_ramp1
    :parameters (?WP - WorkPiece ?P - Conv1 ?R1 - R1)
    :duration (= ?duration 1)
    :condition (and 
        (at start (and 
            (available)
            (= (position ?P) 24)
            (on ?WP ?P)
        ))
    )
    :effect (and 
        (at start (not (available)))
        (at end (and 
            (available)
            (in ?WP ?R1)
            (not (on ?WP ?P))
            (not_on ?WP ?P)
        ))
    )
)

(:durative-action push_ramp2
    :parameters (?WP - WorkPiece ?P - Conv1 ?R - R2)
    :duration (= ?duration 1)
    :condition (and 
        (at start (and 
            (available)
            (= (position ?P) 20)
            (on ?WP ?P)
        ))
    )
    :effect (and 
        (at start (not (available)))
        (at end (and 
            (available)
            (in ?WP ?R)
            (not (on ?WP ?P))
            (not_on ?WP ?P)
        ))
    )
)

(:durative-action push_ramp3
    :parameters (?WP - WorkPiece ?P - Conv1 ?R - R3)
    :duration (= ?duration 1)
    :condition (and 
        (at start (and 
            (available)
            (= (position ?P) 9)
            (on ?WP ?P)
        ))
    )
    :effect (and 
        (at start (not (available)))
        (at end (and 
            (available)
            (in ?WP ?R)
            (not (on ?WP ?P))
            (not_on ?WP ?P)
        ))
    )
)

(:durative-action LSC_to_PAC
    :parameters (?WP - WorkPiece ?P - Conv1 ?PA - Conv2)
    :duration (= ?duration 1)
    :condition (and 
        (at start (and 
            (available)
            (= (position ?P) 16)
            (on ?WP ?P)
            (= (position ?PA) 1)
            (forall (?WP - WorkPiece)
                (not_on ?WP ?PA))
        ))
    )
    :effect (and 
        (at start (not (available)))
        (at end (and 
            (available)
            (not (on ?WP ?P))
            (not_on ?WP ?P)
            (on ?WP ?PA)
            (not (not_on ?WP ?PA))
        ))
    )
)

(:durative-action PAC_moveforward
    :parameters (?P1 ?P2 - Conv2)
    :duration (= ?duration 1)
    :condition (and 
        (at start (and
            (begin ?P1)
            (next ?P1 ?P2)
            (available)
            (forall (?P - Conv2)
            (< (position ?P) 6))
            (forall (?P - Conv2)
            (> (position ?p) 0))
        ))
    )
    :effect (and 
        (at start (not (available)))
        (at end(and
            (available)
            (increase (position ?P1) 1)
            (increase (position ?P2) 1)
        ))  
    )
)

(:durative-action change_PAC_order_end
    :parameters (?P - Conv2)
    :duration (= ?duration 1)
    :condition (and 
        (at start (and 
            (= (position ?P) 6)
            (forall (?WP - WorkPiece)
                (not_on ?WP ?P))
        ))
    )
    :effect (at end 
        (decrease (position ?P) 5)
    )
)

(:durative-action PAC_movebackward
    :parameters (?P1 ?P2 - Conv2)
    :duration (= ?duration 1)
    :condition (and 
        (at start (and
            (available)
            (begin ?P1)
            (next ?P1 ?P2)
            (forall (?P - Conv2)
            (< (position ?P) 6))
            (forall (?P - Conv2)
            (> (position ?P) 0))
        ))
    )
    :effect (and
        (at start (not (available)))
        (at end (and 
            (available)
            (decrease (position ?P1) 1)
            (decrease (position ?P2) 1)
        ))
    )
)

(:durative-action change_PAC_order_start
    :parameters (?P - Conv2)
    :duration (= ?duration 1)
    :condition (and 
        (at start (and
            (= (position ?P) 0)
            (forall (?WP - WorkPiece)
                (not_on ?WP ?P))
        ))
    )
    :effect (at end
            (increase (position ?P) 5)
    )
)

(:durative-action push_ramp4
    :parameters (?WP - WorkPiece ?P - Conv2 ?R - R4)
    :duration (= ?duration 1)
    :condition (and 
        (at start (and 
            (available)
            (= (position ?P) 5)
            (on ?WP ?P)
        ))
    )
    :effect (and 
        (at start (not (available)))
        (at end (and 
            (available)
            (in ?WP ?R)
            (not (on ?WP ?P))
            (not_on ?WP ?P)
        ))
    )
)

(:durative-action PAC_to_LSC
    :parameters (?WP - WorkPiece ?P - Conv1 ?PA - Conv2)
    :duration (= ?duration 1)
    :condition (and 
        (at start (and 
            (available)
            (= (position ?P) 16)
            (on ?WP ?PA)
            (= (position ?PA) 1)
            (forall (?WP - WorkPiece)
                (not_on ?WP ?P))
        ))
    )
    :effect (and 
        (at start (not (available)))
        (at end (and 
            (available)
            (not (on ?WP ?PA))
            (not_on ?WP ?PA)
            (on ?WP ?P)
            (not (not_on ?WP ?P))
        ))
    )
)

)