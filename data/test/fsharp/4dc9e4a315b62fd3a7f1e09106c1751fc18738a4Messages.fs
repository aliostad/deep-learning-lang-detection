namespace IRTB

module Messages = 

    open IRTB.User
    open IRTB.DomainEvents
    open IRTB.Market

    type SystemMessage = 
        | AddSeller of User
        | AddBuyer of User

    type Message = 
        | SystemMessage of SystemMessage
        | DomainEvent of DomainEvent

    let message_fold sys_function domain_function message = 
        match message with 
            | DomainEvent user_message -> domain_function user_message
            | SystemMessage sys_message -> sys_function sys_message

    let domain_event_fold auction_start_funct bid_funct auction_end_funct market message = 
        match message with 
            | AuctionStart start -> auction_start_funct market start 
            | Bid bid -> bid_funct market bid 
            | AuctionEnd ending -> auction_end_funct market ending 

    let sys_message_fold add_seller_funct add_buyer_funct market message = 
        match message with 
            | AddSeller seller -> add_seller_funct market seller
            | AddBuyer buyer -> add_buyer_funct market buyer

    type domain_event_api = {
        auction_start: Market -> AuctionStart -> Market;
        auction_end: Market -> AuctionEnd -> Market;
        bid: Market -> Bid -> Market
    }

    type sys_message_api = {
        add_buyer: Market -> User -> Market;
        add_seller: Market -> User -> Market
    }

    type market_api = {
        domain_api: domain_event_api;
        sys_api: sys_message_api
    }

    let process_message market_api market message = 
        let user_function = 
            domain_event_fold market_api.domain_api.auction_start market_api.domain_api.bid market_api.domain_api.auction_end market
        let sys_function = 
            sys_message_fold market_api.sys_api.add_seller market_api.sys_api.add_buyer market
            
        let processing_funct = 
            message_fold sys_function user_function

        processing_funct message