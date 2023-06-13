; This domain could run by palnner Optic
; auto-mode
; Alt+P to run the programm, need to wait for about 30s to generate the last strategy
; only three components, stack, crean, stamp
; 9 primitives
; the result is in Figure 5.7 on P.49
; only strong constrain is written here, could be used for recovery
(define (domain xPPU_new)
(:requirements :strips :fluents :typing :durative-actions)

(:types
    WorkPiece
    stack stamp conveyor - loc
)

(:predicates 
    ;stack state predicates
    (Separator_extended) ;stack separator
    (Separator_retracted)

    ;crane state predicates
    (crane_at ?loc - loc)
    (available_crane)
    (hand_empty)
    (spot_is_free ?loc - loc)

    ;stamp state preidcates
    (cy_stamp_extended)
    (cy_stamp_retracted)
    (wp_under_stamp ?WorkPiece - WorkPiece)

    ; conveyor
    (available ?loc - loc)

    ;product predicates
    (in_stack ?WP - WorkPiece)
    (wp_current_position ?WorkPiece - WorkPiece ?loc - loc)
    (taken_in ?WorkPiece - WorkPiece)
    (stamp_finished ?WorkPiece - WorkPiece)
    (in_ramp  ?WorkPiece - WorkPiece) ; detected at the beginning of ramp 
)

(:functions
    (distance ?from - loc ?to - loc) 
    ;the time to take of crane to move among 3 loc
)

;stack component includes 2 acitons
(:durative-action extend_separator
    :parameters (?WP - WorkPiece ?stack - stack)
    :duration (= ?duration 1)
    :condition (and 
        (at start (and
            (in_stack ?WP)
            (Separator_retracted)
            (spot_is_free ?stack)
            (available ?stack )
        ))
    )
    :effect (and 
        (at start (and
            (not (available ?stack))
            (not (spot_is_free ?stack))
            (not (in_stack ?WP))
            ))
        (at end (and
            (available ?stack )
            (Separator_extended)
            (not (Separator_retracted))
            (wp_current_position ?WP ?stack)
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
    :effect (at end (and
            (Separator_retracted)
            (not (Separator_extended))
        ))
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
    :parameters (?WP - WorkPiece ?sep_loc - loc)
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
            (not (hand_empty))
        ))
        (at end (and
            (available_crane)
            (spot_is_free ?sep_loc) ;one action changes the position of wp and the statue of spot both
            (taken_in ?WP)
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
            (not (spot_is_free ?sep_loc))
        ))
        (at end (and
            (available_crane)
            (not (taken_in ?WP))
            (hand_empty)
            (wp_current_position ?WP ?sep_loc)
        ))
    )
)

; stamp contains three actions, extend retract stamp
(:durative-action stamp_cy_retracted ; move wp to stamp
    :parameters (?WP - WorkPiece ?stamp - stamp)
    :duration (= ?duration 1)
    :condition (and 
        (at start (and 
            (cy_stamp_extended)
            (wp_current_position ?WP ?stamp) ;the wp is already on spot
        ))
    )
    :effect (and 
        (at start (and 
            (not (cy_stamp_extended))
            (not (wp_current_position ?WP ?stamp)) ; the position of stamp is different, to avoid crane pick up wp during stamping
        ))
        (at end (and 
            (cy_stamp_retracted)
            (wp_under_stamp ?WP)
        ))
    )
)

(:durative-action stamp_cy_extend
    :parameters (?WP - WorkPiece ?stamp - stamp) 
    :duration (= ?duration 1)
    :condition (and 
        (at start (and 
            (cy_stamp_retracted) ;actuator is avaliable
            (stamp_finished ?WP)
            (wp_under_stamp ?WP)
        ))
    )
    :effect (and 
        (at start (and 
            (not (cy_stamp_retracted))
            (not (wp_under_stamp ?WP))
        ))
        (at end (and 
            (cy_stamp_extended)
            (WP_current_position ?WP ?stamp) ;tracking the wp position
        ))
    )
)
; The reason that this two actions couldn't like the action of stack intergrated, they are both extend and retract actions
; the preconditions are different
; this two actions could be combined in stamp_action, like in xPPU_old.pddl

(:durative-action stamp
    :parameters (?WP - WorkPiece)
    :duration (= ?duration 5)
    :condition (and 
        (at start (and
            (cy_stamp_retracted)
            (wp_under_stamp ?WP)
        ))
    )
    :effect (and 
        (at end (and
            (stamp_finished ?WP)
        ))
    )
)

; conveyor
(:durative-action move_forward ; this action is with wp, not equipment. if there are multiple wp on conveyor at the same time, there will be multiple move_forward actions
    :parameters (?wp - WorkPiece ?conveyor - conveyor)
    :duration (= ?duration 2)
    :condition (and 
        (at start (and 
            (wp_current_position ?WP ?conveyor)
        ))
    )
    :effect (and 
        (at start (and 
            (not (wp_current_position ?wp ?conveyor))
            (spot_is_free ?conveyor)
        ))
        (at end (and
            (in_ramp ?wp)
        ))
    )
)

)