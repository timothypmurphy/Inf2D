-- Inf2d Assignment 1 2018-2019
-- Matriculation number:
-- {-# OPTIONS -Wall #-}


module Inf2d1 where

import Data.List (sortBy)
import Debug.Trace
import TTTGame

gridLength_search::Int
gridLength_search = 6
gridWidth_search :: Int
gridWidth_search = 6



{- NOTES:

-- DO NOT CHANGE THE NAMES OR TYPE DEFINITIONS OF THE FUNCTIONS!
You can write new auxillary functions, but don't change the names or type definitions
of the functions which you are asked to implement.

-- Comment your code.

-- You should submit this file, and only this file, when you have finished the assignment.

-- The deadline is the  13th March 2018 at 3pm.

-- See the assignment sheet and document files for more information on the predefined game functions.

-- See the README for description of a user interface to test your code.

-- See www.haskell.org for haskell revision.

-- Useful haskell topics, which you should revise:
-- Recursion
-- The Maybe monad
-- Higher-order functions
-- List processing functions: map, fold, filter, sortBy ...

-- See Russell and Norvig Chapters 3 for search algorithms,
-- and Chapter 5 for game search algorithms.

-}

-- Section 1: Uniform Search

-- 6 x 6 grid search states

-- The Node type defines the position of the robot on the grid.
-- The Branch type synonym defines the branch of search through the grid.
type Node = (Int,Int)
type Branch = [(Int,Int)]

badNodesList::[Node]
-- This is your list of bad nodes. You should experimet with it to make sure your algorithm covers different cases. 
badNodesList = [(6,2),(5,2),(4,2),(3,2),(2,2),(2,3),(2,4),(2,5),(3,5),(4,5),(5,5),(5,4),(4,4)]

-- The maximum depth this search can reach
-- TODO: Fill in the maximum depth and justify your choice
maxDepth::Int
maxDepth= (gridLength_search * gridWidth_search) -1
-- Why did you choose this number?
-- This is the maximum number of squres on the grid -1. It is not possible to have a longer branch without retracing ones steps


-- The next function should return all the possible continuations of input search branch through the grid.
-- Remember that the robot can only move up, down, left and right, and can't move outside the grid.
-- The current location of the robot is the head of the input branch.
-- Your function should return an empty list if the input search branch is empty.
-- This implementation of next function does not backtrace branches.

next::Branch -> [Branch]
next [] =  []
next ((a,b):xs) = nextHelper ((a,b):xs) 
                 [[(a+1, b) | ((a+1, b) `elem` xs) == False && a+1 < 7], 
                  [(a-1, b) | ((a-1, b) `elem` xs) == False && a-1 > 0], 
                  [(a, b+1) | ((a, b+1) `elem` xs) == False && b+1 < 7], 
                  [(a, b-1) | ((a, b-1) `elem` xs) == False && b-1 > 0]] 

-- The nextHelper function is required to filter out empty lists in the list of branches and also remove branches that contain bad nodes

nextHelper:: Branch -> [Branch] -> [Branch]
nextHelper branch [] = []
nextHelper branch ([]:ys) = nextHelper branch ys
nextHelper branch ((x:xs):ys) | x `elem` badNodesList = nextHelper branch ys
                              | otherwise = ((x:xs) ++ branch) : nextHelper branch ys



-- |The checkArrival function should return true if the current location of the robot is the destination, and false otherwise.
 -- Note that this is the right type declaration for this function. You might have an old version of the Assignment PDF that names this wrongly.
checkArrival::Node -> Node -> Bool
checkArrival destination curNode = destination == curNode


-- Section 3 Uniformed Search
-- | Breadth-First Search
-- The breadthFirstSearch function should use the next function to expand a node,
-- and the checkArrival function to check whether a node is a destination position.
-- The function should search nodes using a breadth first search order.

breadthFirstSearch::Node->(Branch -> [Branch])->[Branch]->[Node]->Maybe Branch

breadthFirstSearch destination next [] exploredList = Nothing
breadthFirstSearch destination next (x:xs) exploredList | checkBranchesArrival destination (x:xs)  == [] = breadthFirstSearch destination next (filterNodes(nextBranches (x:xs)) (appendExploredList (x:xs) exploredList)) (appendExploredList (x:xs) exploredList)
														| otherwise = Just (checkBranchesArrival destination (x:xs))


-- The appendExploredList function will update the explored list with the most recent travelled node														  
appendExploredList :: [Branch] -> [Node] -> [Node]
appendExploredList [] nodes = []
appendExploredList ((x:xs):ys) nodes | x `elem` nodes = appendExploredList ys nodes
                                     | otherwise = x : appendExploredList ys nodes

-- checkBranchesArrival will check all heads of branches to see if any of them have arrived at the destination
checkBranchesArrival :: Node -> [Branch] -> Branch
checkBranchesArrival destination [] = []
checkBranchesArrival destination ((x:xs):ys) | checkArrival destination x = reverse (x:xs)
                                             | otherwise = checkBranchesArrival destination ys
 
-- filterNodes removes any branches that contain an explored node at the head
filterNodes::[Branch] -> [Node] -> [Branch]
filterNodes branches [] = branches
filterNodes [] nodes = []
filterNodes (((a,b):xs):ys) exploredNodes | (a,b) `elem` exploredNodes = filterNodes ys exploredNodes
                                          | otherwise = ((a,b):xs) : filterNodes ys exploredNodes

-- nextBranches gets the next possible moves for all branches
nextBranches::[Branch] -> [Branch]
nextBranches [] = []
nextBranches (x:xs) = next x ++ nextBranches xs

-- All of these functions are recursive so would be difficult to implement within one whole function. 
-- They will also be used in other search problems and help to make my code more readable


-- | Depth-First Search
-- The depthFirstSearch function is similiar to the breadthFirstSearch function,
-- except it searches nodes in a depth first search order.
depthFirstSearch::Node->(Branch -> [Branch])->[Branch]-> [Node]-> Maybe Branch
depthFirstSearch destination next [] exploredList = Nothing
depthFirstSearch destination next ((x:xs):ys) exploredList | checkArrival destination x = Just (reverse (x:xs))
                                                           | (filterNodes (next (x:xs)) exploredList) == [] = depthFirstSearch destination next ys (exploredList ++ [x])
                                                           | otherwise = depthFirstSearch destination next ((filterNodes (next (x:xs)) (exploredList ++ [x])) ++ ys) (exploredList ++ [x])

-- | Depth-Limited Search
-- The depthLimitedSearch function is similiar to the depthFirstSearch function,
-- except its search is limited to a pre-determined depth, d, in the search tree.
depthLimitedSearch::Node->(Branch -> [Branch])->[Branch]-> Int-> Maybe Branch
depthLimitedSearch destination next [] d = Nothing
depthLimitedSearch destination next ((x:xs):ys) d | checkArrival destination x = Just (reverse (x:xs))
                                                  | (next (x:xs)) == [] = depthLimitedSearch destination next ys d
                                                  | length (x:xs) == d+1 = depthLimitedSearch destination next ys d
                                                  | otherwise = depthLimitedSearch destination next ((next (x:xs)) ++ ys) d


-- | Iterative-deepening search
-- The iterDeepSearch function should initially search nodes using depth-first to depth d,
-- and should increase the depth by 1 if search is unsuccessful.
-- This process should be continued until a solution is found.
-- Each time a solution is not found the depth should be increased.
iterDeepSearch:: Node-> (Branch -> [Branch])->Node -> Int-> Maybe Branch
iterDeepSearch destination next initialNode d = iterLoop destination next initialNode [[initialNode]] d 

-- iterLoop is used to store the list of branches that are being explored so it can be acted on recursively
iterLoop :: Node-> (Branch -> [Branch])-> Node -> [Branch] -> Int -> Maybe Branch
iterLoop destination next n [] d | d == maxDepth = Nothing
                                 | otherwise = iterLoop destination next n [[n]] (d+1) 
iterLoop destination next n ((x:xs):ys) d | checkArrival destination x = Just (reverse (x:xs))
                                          | (next (x:xs)) == [] = iterLoop destination next n ys d 
                                          | length (x:xs) == d+1 = iterLoop destination next n ys d 
                                          | otherwise = iterLoop destination next n ((next (x:xs)) ++ ys) d 

-- | Section 4: Informed search

-- Manhattan distance heuristic
-- This function should return the manhattan distance between the 'position' point and the 'destination'.

manhattan::Node->Node->Int
manhattan (a,b) (c,d) = abs ((a-c) + (b-d))

-- | Best-First Search
-- The bestFirstSearch function uses the checkArrival function to check whether a node is a destination position,
-- and the heuristic function (of type Node->Int) to determine the order in which nodes are searched.
-- Nodes with a lower heuristic value should be searched before nodes with a higher heuristic value.

bestFirstSearch::Node->(Branch -> [Branch])->(Node->Int)->[Branch]-> [Node]-> Maybe Branch
--bestFirstSearch destination next heur b exp = bestFirstSearchSorted destination next heur (bfsSort b heur) exp
bestFirstSearch dest next heur [] exp = Nothing
bestFirstSearch dest next heur ((x:xs):ys) exp | checkArrival dest x = Just (reverse (x:xs))
                                               | (filterNodes (next (x:xs)) exp) == [] = bestFirstSearch dest next heur (bfsSort ys heur) (exp ++ [x])
                                               | otherwise = bestFirstSearch dest next heur (bfsSort((filterNodes (next (x:xs)) (exp ++ [x])) ++ ys) heur) (exp ++ [x])

-- bfsSort is used to sort the branches based on the heuristic function
bfsSort::[Branch]->(Node->Int)->[Branch]
bfsSort ((x:xs):(y:ys):zs) h | h x > h y = bfsSort ((y:ys) : zs) h ++ [(x:xs)] 
                             | otherwise = (x:xs) : bfsSort ((y:ys):zs) h
bfsSort ((x:xs):(y:ys):[]) h | h x > h y = [(x:xs)] ++ [(y:ys)]
                             | otherwise = [(y:ys)] ++ [(x:xs)]
bfsSort x h = x

    
	
-- | A* Search
-- The aStarSearch function is similar to the bestFirstSearch function
-- except it includes the cost of getting to the state when determining the value of the node.

--aStarSearch::Node->(Branch -> [Branch])->(Node->Int)->(Branch ->Int)->[Branch]-> [Node]-> Maybe Branch
--aStarSearch destination next heuristic cost branches exploredList = aStarSearchSorted destination next heuristic cost (aStarSort branches heuristic cost) exploredList

aStarSearch::Node->(Branch -> [Branch])->(Node->Int)->(Branch ->Int)->[Branch]-> [Node]-> Maybe Branch
aStarSearch dest next heur cost [] exp = Nothing
aStarSearch dest next heur cost ((x:xs):ys) exp | checkArrival dest x = Just (reverse (x:xs))
                                                | (filterNodes (next (x:xs)) exp) == [] = aStarSearch dest next heur cost (aStarSort ys heur cost) (exp ++ [x])
                                                | otherwise = aStarSearch dest next heur cost (aStarSort((filterNodes (next (x:xs)) (exp ++ [x])) ++ ys) heur cost) (exp ++ [x])

-- aStarSort, similar to bfs sort, is used to sort the list of branches based on the heuristic and cost function
aStarSort::[Branch]->(Node->Int)->(Branch ->Int)->[Branch]
aStarSort ((x:xs):(y:ys):zs) h c | h x + c (x:xs) > h y + c (y:ys) = aStarSort ((y:ys) : zs) h c ++ [(x:xs)] 
                                 | otherwise = (x:xs) : aStarSort ((y:ys):zs) h c
aStarSort ((x:xs):(y:ys):[]) h c | h x + c (x:xs) > h y + c (y:ys) = [(x:xs)] ++ [(y:ys)]
                                 | otherwise = [(y:ys)] ++ [(x:xs)]
aStarSort x h c = x

    
	
-- | The cost function calculates the current cost of a trace, where each movement from one state to another has a cost of 1.
cost :: Branch  -> Int
cost branch = length branch - 1


-- | Section 5: Games
-- See TTTGame.hs for more detail on the functions you will need to implement for both games' minimax and alphabeta searches. 



-- | Section 5.1 Tic Tac Toe


-- | The eval function should be used to get the value of a terminal state. 
-- A positive value (+1) is good for max player. The human player will be max.
-- A negative value (-1) is good for min player. The computer will be min.
-- A value 0 represents a draw.

eval :: Game -> Int
-- simply checks if player 1 has won, and if so returns 1, else check for player 0 and if so returns -1, else returns 0 as draw
eval game | checkWin game 1 = 1
          | checkWin game 0 = -1
          | otherwise = 0

-- | The minimax function should return the minimax value of the state (without alphabeta pruning).
-- The eval function should be used to get the value of a terminal state. 



-- Minimax can somtimes take over 2 minutes to run
minimax:: Game->Player->Int
minimax game 1 | terminal game = eval game
               | otherwise = (minimaxHelper (moves game 1) 0)
minimax game 0 | terminal game = eval game
               | otherwise = (minimaxHelper (moves game 0) 1)
                
-- minimaxHelper is used to like minimax, except it takes a list of games, so it can process the list of possible moves recursively 
minimaxHelper :: [Game]->Player->Int
minimaxHelper (x:[]) p | terminal x = eval x
                       | p == 1 = (minimaxHelper (moves x 1) 0)
                       | otherwise = (minimaxHelper (moves x 0) 1)
minimaxHelper (x:xs) 1 | terminal x = eval x
                       | otherwise = min (minimaxHelper (moves x 1) 0) (minimaxHelper xs 1)
minimaxHelper (x:xs) 0 | terminal x = eval x
                       | otherwise = max (minimaxHelper (moves x 0) 1) (minimaxHelper xs 0)
	

-- | The alphabeta function should return the minimax value using alphabeta pruning.
-- The eval function should be used to get the value of a terminal state. 

alphabeta:: Game->Player->Int
alphabeta game 1 | terminal game = eval game
                 | otherwise = (alphabetaHelper (moves game 1) 0 (-2) 2)
alphabeta game 0 | terminal game = eval game
                 | otherwise = (alphabetaHelper (moves game 0) 1 (-2) 2)

-- alphabetaHelper is used to process a list of games recursively and also keeps track of the mins and maxs for a b pruning
alphabetaHelper :: [Game]->Player->Int->Int->Int
alphabetaHelper (x:[]) p a b | terminal x = eval x
                             | p == 1 = (alphabetaHelper (moves x 1) 0 a b)
                             | otherwise = (alphabetaHelper (moves x 0) 1 a b)

alphabetaHelper (x:xs) 1 a b | terminal x = eval x
                             | otherwise = prune xs 1 (alphabetaHelper (moves x 1) 0 a b) a b

alphabetaHelper (x:xs) 0 a b | terminal x = eval x
                             | otherwise = prune xs 0 (alphabetaHelper (moves x 0) 1 a b) a b

-- prune will prune the list of games based on the mins and maxs 
prune :: [Game]->Player->Int->Int->Int->Int
prune xs 1 lim a b | (min b lim) < a = lim
                   | otherwise = min lim (alphabetaHelper xs 1 (min b lim) b)

prune xs 0 lim a b | b < (max a lim) = lim
                   | otherwise = max lim (alphabetaHelper xs 0 a (max a lim))
    
-- | Section 5.2 Wild Tic Tac Toe





-- | The evalWild function should be used to get the value of a terminal state. 
-- It should return 1 if either of the move types is in the correct winning position. 
-- A value 0 represents a draw.

evalWild :: Game -> Int
-- simply gives the player who reached(!) the terminal state +1  if either the x's or the o's are in the correct position.
evalWild game | checkWin game 1 = 1
              | checkWin game 0 = 1
              | otherwise = 0



-- | The alphabetaWild function should return the minimax value using alphabeta pruning.
-- The evalWild function should be used to get the value of a terminal state. Note that this will now always return 1 for any player who reached the terminal state.
-- You will have to modify this output depending on the player. If a move by the max player sent(!) the game into a terminal state you should give a +1 reward. 
-- If the min player sent the game into a terminal state you should give -1 reward. 

alphabetaWild:: Game->Player->Int
alphabetaWild game 1 | terminal game && evalWild game /= 0 = -1
                     | terminal game = evalWild game
                     | otherwise = (alphabetaHelperWild (moves game 1) 0 (-2) 2)
alphabetaWild game 0 | terminal game && evalWild game /= 0 = 1
                     | terminal game = evalWild game
                     | otherwise = (alphabetaHelperWild (moves game 0) 1 (-2) 2)
	
alphabetaHelperWild :: [Game]->Player->Int->Int->Int
alphabetaHelperWild (x:[]) 1 a b | terminal x && evalWild x /= 0 = -1
                                 | terminal x = evalWild x
                                 | otherwise = (alphabetaHelperWild (moves x 1) 0 a b)
alphabetaHelperWild (x:[]) 0 a b | terminal x && evalWild x /= 0 = 1
                                 | terminal x = evalWild x
                                 | otherwise = (alphabetaHelperWild (moves x 0) 1 a b)
alphabetaHelperWild (x:xs) 1 a b | terminal x && evalWild x /= 0 = -1
                                 | terminal x = evalWild x
                                 | otherwise = pruneWild xs 1 (alphabetaHelperWild (moves x 1) 0 a b) a b
alphabetaHelperWild (x:xs) 0 a b | terminal x && evalWild x /= 0 = 1
                                 | terminal x = evalWild x
                                 | otherwise = pruneWild xs 0 (alphabetaHelperWild (moves x 0) 1 a b) a b
                     

pruneWild :: [Game]->Player->Int->Int->Int->Int
pruneWild xs 1 lim a b | (min b lim) < a = lim
                       | otherwise = min lim (alphabetaHelperWild xs 1 (min b lim) b)
pruneWild xs 0 lim a b | b < (max a lim) = lim
                       | otherwise = max lim (alphabetaHelperWild xs 0 a (max a lim))
-- | End of official assignment. However, if you want to also implement the minimax function to work for Wild Tic Tac Toe you can have a go at it here. This is NOT graded.

		
-- | The minimaxWild function should return the minimax value of the state (without alphabeta pruning). 
-- The evalWild function should be used to get the value of a terminal state. 

minimaxWild:: Game->Player->Int
minimaxWild game player =undefined
	

			
			-- | Auxiliary Functions
-- Include any auxiliary functions you need for your algorithms here.
-- For each function, state its purpose and comment adequately.
-- Functions which increase the complexity of the algorithm will not get additional scores
 


