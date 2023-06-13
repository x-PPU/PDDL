; This domain could run by palnner Optic
; only three components, stack, crean, stamp
; 9 primitives
; only strong constrain is written here, could be used for recovery
(define (domain xPPU)
(:requirements :strips :fluents :typing :durative-actions)

(:types
    WorkPiece
    stack stamp conveyor - loc
    Conv1 Conv2 - Point
    R1 R2 R3 R4 - Ramp 
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
    (in  ?WorkPiece - WorkPiece ?R - Ramp)
    (on ?WP - WorkPiece ?P - Point)
    (not_on ?WP - WorkPiece ?P - Point)

    ;point features predicate
    (next ?P0 ?P1 - Point)
    (begin ?P0 - Point)

    ;component state predicate
    (available1)
    (available2)

    ;sensor value
    (s_wpisprovided ?WP - WorkPiece ?sep_loc - loc)
)

(:functions
    (distance ?from - loc ?to - loc) 
    (position ?P - Point)
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
            (S_WPisProvided ?WP ?sep_loc)
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
; why this two actions couldnt with those of stack intergrated, they are both extend and retract actions
; because the preconditions are different
; this two actions could combined in stamp_action, like in xPPU_old.pddl

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
(:durative-action trans_to_conveyor
    :parameters (?WP - WorkPiece ?conveyor - conveyor ?P1 ?P2 ?P3 ?P4 ?P5 - Conv1 ?PA ?PB - Conv2)
    :duration (= ?duration 1)
    :condition (and 
        (at start (and 
            (wp_current_position ?WP ?conveyor)
            (begin ?P1)
            (next ?P1 ?P2)
            (next ?P2 ?P3)
            (next ?P3 ?P4)
            (next ?P4 ?P5)
            (begin ?PA)
            (next ?PA ?PB)
        ))
    )
    :effect (and 
        (at start (and 
            (not (wp_current_position ?wp ?conveyor))
            (spot_is_free ?conveyor)
        ))
        (at end (and
            (on ?WP ?P1)
            (not_on ?WP ?P2)
            (not_on ?WP ?P3)
            (not_on ?WP ?P4)
            (not_on ?WP ?P5)
            (not_on ?WP ?PA)
            (not_on ?WP ?PB)
        ))
    )
)

(:durative-action LSC_moveforward
    :parameters (?P1 ?P2 ?P3 ?P4 ?P5 - Conv1)
    :duration (= ?duration 1)
    :condition (at start (and
            (begin ?P1)
            (next ?P1 ?P2)
            (next ?P2 ?P3)
            (next ?P3 ?P4)
            (next ?P4 ?P5)
            (available1)
            (forall (?P - Conv1)
            (< (position ?P) 25))
            (forall (?P - Conv1)
            (> (position ?p) 0)))
    )
    :effect (and 
        (at start (not (available1)))
        (at end(and
            (available1)
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
    :condition (at start (and 
            (= (position ?P) 25)
            (forall (?WP - WorkPiece)
                (not_on ?WP ?P)))
    )
    :effect (at end 
        (decrease (position ?P) 24)
    )
)

(:durative-action LSC_movebackward
    :parameters (?P1 ?P2 ?P3 ?P4 ?P5 - Conv1)
    :duration (= ?duration 1)
    :condition (at start (and
            (available1)
            (begin ?P1)
            (next ?P1 ?P2)
            (next ?P2 ?P3)
            (next ?P3 ?P4)
            (next ?P4 ?P5)
            (forall (?P - Conv1)
            (< (position ?P) 25))
            (forall (?P - Conv1)
            (> (position ?p) 0)))
    )
    :effect (and
        (at start (not (available1)))
        (at end (and 
            (available1)
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
    :condition (at start (and 
            (= (position ?P) 0)
            (forall (?WP - WorkPiece)
                (not_on ?WP ?P)))
    )
    :effect (at end 
        (increase (position ?P) 24)
    )
)

(:durative-action push_ramp1
    :parameters (?WP - WorkPiece ?P - Conv1 ?R1 - R1)
    :duration (= ?duration 1)
    :condition (at start (and 
            (available1)
            (= (position ?P) 24)
            (on ?WP ?P))
    )
    :effect (and 
        (at start (not (available1)))
        (at end (and 
            (available1)
            (in ?WP ?R1)
            (not (on ?WP ?P))
            (not_on ?WP ?P)
        ))
    )
)

(:durative-action push_ramp2
    :parameters (?WP - WorkPiece ?P - Conv1 ?R - R2)
    :duration (= ?duration 1)
    :condition (at start (and 
            (available1)
            (= (position ?P) 20)
            (on ?WP ?P))
    )
    :effect (and 
        (at start (not (available1)))
        (at end (and 
            (available1)
            (in ?WP ?R)
            (not (on ?WP ?P))
            (not_on ?WP ?P)
        ))
    )
)

(:durative-action push_ramp3
    :parameters (?WP - WorkPiece ?P - Conv1 ?R - R3)
    :duration (= ?duration 1)
    :condition (at start (and 
            (available1)
            (= (position ?P) 9)
            (on ?WP ?P))
    )
    :effect (and 
        (at start (not (available1)))
        (at end (and 
            (available1)
            (in ?WP ?R)
            (not (on ?WP ?P))
            (not_on ?WP ?P)
        ))
    )
)

(:durative-action LSC_to_PAC
    :parameters (?WP - WorkPiece ?P - Conv1 ?PA - Conv2)
    :duration (= ?duration 1)
    :condition (at start (and 
            (available1)
            (available2)
            (= (position ?P) 16)
            (on ?WP ?P)
            (= (position ?PA) 1)
            (forall (?WP - WorkPiece)
                (not_on ?WP ?PA))
        )
    )
    :effect (and 
        (at start (and
            (not (available1))
            (not (available2))
        ))
        (at end (and 
            (available1)
            (available2)
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
    :condition (at start (and
            (begin ?P1)
            (next ?P1 ?P2)
            (available2)
            (forall (?P - Conv2)
            (< (position ?P) 6))
            (forall (?P - Conv2)
            (> (position ?p) 0)))
    )
    :effect (and 
        (at start (not (available2)))
        (at end(and
            (available2)
            (increase (position ?P1) 1)
            (increase (position ?P2) 1)
        ))  
    )
)

(:durative-action change_PAC_order_end
    :parameters (?P - Conv2)
    :duration (= ?duration 1)
    :condition (at start (and 
            (= (position ?P) 6)
            (forall (?WP - WorkPiece)
                (not_on ?WP ?P)))
    )
    :effect (at end 
        (decrease (position ?P) 5)
    )
)

(:durative-action PAC_movebackward
    :parameters (?P1 ?P2 - Conv2)
    :duration (= ?duration 1)
    :condition (at start (and
            (available2)
            (begin ?P1)
            (next ?P1 ?P2)
            (forall (?P - Conv2)
            (< (position ?P) 6))
            (forall (?P - Conv2)
            (> (position ?P) 0)))
    )
    :effect (and
        (at start (not (available2)))
        (at end (and 
            (available2)
            (decrease (position ?P1) 1)
            (decrease (position ?P2) 1)
        ))
    )
)

(:durative-action change_PAC_order_start
    :parameters (?P - Conv2)
    :duration (= ?duration 1)
    :condition (at start (and 
            (= (position ?P) 0)
            (forall (?WP - WorkPiece)
                (not_on ?WP ?P)))
    )
    :effect (at end
            (increase (position ?P) 5)
        )
)

(:durative-action push_ramp4
    :parameters (?WP - WorkPiece ?P - Conv2 ?R - R4)
    :duration (= ?duration 1)
    :condition (at start (and 
            (available2)
            (= (position ?P) 5)
            (on ?WP ?P))
    )
    :effect (and 
        (at start (not (available2)))
        (at end (and 
            (available2)
            (in ?WP ?R)
            (not (on ?WP ?P))
            (not_on ?WP ?P)
        ))
    )
)

(:durative-action PAC_to_LSC
    :parameters (?WP - WorkPiece ?P - Conv1 ?PA - Conv2)
    :duration (= ?duration 1)
    :condition (at start (and 
            (available1)
            (available2)
            (= (position ?P) 16)
            (on ?WP ?PA)
            (= (position ?PA) 1)
            (forall (?WP - WorkPiece)
                (not_on ?WP ?P)))
    )
    :effect (and 
        (at start (and
            (not (available1))
            (not (available2))
        ))
        (at end (and 
            (available1)
            (available2)
            (not (on ?WP ?PA))
            (not_on ?WP ?PA)
            (on ?WP ?P)
            (not (not_on ?WP ?P))
        ))
    )
)

)