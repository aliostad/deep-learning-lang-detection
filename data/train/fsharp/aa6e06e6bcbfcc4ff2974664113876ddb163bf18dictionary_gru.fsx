// I am throwing in the towel here regarding recurrent nets.

// They are simply too complex to make and debug.
// Like in the LSTM, there is an error in this code, but I do not have a prayer of
// finding it due to the size of the code.

// In a situation like this, the only thing I could possibly do is design a large
// number of test cases and run it through that.

let target_length = 3
let batch_size = 50

let momentum_rate = 0.9f
let learning_rate = 0.01f
let learning_coef = -learning_rate/float32 batch_size

// Here the dictionary approach does not make things easier like at all. All the option types just
// complicate things.

#load "rnn_standard_v3.fsx"
open Rnn_standard_v3
open Utils.Utils
open System.Collections.Generic

let rng = System.Random()

// To me these two problems look roughly similar but to the network they are worlds apart it seems.
let sequence_recall_data batch_size seq_length =
    [|
    for k = 1 to batch_size do
        let t = [|for i=1 to 7 do yield if rng.NextDouble() > 0.5 then 1.0f else 0.0f|]
        yield t
        for i=2 to seq_length-1 do
            let t = [|for i=1 to 7 do yield if rng.NextDouble() > 0.5 then 1.0f else 0.0f|]
            yield t
        yield t |]

let sequence_recall_data2 batch_size seq_length =
    [|
    for k = 1 to batch_size do
        let e = rng.NextDouble()*7.0 |> int
        let t = [|0.0f;0.0f;0.0f;0.0f;0.0f;0.0f;0.0f;|]
        t.[e] <- 0.5f
        yield t
        for i=2 to seq_length-1 do
            let e = rng.NextDouble()*7.0 |> int
            let t = [|0.0f;0.0f;0.0f;0.0f;0.0f;0.0f;0.0f;|]
            t.[e] <- 0.5f
            yield t
        yield t |]

let training_data = sequence_recall_data batch_size target_length
let training_data_transposed =
    [|
    for i=0 to target_length-1 do
        for k=0 to batch_size-1 do
            let ind = k*target_length+i
            yield training_data.[ind] |] |> Array.concat

let d_training_data =
    [|
    for i=0 to target_length-1 do
        yield ({num_rows=7;num_cols=batch_size;dArray=worker.Malloc(training_data_transposed.[i*(batch_size*7)..(i+1)*(batch_size*7)-1])}:dM) |]


let hidden_size = 10
let input_size = 7

let xh = createRandomMatrix hidden_size input_size
let hh = createRandomMatrix hidden_size hidden_size
let bias_h = createRandomMatrix hidden_size 1

type gruPars = {
    weights_input_reset : dM
    weights_input_update : dM
    weights_input_new_state : dM

    weights_hidden_reset : dM
    weights_hidden_update : dM
    weights_hidden_new_state : dM

    weights_bias_reset : dM
    weights_bias_update : dM
    weights_bias_new_state : dM

    new_state_temporary : dM option ref

    momentum_weights_input_reset : dM
    momentum_weights_input_update : dM
    momentum_weights_input_new_state : dM

    momentum_weights_hidden_reset : dM
    momentum_weights_hidden_update : dM
    momentum_weights_hidden_new_state : dM

    momentum_weights_bias_reset : dM
    momentum_weights_bias_update : dM
    momentum_weights_bias_new_state : dM

    momentum_flag_input_reset : float32 ref
    momentum_flag_input_update : float32 ref
    momentum_flag_input_new_state : float32 ref

    momentum_flag_hidden_reset : float32 ref
    momentum_flag_hidden_update : float32 ref
    momentum_flag_hidden_new_state : float32 ref

    momentum_flag_bias_reset : float32 ref
    momentum_flag_bias_update : float32 ref
    momentum_flag_bias_new_state : float32 ref

    weights_input_reset_copy : dM
    weights_input_update_copy : dM
    weights_input_new_state_copy : dM

    weights_hidden_reset_copy : dM
    weights_hidden_update_copy : dM
    weights_hidden_new_state_copy : dM

    weights_bias_reset_copy : dM
    weights_bias_update_copy : dM
    weights_bias_new_state_copy : dM
    }

let createGruPars hidden_size input_size = 
    let copyWeights weights =
        sgeam nT nT 1.0f weights 0.0f weights
    let weights_input_reset = createRandomMatrix hidden_size input_size
    let weights_input_update = createRandomMatrix hidden_size input_size
    let weights_input_new_state = createRandomMatrix hidden_size input_size

    let weights_hidden_reset = createRandomMatrix hidden_size hidden_size
    let weights_hidden_update = createRandomMatrix hidden_size hidden_size
    let weights_hidden_new_state = createRandomMatrix hidden_size hidden_size

    let weights_bias_reset = createRandomMatrix hidden_size 1
    let weights_bias_update = createRandomMatrix hidden_size 1
    let weights_bias_new_state = createRandomMatrix hidden_size 1

    {
    weights_input_reset = weights_input_reset
    weights_input_update = weights_input_update
    weights_input_new_state = weights_input_new_state

    weights_hidden_reset = weights_hidden_reset
    weights_hidden_update = weights_hidden_update
    weights_hidden_new_state = weights_hidden_new_state

    weights_bias_reset = weights_bias_reset
    weights_bias_update = weights_bias_update
    weights_bias_new_state = weights_bias_new_state

    new_state_temporary = ref None

    momentum_weights_input_reset = createEmptyAndSetZero weights_input_reset
    momentum_weights_input_update = createEmptyAndSetZero weights_input_update
    momentum_weights_input_new_state = createEmptyAndSetZero weights_input_new_state

    momentum_weights_hidden_reset = createEmptyAndSetZero weights_hidden_reset
    momentum_weights_hidden_update = createEmptyAndSetZero weights_hidden_update
    momentum_weights_hidden_new_state = createEmptyAndSetZero weights_hidden_new_state

    momentum_weights_bias_reset = createEmptyAndSetZero weights_bias_reset
    momentum_weights_bias_update = createEmptyAndSetZero weights_bias_update
    momentum_weights_bias_new_state = createEmptyAndSetZero weights_bias_new_state

    momentum_flag_input_reset = ref 0.0f
    momentum_flag_input_update = ref 0.0f
    momentum_flag_input_new_state = ref 0.0f

    momentum_flag_hidden_reset = ref 0.0f
    momentum_flag_hidden_update = ref 0.0f
    momentum_flag_hidden_new_state = ref 0.0f

    momentum_flag_bias_reset = ref 0.0f
    momentum_flag_bias_update = ref 0.0f
    momentum_flag_bias_new_state = ref 0.0f

    weights_input_reset_copy = copyWeights weights_input_reset
    weights_input_update_copy = copyWeights weights_input_update
    weights_input_new_state_copy = copyWeights weights_input_new_state

    weights_hidden_reset_copy = copyWeights weights_hidden_reset
    weights_hidden_update_copy = copyWeights weights_hidden_update
    weights_hidden_new_state_copy = copyWeights weights_hidden_new_state

    weights_bias_reset_copy = copyWeights weights_bias_reset
    weights_bias_update_copy = copyWeights weights_bias_update
    weights_bias_new_state_copy = copyWeights weights_bias_new_state
    }

type gruActivations = {
    reset_gate : dM
    update_gate : dM
    potential_new_state : dM
    output : dM
    }

type RNNActivations =
    | GRUActivations of gruActivations
    | StandardActivations of dM

type RNNParameters =
    | GRUParameters of gruPars
    | StandardParameters of weightPars

type gruErrors = {
    error_reset_gate : dM
    error_update_gate : dM
    error_potential_new_state : dM
    error_output : dM
    }

type RNNErrors =
    | GRUErrors of gruErrors
    | StandardErrors of dM
    

let pars1 = createGruPars hidden_size input_size

let hy = createRandomMatrix input_size hidden_size
let bias_y = createRandomMatrix input_size 1

let pars2 = createWeightPars hy None bias_y

let forward_dict = new Dictionary<int*int,RNNActivations>()
let error_dict = new Dictionary<int*int,RNNErrors>()
let label_dict = new Dictionary<int*int,dM>()
let pars_dict = new Dictionary<int,RNNParameters>()

pars_dict.Add(1,GRUParameters pars1)
pars_dict.Add(2,StandardParameters pars2)

forward_dict.Add((0,1),StandardActivations d_training_data.[0])
forward_dict.Add((0,2),StandardActivations d_training_data.[1])
label_dict.Add((2,3),d_training_data.[2])

let optional_get (dict: Dictionary<'a,'b>) key =
    if dict.ContainsKey(key) then Some dict.[key] else None

let get_activation input = 
    match input with
        | Some x ->
            match x with
                | GRUActivations x -> Some x.output
                | StandardActivations x -> Some x
        | None -> None

let get_gru_gates cur_act_start =
    match cur_act_start with
        | Some acts ->
            match acts with
                | GRUActivations x ->
                    Some x.reset_gate, Some x.update_gate, Some x.potential_new_state, Some x.output
                | StandardActivations x -> failwith "This is a GRU activation function!"
        | None -> None, None, None, None

let gru_forward row col =
    let prev_state = optional_get forward_dict (row,col-1)
    let input = optional_get forward_dict (row-1,col)
    let cur_act_start = optional_get forward_dict (row, col)

    let pars = pars_dict.[row]
    
    let input = get_activation input
    let prev_state = get_activation prev_state

    match pars with
        | GRUParameters pars ->
            let reset,update,new_state,output = get_gru_gates cur_act_start

            let multiply_flag = ref 0.0f
            let reset = dynamic_multiply nT nT 1.0f (Some pars.weights_input_reset) input multiply_flag reset
            let reset = dynamic_multiply nT nT 1.0f (Some pars.weights_hidden_reset) prev_state multiply_flag reset
            if !multiply_flag = 0.0f then failwith "No operations done in forward step!"
            let reset = reset.Value
            addBias reset pars.weights_bias_reset
            let reset = clippedLinearLogisticActivationModule.Apply(reset,reset)

            let multiply_flag = ref 0.0f
            let update = dynamic_multiply nT nT 1.0f (Some pars.weights_input_update) input multiply_flag update
            let update = dynamic_multiply nT nT 1.0f (Some pars.weights_hidden_update) prev_state multiply_flag update
            if !multiply_flag = 0.0f then failwith "No operations done in forward step!"
            let update = update.Value
            addBias update pars.weights_bias_update
            let update = clippedLinearLogisticActivationModule.Apply(update,update)

            let multiply_flag = ref 0.0f
            let new_state = dynamic_multiply nT nT 1.0f (Some pars.weights_input_new_state) input multiply_flag new_state

            let temp = elementwiseMultiplicationModule.Apply(Some reset,prev_state,!pars.new_state_temporary)
            pars.new_state_temporary := temp
    
            let new_state = dynamic_multiply nT nT 1.0f (Some pars.weights_hidden_new_state) temp multiply_flag new_state
            if !multiply_flag = 0.0f then failwith "No operations done in forward step!"
            let new_state = new_state.Value
            addBias new_state pars.weights_bias_new_state
            let new_state = clippedLinearTanhActivationModule.Apply(new_state,new_state)

            let output = elementwiseMultiplicationModule.Apply(Some update, Some new_state, output)
            let output = elementwiseMultiplicationAndAdditionModule.Apply(Some update,prev_state,output, output)

            let acts = {
                reset_gate = reset
                update_gate = update
                potential_new_state = new_state
                output = output.Value
                }

            match cur_act_start with
                | None -> forward_dict.Add((row,col),GRUActivations acts)
                | Some x -> ()

        | StandardParameters pars ->
            let multiply_flag = ref 0.0f

            let cur_act_start = get_activation cur_act_start
    
            let cur_act = dynamic_multiply nT nT 1.0f (Some pars.weights_input_hidden) input multiply_flag cur_act_start
            let cur_act = dynamic_multiply nT nT 1.0f pars.weights_hidden_hidden prev_state multiply_flag cur_act

            match pars.weights_hidden_hidden, prev_state with
                | None, Some x -> failwith "No hidden weights!"
                | _ -> ()

            if !multiply_flag = 0.0f then failwith "No operations done in forward step!"
            let cur_act = cur_act.Value
            addBias cur_act pars.bias_hidden
            let cur_act = constrainedClippedLinearLogisticActivationModule.Apply(cur_act,cur_act)

            match cur_act_start with
                | None -> forward_dict.Add((row,col),StandardActivations cur_act)
                | Some x -> ()


let createErrorsLikeActs t = {
    error_reset_gate = createEmptyMatrixLike t.output
    error_update_gate = createEmptyMatrixLike t.update_gate
    error_potential_new_state = createEmptyMatrixLike t.potential_new_state
    error_output = createEmptyMatrixLike t.output
    }

let gruUpdateGateErrorModule1 = 
    new DeviceQuadraryTransformModule<float32>
        <@ fun a b c d ->
            a * (b - c) * clipped_linear_sigmoid_derivative d @>

let gruUpdateGateErrorModule2 = 
    new DeviceTrinaryTransformModule<float32>
        <@ fun a c d ->
            a * (- c) * clipped_linear_sigmoid_derivative d @>

let gruNewErrorModule = 
    new DeviceTrinaryTransformModule<float32>
        <@ fun a b c ->
            a * (1.0f - b) * clipped_linear_tanh_derivative c @>

let gruResetErrorModule = 
    new DeviceTrinaryTransformModule<float32>
        <@ fun a b c ->
            a * b * clipped_linear_sigmoid_derivative c @>

let contrainedClippedLinearLogisticErrorModule_two =
    new DeviceUnaryTransformModule<float32>
        <@ fun a ->
            constrained_clipped_linear_sigmoid_derivative a @>

let gru_cur_error row col =
    let cur_act = forward_dict.[row,col]
    let prev_state = get_activation (optional_get forward_dict (row,col-1))
    let er_start = optional_get error_dict (row,col)
    let pars = pars_dict.[row]

    let error_calculate error cur_act =
        match pars with
            | GRUParameters pars ->
                let error_update_gate =
                    match prev_state with
                        | Some prev_state ->
                            let error_update_gate = gruUpdateGateErrorModule1.Apply(error.error_output,prev_state,cur_act.potential_new_state,cur_act.update_gate, error.error_update_gate)
                            error_update_gate
                        | None ->
                            let error_update_gate = gruUpdateGateErrorModule2.Apply(error.error_output,cur_act.potential_new_state,cur_act.update_gate, error.error_update_gate)
                            error_update_gate

                let error_new_state = gruNewErrorModule.Apply(error.error_output,cur_act.update_gate,cur_act.output,error.error_potential_new_state)

                let error_reset = 
                    match prev_state with
                        | Some prev_state ->
                            let error_reset = sgemm2 T nT 1.0f pars.weights_hidden_new_state error_new_state 0.0f error.error_reset_gate
                            gruResetErrorModule.Apply(error_reset,prev_state,cur_act.reset_gate, error_reset)
                        | None ->
                            setModule.Apply(0.0f, error.error_reset_gate, error.error_reset_gate)
                ()
            | StandardParameters pars -> 
                failwith "Invalid input into error_calculate. Use the standard function."

    let error_calculate_standard error cur_act =
        match pars with
            | GRUParameters pars -> failwith "Invalid input into error_calculate_gru. Use the GRU function."
            | StandardParameters pars ->
                contrainedClippedLinearLogisticErrorModule_two.Apply(cur_act,error) |> ignore

    match er_start with
        | Some error ->
            match error, cur_act with
                | GRUErrors error, GRUActivations cur_act ->
                    error_calculate error cur_act
                | StandardErrors error, StandardActivations cur_act ->
                    error_calculate_standard error cur_act
                | _ -> failwith "Invalid inputs in er_start match in gru_cur_error."
        | None ->
            match cur_act with
                | GRUActivations cur_act ->
                    let error = createErrorsLikeActs cur_act
                    error_calculate error cur_act
                    error_dict.Add((row,col),GRUErrors error)
                | StandardActivations cur_act -> 
                    let error = createEmptyMatrixLike cur_act
                    error_calculate_standard error cur_act
                    error_dict.Add((row,col),StandardErrors error)

let gru_error_label() =
    for x in label_dict do
        let k = x.Key
        let row, col = k
        let target = x.Value
        let output = 
            match forward_dict.[k] with
                | StandardActivations x -> x
                | GRUActivations x -> x.output

        let er_start = optional_get error_dict k

        match er_start with
            | Some er -> 
                match er with
                    | GRUErrors x ->
                        binaryErrorModule.Apply(target,output,x.error_output) |> ignore
                        gru_cur_error row col
                    | StandardErrors x ->
                        binaryErrorModule.Apply(target,output,x) |> ignore
            | None ->
                match forward_dict.[k] with
                    | GRUActivations x ->
                        let output = binaryErrorModule.Apply(target,output)
                        let er = createErrorsLikeActs x
                        error_dict.Add(k,GRUErrors er)
                        gru_cur_error row col
                    | StandardActivations x ->
                        let t = binaryErrorModule.Apply(target,output)
                        error_dict.Add(k,StandardErrors t)

let addModule = 
    new DeviceBinaryTransformModule<float32>
        <@ fun a b ->
            a + b @>

let gru_error row col =
    let cur_act = forward_dict.[row,col]
    let er_up = optional_get error_dict (row+1,col)    
    let er_right = optional_get error_dict (row,col+1)    
    let er_start = optional_get error_dict (row,col)

    let er_start = 
        match er_start with
            | Some x ->
                x
            | None ->
                match cur_act with
                    | GRUActivations cur_act ->
                        let er = createErrorsLikeActs cur_act
                        error_dict.Add((row,col),GRUErrors er)
                        GRUErrors er
                    | StandardActivations cur_act ->
                        let er = createEmptyAndSetZero cur_act
                        error_dict.Add((row,col),StandardErrors er)
                        StandardErrors er
    
    let er_flag = ref 0.0f
    match er_up with
        | Some er_up ->
            let pars_up = pars_dict.[row+1]
            match pars_up, er_up, er_start with
                | GRUParameters pars_up, GRUErrors x, GRUErrors er_start ->
                    dynamic_multiply T nT 1.0f (Some pars_up.weights_input_reset) (Some x.error_update_gate) er_flag (Some er_start.error_output) |> ignore
                    dynamic_multiply T nT 1.0f (Some pars_up.weights_input_update) (Some x.error_reset_gate) er_flag (Some er_start.error_output) |> ignore
                    dynamic_multiply T nT 1.0f (Some pars_up.weights_input_new_state) (Some x.error_potential_new_state) er_flag (Some er_start.error_output) |> ignore
                | StandardParameters pars_up, StandardErrors x, StandardErrors er_start ->
                    dynamic_multiply T nT 1.0f (Some pars_up.weights_input_hidden) (Some x) er_flag (Some er_start) |> ignore
                | StandardParameters pars_up, StandardErrors x, GRUErrors er_start ->
                    dynamic_multiply T nT 1.0f (Some pars_up.weights_input_hidden) (Some x) er_flag (Some er_start.error_output) |> ignore
                | _ -> failwith "Invalid input in er_up pattern match in gru_error."
        | None -> ()

    match er_right with
        | Some x ->
            let pars_right = pars_dict.[row]
            match pars_right, x, er_start with
                | GRUParameters pars_right, GRUErrors x, GRUErrors er_start ->
                    dynamic_multiply T nT 1.0f (Some pars_right.weights_hidden_reset) (Some x.error_update_gate) er_flag (Some er_start.error_output) |> ignore
                    dynamic_multiply T nT 1.0f (Some pars_right.weights_hidden_update) (Some x.error_reset_gate) er_flag (Some er_start.error_output) |> ignore
                    dynamic_multiply T nT 1.0f (Some pars_right.weights_hidden_new_state) (Some x.error_potential_new_state) er_flag (Some er_start.error_output) |> ignore
                | StandardParameters pars_right, StandardErrors x, StandardErrors er_start ->
                    dynamic_multiply T nT 1.0f pars_right.weights_hidden_hidden (Some x) er_flag (Some er_start) |> ignore
                | StandardParameters pars_right, StandardErrors x, GRUErrors er_start ->
                    dynamic_multiply T nT 1.0f pars_right.weights_hidden_hidden (Some x) er_flag (Some er_start.error_output) |> ignore
                | _ -> failwith (sprintf "Incorrect input in gru_error at row=%i col=%i" row col)
        | None -> ()

    gru_cur_error row col


let gru_set_momentum_flags() =
    for x in pars_dict do
        match x.Value with
            | GRUParameters x ->
                x.momentum_flag_input_update := momentum_rate
                x.momentum_flag_input_reset := momentum_rate
                x.momentum_flag_input_new_state := momentum_rate

                x.momentum_flag_hidden_update := momentum_rate
                x.momentum_flag_hidden_reset := momentum_rate
                x.momentum_flag_hidden_new_state := momentum_rate

                x.momentum_flag_bias_update := momentum_rate
                x.momentum_flag_bias_reset := momentum_rate
                x.momentum_flag_bias_new_state := momentum_rate
            | StandardParameters x ->
                x.momentum_flag_bias := momentum_rate
                x.momentum_flag_input := momentum_rate
                x.momentum_flag_hidden := momentum_rate

let gru_gradient_calculate row col =
    let act_left = get_activation(optional_get forward_dict (row,col-1))
    let act_down = get_activation(optional_get forward_dict (row-1,col))

    let er_cur = error_dict.[row,col]
    let pars_cur = pars_dict.[row]
    
    match er_cur, pars_cur with
        | GRUErrors er_cur, GRUParameters pars_cur ->
            dynamic_multiply nT T learning_coef (Some er_cur.error_update_gate) act_left pars_cur.momentum_flag_hidden_update (Some pars_cur.momentum_weights_hidden_update) |> ignore
            dynamic_multiply nT T learning_coef (Some er_cur.error_reset_gate) act_left pars_cur.momentum_flag_hidden_reset (Some pars_cur.momentum_weights_hidden_reset) |> ignore
            dynamic_multiply nT T learning_coef (Some er_cur.error_potential_new_state) act_left pars_cur.momentum_flag_hidden_new_state (Some pars_cur.momentum_weights_hidden_new_state) |> ignore

            dynamic_multiply nT T learning_coef (Some er_cur.error_update_gate) act_down pars_cur.momentum_flag_input_update (Some pars_cur.momentum_weights_input_update) |> ignore
            dynamic_multiply nT T learning_coef (Some er_cur.error_reset_gate) act_down pars_cur.momentum_flag_input_reset (Some pars_cur.momentum_weights_input_reset) |> ignore
            dynamic_multiply nT T learning_coef (Some er_cur.error_potential_new_state) act_down pars_cur.momentum_flag_input_new_state (Some pars_cur.momentum_weights_input_new_state) |> ignore

            dynamicCalculateBias learning_coef er_cur.error_update_gate pars_cur.momentum_flag_bias_update pars_cur.momentum_weights_bias_update
            dynamicCalculateBias learning_coef er_cur.error_reset_gate pars_cur.momentum_flag_bias_reset pars_cur.momentum_weights_bias_reset
            dynamicCalculateBias learning_coef er_cur.error_potential_new_state pars_cur.momentum_flag_bias_new_state pars_cur.momentum_weights_bias_new_state
        | StandardErrors er_cur, StandardParameters pars_cur ->
            dynamic_multiply nT T learning_coef (Some er_cur) act_left pars_cur.momentum_flag_hidden pars_cur.momentum_weights_hidden_hidden |> ignore
            dynamic_multiply nT T learning_coef (Some er_cur) act_down pars_cur.momentum_flag_input (Some pars_cur.momentum_weights_input_hidden) |> ignore
            dynamicCalculateBias learning_coef er_cur pars_cur.momentum_flag_bias pars_cur.momentum_bias_hidden
        | _ -> failwith "Invalid hidden to hidden input in gru_gradient_calculate."
    ()

let gru_gradient_add_to_weights() =
    for x in pars_dict do
        match x.Value with
            | GRUParameters x ->
                sgeam2 nT nT 1.0f x.momentum_weights_input_update 1.0f x.weights_input_update x.weights_input_update |> ignore
                sgeam2 nT nT 1.0f x.momentum_weights_input_reset 1.0f x.weights_input_reset x.weights_input_reset |> ignore
                sgeam2 nT nT 1.0f x.momentum_weights_input_new_state 1.0f x.weights_input_new_state x.weights_input_new_state |> ignore

                sgeam2 nT nT 1.0f x.momentum_weights_hidden_update 1.0f x.weights_hidden_update x.weights_hidden_update |> ignore
                sgeam2 nT nT 1.0f x.momentum_weights_hidden_reset 1.0f x.weights_hidden_reset x.weights_hidden_reset |> ignore
                sgeam2 nT nT 1.0f x.momentum_weights_hidden_new_state 1.0f x.weights_hidden_new_state x.weights_hidden_new_state |> ignore

                sgeam2 nT nT 1.0f x.momentum_weights_bias_update 1.0f x.weights_bias_update x.weights_bias_update |> ignore
                sgeam2 nT nT 1.0f x.momentum_weights_bias_reset 1.0f x.weights_bias_reset x.weights_bias_reset |> ignore
                sgeam2 nT nT 1.0f x.momentum_weights_bias_new_state 1.0f x.weights_bias_new_state x.weights_bias_new_state |> ignore
            | StandardParameters x ->
                dynamic_add nT nT 1.0f (Some x.momentum_weights_input_hidden) 1.0f (Some x.weights_input_hidden) (Some x.weights_input_hidden) |> ignore
                dynamic_add nT nT 1.0f x.momentum_weights_hidden_hidden 1.0f x.weights_hidden_hidden x.weights_hidden_hidden |> ignore
                dynamic_add nT nT 1.0f (Some x.momentum_bias_hidden) 1.0f (Some x.bias_hidden) (Some x.bias_hidden) |> ignore

/// Adds the momentum to the copy matrices. Used in Nesterov's Momentum.
let gru_gradient_add_to_weights_nestorov() =
    for x in pars_dict do
        match x.Value with
            | GRUParameters x ->
                sgeam2 nT nT 1.0f x.momentum_weights_input_update 1.0f x.weights_input_update_copy x.weights_input_update_copy |> ignore
                sgeam2 nT nT 1.0f x.momentum_weights_input_reset 1.0f x.weights_input_reset_copy x.weights_input_reset_copy |> ignore
                sgeam2 nT nT 1.0f x.momentum_weights_input_new_state 1.0f x.weights_input_new_state_copy x.weights_input_new_state_copy |> ignore

                sgeam2 nT nT 1.0f x.momentum_weights_hidden_update 1.0f x.weights_hidden_update_copy x.weights_hidden_update_copy |> ignore
                sgeam2 nT nT 1.0f x.momentum_weights_hidden_reset 1.0f x.weights_hidden_reset_copy x.weights_hidden_reset_copy |> ignore
                sgeam2 nT nT 1.0f x.momentum_weights_hidden_new_state 1.0f x.weights_hidden_new_state_copy x.weights_hidden_new_state_copy |> ignore

                sgeam2 nT nT 1.0f x.momentum_weights_bias_update 1.0f x.weights_bias_update_copy x.weights_bias_update_copy |> ignore
                sgeam2 nT nT 1.0f x.momentum_weights_bias_reset 1.0f x.weights_bias_reset_copy x.weights_bias_reset_copy |> ignore
                sgeam2 nT nT 1.0f x.momentum_weights_bias_new_state 1.0f x.weights_bias_new_state_copy x.weights_bias_new_state_copy |> ignore
            | StandardParameters x ->
                dynamic_add nT nT 1.0f (Some x.momentum_weights_input_hidden) 1.0f (Some x.weights_input_hidden_copy) (Some x.weights_input_hidden_copy) |> ignore
                dynamic_add nT nT 1.0f x.momentum_weights_hidden_hidden 1.0f x.weights_hidden_hidden_copy x.weights_hidden_hidden_copy |> ignore
                dynamic_add nT nT 1.0f (Some x.momentum_bias_hidden) 1.0f (Some x.bias_hidden_copy) (Some x.bias_hidden_copy) |> ignore

let gru_overwrite_with_copies_and_add_momentum() =
    for x in pars_dict do
        match x.Value with
            | GRUParameters x ->
                sgeam2 nT nT 1.0f x.momentum_weights_input_update 1.0f x.weights_input_update_copy x.weights_input_update |> ignore
                sgeam2 nT nT 1.0f x.momentum_weights_input_reset 1.0f x.weights_input_reset_copy x.weights_input_reset |> ignore
                sgeam2 nT nT 1.0f x.momentum_weights_input_new_state 1.0f x.weights_input_new_state_copy x.weights_input_new_state |> ignore

                sgeam2 nT nT 1.0f x.momentum_weights_hidden_update 1.0f x.weights_hidden_update_copy x.weights_hidden_update |> ignore
                sgeam2 nT nT 1.0f x.momentum_weights_hidden_reset 1.0f x.weights_hidden_reset_copy x.weights_hidden_reset |> ignore
                sgeam2 nT nT 1.0f x.momentum_weights_hidden_new_state 1.0f x.weights_hidden_new_state_copy x.weights_hidden_new_state |> ignore

                sgeam2 nT nT 1.0f x.momentum_weights_bias_update 1.0f x.weights_bias_update_copy x.weights_bias_update |> ignore
                sgeam2 nT nT 1.0f x.momentum_weights_bias_reset 1.0f x.weights_bias_reset_copy x.weights_bias_reset |> ignore
                sgeam2 nT nT 1.0f x.momentum_weights_bias_new_state 1.0f x.weights_bias_new_state_copy x.weights_bias_new_state |> ignore
            | StandardParameters x ->
                dynamic_add nT nT 1.0f (Some x.momentum_weights_input_hidden) 1.0f (Some x.weights_input_hidden_copy) (Some x.weights_input_hidden) |> ignore
                dynamic_add nT nT 1.0f x.momentum_weights_hidden_hidden 1.0f x.weights_hidden_hidden_copy x.weights_hidden_hidden |> ignore
                dynamic_add nT nT 1.0f (Some x.momentum_bias_hidden) 1.0f (Some x.bias_hidden_copy) (Some x.bias_hidden) |> ignore

let num_iterations = 500
for i=1 to num_iterations do
    
    // Adds copy+momentum matrices are assigned to the weights. Nesterov's Momentum.
    gru_overwrite_with_copies_and_add_momentum()

    gru_forward 1 1 
    gru_forward 1 2 
    gru_forward 1 3 

    gru_forward 2 3

    match forward_dict.[2,3] with
        | GRUActivations act ->
            printfn "%f" (crossEntropyCostModule.Apply(d_training_data.[0],act.output)/float32 batch_size)
        | StandardActivations act ->
            printfn "%f" (crossEntropyCostModule.Apply(d_training_data.[0],act)/float32 batch_size)

    gru_error_label()

    gru_error 1 3
    gru_error 1 2
    gru_error 1 1

    gru_set_momentum_flags()

    gru_gradient_calculate 2 3
    gru_gradient_calculate 1 3
    gru_gradient_calculate 1 2
    gru_gradient_calculate 1 1
   
    gru_gradient_add_to_weights_nestorov()