(define (problem waiting-22) ;; Replace XX with task number
    (:domain waiting)
    (:objects 
        p1 - plate
        LB - location
        LF - location
        MB - location
        MF - location
        UB - location
        UF - location
        Cust1 - customer
    )
    
    (:init
        (Adjacent BUFF UF)
        (Adjacent UF MF)
        (Adjacent MF LF)
        (Adjacent LF LB)
        (Adjacent LB MB)
        (Adjacent MB UB)
        (Adjacent UB UF)
        (ObjectAt Agent BUFF)
        (ObjectAt p1 BUFF)
        (ObjectAt Cust1 LB)
        (EmptyHands Agent)
        (Free p1)
    )
    
    (:goal (and 
        (Served Cust1)
    ))
)
