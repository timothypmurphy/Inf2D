(define (domain waiting)
    (:requirements :adl )
    
    (:types
        waiter
        location
        plate
        customer
        broom
        food
        ;; Fill in additional types here
    )
    
    (:constants 
        ;; You should not need to add any additional constants
        Agent - waiter
        BUFF - location
    )
    
    (:predicates
        ;; Example:
        ;; (Contains ?x - object ?c - container)
        (Adjacent ?x - location ?y - location)
        (ObjectAt ?o - object ?x - location)
        (HasFood ?p - plate)
        (Served ?c - customer)
        (EmptyHands ?a - waiter)
        (Free ?o - object)
        (Broken ?p - plate)
    )
    
    (:action HANDOVER
        :parameters (?agent - waiter ?cust - customer ?plt - plate ?x - location)
        :precondition (and
            (not(Served ?cust))
            (ObjectAt ?cust ?x)
            (ObjectAt ?agent ?x)
            (not(Free ?plt))
            (HasFood ?plt)
        )
        :effect (and
            (EmptyHands ?agent)
            (ObjectAt ?plt ?x)
            (Served ?cust)
        )
    )
    
    (:action FILL
        :parameters (?agent - waiter ?plt - plate)
        :precondition (and
            (ObjectAt ?agent BUFF)
            (not(Free ?plt))
            (not(HasFood ?plt))
            (not(Broken ?plt))
        )
        :effect (and
            (HasFood ?plt)
        )
    )
    
    (:action MOVE
        :parameters (?agent - waiter ?x - location ?y - location)
        :precondition (and
            (or (Adjacent ?x ?y) (Adjacent ?y ?x))
            (ObjectAt ?agent ?x)
            (not(exists(?z - plate) (and (ObjectAt ?z ?y) (Broken ?z))))
        )
        :effect (and
            (not(ObjectAt ?agent ?x))
            (ObjectAt ?agent ?y)
        )
    )
    
    (:action SWEEP
        :parameters(?agent - waiter ?x - location ?y - location ?brm - broom)
        :precondition (and
            (or (Adjacent ?x ?y) (Adjacent ?y ?x))
            ;;(or 
            ;;    (exists(?p - plate) (and (ObjectAt ?p ?y) (Broken ?p))) 
            ;;    (exists(?f - food) (ObjectAt ?f ?y))
            ;;)
            (ObjectAt ?agent ?x)
            (not(Free ?brm))
            
        )
        :effect (and
            (forall (?p - plate) 
                (when (and (ObjectAt ?p ?y) (Broken ?p)) 
                    (and (not(ObjectAt ?p ?y)))
                )
            )
            (forall (?f - food) 
                (when (and (ObjectAt ?f ?y)) 
                    (and (not(ObjectAt ?f ?y)))
                )
            )
        )
    )
    
    (:action PICKUPPLATE
        :parameters (?agent - waiter ?plt - plate  ?x - location)
        :precondition (and
            (EmptyHands ?agent)
            (ObjectAt ?plt ?x)
            (ObjectAt ?agent ?x)
            (Free ?plt)
            ;;(not(broken ?plt))
        )
        :effect (and
            (not (EmptyHands ?agent))
            (not (ObjectAt ?plt ?x))
            (not (Free ?plt))
        )
    )
    
    (:action PUTDOWNPLATE
        :parameters (?agent - waiter ?plt - plate ?x - location)
        :precondition (and
            (not(Free ?plt))
            (ObjectAt ?agent ?x)
            (not(Broken ?plt))
        )
        :effect (and 
            (ObjectAt ?plt ?x)
            (EmptyHands ?agent)
            (Free ?plt)
        )
    )

    (:action PICKUPBROOM
        :parameters (?agent - waiter ?brm - broom  ?x - location)
        :precondition (and
            (EmptyHands ?agent)
            (ObjectAt ?brm ?x)
            (ObjectAt ?agent ?x)
        )
        :effect (and
            (not (EmptyHands ?agent))
            (not (ObjectAt ?brm ?x))
            (not (Free ?brm))
        )
    )
    
    (:action PUTDOWNBROOM
        :parameters (?agent - waiter ?brm - broom ?x - location)
        :precondition (and
            (ObjectAt ?agent ?x)
            (not(Free ?brm))
        )
        :effect (and 
            (ObjectAt ?brm ?x)
            (EmptyHands ?agent)
            (Free ?brm)
        )
    )
)
