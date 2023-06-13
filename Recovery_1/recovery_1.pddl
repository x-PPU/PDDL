;could run in both planners
;evaluate for Recovery I in Figure 5.10 on P.51
;based on xPPU_new, modified some primitives
(define (domain Recovery1)
(:requirements :strips :typing :durative-actions :fluents)

(:types
    WorkPiece loc - object
    stack stamp conveyor - loc
)

(:predicates
    ;stack state predicates
    (Separator_extended) ;stack separator
    (Separator_retracted)
    (available ?loc - loc)

    ;crane state predicates
    (crane_at ?loc - object)
    (available_crane)
    (hand_empty)
    (spot_is_free ?loc - object)

    ;product predicates
    (wp_current_position ?WorkPiece - object ?loc - object) 
    (taken_in ?WorkPiece - object)
    
    ;sensor value
    (s_wpisprovided ?WP - WorkPiece ?sep_loc - loc)
)

(:functions
    (distance ?from - loc ?to - loc)
)

;stack include 2 acitons
(:durative-action extend_separator
    :parameters (?WP - WorkPiece ?stack - stack)
    :duration (= ?duration 1)
    :condition (and 
        (at start (and
            (Separator_retracted)
            (spot_is_free ?stack)
            (available ?stack)
        ))
    )
    :effect (and 
        (at start (not (available ?stack)))
        (at end (and
            (available ?stack)
            (Separator_extended)
            (not (Separator_retracted))
            (not (spot_is_free ?stack))
            (wp_current_position ?WP ?stack)
            (s_wpisprovided ?WP ?stack)
        ))
    )
)

(:durative-action retract_separator
    :parameters (?stack - stack)
    :duration (= ?duration 1)
    :condition (and
        (at start (and
            (Separator_extended)
            (spot_is_free ?stack)
        ))
    )
    :effect (and 
        (at end (and
            (Separator_retracted)
            (not (Separator_extended))
        ))
    )
)


;crane include 3 acitons
(:durative-action crane_turn
    :parameters (?from - loc ?to - loc)
    :duration (= ?duration (distance ?from ?to)) 
    :condition (and 
        (at start (and
            (crane_at ?from)
            (available_crane)
        ))
    )
    :effect (and 
        (at start (and
            (not (crane_at ?from))
        ))
        (at end (and
            (crane_at ?to)
        ))
    )
)

; valve include 2 actions
(:durative-action pick_up
    :parameters (?WP - WorkPiece ?sep_loc - loc) ; where and which, if therere more cranes, here ?crane
    :duration (= ?duration 1)
    :condition (and 
        (at start (and 
            (crane_at ?sep_loc)
            (wp_current_position ?WP ?sep_loc)
            (hand_empty)
            (available_crane)
        ))
    )
    :effect (and 
        (at start (and
            (not (available_crane))
            (not (wp_current_position ?WP ?sep_loc))
        ))
        (at end (and
            (available_crane)
            (spot_is_free ?sep_loc) ;one action changes the position of wp and the statue of spot both
            (taken_in ?WP) ; wp_current position has no value, its not go vanishing, but taken_in here by crane
            (not (hand_empty))
        ))
        
    )
)

(:durative-action release
    :parameters (?WP - WorkPiece ?sep_loc - loc)
    :duration (= ?duration 1)
    :condition (and 
        (at start (and
            (taken_in ?WP)
            (crane_at ?sep_loc)
            (available_crane)
            (spot_is_free ?sep_loc)
        ))
    )
    :effect (and 
        (at start (and
            (not (available_crane))
        ))
        (at end (and
            (available_crane)
            (not (taken_in ?WP))
            (hand_empty)
            (not (spot_is_free ?sep_loc))
            (wp_current_position ?WP ?sep_loc)
            (S_WPisProvided ?WP ?sep_loc)
        ))
    )
)

)