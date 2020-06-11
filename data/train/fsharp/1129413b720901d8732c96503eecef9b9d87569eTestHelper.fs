module NeuralFish.Tests.TestHelper

open NeuralFish.Core
open NeuralFish.Types
open NeuralFish.Cortex

let createNeuronInstance = createNeuronInstance defaultInfoLog
let defaultThinkTimeout = 500
let createCortex = createCortex defaultThinkTimeout defaultInfoLog
let synchronize (_,(_, neuronInstance)) = synchronize neuronInstance
let addNeuronToNN (_,(_,neuronInstance)) neuronArray = Array.append neuronArray [|neuronInstance|]
//This is lazy
let synchronizeNNMap (neuralNetworkMap : NeuralNetwork) =
  neuralNetworkMap
  |> Seq.map (fun keyValue -> keyValue.Value |> snd)
  |> Seq.toArray
  |> synchronizeNN
let killNeuralNetworkMap (neuralNetworkMap : NeuralNetwork) =
  neuralNetworkMap
  |> Seq.map (fun keyValue -> keyValue.Value |> snd)
  |> Seq.toArray
  |> killNeuralNetwork

let killNeuralNetworkArray neuralNetworkArray = 
  neuralNetworkArray
  |> Array.Parallel.map(fun (_,(_,neuronInstance)) -> neuronInstance )
  |> killNeuralNetwork

let sendRecurrentSignals neuralNetwork =
  neuralNetwork
  |> Array.iter(fun (_,(_,neuron : NeuronInstance)) -> SendRecurrentSignals |> neuron.PostAndReply)
let sendRecurrentSignalsNN neuralNetwork =
  neuralNetwork
  |> Array.iter(fun (neuron : NeuronInstance) -> SendRecurrentSignals |> neuron.PostAndReply)

type GeneratorMsg =
  | GetData of AsyncReplyChannel<float seq>
  | KillGenerator of AsyncReplyChannel<unit>

let fakeDataGenerator (initialBuffer : (float seq) list) =
  let generator =
    MailboxProcessor<GeneratorMsg>.Start(fun inbox ->
      let rec loop buffer =
        async {
          let! someMsg = inbox.TryReceive 200
          match someMsg with
          | None -> return! loop buffer
          | Some msg ->
            match msg with
            | GetData replyChannel ->
              let maybeData = buffer |> List.tryHead
              match maybeData with
              | None ->
                Seq.empty |> replyChannel.Reply
                return! loop buffer
              | Some data ->
                data |> replyChannel.Reply
                let tailBuffer = buffer |> List.tail
                let newBuffer = List.append tailBuffer [data]
                return! loop newBuffer
            | KillGenerator replyChannel ->
              replyChannel.Reply()
        }
      loop initialBuffer
    ) |> (fun x -> x.Error.Add(fun err -> printfn "%A" err); x)
  //TODO these never die. Need to manage this
  (fun () ->
     match generator.TryPostAndReply(GetData, timeout = 5000) with
     | Some data -> data
     | None -> raise <| System.Exception("Data Generator is dead")
   )

type TestHookMsg =
  | SendDataToBuffer of float
  | WaitForData of AsyncReplyChannel<float>
  | Die of AsyncReplyChannel<unit>


let getTestHook () =
  let generator = MailboxProcessor<TestHookMsg>.Start(fun inbox ->
    let rec loop dataBuffer replybuffer =
      async {
        let! msg = inbox.Receive ()
        match msg with
        | SendDataToBuffer dataValue ->
          if (replybuffer |> List.isEmpty) then
            let dataBuffer = dataValue :: dataBuffer
            return! loop dataBuffer List.empty
          else
            replybuffer |> List.iter (fun (replyChannel : AsyncReplyChannel<float>) -> replyChannel.Reply dataValue)
            return! loop dataBuffer List.empty
        | Die replyChannel ->
          replyChannel.Reply () 
          replybuffer |> List.iter (fun (replyChannel : AsyncReplyChannel<float>) -> replyChannel.Reply 0.0)
          return ()
        | WaitForData replyChannel ->
          if (dataBuffer |> List.isEmpty) then
            let replybuffer = replyChannel :: replybuffer
            return! loop dataBuffer replybuffer
          else
            let dataValue =  dataBuffer |> List.head
            dataValue |> replyChannel.Reply
            replybuffer |> List.iter (fun (replyChannel : AsyncReplyChannel<float>) -> replyChannel.Reply dataValue)
            let dataBuffer = dataBuffer |> List.tail
            return! loop dataBuffer replybuffer
      }
    loop [] []
  )

  let hookFunction = (fun data -> SendDataToBuffer data |> generator.Post)
  (hookFunction, generator)


type NeuronIdGeneratorMsg =
  | GetIntId of AsyncReplyChannel<int>
  | KillNumberGenerator of AsyncReplyChannel<unit>

//TODO cleanup all those generators at the end of a test
let getNumberGenerator () =
  let generator =
    MailboxProcessor<NeuronIdGeneratorMsg>.Start(fun inbox ->
      let rec loop currentNumber =
        async {
          let! someMsg = inbox.TryReceive 250
          match someMsg with
          | None -> return! loop currentNumber
          | Some msg ->
            match msg with
            | GetIntId replyChannel ->
              currentNumber |> replyChannel.Reply
              return! loop (currentNumber+1)
            | KillNumberGenerator replyChannel->
              replyChannel.Reply ()
        }
      loop 0
    ) |> (fun x -> x.Error.Add(fun err -> printfn "%A" err); x)
  (fun () -> GetIntId |> generator.PostAndReply)
