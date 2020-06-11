namespace SkyVue.Interface

open SkyVue.Data

// Manage channels, subscriptions and permissions.
type IManage =

    // A channel owner can alter an existing subscription to change permissions.
    abstract Alter : token:string -> channelId:string -> userId:string -> canAdd:bool -> canDelete:bool -> canView:bool -> Subscription

    // Create an entirely new channel.
    abstract Create : token:string -> name:string -> Channel

    // Customize the name and the display icon URL for this channel.
    abstract Customize : token:string -> channelId:string -> icon:string -> name:string -> Channel

    // List users on the channel, for members - or anyone if public.
    abstract ListChannelUsers : token:string -> channelId:string -> List<User>
    
    // List subscriptions to the channel, for members - or anyone if public.
    abstract ListSubscribers : token:string -> channelId:string -> List<Subscription>

    // Offer channel subscription to a user if none exists or alter user
    // permissions if it does. This defaults to allow full permissions.
    abstract Offer : token:string -> channelId:string -> userId:string -> Subscription

    // Protect a channel with a shared password. If the channel is already
    // protected, you must be certain it is first unlocked to change the
    // password.
    abstract Protect : token:string -> channelId:string -> password:string -> Channel

    // (Un)Publish an existing channel for read-permission.
    abstract Publish : token:string -> channelId:string -> published:bool -> Channel

    // Unprotect a channel with a shared password. You must be certain it is
    // first unlocked to disable protection.
    abstract Unprotect : token:string -> channelId:string -> Channel

    // If requested by the channel owner or the user in question, this
    // completely removes the subsciption.
    abstract Unsubscribe : token:string -> userId:string -> channelId:string -> Subscription