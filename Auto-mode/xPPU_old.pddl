; This domain could run by planner LPG-td
; auto-mode
; Alt+P to run the programm, unstabil, could run multiple time
; only contains three components, stack, carne, stamp
; 12 primitives
; the result is in Figure 5.4 on P.46
; production requirement is written in primitives, so couldn't be used for recovery
(define (domain xPPU_old)
(:requirements :strips :typing :negative-preconditions :equality :disjunctive-preconditions :durative-actions)

(:types
    WorkPiece
    stack stamp conveyor - loc ;the position reached with carrier crane
)

(:predicates
    ;stack state predicates
    (Separator_extended) ;stack separator

    ;workpiece type detemination
    (WP_metal ?WorkPiece - WorkPiece) ;sensor value
    (WP_light ?WorkPiece - Workpiece) ;sensor value

    ;crane state predicate
    (crane_at ?loc - loc)
    (avaliable)
    (hand_empty) ; transport a WP
    (loc_empty ?loc - loc)

    ; stamp state predicate
    (stamping)
    
    ;product predicate
    (in_stack ?WP - WorkPiece)
    (WP_provided ?WorkPiece - Workpiece ?loc - loc) ;WP at stack or stamp or the beginning of conveyor
    (WPType_metal ?WorkPiece - Workpiece) ;the type of workpiece
    (WPType_black ?WorkPiece - Workpiece)
    (WPType_white ?WorkPiece - Workpiece)
    (type_identified ?WP - WorkPiece) ;the type is already known
    (taken_in ?WorkPiece - Workpiece) ;WP is transport by crane now
    (stamp_finished ?WorkPiece - WorkPiece)
    (in_ramp  ?WorkPiece - WorkPiece) ; detected at the beginning of ramp
)

;stack component includes 2 acitons
(:durative-action extend_separator
    :parameters (?WP - WorkPiece ?stack - stack)
    :duration (= ?duration 1)
    :condition (and 
        (at start (and 
            (in_stack ?WP) 
            (not(Separator_extended))
            (not(WP_provided ?WP ?stack))
        ))
    )
    :effect (and 
        (at start (not (in_stack ?WP)))
        (at end (and
            (Separator_extended)
            (WP_provided ?WP ?stack)
            (not (loc_empty ?stack))
        ))
    )
)

(:durative-action retract_separator
    :parameters (?stack - stack) ;irrelevant with WP
    :duration (= ?duration 1)
    :condition (and
        (at start (and
            (Separator_extended)
            (loc_empty ?stack)
        ))
     )
    :effect (and 
        (at end (and
            (not (Separator_extended))
            (not (loc_empty ?stack)) ;for crane, to avoid crane put a WP back to stack when retract
        ))
        
    )
)

;identify the type of WP, include 3 actions
(:durative-action WP_metal
    :parameters (?WP - WorkPiece ?stack - stack)
    :duration (= ?duration 1)
    :condition (and
        (at start (and
            (WP_metal ?WP)
            (WP_provided ?WP ?stack)
        ))
    )
    :effect (and 
        (at end (and
            (WPType_metal ?WP)
            (type_identified ?WP)
        ))
    )
)

(:durative-action WP_black
    :parameters (?WP - WorkPiece ?stack - stack)
    :duration (= ?duration 1)
    :condition (and
        (at start (and 
            (not (WP_metal ?WP))
            (not (WP_light ?WP))
            (WP_provided ?WP ?stack)
        ))
    )
    :effect (and 
        (at end (and 
            (WPType_black ?WP)
            (type_identified ?WP)
        ))
    )
)

(:durative-action WP_white
    :parameters (?WP - WorkPiece ?stack - stack)
    :duration (= ?duration 1)
    :condition (and
        (at start (and
            (not (WP_metal ?WP))
            (WP_light ?WP)
            (WP_provided ?WP ?stack)
        ))
    )
    :effect (and 
        (at end (and
            (WPType_white ?WP)
            (type_identified ?WP)
        ))
    )
)

;crane include 3 acitons
(:durative-action turn_stack
    :parameters (?WP - WorkPiece ?stack - stack ?conveyor - conveyor ?stamp - stamp)
    :duration (= ?duration 2)
    :condition (and 
        (at start (and
            (avaliable)
            (WP_provided ?WP ?stack)
            (not (crane_at ?stack))
        ))
    )
    :effect (and 
        (at start (and
            (not (avaliable))
            (not (crane_at ?conveyor))
            (not (crane_at ?stamp))
        ))
        (at end (and
            (avaliable)
            (crane_at ?stack)
        ))
    )
)

(:durative-action turn_conveyor
    :parameters (?WP - WorkPiece ?stack - stack ?conveyor - conveyor ?stamp - stamp)
    :duration (= ?duration 2)
    :condition (and
        (at start (and
            (avaliable)
            (not (crane_at ?conveyor))
            (forall (?WP - WorkPiece)
                (not (WP_provided ?WP ?conveyor)))
            (taken_in ?WP)
            (or 
                (WPType_black ?WP) ; black WP direct to conveyor
                (and ; other WP should be stamped before to conveyor
                    (stamp_finished ?WP) ;production requirement
                    (not (WPType_black ?WP))
                )
            )
        ))
    )
    :effect(and
        (at start (not (avaliable)))
        (at end (and
            (avaliable)
            (crane_at ?conveyor)
            (not(crane_at ?stack))
            (not(crane_at ?stamp))
        ))
    )
)

(:durative-action turn_stamp
    :parameters (?WP - WorkPiece ?stack - stack ?conveyor - conveyor ?stamp - stamp)
    :duration (= ?duration 2)
    :condition (and
        (at start (and
            (avaliable)
            (not (crane_at ?stamp))
            (or 
                (and ; there's no WP at stamp
                    (not (WP_provided ?WP ?stamp))
                    (not (hand_empty))
                    (taken_in ?WP) ; have a WP of crane wait for stamp
                    (not (WPType_black ?WP)) ; the WP is not black
                )
                (and ; there is a WP at stamp
                    (WP_provided ?WP ?stamp)
                    (not(hand_empty)) ; crane is empty
                    (stamp_finished ?WP)
                )
            )
        ))
    )
    :effect(and
        (at start (not (avaliable)))
        (at end (and
            (avaliable)
            (not (crane_at ?conveyor))
            (not(crane_at ?stack))
            (crane_at ?stamp)
        ))
    )
)

; valve of the crane include 2 actions
(:durative-action pick_up
    :parameters (?WP - WorkPiece ?loc - loc)
    :duration (= ?duration 1)
    :condition (and 
        (at start (and
            (type_identified ?WP)
            (crane_at ?loc)
            (WP_provided ?WP ?loc)
            (not (taken_in ?WP))
            (hand_empty)
            (avaliable)
        ))
    )
    :effect (and 
        (at start (and
            (not (hand_empty))
            (not (avaliable))
        ))
        (at end (and
            (avaliable)
            (not (WP_provided ?WP ?loc))
            (taken_in ?WP)
            (loc_empty ?loc)
        ))
    )
)

(:durative-action release
    :parameters (?WP - WorkPiece ?loc - loc)
    :duration (= ?duration 1)
    :condition (and 
        (at start (and
            (taken_in ?WP)
            (crane_at ?loc)
            (not (hand_empty))
            (not (WP_provided ?WP ?loc))
            (loc_empty ?loc)
            (avaliable)
        ))
    )
    :effect (and 
        (at start (not (avaliable)))
        (at end (and
            (avaliable)
            (hand_empty)
            (not (taken_in ?WP))
            (WP_provided ?WP ?loc)
            (not (loc_empty ?loc))
        ))
    )
)

; stamp 
(:durative-action stamp
    :parameters (?WP - WorkPiece ?stamp - stamp)
    :duration (= ?duration 5)
    :condition (and 
        (at start (and
            (WP_provided ?WP ?stamp)
            (not (WPType_black ?WP))
            (not (stamping))
        ))
    )
    :effect (and 
        (at start (and
            (not (WP_provided ?WP ?stamp))
            (stamping)
        ))
        (at end (and
            (not (stamping))
            (WP_provided ?WP ?stamp)
            (stamp_finished ?WP)
        ))
    )
)

(:durative-action push_cylinder
    :parameters (?WP - Workpiece ?conveyor - conveyor)
    :duration (= ?duration 1)
    :condition (and 
        (at start (and
            (type_identified ?WP)
            (WP_provided ?WP ?conveyor)
        ))
    )
    :effect (and 
        (at end (and 
            (in_ramp ?WP)
            (loc_empty ?conveyor)
            (not (WP_provided ?WP ?conveyor))
        ))
    )
)
)