(define (problem waiting-23) ;; Replace XX with task number
    (:domain waiting)
    (:objects 
        p1 - plate
        p2 - plate
        LB - location
        LF - location
        MB - location
        MF - location
        UB - location
        UF - location
        Cust1 - customer
        Cust2 - customer
    )
    
    (:init
        (Adjacent BUFF UF)
        (Adjacent UF MF)
        (Adjacent MF LF)
        (Adjacent LF LB)
        (Adjacent LB MB)
        (Adjacent MB UB)
        (Adjacent UB UF)
        (ObjectAt Agent MF)
        (ObjectAt p1 MB)
        (ObjectAt p2 LB)
        (ObjectAt Cust1 UB)
        (ObjectAt Cust2 LF)
        (EmptyHands Agent)
        (Free p1)
        (Free p2)
    )
    
    (:goal (and 
        (Served Cust1)
        (Served Cust2)
        (ObjectAt Agent BUFF)
    ))
)
