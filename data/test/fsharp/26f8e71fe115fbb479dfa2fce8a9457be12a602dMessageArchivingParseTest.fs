// ----------------------------------------------------------------------------
// This file is subject to the terms and conditions defined in
// file 'LICENSE.txt', which is part of this source code package.
// ----------------------------------------------------------------------------
namespace Test.Yaaf.Xmpp.IM

open System.IO
open NUnit.Framework
open FsUnit
open Test.Yaaf.Xmpp.TestHelper
open Test.Yaaf.Xml.XmlTestHelper
open Test.Yaaf.Xmpp
open Yaaf.Xmpp
open Yaaf.Xmpp.Server
open Yaaf.Xmpp.Stream
open System.Threading.Tasks
open Yaaf.IO
open Yaaf.TestHelper
open Yaaf.Xmpp.XmlStanzas
open Yaaf.Xmpp.MessageArchiving      

[<TestFixture>]
type ``Test-Yaaf-Xmpp-IM-MessageArchiving-Data-Parsing``() as this =
    inherit XmlStanzaParsingTestClass()
    let prefTest stanzaString (info:IStanza) (elem:PreferenceAction) = 
        let newStanza = Parsing.createPreferenceElement info.Header.Id.Value info.Header.To elem
        this.GenericTest Parsing.preferenceContentGenerator stanzaString newStanza
    let manualTest stanzaString (info:IStanza) (elem:ManualArchivingAction) = 
        let newStanza = Parsing.createManualArchivingElement info.Header.Id.Value info.Header.To elem
        this.GenericTest Parsing.manualArchivingContentGenerator stanzaString newStanza
    let autoTest stanzaString (info:IStanza) (elem:AutomaticArchivingAction) = 
        let newStanza = Parsing.createAutomaticArchivingElement info.Header.Id.Value elem
        this.GenericTest Parsing.automaticArchivingContentGenerator stanzaString newStanza
    let manageTest stanzaString (info:IStanza) (elem:MessageArchivingAction) = 
        let newStanza = Parsing.createArchivingManagementElement info.Header.Id.Value info.Header.To elem
        this.GenericTest Parsing.archivingManagementContentGenerator stanzaString newStanza
    let replicationTest stanzaString (info:IStanza) (elem:ReplicationAction) = 
        let newStanza = Parsing.createReplicationElement info.Header.Id.Value info.Header.To elem
        this.GenericTest Parsing.replicationContentGenerator stanzaString newStanza

// Test preference messages

    [<Test>]
    member this.``Check that we can parse & write PreferenceResult message archiving`` () = 
        let stanza = "<iq type='result' id='pref1' to='juliet@capulet.com/chamber'>
  <pref xmlns='urn:xmpp:archive'>
    <auto save='false'/>
    <default expire='31536000' otr='concede' save='body'/>
    <item jid='romeo@montague.net' otr='require' save='false'/>
    <item expire='630720000' jid='benvolio@montague.net' otr='forbid' save='message'/>
    <session thread='ffd7076498744578d10edabfe7f4a866' save='body'/>
    <method type='auto' use='forbid'/>
    <method type='local' use='concede'/>
    <method type='manual' use='prefer'/>
  </pref>
</iq>"
        let info = this.Test stanza
        info |> Parsing.isContentPreference |> should be True
        info |> Parsing.isContentArchiveManagement |> should be False
        info |> Parsing.isContentManualArchiving |> should be False
        info |> Parsing.isContentReplication |> should be False
        info |> Parsing.isContentAutomaticArchiving |> should be False
        let elem = Parsing.parseContentPreference info
        match elem with
        | PreferenceResult r -> ()
        | _ -> Assert.Fail "parsed should be preferenceResult"
        prefTest stanza info elem
        ()
        
    [<Test>]
    member this.``Check that we can parse & write preference request`` () = 
        let stanza = "<iq type='get' id='pref1'>
  <pref xmlns='urn:xmpp:archive'/>
</iq>"
        let info = this.Test stanza
        info |> Parsing.isContentPreference |> should be True
        info |> Parsing.isContentArchiveManagement |> should be False
        info |> Parsing.isContentManualArchiving |> should be False
        info |> Parsing.isContentReplication |> should be False
        info |> Parsing.isContentAutomaticArchiving |> should be False
        let elem = Parsing.parseContentPreference info
        match elem with
        | PreferenceAction.RequestPreferences -> ()
        | _ -> Assert.Fail "parsed should be RequestPreferences"
        prefTest stanza info elem
        ()

    [<Test>]
    member this.``Check that we can parse & write preference set/push: default mode`` () = 
        let stanza = "<iq type='set' id='pref2'>
  <pref xmlns='urn:xmpp:archive'>
    <default otr='prefer' save='false'/>
  </pref>
</iq>"
        let info = this.Test stanza
        info |> Parsing.isContentPreference |> should be True
        info |> Parsing.isContentArchiveManagement |> should be False
        info |> Parsing.isContentManualArchiving |> should be False
        info |> Parsing.isContentReplication |> should be False
        info |> Parsing.isContentAutomaticArchiving |> should be False
        let elem = Parsing.parseContentPreference info
        match elem with
        | PreferenceAction.SetDefault _ -> ()
        | _ -> Assert.Fail "parsed should be SetDefault"
        prefTest stanza info elem
        ()

    [<Test>]
    member this.``Check that we can parse & write preference set/push: contact`` () = 
        let stanza = "<iq type='set' id='pref3'>
  <pref xmlns='urn:xmpp:archive'>
    <item jid='romeo@montague.net' save='body' expire='604800' otr='concede'/>
  </pref>
</iq>"
        let info = this.Test stanza
        info |> Parsing.isContentPreference |> should be True
        info |> Parsing.isContentArchiveManagement |> should be False
        info |> Parsing.isContentManualArchiving |> should be False
        info |> Parsing.isContentReplication |> should be False
        info |> Parsing.isContentAutomaticArchiving |> should be False
        let elem = Parsing.parseContentPreference info
        match elem with
        | PreferenceAction.SetItem _ -> ()
        | _ -> Assert.Fail "parsed should be SetItem"
        prefTest stanza info elem
        ()

    [<Test>]
    member this.``Check that we can parse & write preference set/push: remove item`` () = 
        let stanza = "<iq type='set' id='remove1'>
  <itemremove xmlns='urn:xmpp:archive'>
    <item jid='benvolio@montague.net'/>
  </itemremove>
</iq>"
        let info = this.Test stanza
        info |> Parsing.isContentPreference |> should be True
        info |> Parsing.isContentArchiveManagement |> should be False
        info |> Parsing.isContentManualArchiving |> should be False
        info |> Parsing.isContentReplication |> should be False
        info |> Parsing.isContentAutomaticArchiving |> should be False
        let elem = Parsing.parseContentPreference info
        match elem with
        | PreferenceAction.RemoveItem _ -> ()
        | _ -> Assert.Fail "parsed should be RemoveItem"
        prefTest stanza info elem
        ()

    [<Test>]
    member this.``Check that we can parse & write preference set/push: chat session`` () = 
        let stanza = "<iq type='set' id='pref4'>
  <pref xmlns='urn:xmpp:archive'>
    <session thread='ffd7076498744578d10edabfe7f4a866' save='body' otr='concede'/>
  </pref>
</iq>"
        let info = this.Test stanza
        info |> Parsing.isContentPreference |> should be True
        info |> Parsing.isContentArchiveManagement |> should be False
        info |> Parsing.isContentManualArchiving |> should be False
        info |> Parsing.isContentReplication |> should be False
        info |> Parsing.isContentAutomaticArchiving |> should be False
        let elem = Parsing.parseContentPreference info
        match elem with
        | PreferenceAction.SetSession _ -> ()
        | _ -> Assert.Fail "parsed should be SetSession"
        prefTest stanza info elem
        ()

    [<Test>]
    member this.``Check that we can parse & write preference set/push: remove session`` () = 
        let stanza = "<iq type='set' id='remove2'>
  <sessionremove xmlns='urn:xmpp:archive'>
    <session thread='ffd7076498744578d10edabfe7f4a866'/>
  </sessionremove>
</iq>"
        let info = this.Test stanza
        info |> Parsing.isContentPreference |> should be True
        info |> Parsing.isContentArchiveManagement |> should be False
        info |> Parsing.isContentManualArchiving |> should be False
        info |> Parsing.isContentReplication |> should be False
        info |> Parsing.isContentAutomaticArchiving |> should be False
        let elem = Parsing.parseContentPreference info
        match elem with
        | PreferenceAction.RemoveSession _ -> ()
        | _ -> Assert.Fail "parsed should be RemoveSession"
        prefTest stanza info elem
        ()

    [<Test>]
    member this.``Check that we can parse & write preference set/push: method`` () = 
        let stanza = "<iq type='set' id='pref5'>
  <pref xmlns='urn:xmpp:archive'>
    <method type='auto' use='concede'/>
    <method type='local' use='forbid'/>
    <method type='manual' use='prefer'/>
  </pref>
</iq>"
        let info = this.Test stanza
        info |> Parsing.isContentPreference |> should be True
        info |> Parsing.isContentArchiveManagement |> should be False
        info |> Parsing.isContentManualArchiving |> should be False
        info |> Parsing.isContentReplication |> should be False
        info |> Parsing.isContentAutomaticArchiving |> should be False
        let elem = Parsing.parseContentPreference info
        match elem with
        | PreferenceAction.SetMethods _ -> ()
        | _ -> Assert.Fail "parsed should be SetMethods"
        prefTest stanza info elem
        ()

// Test Manual Archiving

    [<Test>]
    member this.``Check that we can parse & write ManualArchiving message: storing`` () = 
        let stanza = "<iq type='set' id='up1'>
  <save xmlns='urn:xmpp:archive'>
    <chat with='juliet@capulet.com/chamber'
          start='1469-07-21T02:56:15Z'
          thread='damduoeg08'
          subject='She speaks!'>
      <from secs='0'><body>Art thou not Romeo, and a Montague?</body></from>
      <to secs='11'><body>Neither, fair saint, if either thee dislike.</body></to>
      <from secs='7'><body>How cam'st thou hither, tell me, and wherefore?</body></from>
      <note utc='1469-07-21T03:04:35Z'>I think she might fancy me.</note>
    </chat>
  </save>
</iq>"
        let info = this.Test stanza
        info |> Parsing.isContentPreference |> should be False
        info |> Parsing.isContentArchiveManagement |> should be False
        info |> Parsing.isContentManualArchiving |> should be True
        info |> Parsing.isContentReplication |> should be False
        info |> Parsing.isContentAutomaticArchiving |> should be False
        let elem = Parsing.parseContentManualArchiving info
        match elem with
        | ManualArchivingAction.Save _ -> ()
        | _ -> Assert.Fail "parsed should be ManualArchivingAction.Save"
        manualTest stanza info elem

    [<Test>]
    member this.``Check that we can parse & write ManualArchiving message: result`` () = 
        let stanza = "<iq type='result' id='up1'>
  <save xmlns='urn:xmpp:archive'>
    <chat with='juliet@capulet.com/chamber'
          start='1469-07-21T02:56:15Z'
          thread='damduoeg08'
          subject='She speaks!'
          version='0'/>
  </save>
</iq>"
        let info = this.Test stanza
        info |> Parsing.isContentPreference |> should be False
        info |> Parsing.isContentArchiveManagement |> should be False
        info |> Parsing.isContentManualArchiving |> should be True
        info |> Parsing.isContentReplication |> should be False
        info |> Parsing.isContentAutomaticArchiving |> should be False
        let elem = Parsing.parseContentManualArchiving info
        match elem with
        | ManualArchivingAction.SaveResult _ -> ()
        | _ -> Assert.Fail "parsed should be ManualArchivingAction.SaveResult"
        manualTest stanza info elem

    [<Test>]
    member this.``Check that we can parse & write ManualArchiving message: storing offline messages`` () = 
        let stanza = "<iq type='set' id='up2'>
  <save xmlns='urn:xmpp:archive'>
    <chat with='juliet@capulet.com/chamber'
          start='1469-07-21T02:56:15Z'
          subject='She speaks!'>
      <from utc='1469-07-21T00:32:29Z'><body>Art thou not Romeo, and a Montague?</body></from>
      <to secs='11'><body>Neither, fair saint, if either thee dislike.</body></to>
      <from secs='7'><body>How cam'st thou hither, tell me, and wherefore?</body></from>
    </chat>
  </save>
</iq>"
        let info = this.Test stanza
        info |> Parsing.isContentPreference |> should be False
        info |> Parsing.isContentArchiveManagement |> should be False
        info |> Parsing.isContentManualArchiving |> should be True
        info |> Parsing.isContentReplication |> should be False
        info |> Parsing.isContentAutomaticArchiving |> should be False
        let elem = Parsing.parseContentManualArchiving info
        match elem with
        | ManualArchivingAction.Save _ -> ()
        | _ -> Assert.Fail "parsed should be ManualArchivingAction.Save"
        manualTest stanza info elem

    [<Test>]
    member this.``Check that we can parse & write ManualArchiving message: storing groupchat messages`` () = 
        let stanza = "<iq type='set' id='up3'>
  <save xmlns='urn:xmpp:archive'>
    <chat with='balcony@house.capulet.com'
          start='1469-07-21T03:16:37Z'>
      <from secs='0' name='benvolio'><body>She will invite him to some supper.</body></from>
      <from secs='6' name='mercutio'><body>A bawd, a bawd, a bawd! So ho!</body></from>
      <from secs='3' name='romeo' jid='romeo@montague.net'><body>What hast thou found?</body></from>
    </chat>
  </save>
</iq>"
        let info = this.Test stanza
        info |> Parsing.isContentPreference |> should be False
        info |> Parsing.isContentArchiveManagement |> should be False
        info |> Parsing.isContentManualArchiving |> should be True
        info |> Parsing.isContentReplication |> should be False
        info |> Parsing.isContentAutomaticArchiving |> should be False
        let elem = Parsing.parseContentManualArchiving info
        match elem with
        | ManualArchivingAction.Save _ -> ()
        | _ -> Assert.Fail "parsed should be ManualArchivingAction.Save"
        manualTest stanza info elem

    [<Test>]
    member this.``Check that we can parse & write ManualArchiving message: storing with next link`` () = 
        let stanza = "<iq type='set' id='link1'>
  <save xmlns='urn:xmpp:archive'>
    <chat with='benvolio@montague.net'
          start='1469-07-21T03:01:54Z'>
      <next with='balcony@house.capulet.com' start='1469-07-21T03:16:37Z'/>
      <to secs='0'><body>O, I am fortune's fool!</body></to>
      <from secs='4'><body>Why dost thou stay?</body></from>
    </chat>
  </save>
</iq>"
        let info = this.Test stanza
        info |> Parsing.isContentPreference |> should be False
        info |> Parsing.isContentArchiveManagement |> should be False
        info |> Parsing.isContentManualArchiving |> should be True
        info |> Parsing.isContentReplication |> should be False
        info |> Parsing.isContentAutomaticArchiving |> should be False
        let elem = Parsing.parseContentManualArchiving info
        match elem with
        | ManualArchivingAction.Save _ -> ()
        | _ -> Assert.Fail "parsed should be ManualArchivingAction.Save"
        manualTest stanza info elem

    [<Test>]
    member this.``Check that we can parse & write ManualArchiving message: storing with previous link`` () = 
        let stanza = "<iq type='set' id='link2'>
  <save xmlns='urn:xmpp:archive'>
    <chat with='balcony@house.capulet.com'
          start='1469-07-21T03:16:37Z'>
      <previous with='benvolio@montague.net' start='1469-07-21T03:01:54Z'/>
      <from secs='0' name='benvolio'><body>She will invite him to some supper.</body></from>
      <from secs='6' name='mercutio'><body>A bawd, a bawd, a bawd! So ho!</body></from>
      <from secs='3' name='romeo'><body>What hast thou found?</body></from>
    </chat>
  </save>
</iq>"
        let info = this.Test stanza
        info |> Parsing.isContentPreference |> should be False
        info |> Parsing.isContentArchiveManagement |> should be False
        info |> Parsing.isContentManualArchiving |> should be True
        info |> Parsing.isContentReplication |> should be False
        info |> Parsing.isContentAutomaticArchiving |> should be False
        let elem = Parsing.parseContentManualArchiving info
        match elem with
        | ManualArchivingAction.Save _ -> ()
        | _ -> Assert.Fail "parsed should be ManualArchivingAction.Save"
        manualTest stanza info elem

    [<Test>]
    member this.``Check that we can parse & write ManualArchiving message: storing with deleting previous and next link`` () = 
        let stanza = "<iq type='set' id='link3'>
  <save xmlns='urn:xmpp:archive'>
    <chat with='balcony@house.capulet.com'
          start='1469-07-21T03:16:37Z'>
      <previous/>
      <next/>
    </chat>
  </save>
</iq>"
        let info = this.Test stanza
        info |> Parsing.isContentPreference |> should be False
        info |> Parsing.isContentArchiveManagement |> should be False
        info |> Parsing.isContentManualArchiving |> should be True
        info |> Parsing.isContentReplication |> should be False
        info |> Parsing.isContentAutomaticArchiving |> should be False
        let elem = Parsing.parseContentManualArchiving info
        match elem with
        | ManualArchivingAction.Save _ -> ()
        | _ -> Assert.Fail "parsed should be ManualArchivingAction.Save"
        manualTest stanza info elem

    [<Test>]
    member this.``Check that we can parse & write ManualArchiving message: storing with attributes form`` () = 
        let stanza = "<iq type='set' id='form1'>
  <save xmlns='urn:xmpp:archive'>
    <chat with='benvolio@montague.net'
          start='1469-07-21T03:01:54Z'>
      <to secs='0'><body>O, I am fortune's fool!</body></to>
      <from secs='4'><body>Why dost thou stay?</body></from>
      <x xmlns='jabber:x:data' type='submit'>
        <field var='FORM_TYPE'><value>http://example.com/archiving</value></field>
        <field var='task'><value>1</value></field>
        <field var='important'><value>1</value></field>
        <field var='action_before'><value>1469-07-29T12:00:00Z</value></field>
      </x>
    </chat>
  </save>
</iq>"
        let info = this.Test stanza
        info |> Parsing.isContentPreference |> should be False
        info |> Parsing.isContentArchiveManagement |> should be False
        info |> Parsing.isContentManualArchiving |> should be True
        info |> Parsing.isContentReplication |> should be False
        info |> Parsing.isContentAutomaticArchiving |> should be False
        let elem = Parsing.parseContentManualArchiving info
        match elem with
        | ManualArchivingAction.Save _ -> ()
        | _ -> Assert.Fail "parsed should be ManualArchivingAction.Save"
        // TODO: we ignore the custom form for now
        let stanza = "<iq type='set' id='form1'>
  <save xmlns='urn:xmpp:archive'>
    <chat with='benvolio@montague.net'
          start='1469-07-21T03:01:54Z'>
      <to secs='0'><body>O, I am fortune's fool!</body></to>
      <from secs='4'><body>Why dost thou stay?</body></from>
    </chat>
  </save>
</iq>"
        manualTest stanza info elem
        warn ("This feature is currently not implemented properly")


// Test Automatic Archiving

    [<Test>]
    member this.``Check that we can parse & write AutomaticArchiving message: change setting`` () = 
        let stanza = "<iq type='set' id='auto1'>
  <auto save='true' xmlns='urn:xmpp:archive'/>
</iq>"
        let info = this.Test stanza
        info |> Parsing.isContentPreference |> should be False
        info |> Parsing.isContentArchiveManagement |> should be False
        info |> Parsing.isContentManualArchiving |> should be False
        info |> Parsing.isContentReplication |> should be False
        info |> Parsing.isContentAutomaticArchiving |> should be True
        let elem = Parsing.parseContentAutomaticArchiving info
        match elem with
        | AutomaticArchivingAction.SetAutomaticArchiving _ -> ()
        | _ -> Assert.Fail "parsed should be AutomaticArchivingAction.SetAutomaticArchiving"
        autoTest stanza info elem


// Test Archive Managment

    [<Test>]
    member this.``Check that we can parse & write ArchiveManagement message: list collections`` () = 
        let stanza = "<iq type='get' id='juliet1'>
  <list xmlns='urn:xmpp:archive'
        with='juliet@capulet.com'>
    <set xmlns='http://jabber.org/protocol/rsm'>
      <max>30</max>
    </set>
  </list>
</iq>"
        let info = this.Test stanza
        info |> Parsing.isContentPreference |> should be False
        info |> Parsing.isContentArchiveManagement |> should be True
        info |> Parsing.isContentManualArchiving |> should be False
        info |> Parsing.isContentReplication |> should be False
        info |> Parsing.isContentAutomaticArchiving |> should be False
        let elem = Parsing.parseContentArchivingManagement info
        match elem with
        | MessageArchivingAction.RequestList _ -> ()
        | _ -> Assert.Fail "parsed should be MessageArchivingAction.RequestList"
        let stanza = "<iq type='get' id='juliet1'>
  <list xmlns='urn:xmpp:archive'
        with='juliet@capulet.com'>
  </list>
</iq>"
        manageTest stanza info elem
        warn ("We ignore result set management for now")

    [<Test>]
    member this.``Check that we can parse & write ArchiveManagement message: list collections between dates`` () = 
        let stanza = "<iq type='get' id='period1'>
  <list xmlns='urn:xmpp:archive'
        with='juliet@capulet.com'
        start='1469-07-21T02:00:00Z'
        end='1479-07-21T04:00:00Z'>
    <set xmlns='http://jabber.org/protocol/rsm'>
      <max>30</max>
    </set>
  </list>
</iq>"
        let info = this.Test stanza
        info |> Parsing.isContentPreference |> should be False
        info |> Parsing.isContentArchiveManagement |> should be True
        info |> Parsing.isContentManualArchiving |> should be False
        info |> Parsing.isContentReplication |> should be False
        info |> Parsing.isContentAutomaticArchiving |> should be False
        let elem = Parsing.parseContentArchivingManagement info
        match elem with
        | MessageArchivingAction.RequestList _ -> ()
        | _ -> Assert.Fail "parsed should be MessageArchivingAction.RequestList"
        let stanza = "<iq type='get' id='period1'>
  <list xmlns='urn:xmpp:archive'
        with='juliet@capulet.com'
        start='1469-07-21T02:00:00Z'
        end='1479-07-21T04:00:00Z'>
  </list>
</iq>"
        manageTest stanza info elem
        warn ("We ignore result set management for now")

    [<Test>]
    member this.``Check that we can parse & write ArchiveManagement message: receive empty list`` () = 
        let stanza = "<iq type='result' to='romeo@montague.net/orchard' id='list1'>
  <list xmlns='urn:xmpp:archive'/>
</iq>"
        let info = this.Test stanza
        info |> Parsing.isContentPreference |> should be False
        info |> Parsing.isContentArchiveManagement |> should be True
        info |> Parsing.isContentManualArchiving |> should be False
        info |> Parsing.isContentReplication |> should be False
        info |> Parsing.isContentAutomaticArchiving |> should be False
        let elem = Parsing.parseContentArchivingManagement info
        match elem with
        | MessageArchivingAction.RequestResult _ -> ()
        | _ -> Assert.Fail "parsed should be MessageArchivingAction.RequestResult"
        manageTest stanza info elem

    [<Test>]
    member this.``Check that we can parse & write ArchiveManagement message: retrieve collection`` () = 
        let stanza = "<iq type='get' id='page1'>
  <retrieve xmlns='urn:xmpp:archive'
            with='juliet@capulet.com/chamber'
            start='1469-07-21T02:56:15Z'>
    <set xmlns='http://jabber.org/protocol/rsm'>
      <max>100</max>
    </set>
  </retrieve>
</iq>"
        let info = this.Test stanza
        info |> Parsing.isContentPreference |> should be False
        info |> Parsing.isContentArchiveManagement |> should be True
        info |> Parsing.isContentManualArchiving |> should be False
        info |> Parsing.isContentReplication |> should be False
        info |> Parsing.isContentAutomaticArchiving |> should be False
        let elem = Parsing.parseContentArchivingManagement info
        match elem with
        | MessageArchivingAction.RequestCollection _ -> ()
        | _ -> Assert.Fail "parsed should be MessageArchivingAction.RequestCollection"
        let stanza = "<iq type='get' id='page1'>
  <retrieve xmlns='urn:xmpp:archive'
            with='juliet@capulet.com/chamber'
            start='1469-07-21T02:56:15Z'>
  </retrieve>
</iq>"
        manageTest stanza info elem
        warn ("We ignore result set management for now")

    [<Test>]
    member this.``Check that we can parse & write ArchiveManagement message: receive collection`` () = 
        let stanza = "<iq type='result' to='romeo@montague.net/orchard' id='page1'>
  <chat xmlns='urn:xmpp:archive'
        with='juliet@capulet.com/chamber'
        start='1469-07-21T02:56:15Z'
        subject='She speaks!'
        version='4'>
    <from secs='0'><body>Art thou not Romeo, and a Montague?</body></from>
    <to secs='11'><body>Neither, fair saint, if either thee dislike.</body></to>
    <from secs='9'><body>How cam'st thou hither, tell me, and wherefore?</body></from>
    <set xmlns='http://jabber.org/protocol/rsm'>
      <first index='0'>0</first>
      <last>99</last>
      <count>217</count>
    </set>
  </chat>
</iq>"
        let info = this.Test stanza
        info |> Parsing.isContentPreference |> should be False
        info |> Parsing.isContentArchiveManagement |> should be True
        info |> Parsing.isContentManualArchiving |> should be False
        info |> Parsing.isContentReplication |> should be False
        info |> Parsing.isContentAutomaticArchiving |> should be False
        let elem = Parsing.parseContentArchivingManagement info
        match elem with
        | MessageArchivingAction.CollectionResult _ -> ()
        | _ -> Assert.Fail "parsed should be MessageArchivingAction.CollectionResult"
        let stanza = "<iq type='result' to='romeo@montague.net/orchard' id='page1'>
  <chat xmlns='urn:xmpp:archive'
        with='juliet@capulet.com/chamber'
        start='1469-07-21T02:56:15Z'
        subject='She speaks!'
        version='4'>
    <from secs='0'><body>Art thou not Romeo, and a Montague?</body></from>
    <to secs='11'><body>Neither, fair saint, if either thee dislike.</body></to>
    <from secs='9'><body>How cam'st thou hither, tell me, and wherefore?</body></from>
  </chat>
</iq>"
        manageTest stanza info elem
        warn ("We ignore result set management for now")

    [<Test>]
    member this.``Check that we can parse & write ArchiveManagement message: remove single collection`` () = 
        let stanza = "<iq type='set' id='remove1'>
  <remove xmlns='urn:xmpp:archive'
          with='juliet@capulet.com/chamber'
          start='1469-07-21T02:56:15Z'/>
</iq>"
        let info = this.Test stanza
        info |> Parsing.isContentPreference |> should be False
        info |> Parsing.isContentArchiveManagement |> should be True
        info |> Parsing.isContentManualArchiving |> should be False
        info |> Parsing.isContentReplication |> should be False
        info |> Parsing.isContentAutomaticArchiving |> should be False
        let elem = Parsing.parseContentArchivingManagement info
        match elem with
        | MessageArchivingAction.RemoveCollection _ -> ()
        | _ -> Assert.Fail "parsed should be MessageArchivingAction.RemoveCollection"
        manageTest stanza info elem

    [<Test>]
    member this.``Check that we can parse & write ArchiveManagement message: remove all with jid between two times`` () = 
        let stanza = "<iq type='set' id='remove3'>
  <remove xmlns='urn:xmpp:archive'
          with='juliet@capulet.com'
          start='1469-07-21T02:00:00Z'
          end='1469-07-21T04:00:00Z'/>
</iq>"
        let info = this.Test stanza
        info |> Parsing.isContentPreference |> should be False
        info |> Parsing.isContentArchiveManagement |> should be True
        info |> Parsing.isContentManualArchiving |> should be False
        info |> Parsing.isContentReplication |> should be False
        info |> Parsing.isContentAutomaticArchiving |> should be False
        let elem = Parsing.parseContentArchivingManagement info
        match elem with
        | MessageArchivingAction.RemoveAllCollections _ -> ()
        | _ -> Assert.Fail "parsed should be MessageArchivingAction.RemoveAllCollections"
        manageTest stanza info elem

    [<Test>]
    member this.``Check that we can parse & write ArchiveManagement message: removing all collections`` () = 
        let stanza = "<iq type='set' id='remove6'>
  <remove xmlns='urn:xmpp:archive'/>
</iq>"
        let info = this.Test stanza
        info |> Parsing.isContentPreference |> should be False
        info |> Parsing.isContentArchiveManagement |> should be True
        info |> Parsing.isContentManualArchiving |> should be False
        info |> Parsing.isContentReplication |> should be False
        info |> Parsing.isContentAutomaticArchiving |> should be False
        let elem = Parsing.parseContentArchivingManagement info
        match elem with
        | MessageArchivingAction.RemoveAllCollections f -> 
            f.With.IsNone |> should be True
            f.Start.IsNone |> should be True
            f.End.IsNone |> should be True
            ()
        | _ -> Assert.Fail "parsed should be MessageArchivingAction.RemoveAllCollections"
        manageTest stanza info elem

    [<Test>]
    member this.``Check that we can parse & write ArchiveManagement message: removing a collection being recorded by the server`` () = 
        let stanza = "<iq type='set' id='remove7'>
  <remove xmlns='urn:xmpp:archive'
          with='juliet@capulet.com/chamber'
          open='true'/>
</iq>"
        let info = this.Test stanza
        info |> Parsing.isContentPreference |> should be False
        info |> Parsing.isContentArchiveManagement |> should be True
        info |> Parsing.isContentManualArchiving |> should be False
        info |> Parsing.isContentReplication |> should be False
        info |> Parsing.isContentAutomaticArchiving |> should be False
        let elem = Parsing.parseContentArchivingManagement info
        match elem with
        | MessageArchivingAction.RemoveOpenCollections jid -> 
            jid.IsSome |> should be True
            ()
        | _ -> Assert.Fail "parsed should be MessageArchivingAction.RemoveAllCollections"
        manageTest stanza info elem

    [<Test>]
    member this.``Check that we can parse & write ArchiveManagement message: removing all collections being recorded by the server`` () = 
        let stanza = "<iq type='set' id='remove8'>
  <remove xmlns='urn:xmpp:archive'
          open='true'/>
</iq>"
        let info = this.Test stanza
        info |> Parsing.isContentPreference |> should be False
        info |> Parsing.isContentArchiveManagement |> should be True
        info |> Parsing.isContentManualArchiving |> should be False
        info |> Parsing.isContentReplication |> should be False
        info |> Parsing.isContentAutomaticArchiving |> should be False
        let elem = Parsing.parseContentArchivingManagement info
        match elem with
        | MessageArchivingAction.RemoveOpenCollections jid -> 
            jid.IsNone |> should be True
            ()
        | _ -> Assert.Fail "parsed should be MessageArchivingAction.RemoveAllCollections"
        manageTest stanza info elem

    [<Test>]
    member this.``Check that we can parse & write Replication message: requesting a page of modifications`` () = 
        let stanza = "<iq type='get' id='sync1'>
  <modified xmlns='urn:xmpp:archive'
            start='1469-07-21T01:14:47Z'>
    <set xmlns='http://jabber.org/protocol/rsm'>
      <max>50</max>
    </set>
  </modified>
</iq>"
        let info = this.Test stanza
        info |> Parsing.isContentPreference |> should be False
        info |> Parsing.isContentArchiveManagement |> should be False
        info |> Parsing.isContentManualArchiving |> should be False
        info |> Parsing.isContentReplication |> should be True
        info |> Parsing.isContentAutomaticArchiving |> should be False
        let elem = Parsing.parseContentReplication info
        match elem with
        | ReplicationAction.RequestModifiedSince _ -> 
            ()
        | _ -> Assert.Fail "parsed should be ReplicationAction.RequestModifiedSince"
        let stanza = "<iq type='get' id='sync1'>
  <modified xmlns='urn:xmpp:archive'
            start='1469-07-21T01:14:47Z'>
  </modified>
</iq>"
        replicationTest stanza info elem
        warn ("We ignore result set management for now")

    [<Test>]
    member this.``Check that we can parse & write Replication message: receiving a page of modifications`` () = 
        let stanza = "<iq type='result' to='romeo@montague.net/orchard' id='sync1'>
  <modified xmlns='urn:xmpp:archive'>
    <changed with='juliet@capulet.com/chamber'
             start='1469-07-21T02:56:15Z'
             version='0'/>
    <removed with='balcony@house.capulet.com'
             start='1469-07-21T03:16:37Z'
             version='3'/>
    <set xmlns='http://jabber.org/protocol/rsm'>
      <last>ja923ljasnvla09woei777</last>
      <count>1372</count>
    </set>
  </modified>
</iq>"
        let info = this.Test stanza
        info |> Parsing.isContentPreference |> should be False
        info |> Parsing.isContentArchiveManagement |> should be False
        info |> Parsing.isContentManualArchiving |> should be False
        info |> Parsing.isContentReplication |> should be True
        info |> Parsing.isContentAutomaticArchiving |> should be False
        let elem = Parsing.parseContentReplication info
        match elem with
        | ReplicationAction.RequestModifiedResult _ -> 
            ()
        | _ -> Assert.Fail "parsed should be ReplicationAction.RequestModifiedResult"
        let stanza = "<iq type='result' to='romeo@montague.net/orchard' id='sync1'>
  <modified xmlns='urn:xmpp:archive'>
    <changed with='juliet@capulet.com/chamber'
             start='1469-07-21T02:56:15Z'
             version='0'/>
    <removed with='balcony@house.capulet.com'
             start='1469-07-21T03:16:37Z'
             version='3'/>
  </modified>
</iq>"
        replicationTest stanza info elem
        warn ("We ignore result set management for now")



