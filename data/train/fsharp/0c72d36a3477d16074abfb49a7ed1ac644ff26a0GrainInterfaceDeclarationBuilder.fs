namespace FSM.Orleans

[<AutoOpen>]
module GrainInterfaceDeclarationBuilder =
    open Microsoft.CodeAnalysis
    open Microsoft.CodeAnalysis.CSharp
    open Microsoft.CodeAnalysis.CSharp.Syntax

    open BrightSword.RoslynWrapper

    let build_grain_interface vm =
        let sm = StateMachine(vm)

        let grain_message_handler_signatures =
            let to_grain_message_handler_signature message =
                let method_handler_type = sprintf "Task<%s>" sm.data_typename
                let method_handler_args = message.MessageType |> Option.map (fun m -> (m.unapply.ToLower(), ``type`` (m.unapply))) |> Option.fold (fun _ v -> [v]) []
                in
                ``arrow_method`` method_handler_type message.MessageName.unapply ``<<`` [] ``>>``
                    ``(`` method_handler_args ``)``
                    []
                    None
                :> MemberDeclarationSyntax
            in
            vm.MessageBlock.Messages
            |> List.map to_grain_message_handler_signature
        in
        [
            ``interface`` sm.grain_interface_typename ``<<`` [] ``>>``
                ``:`` [ sm.grain_interface_base_typename ]
                [``public``]
                ``{``
                    grain_message_handler_signatures
                ``}``
                :> MemberDeclarationSyntax
        ]
