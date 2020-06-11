module SpikeServer

    open System
    open Parameters

    let spikeHandler (request : SpikeMessageReader) =
        // Get current time in ticks
        let ticks = DateTime.Now.Ticks

        // Load concept that is target of spike
        use concept = Trinity.Global.LocalStorage.UseConcept(request.target)

        // decay potential over time e^-lt
        let delta = float(ticks - concept.LastUpdated)
        let lambda = float(-concept.ActionPotential) * delta
        concept.ActionPotential <- single(float(concept.ActionPotential) * Math.Exp(lambda))
        concept.LastUpdated <- ticks

        // Update potential with spike value
        concept.ActionPotential <- concept.ActionPotential + request.spike

        if concept.ActionPotential > Parameters.ACTIVATION_THRESHOLD then
            // Concept activated
            // Reset concept
            concept.ActionPotential <- Parameters.ACTION_POTENTIAL_RESET
            concept.LastActivated <- ticks

            // send spike to each outgoing link
            concept.Beliefs.ForEach (fun l ->
                use msg = new SpikeMessageWriter(l.TV.C * Parameters.SPIKE_POTENTIAL, l.Target)
                for i in 0 .. Global.ServerCount - 1 do
                    Global.CloudStorage.SpikeToSpikeServer(i, msg)
                )

    let create () =
        { new SpikeServerBase() with
            member this.SpikeHandler request = spikeHandler request
        }
