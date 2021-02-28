(define (domain waiting)
    (:requirements :adl )
    
    (:types
        waiter
        location
        plate
        customer
    )
    
    (:constants 
        ;; You should not need to add any additional constants
        Agent - waiter
        BUFF - location
    )
    
    (:predicates
        ;; Adjacent is used to layout the adjacent areas of the restaurant
        (Adjacent ?x - location ?y - location)
        ;; ObjectAt is used to tell where each object is in the restaurant
        (ObjectAt ?o - object ?x - location)
        ;; When a plate is filled HasFood is true
        (HasFood ?p - plate)
        (Served ?c - customer)
        ;; EmptyHands is used to tell if the agent is holding a plate or not
        (EmptyHands ?a - waiter)
        ;; Free is used to tell if a plate is available to be picked up by the agent
        (Free ?p - plate)
        
    )
    
    (:action PICKUP
        :parameters (?agent - waiter ?plt - plate  ?x - location)
        :precondition (and
            (EmptyHands ?agent)
            (ObjectAt ?plt ?x)
            (ObjectAt ?agent ?x)
            (Free ?plt)
            (not(HasFood ?plt))
        )
        :effect (and
            (not (EmptyHands ?agent))
            (not (ObjectAt ?plt ?x))
            (not (Free ?plt))
        )
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
            (Free ?plt)
            (Served ?cust)
        )
    )
    
    (:action FILL
        :parameters (?agent - waiter ?plt - plate)
        :precondition (and
            (ObjectAt ?agent BUFF)
            (not(Free ?plt))
            (not(HasFood ?plt))
        )
        :effect (and
            (HasFood ?plt)
        )
    )
    
    (:action MOVE
        :parameters (?agent - waiter ?x - location ?y - location)
        :precondition (and
            ;; I used an OR here instead of listing out the mirror of each adjacent tile, e.g. (BUFF, UF) and (UF, BUFF)
            (or (Adjacent ?x ?y) (Adjacent ?y ?x))
            (ObjectAt ?agent ?x)
        )
        :effect (and
            (not(ObjectAt ?agent ?x))
            (ObjectAt ?agent ?y)
        )
    )
)
