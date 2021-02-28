(define (problem waiting-32) ;; Replace XX with task number
    (:domain waiting)
    (:objects 
        LB - location
        LF - location
        MB - location
        MF - location
        UB - location
        UF - location
        b1 - broom
        p1 - plate
        p2 - plate
        p3 - plate
        f1 - food
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
        (ObjectAt p2 MF)
        (ObjectAt p3 MB)
        (ObjectAt Cust1 LB)
        (ObjectAt f1 UF)
        (ObjectAt b1 UB)
        (EmptyHands Agent)
        (Free p1)
        (Free b1)
        (Broken p2)
        (Broken p3)
    )
    
    (:goal (and 
        (Served Cust1)
        (ObjectAt Agent BUFF)
        (not(exists (?x - plate)(exists (?y - location) (and (ObjectAt ?x ?y) (Broken ?x)))))
        (not(exists (?x - food)(exists (?y - location) (ObjectAt ?x ?y))))
    ))
)
