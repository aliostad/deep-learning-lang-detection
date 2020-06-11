namespace fszmq.props

open NUnit.Framework
open FsCheck
open FsCheck.NUnit

open fszmq

[<TestFixture>]
module Properties = 

  /// Tests is 2 Message instances have the same size and data
  let hasEqualContent msg1 msg2 = 
    Message.size msg1 = Message.size msg2 
    && 
    Message.data msg1 = Message.data msg2

  /// Successive clones should not change the content of a Message
  [<Property(Arbitrary = [| typeof<Generators> |])>]
  let ``clone is idempotent`` msg =
    use once  = Message.clone msg
    use twice = msg 
                |> Message.clone 
                |> Message.clone

    twice |> hasEqualContent once

  /// Compare content before and after cloning
  [<Property(Arbitrary = [| typeof<Generators> |])>]
  let ``copy alters target not source -- naive`` msg1 msg2 =
    let source,before = Message.data msg1,Message.data msg2
    Message.copy msg1 msg2
    let after = Message.data msg2

    (after = source) && (after <> before)

  /// Compare content before and after cloning
  [<Property(Arbitrary = [| typeof<Generators> |])>]
  let ``copy alters target not source -- labels`` msg1 msg2 =
    let source,before = Message.data msg1,Message.data msg2
    Message.copy msg1 msg2
    let after = Message.data msg2
    
    (after = source |@ "source") 
    .&. 
    (after <> before |@ "target")

  /// Compare dissimilar content before and after cloning
  [<Property(Arbitrary = [| typeof<Generators> |])>]
  let ``copy alters target not source -- filtered`` msg1 msg2 =
    (Message.data msg1 <> Message.data msg2) 
      ==> ( let source,before = Message.data msg1,
                                Message.data msg2
            Message.copy msg1 msg2
            let after = Message.data msg2
    
            (after = source |@ "source") 
            .&. 
            (after <> before |@ "target") )
