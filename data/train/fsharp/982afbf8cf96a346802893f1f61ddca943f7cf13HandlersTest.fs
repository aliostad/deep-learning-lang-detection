module IML.DeviceScannerDaemon.HandlersTest

open IML.DeviceScannerDaemon.Handlers
open IML.DeviceScannerDaemon.TestFixtures
open Fable.Import.Node
open Fable.Core.JsInterop
open Fable.Core
open Fable.PowerPack
open Fable.Import
open Fable.Import.Jest
open Fable.Import.Jest.Matchers

let toJson =  Json.ofString >> Result.unwrapResult

testList "Data Handler" [
  let withSetup f ():unit =
    let ``end`` = Matcher<string option, unit>()

    let handler = dataHandler' ``end``.Mock

    f (``end``, handler)

  yield! testFixture withSetup [
    "Should call end with map for info event", fun (``end``, handler) ->
      handler (toJson """{ "ACTION": "info" }""")
      ``end`` <?> Some("{}");

    "Should call end for add event", fun (``end``, handler) ->
       handler addObj
       ``end`` <?> None;

    "Should call end for remove event", fun (``end``, handler) ->
      handler removeObj
      ``end`` <?> None;

    "Should end on a bad match", fun (``end``, handler) ->
      expect.assertions 2
      try
        handler (toJson """{}""")
      with
        | ex ->
          ``end`` <?> None
          expect.Invoke(ex.Message).toEqual("Handler got a bad match");

    "Should remove an item", fun (``end``, handler) ->
        handler addObj

        handler (toJson """{ "ACTION": "info" }""")

        ``end`` <?> Some("{\"/devices/pci0000:00/0000:00:01.1/ata1/host1/target1:0:0/1:0:0:0/block/sdb/sdb1\":{\"ACTION\":\"add\",\"MAJOR\":\"8\",\"MINOR\":\"17\",\"DEVLINKS\":\"/dev/disk/by-id/ata-VBOX_HARDDISK_VB304a0a0f-15e93f07-part1 /dev/disk/by-path/pci-0000:00:01.1-ata-1.0-part1\",\"PATHS\":[\"/dev/sdb1\",\"/dev/disk/by-id/ata-VBOX_HARDDISK_VB304a0a0f-15e93f07-part1\",\"/dev/disk/by-path/pci-0000:00:01.1-ata-1.0-part1\"],\"DEVNAME\":\"/dev/sdb1\",\"DEVPATH\":\"/devices/pci0000:00/0000:00:01.1/ata1/host1/target1:0:0/1:0:0:0/block/sdb/sdb1\",\"DEVTYPE\":\"partition\",\"ID_VENDOR\":null,\"ID_MODEL\":\"VBOX_HARDDISK\",\"ID_SERIAL\":\"VBOX_HARDDISK_VB304a0a0f-15e93f07\",\"ID_FS_TYPE\":\"LVM2_member\",\"ID_PART_ENTRY_NUMBER\":1,\"IML_SIZE\":\"81784832\",\"IML_SCSI_80\":\"80\",\"IML_SCSI_83\":\"83\",\"IML_IS_RO\":true,\"DM_MULTIPATH_DEVICE_PATH\":true,\"DM_LV_NAME\":\"swap\",\"DM_VG_NAME\":\"centos\"}}")

        handler removeObj

        handler (toJson """{ "ACTION": "info" }""")

        ``end`` <?> Some("{}");
  ]
]
