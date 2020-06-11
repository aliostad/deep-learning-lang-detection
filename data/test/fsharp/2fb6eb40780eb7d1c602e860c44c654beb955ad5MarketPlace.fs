namespace IRTB 
#nowarn "40"

module MarketPlace = 

    open IRTB.Market
    open IRTB.Messages

    let market_api = {
        sys_api = {
            add_buyer =  Market.add_buyer;
            add_seller = Market.add_seller
        };
        user_api = {
            payment = Market.process_offer;
            bid = Market.process_bid
        }
    }

    type MarketPlace () = 

        static let agent = MailboxProcessor.Start(fun inbox -> 

            let processing_function = Messages.process_message market_api

            let rec messageLoop (market : Market) = async{

                let! msg = inbox.Receive()

                let updated_market = processing_function market msg

                return! messageLoop updated_market 
                }

            messageLoop {users = []}
            )

        static member add_to_market_place (message: Message) = agent.Post message

    

