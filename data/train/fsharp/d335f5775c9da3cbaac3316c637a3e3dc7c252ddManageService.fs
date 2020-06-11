namespace SkyVue.Service

open Microsoft.FSharp.Linq
open System
open System.Data.Linq.SqlClient
open System.Linq
open System.Text.RegularExpressions

open SkyVue.Data
open SkyVue.Error
open SkyVue.Interface

type ManageService(db : DataStore, logon : ILogon) =

    let verifyOwnerAndChannel (token) (channelId) =
        let user = logon.Verify(token)

        // find the channel to be managed
        let matches = query {
            for c in db.Channel do
            where (c.UserId = user.UserId)
            select c
        }
        if Seq.length matches <> 0 then
            raise (NotFound "Your channel could not be found.")
        user, Seq.head matches

    interface IManage with

        member x.Alter (token:string) (channelId:string) (userId:string) (canAdd:bool) (canDelete:bool) (canView:bool) =
            let owner = logon.Verify(token)
            let matches = query {
                for c in db.Channel do
                join s in db.Subscription on (c.ChannelId = s.ChannelId)
                where (c.ChannelId = channelId &&
                       c.UserId = owner.UserId &&
                       s.UserId = userId)
                select s
            }
            if Seq.length matches <> 1 then
                raise (NotFound "The specified subscription was not found.")

            let subscription = Seq.head matches
            subscription.CanAdd <- if canAdd then DataStore.yes else DataStore.no
            subscription.CanDelete <- if canDelete then DataStore.yes else DataStore.no
            subscription.CanView <- if canView then DataStore.yes else DataStore.no
            db.DataContext.SubmitChanges()
            subscription

        member x.Create (token:string) (name:string) =
            let user = logon.Verify(token)

            // verify that the channel name is unique
            let exists = query {
                for c in db.Channel do
                where (c.Name = name)
                count
            }
            if exists <> 0 then
                raise (AlreadyExists "A channel with this name already exists.")
            
            // create the channel
            let channel = new Channel()
            channel.ChannelId <- DataStore.id()
            channel.Name <- name
            channel.UserId <- user.UserId
            channel.IsPublic <- DataStore.no
            channel.CanAdd <- DataStore.no
            channel.CanDelete <- DataStore.no
            channel.CanView <- DataStore.no
            db.Channel.InsertOnSubmit(channel)

            // grant the owner permission to it
            let subscription = new Subscription()
            subscription.SubscriptionId <- DataStore.id()
            subscription.ChannelId <- channel.ChannelId
            subscription.UserId <- user.UserId
            subscription.IsActive <- DataStore.yes
            subscription.CanAdd <- DataStore.yes
            subscription.CanDelete <- DataStore.yes
            subscription.CanView <- DataStore.yes
            db.Subscription.InsertOnSubmit(subscription)
            db.DataContext.SubmitChanges()
            channel

            
        member x.Customize (token:string) (channelId:string) (icon:string) (name:string) =
            let owner, channel = verifyOwnerAndChannel token channelId
            
            // TODO: format channel name
            if String.IsNullOrWhiteSpace name then 
                raise (NullOrEmptyInput "Please supply a name.")
            let name = name.Trim()

            // check for conflicting names
            let conflicts = query {
                for c in db.Channel do
                where (c.ChannelId <> channel.ChannelId &&
                       c.Name = name)
                count
            }
            if conflicts <> 0 then
                raise (AlreadyExists "A channel with that name already exists.")

            channel.Name <- name
            channel.Icon <- icon
            db.DataContext.SubmitChanges()
            channel
            
        member x.ListChannelUsers (token:string) (channelId:string) =
            let user = logon.Verify token
            let users = query {
                for c in db.Channel do
                join m in db.Subscription on (c.ChannelId = m.ChannelId)
                join s in db.Subscription on (c.ChannelId = s.ChannelId)
                join u in db.User on (s.UserId = u.UserId)
                where (m.UserId = user.UserId &&
                       c.ChannelId = channelId)
                sortBy u.Identity
                select u
            }
            List.ofSeq users
            
        member x.ListSubscribers (token:string) (channelId:string) =
            let user = logon.Verify token
            let subscribers = query {
                for c in db.Channel do
                join m in db.Subscription on (c.ChannelId = m.ChannelId)
                join s in db.Subscription on (c.ChannelId = s.ChannelId)
                join u in db.User on (s.UserId = u.UserId)
                where (m.UserId = user.UserId &&
                       c.ChannelId = channelId)
                sortBy u.Identity
                select s
            }
            List.ofSeq subscribers
            
        member x.Offer (token:string) (channelId:string) (userId:string) =
            let owner, channel = verifyOwnerAndChannel token channelId

            // locate the guest user
            let matches = query {
                for u in db.User do
                where (u.UserId = userId &&
                       u.UserId <> owner.UserId)
                select u
            }
            if Seq.length matches <> 1 then
                raise (NotFound "That unique guest could not be found.")
            let guest = Seq.head matches

            let existingSubscriptions = query {
                for s in db.Subscription do
                where (s.ChannelId = channel.ChannelId &&
                       s.UserId = guest.UserId)
                count
            }
            if existingSubscriptions <> 0 then
                raise (AccessDenied "That guest is already a subscriber.")

            let subscription = new Subscription()
            subscription.SubscriptionId <- DataStore.id()
            subscription.CanAdd <- DataStore.yes
            subscription.CanDelete <- DataStore.yes
            subscription.CanView <- DataStore.yes
            subscription.IsActive <- DataStore.no
            subscription.ChannelId <- channel.ChannelId
            subscription.UserId <- guest.UserId
            db.Subscription.InsertOnSubmit(subscription)
            db.DataContext.SubmitChanges()
            subscription

        member x.Protect (token:string) (channelId:string) (password:string) =
            let owner, channel = verifyOwnerAndChannel token channelId

            // validate the proposed key
            if String.IsNullOrWhiteSpace password then
                raise (BadIdentityOrPassword "Your key cannot be empty.")

            // mark the channel as protected
            channel.IsProtected <- DataStore.yes

            // find an existing lock, if any
            let matches = query {
                for l in db.Lock do
                where (l.ChannelId = channelId)
                select l
            }
            if Seq.length matches = 0 then
                // insert a new channel lock
                let lock = new Lock()
                lock.ChannelId <- channelId
                lock.ProtectionKey <- password
                db.Lock.InsertOnSubmit(lock)
            else
                // update the existing lock
                let lock = Seq.head matches
                lock.ProtectionKey <- password

            db.DataContext.SubmitChanges()
            channel
            
        member x.Publish (token:string) (channelId:string) (published:bool) =
            let owner, channel = verifyOwnerAndChannel token channelId

            channel.IsPublic <- if published then DataStore.yes else DataStore.no
            channel.CanView <-channel.IsPublic
            channel.CanAdd <- DataStore.no
            channel.CanDelete <- DataStore.no
            db.DataContext.SubmitChanges()
            channel
            
        member x.Unprotect (token:string) (channelId:string) =
            let owner, channel = verifyOwnerAndChannel token channelId
            
            // verify the owner has authenticated this key
            let ownerKeyCache = query {
                for t in db.Tokenkey do
                where (t.TokenId = token &&
                       t.ChannelId = channel.ChannelId)
                count
            }
            if (ownerKeyCache <> 1) then
                raise (AccessDenied "You must first unlock the channel.")
                
            // remove the protection and any cached keys
            channel.IsProtected <- DataStore.no
            db.Tokenkey.DeleteAllOnSubmit(query {
                for t in db.Tokenkey do
                where (t.ChannelId = channel.ChannelId)
                select t
            })
            db.DataContext.SubmitChanges()
            channel

            
        member x.Unsubscribe (token:string) (userId:string) (channelId:string) =
            let owner, channel = verifyOwnerAndChannel token channelId

            // find the subscriber to remove
            let matches = query {
                for c in db.Channel do
                join s in db.Subscription on (c.ChannelId = s.ChannelId)
                where (c.ChannelId = channel.ChannelId &&
                       c.UserId = owner.UserId &&
                       s.UserId <> owner.UserId &&
                       s.UserId = userId)
                select s
            }
            if Seq.length matches <> 1 then
                raise (NotFound "Unable to locate and remove this subscription.")

            // remove the subscriber
            let subscription = Seq.head matches
            db.Subscription.DeleteOnSubmit(subscription)
            db.DataContext.SubmitChanges()
            subscription