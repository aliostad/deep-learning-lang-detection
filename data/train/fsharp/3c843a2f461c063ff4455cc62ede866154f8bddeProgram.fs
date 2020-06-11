open System
open System.Collections

//
//
//  Convenience
//
//

let swap f x y = f y x
let id x = x
let currify2 f x y = f (x, y)
let uncurrify2 f (x, y) = f x y

let write_line: string -> unit = Console.WriteLine
let write_lines: string list -> unit = List.iter write_line
let read_line: unit -> string = Console.ReadLine

//
//
//  Base data
//
//

type units =
| Kilograms
| Grams

let string_of_units = function
| Kilograms -> "kg"
| Grams -> "g"

let convert_units x y z =
    if y = z 
    then x
    else
        match z with
        | Kilograms -> x / 1000.0f
        | Grams -> x * 1000.0f

// ingredients
type ingredient = {
    ing_name: string
    amount: float
    cost: float
    unit: units
}
let ingredients: ingredient list ref = ref []

let string_of_ingredient ing = 
    ing.ing_name
    + ": "
    + string ing.amount
    + string_of_units ing.unit
    + " at $"
    + string ing.cost
    + "/"
    + string_of_units ing.unit

let try_find_ingredient (s: string) l = List.tryFind (fun h -> h.ing_name.ToUpper() = s.ToUpper()) l

let find_ingredient (s: string) l = List.find (fun h -> h.ing_name.ToUpper() = s.ToUpper()) l

let update_ingredient ing = ingredients := ing :: List.filter (fun h -> h.ing_name <> ing.ing_name) !ingredients

let remove_ingredient s = ingredients := List.filter (fun h -> h.ing_name <> s) !ingredients

// recipes
type recipe = {
    rcp_name: string
    ingredients: (string * float) list
}                              
let recipes: recipe list ref = ref []     

let try_find_recipe (s: string) l = List.tryFind (fun h -> h.rcp_name.ToUpper() = s.ToUpper()) l

let try_find_recipe_ingredient (s: string) l = List.tryFind (fun (name: string, _) -> name.ToUpper() = s.ToUpper()) l

let get_recipe_stock rcp =
    if rcp.ingredients = [] then
        0
    else
        rcp.ingredients
        |> List.map (fun (name: string, amt: float) -> 
            let stock = find_ingredient name !ingredients
            stock.amount / amt
        )
        |> List.fold (currify2 Math.Min) Double.MaxValue
        |> int

let get_recipe_ingredient_cost (name: string, amt: float) =
    let stock = find_ingredient name !ingredients
    stock.cost * amt

let get_recipe_cost rcp =
    rcp.ingredients
    |> List.map get_recipe_ingredient_cost
    |> List.sum

let string_of_ingredient_cost s amt = 
    let ing = find_ingredient s !ingredients
    ing.ing_name
    + ": "
    + string amt
    + string_of_units ing.unit
    + " for $"
    + string (ing.cost * amt)
    + " of "
    + string ing.amount
    + string_of_units ing.unit
    + " at $"
    + string ing.cost
    + "/"
    + string_of_units ing.unit

let string_of_recipe rcp =
    [
        rcp.rcp_name + ": $" + string (get_recipe_cost rcp) + " with ingredients for " + string (get_recipe_stock rcp)
        "Ingredients:"
    ] @ List.map (uncurrify2 string_of_ingredient_cost >> (+) "\t") rcp.ingredients
    |> List.map (fun h -> h + "\n") 
    |> List.reduce (+)

let update_recipe rcp =
    recipes :=
        List.fold (fun a h -> 
            if h.rcp_name = rcp.rcp_name
            then rcp :: a
            else h :: a
        ) [] !recipes

let remove_recipe s = recipes := List.filter (fun h -> h.rcp_name <> s) !recipes

//
//
//  Input control flow
//
//

let test_input_loop msg exit init trans filt post pass fail =
    let ans = ref init
    let cont = ref true
    while !cont do
        let input = read_line ()
        if input = exit then
            cont := false   
            write_line ""
            fail ()
        else
            if not (try ans := trans input; true with _ -> false) || not (filt !ans) then 
                write_line msg
            else 
                cont := false
                write_line ""
                pass <| post !ans

let test_float_input_loop = test_input_loop "Invalid input" "" 0.0 float (fun _ -> true) id

let test_option_input_loop l = test_input_loop "Invalid input" "0" 0 int (swap List.contains l) id

let test_ingredient_input_loop msg = test_input_loop msg "" None (swap try_find_ingredient !ingredients) Option.isSome Option.get

let test_recipe_input_loop msg = test_input_loop msg "" None (swap try_find_recipe !recipes) Option.isSome Option.get

let test_recipe_ingredient_input_loop msg rcp = test_input_loop msg "" None (swap try_find_recipe_ingredient rcp.ingredients) Option.isSome Option.get

let test_string_input_loop = test_input_loop "" "" "" id (fun _ -> true) id

let test_int_input_loop = test_input_loop "Invalid input" "" 0 int (fun _ -> true) id

//
//
//  Initialize from file
//
//

let _ =
    try
        let file = IO.File.ReadAllLines("inventory.txt").[0].Split('|')
        let i = ref 1
        let get () = let ans = file.[!i] in i := !i + 1; ans
        while !i < Array.length file do
            match get () with
            | "Ingredient" ->
                ingredients :=
                    {
                        ing_name = get ()
                        amount = float (get ())
                        cost = float (get ())
                        unit = 
                            match get () with
                            | "kg" -> Kilograms
                            | "g" -> Grams
                            | _ -> Kilograms
                    } :: !ingredients
            | "Recipe" ->
                let rcp_name = get ()
                let num_rcp_ings = int (get ())
                let rcp_ings = Array.map (fun _ -> (get (), float (get ()))) [|1 .. num_rcp_ings|]
                recipes :=
                    {
                        rcp_name = rcp_name
                        ingredients = Array.toList rcp_ings
                    } :: !recipes
            | _ -> i := Array.length file
    with _ -> ()

//
//
//  State routing
//
//

type state =
| Main      
    | Stock_manage_ingredients
        | Stock_ingredient
            | Stock_amount
            | Stock_cost
            | Stock_remove
        | Stock_add_ingredient
    | Manage_recipes
        | Recipe
            | Recipe_ingredient
                | Recipe_amount
                | Recipe_remove
            | Recipe_add_ingredient
            | Recipe_remove_recipe
        | Add_recipe
    | Use_recipe
| Exit                             

let state = ref [Main; Exit]

let push_state x = state := x :: !state
let pop_state () = state := List.tail !state
let peek_state x = List.item x !state

// just default filler values, guaranteed to be overwritten before use
let ing: ingredient ref = ref { ing_name = ""; amount = 0.0; cost = 0.0; unit = Grams }
let rcp: recipe ref = ref { rcp_name = ""; ingredients = [] }
let rcp_ing: (string * float) ref = ref ("", 0.0)

while !state <> [Exit] do
    match List.head !state with
    | Main ->             
        write_lines [
            "--- Main ---"
            "1) Manage ingredients"
            "2) Manage recipes"
            "3) Use recipe"
            "0) Exit program"
        ]
        test_option_input_loop [1; 2; 3] (
            function
            | 1 -> push_state Stock_manage_ingredients
            | 2 -> push_state Manage_recipes
            | 3 -> push_state Use_recipe
            | _ -> ()
        ) pop_state
    | Stock_manage_ingredients ->
        write_lines [
            "--- Manage ingredients ---"
            "1) List all ingredients"
            "2) Manage ingredient"
            "3) Add new ingredient"
            "0) Return to Main"
        ]
        test_option_input_loop [1; 2; 3] (
            function
            | 1 -> write_lines <| List.map string_of_ingredient !ingredients
            | 2 ->                
                write_lines [
                    "--- Choose ingredient ---"
                    "Enter the name of the ingredient to manage"
                    "Enter a blank value to go back"
                ]
                test_ingredient_input_loop "That ingredient is not stocked" (fun x ->
                    ing := x
                    push_state Stock_ingredient
                ) ignore
            | 3 -> push_state Stock_add_ingredient
            | _ -> ()
        ) pop_state
    | Stock_ingredient ->
        write_lines [
            "--- Ingredient ---"
            string_of_ingredient !ing
            "1) Adjust stock"
            "2) Adjust cost"
            "3) Remove ingredient"
            "0) Return to Manage ingredients"
        ]
        test_option_input_loop [1; 2; 3] (
            function
            | 1 -> push_state Stock_amount
            | 2 -> push_state Stock_cost
            | 3 -> push_state Stock_remove
            | _ -> ()
        ) pop_state
    | Stock_amount ->
        write_lines [
            "--- Adjust Amount ---"        
            "Enter the amount to adjust by"
            "Enter a blank value to cancel"
        ]
        test_float_input_loop (fun x ->
            ing := { !ing with amount = (!ing).amount + x }
            update_ingredient !ing
        ) ignore
        pop_state ()
    | Stock_cost ->
        write_lines [
            "--- Adjust cost ---"        
            "Enter the cost to adjust by"
            "Enter a blank value to cancel" 
        ]
        test_float_input_loop (fun x -> 
            ing := { !ing with cost = (!ing).cost + x }
            update_ingredient !ing
        ) ignore
        pop_state ()
    | Stock_remove ->
        write_lines [
            "--- Remove ingredient ---"
            "1) Confirm"
            "0) Cancel"
        ]
        test_option_input_loop [1] (fun _ -> 
            remove_ingredient (!ing).ing_name
            pop_state ()
        ) ignore
        pop_state ()
    | Stock_add_ingredient ->
        write_lines [
            "--- Add new ingredient ---"
            "Enter the name of the new ingredient"
            "Enter a blank value to cancel"
        ]
        let pass = ref true
        let fail () = pass := false
        let name = ref ""             
        let amount = ref 0.0                  
        let cost = ref 0.0       
        let unit = ref Kilograms
        test_string_input_loop ((:=) name) fail
        if !pass then
            match try_find_ingredient !name !ingredients with
            | Some (_) ->
                write_line "That ingredient is already stocked"
                fail ()
            | None -> ()    
        if !pass then
            write_lines [
                "Enter the unit of the new ingredient"
                "1) Kilograms"
                "2) Grams"
                "0) Cancel"
            ]
            test_option_input_loop [1; 2] (
                function
                | 1 -> unit := Kilograms
                | 2 -> unit := Grams
                | _ -> ()
            ) fail
        if !pass then
            write_lines [
                "Enter the amount of the new ingredient"
                "Enter a blank value to cancel"
            ]
            test_float_input_loop ((:=) amount) fail
        if !pass then                                              
            write_lines [
                "Enter the cost of the new ingredient"
                "Enter a blank value to cancel"
            ]
            test_float_input_loop ((:=) cost) fail
        if !pass then
            ingredients := {
                ing_name = !name
                amount = !amount
                cost = !cost
                unit = !unit
            } :: !ingredients
        pop_state ()
    | Manage_recipes ->
        write_lines [
            "--- Manage recipes ---"
            "1) List all recipes"
            "2) Manage recipe"
            "3) Add new recipe"
            "0) Return to Main" 
        ]
        test_option_input_loop [1; 2; 3] (
            function
            | 1 -> write_lines (List.map (fun (h: string) -> h.Trim()) (List.map string_of_recipe !recipes))
            | 2 -> 
                write_lines [
                    "--- Choose recipe ---"
                    "Enter the name of the recipe to manage"
                    "Enter a blank value to go back"
                ]
                test_recipe_input_loop "That recipe is not listed" (fun x ->
                    rcp := x
                    push_state Recipe
                ) ignore
            | 3 -> push_state Add_recipe
            | _ -> ()
        ) pop_state
    | Recipe ->
        write_lines [
            "--- Recipe ---"
            string_of_recipe !rcp
            "1) Manage recipe ingredient"
            "2) Add new recipe ingredient"
            "3) Remove recipe"
            "0) Return to Manage recipes"
        ]
        test_option_input_loop [1; 2] (
            function
            | 1 -> 
                write_lines [
                    "--- Choose ingredient ---"
                    "Enter the name of the ingredient to manage"
                    "Enter a blank value to go back"
                ]
                test_recipe_ingredient_input_loop "That ingredient is not used in this recipe" !rcp (fun x ->
                    rcp_ing := x
                    push_state Recipe_ingredient
                ) ignore
            | 2 -> push_state Recipe_add_ingredient
            | _ -> ()
        ) pop_state
    | Recipe_ingredient ->
        write_lines [
            "--- Ingredient ---"
            uncurrify2 string_of_ingredient_cost !rcp_ing
            "1) Adjust amount"
            "2) Remove ingredient"
            "0) Return to Manage ingredients"
        ]
        test_option_input_loop [1; 2] (
            function
            | 1 -> push_state Recipe_amount
            | 2 -> push_state Recipe_remove
            | _ -> ()
        ) pop_state
    | Recipe_amount ->
        write_lines [
            "--- Adjust Amount ---"        
            "Enter the amount to adjust by"
            "Enter a blank value to cancel"
        ]
        test_float_input_loop (fun x ->
            rcp_ing := (fst !rcp_ing, snd !rcp_ing + x)
            rcp := { !rcp with ingredients = !rcp_ing :: List.filter (fun (name, _) -> name <> fst !rcp_ing) (!rcp).ingredients }
            update_recipe !rcp
        ) ignore
        pop_state ()
    | Recipe_remove ->
        write_lines [
            "--- Remove ingredient ---"
            "1) Confirm"
            "0) Cancel"
        ]
        test_option_input_loop [1] (fun _ -> 
            rcp := { !rcp with ingredients = List.filter (fun (name, _) -> name <> fst !rcp_ing) (!rcp).ingredients }
            update_recipe !rcp
        ) ignore
        pop_state ()
    | Recipe_add_ingredient ->
        write_lines [
            "--- Add new ingredient ---"
            "Enter the name of the new ingredient"
            "Enter a blank value to cancel"
        ]
        let pass = ref true
        let fail () = pass := false
        let ing = ref !ing
        let amt = ref 0.0            
        if !pass then
            match List.tryFind (fun (name, _) -> name = (!ing).ing_name) (!rcp).ingredients with
            | Some (_) ->
                write_line "That ingredient is already in the recipe"
                fail ()
            | None -> ()
        test_ingredient_input_loop "That ingredient is not stocked" ((:=) ing) fail
        if !pass then
            write_lines [
                "Enter the amount of the new ingredient in " + string_of_units (!ing).unit
                "Enter a blank value to cancel"
            ]
            test_float_input_loop ((:=) amt) fail
        if !pass then
            rcp_ing := ((!ing).ing_name, !amt)
            rcp := { !rcp with ingredients = !rcp_ing :: (!rcp).ingredients }
            update_recipe !rcp
        pop_state ()
    | Recipe_remove_recipe ->
        write_lines [
            "--- Remove recipe ---"
            "1) Confirm"
            "0) Cancel"
        ]
        test_option_input_loop [1] (fun _ -> 
            remove_recipe (!rcp).rcp_name
            pop_state ()
        ) ignore
        pop_state ()
    | Add_recipe ->
        write_lines [
            "--- Add new recipe ---"
            "Enter the name of the new recipe"
            "Enter a blank value to cancel"
        ]
        let pass = ref true
        let fail () = pass := false
        let name = ref ""
        test_string_input_loop ((:=) name) fail
        if !pass then
            match try_find_recipe !name !recipes with
            | Some (_) ->
                write_line "That recipe is already listed"
                fail ()
            | None -> ()
        if !pass then
            rcp := { rcp_name = !name; ingredients = [] }
            recipes := !rcp :: !recipes
            pop_state ()
            push_state Recipe
        else
            pop_state ()
    | Use_recipe ->
        write_lines [
            "--- Use recipe ---"
            "Enter the name of the recipe to use"
            "Enter a blank value to cancel"
        ]
        let pass = ref true
        let fail () = pass := false
        let amt = ref 0
        test_recipe_input_loop "That recipe is not listed" ((:=) rcp) fail
        if !pass then
            let stock = get_recipe_stock !rcp
            let cost = get_recipe_cost !rcp
            write_lines [
                "There is enough for " + string stock + " of this recipe"
                "Each dish costs $" + string cost
                "Enter the number of dishes to make"
                "Enter a blank value to cancel"
            ]
            test_input_loop "Invalid input" "" 0 int ((>=) stock) id ((:=) amt) fail
        if !pass then
            (!rcp).ingredients
            |> List.map (fun (name: string, amt': float) -> 
                let ing = find_ingredient name !ingredients
                { ing with
                    amount = ing.amount - float !amt * amt'
                }
            )
            |> List.iter update_ingredient
        pop_state ()
    | Exit -> ()

//
//
//  Persist to file
//
//

let _ =
    try
        let file = Text.StringBuilder()
        !ingredients
        |> List.iter (fun h ->
            ignore <| file.Append(
                "|"
                + "Ingredient"
                + "|"
                + h.ing_name
                + "|"
                + string h.amount
                + "|"
                + string h.cost
                + "|"
                + string_of_units h.unit
            )
        )
        !recipes
        |> List.iter (fun h ->
            ignore <| file.Append(
                "|"
                + "Recipe"
                + "|"
                + h.rcp_name
                + "|"
                + string (List.length h.ingredients)
                + (
                    h.ingredients
                    |> List.map (fun h ->
                        "|"
                        + fst h
                        + "|"
                        + string (snd h)
                    )
                    |> List.fold (fun (a: Text.StringBuilder) h -> a.Append(h)) (Text.StringBuilder())
                ).ToString()
            )
        )
        IO.File.WriteAllLines("inventory.txt", [|file.ToString()|])
    with _ -> ()