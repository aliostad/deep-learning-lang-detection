(*
    Copyright (C) 2013  Matthew Mcveigh

    This file is part of F# Unaffiliated BTC-E Trading Framework.

    F# Unaffiliated BTC-E Trading Framework is free software; you can redistribute it and/or
    modify it under the terms of the GNU Lesser General Public
    License as published by the Free Software Foundation; either
    version 3 of the License, or (at your option) any later version.

    F# Unaffiliated BTC-E Trading Framework is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
    Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public
    License along with F# Unaffiliated BTC-E Trading Framework. If not, see <http://www.gnu.org/licenses/>.
*)

namespace TradingFramework

module GeneticProgramming =

    open System

    open TaLib

    type TreeNodeValue<'t> = { 
        BranchNumber: int
        LeafNumber: int
        NumberOfBranches: int
        NumberOfLeafs: int
        Data: 't
    }

    type TreeNode<'t, 'u> = 
        | Leaf of TreeNodeValue<'u>
        | Branch of TreeNodeValue<'t> * TreeNode<'t, 'u> list

    type EvaluationTree<'t, 'u> = { root: TreeNode<'t, 'u> }

    let getPopulationWithFitness population fitness =
        List.map (fun program -> program, fitness(program)) population

    /// Fitness must be return an integer greater than zero
    let fitnessProportionalSelection randomNumberGenerator (population:'a list) fitness =
        assert (population.Length > 1)

        let populationWithFitness = getPopulationWithFitness population fitness

        let extractFitness (program, fitness) = 
            assert(fitness > decimal(0))
            fitness

        let sumOfFitness = List.sumBy extractFitness populationWithFitness
        
        let populationWithProbability = List.map (fun (program, fitness) -> (program, fitness / sumOfFitness)) populationWithFitness

        // Descending order
        let populationWithProbability = List.sortBy (fun (_, probability) -> probability) populationWithProbability
        
        let randomNumber = randomNumberGenerator()
        assert (randomNumber >= 0.0 && randomNumber < 1.0)

        let rec selectPopulate populationWithProbability accumulator =
            match populationWithProbability with
            | (program, probability) :: tail ->  
                if decimal(randomNumber) < probability + accumulator then
                    program
                else
                    selectPopulate tail (probability + accumulator)
            | [] -> 
                failwith "Unreachable"

        selectPopulate populationWithProbability (decimal(0))

    let tournamentSelectionPopulationWithFitness randomNumberGenerator (populationWithFitness:('a * 'b) list) tournamentSize = 
        assert(tournamentSize > 0 && tournamentSize <= populationWithFitness.Length)

        let tournament = [ 
            for _ in 1..tournamentSize do 
            let index = randomNumberGenerator tournamentSize
            assert(index >= 0 && index < populationWithFitness.Length)
            yield populationWithFitness.[index] ]

        let (winner, _) = List.maxBy (fun (_, fitness) -> fitness) tournament

        winner

    let tournamentSelection randomNumberGenerator (population:'a list) (fitness:'a -> decimal) tournamentSize = 
        let populationWithFitness = getPopulationWithFitness population fitness

        tournamentSelectionPopulationWithFitness randomNumberGenerator populationWithFitness tournamentSize

    let generateChildren grow numberOfChildren depth branchesToTheLeft leavesToTheLeft  =
        let rec generateChild numberOfChildren children =
            let branchesToTheLeft = (List.sumBy (fun x -> match x with | Branch(x, _) -> x.NumberOfBranches | _ -> 0) children) + branchesToTheLeft
            let leavesToTheLeft = (List.sumBy (fun x -> match x with | Branch(x, _) -> x.NumberOfLeafs | Leaf(_) -> 1) children) + leavesToTheLeft

            let child = grow depth branchesToTheLeft leavesToTheLeft

            if numberOfChildren = 1 then
                [child]
            else
                child :: generateChild (numberOfChildren - 1) (child :: children)

        generateChild numberOfChildren []

    let createNode createBranchFunction createLeafFunction branchesToTheLeft leavesToTheLeft = function
    | Some(children) -> 
        let branchesInChildren = (List.sumBy (fun x -> match x with | Branch(x, _) -> x.NumberOfBranches | _ -> 0) children)
        Branch({
                BranchNumber = branchesToTheLeft + branchesInChildren + 1
                LeafNumber = 0
                NumberOfBranches = branchesInChildren + 1
                NumberOfLeafs = List.sumBy (fun x -> match x with | Branch(x, _) -> x.NumberOfLeafs | Leaf(_) -> 1) children
                Data = createBranchFunction()
        }, children)
    | None ->
        Leaf({
                BranchNumber = 0
                LeafNumber = leavesToTheLeft + 1
                NumberOfBranches = 0
                NumberOfLeafs = 1
                Data = createLeafFunction()
        })

    let populateByGrowthApply branchGenerator leafGenerator generateIsLeaf generateNumberOfChildren =
        let rec grow depth branchesToTheLeft leavesToTheLeft =
            let createNode = createNode branchGenerator leafGenerator branchesToTheLeft leavesToTheLeft

            if generateIsLeaf depth branchesToTheLeft leavesToTheLeft then
                createNode None
            else
                let numberOfChildren = generateNumberOfChildren depth branchesToTheLeft leavesToTheLeft
                let children = generateChildren grow numberOfChildren (depth + 1) branchesToTheLeft leavesToTheLeft

                createNode <| Some(children)

        { root = grow 0 0 0 }

    /// <summary>
    /// Generates a program using the grow method.
    /// </summary>
    /// <param name="branchGenerator">Function that creates and returns the value for a branch node.</param>
    /// <param name="leafGenerator">Function that creates and returns the value for a leaf node.</param>
    /// <param name="randomNumberGenerator">Function that's expected to generate a random number in the range of 0..argument-1</param>
    /// <param name="maxDepth">Maximum depth of the tree (level of the lowest possible child).</param>
    /// <param name="maxChildren">Maximum number of children a branch node may be given.</param>
    /// <param name="chanceOfLeaf">1 in chanceOfLeafNode chance of the trees being combined on a leaf node. e.g. If you want a chance of 1 in 10 then you'd pass 10.</param>
    let populateByGrowth branchGenerator leafGenerator randomNumberGenerator maxDepth maxChildren chanceOfLeaf =
        assert(maxDepth > 0 && maxChildren > 0)

        let generateIsLeaf depth _ _ =
            depth = maxDepth || randomNumberGenerator chanceOfLeaf = 0

        let generateNumberOfChildren _ _ _ =
            (randomNumberGenerator maxChildren) + 1
        
        populateByGrowthApply branchGenerator leafGenerator generateIsLeaf generateNumberOfChildren

    type NodePosition =
        {
            BranchNumber: int
            LeafNumber: int
            NumberOfBranches: int
            NumberOfLeafs: int
        }

    let extractNodeValuePosition (value: TreeNodeValue<'a>) = 
        {
            BranchNumber = value.BranchNumber
            LeafNumber = value.LeafNumber
            NumberOfBranches = value.NumberOfBranches
            NumberOfLeafs = value.NumberOfLeafs
        }

    let extractNodePosition = function
    | Leaf(value) -> extractNodeValuePosition value
    | Branch(value, _) -> extractNodeValuePosition value

    let rec copyChildren provideOwnCopy leavesToTheLeft branchesToTheLeft mutate copyNode = function
    | child :: tail ->
        let child = copyNode provideOwnCopy leavesToTheLeft branchesToTheLeft child mutate

        let childPosition = extractNodePosition child
        let leavesToTheLeft = leavesToTheLeft + childPosition.NumberOfLeafs
        let branchesToTheLeft = branchesToTheLeft + childPosition.NumberOfBranches

        child :: copyChildren provideOwnCopy leavesToTheLeft branchesToTheLeft mutate copyNode tail
    | [] -> []

    let rec copyNode copyLeaf copyBranch provideOwnCopy leavesToTheLeft branchesToTheLeft node mutate =
        match node with
        | Leaf(node) -> 
            match provideOwnCopy (extractNodeValuePosition node) leavesToTheLeft branchesToTheLeft true with
                | Some(copy) -> copy
                | None ->
                    mutate <| copyLeaf leavesToTheLeft node
        | Branch(node, children) -> 
            match provideOwnCopy (extractNodeValuePosition node) leavesToTheLeft branchesToTheLeft false with
                | Some(copy) -> copy
                | None ->
                    mutate <| copyBranch leavesToTheLeft branchesToTheLeft node children provideOwnCopy mutate

    let copyLeaf leavesToTheLeft leafNode =
        let leaf = {
            BranchNumber = 0
            LeafNumber = leavesToTheLeft + 1
            NumberOfBranches = 0
            NumberOfLeafs = 1
            Data = leafNode.Data
        }
        TreeNode.Leaf(leaf)

    let rec copyBranch leavesToTheLeft branchesToTheLeft branchNode children provideOwnCopy mutate =
        let copyNode = copyNode copyLeaf copyBranch
        let children = copyChildren provideOwnCopy leavesToTheLeft branchesToTheLeft mutate copyNode children
        let branchesInChildren = List.sumBy (fun x -> match x with | TreeNode.Branch(x, _) -> x.NumberOfBranches | _ -> 0) children
        let branchNode = {
            BranchNumber = branchesToTheLeft + branchesInChildren + 1
            LeafNumber = 0
            NumberOfBranches = branchesInChildren + 1
            NumberOfLeafs = List.sumBy (fun x -> match x with | TreeNode.Branch(x, _) -> x.NumberOfLeafs | TreeNode.Leaf(_) -> 1) children
            Data = branchNode.Data
        }
        TreeNode.Branch(branchNode, children)

    let reproduce program mutate =
        { root = copyNode copyLeaf copyBranch (fun _ _ _ _ -> None) 0 0 program.root mutate }

    /// <summary>
    /// Combines two trees (programs) together at a random point. The root of the rhs tree replaces a node somewhere within the lhs tree.
    /// </summary>
    /// <param name="mutate">This function is applied to all nodes in the tree, if you return a new node then the node passed to the function will be replaced in the combined tree with the new node.</param>
    /// <returns>Combined tree, all the nodes in this tree are copies, so mutate the lhs or rhs trees will not mutate the combined tree.</returns>
    let combine (lhsNode: TreeNode<'a,'b>) (lhsNodeToCombineOn: TreeNode<'a,'b>) rhsNode mutate =
        let f = extractNodePosition lhsNodeToCombineOn

        let provideOwnCopy node leafsToTheLeft branchesToTheLeft isLeaf = 
            if f = node then
                Some(copyNode copyLeaf copyBranch (fun _ _ _ _ -> None) leafsToTheLeft branchesToTheLeft rhsNode mutate)
            else
                None

        { root = copyNode copyLeaf copyBranch provideOwnCopy 0 0 lhsNode mutate }

    type NodeLocation =
    | BranchPosition of int
    | LeafPosition of int

    /// <summary>
    /// Finds the node at the given location by walking down (depth first) from the given root node.
    /// </summary>
    let walkToNode position root =
        let rec walkChildren walk = function
        | child :: children -> 
            match walk child with
            | Some(x) -> Some(x)
            | None -> walkChildren walk children
        | [] -> None

        let rec walk node = 
            match node with
            | Branch(value, children) -> 
                match position with
                | BranchPosition(position) when position = value.BranchNumber -> Some(node)
                | _ -> walkChildren walk children
            | Leaf(value) -> 
                match position with
                | LeafPosition(position) when position = value.LeafNumber -> Some(node)
                | _ -> None
            
        walk root

    /// <summary>
    /// Finds a random node within a tree.
    /// </summary>
    /// <param name="chanceOfLeafNode">1 in chanceOfLeafNode chance of the trees being combined on a leaf node. e.g. If you want a chance of 1 in 10 then you'd pass 10.</param>
    /// <param name="randomNumberGenerator">Function that's expected to generate a random number in the range of 0..argument-1</param>
    let selectNode chanceOfLeafNode randomNumberGenerator tree =
        // If root is a leaf then make the chance of a leaf 1/1
        let combineOnLeaf = 
            match tree.root with
            | Leaf(_) -> true
            | _ -> randomNumberGenerator chanceOfLeafNode = 1

        let rootPosition = extractNodePosition tree.root

        // Range of 1..n rather than 0..n - 1
        let nodeLocation = 
            if combineOnLeaf then
                LeafPosition((randomNumberGenerator rootPosition.NumberOfLeafs) + 1)
            else
                BranchPosition((randomNumberGenerator rootPosition.NumberOfBranches) + 1)

        walkToNode nodeLocation tree.root
    
    /// <summary>
    /// Cut and splice crossover of two trees lhs and rhs.
    /// </summary>
    /// <param name="selectNode">Function that's expected to return a node to perform the crossover on when given a tree.</param>
    /// <param name="mutate">This function is applied to all nodes in the trees, if you return a new node then the node passed to the function will be replaced in the crossed over trees with the new node.</param>
    let crossover lhs rhs selectNode mutate =
        match selectNode lhs, selectNode rhs with
        | (Some(lhsNode), Some(rhsNode)) -> 
            let left = combine lhs.root lhsNode rhsNode mutate
            let right = combine rhs.root rhsNode lhsNode mutate
            left, right
        | _ -> failwith "Failed to find a point to crossover on both trees."