(define (domain waiting)
    (:requirements :adl )
    
    (:types
        waiter
        location
        plate
        customer
        broom
        food
    )
    
    (:constants 
        ;; You should not need to add any additional constants
        Agent - waiter
        BUFF - location
    )
    
    (:predicates
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
            ;; Once the plate has been handed to the customer the location is no longer stored, as the plate has no more use in this model.
            (EmptyHands ?agent)
            (Served ?cust)
            (not(HasFood ?plt))
            (Free ?plt)
            
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
            ;; If the agent is holding a broom and is adjacent to a tile with a broken plate or spilt food then it should brush it up instead of moving. The code below ensures this.
            (or
                (and 
                    (not(exists (?p - plate)(exists (?z - location) (and 
                         (ObjectAt ?p ?z) 
                         (Broken ?p) 
                         (or 
                            (Adjacent ?x ?z) 
                            (Adjacent ?z ?x)
                        )
                    ))))
                    (not(exists (?f - food)(exists (?z - location) (and 
                        (ObjectAt ?f ?z) 
                        (or 
                            (Adjacent ?x ?z) 
                            (Adjacent ?z ?x)
                        )
                    ))))
                )
                (and
                    (not(exists(?brm - broom)(not(Free ?brm))))
                    (not(exists (?p - plate) (and 
                         (ObjectAt ?p ?y) 
                         (Broken ?p) 
                    )))
                )
            )
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
            ;; Only sweep if there is a broken plate or spilt food.
            (or 
                (exists(?p - plate) (and (ObjectAt ?p ?y) (Broken ?p))) 
                (exists(?f - food) (ObjectAt ?f ?y))
            )
            (ObjectAt ?agent ?x)
            (not(Free ?brm))
        )
        :effect (and
            ;; Remove all broken plates and spilled food from the tile that has been swept
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
            (not(broken ?plt))
            (Free ?plt)
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
            ;; A plate should only be put down when it has no food i.e., The agent should never fill a plate with food unless there is a clear path to the customer it is going to serve.
            (not(Free ?plt))
            (ObjectAt ?agent ?x)
            (not(Broken ?plt))
            (not(HasFood ?plt))
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
            ;; Only put down the broom when the whole restaurant is clean
            (not(exists (?p - plate)(exists (?z - location) (and 
                (ObjectAt ?p ?z) 
                (Broken ?p) 
            ))))
            (not(exists (?f - food)(exists (?z - location) (and 
                (ObjectAt ?f ?z) 
            ))))
                
        )
        :effect (and 
            (ObjectAt ?brm ?x)
            (EmptyHands ?agent)
            (Free ?brm)
        )
    )
)
