//===============================================================================
// Microsoft patterns & practices
// Parallel Programming Guide
//===============================================================================
// Copyright © Microsoft Corporation.  All rights reserved.
// This code released under the terms of the 
// Microsoft patterns & practices license (http://parallelpatterns.codeplex.com/license).
//===============================================================================

namespace Microsoft.Practices.ParallelGuideSamples.SocialNetwork

open System
open System.Collections.Generic

/// A subscriber's data in the social network
/// For our present purposes, just a collection of friends' IDs 
type Subscriber() = 
    let friends = new HashSet<_>()

    /// Return a reference for read-only operations
    member x.Friends = friends 

    /// Return a copy
    member x.FriendsCopy() =
        new HashSet<_>(friends)

    /// Print friends of the current contact, but limit the 
    /// number of printed friends to 'maxFriends'
    member x.Print maxFriends =
        printf "%5d" friends.Count
        friends 
          |> Seq.take (min friends.Count maxFriends)
          |> Seq.iter (printf "%8d")
        printfn ""
