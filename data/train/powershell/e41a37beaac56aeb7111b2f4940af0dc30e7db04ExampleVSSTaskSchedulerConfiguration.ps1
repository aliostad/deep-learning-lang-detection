Configuration VSSTaskScheduler{

    Import-DscResource -ModuleName cVSS

    node $YourNode{

      cVSSTaskScheduler SevenAM{
          TaskName = "ShadowCopyVolume7AM"
          Ensure = "Absent"
          Drive = "C:"
          TriggerTime = "7:00AM"
      }
      
       cVSSTaskScheduler NineAM{
           TaskName = "ShadowCopyVolume9AM"
           Ensure = "Present"
           Drive = "C:"
           TriggerTime = "9:00AM"
       }
      
       cVSSTaskScheduler Noon{
           TaskName = "ShadowCopyVolumeNoon"
           Ensure = "Present"
           Drive = "C:"
           TriggerTime = "12:00PM"
       }
    }
}

VSSTaskScheduler -OutputPath $YourPath

Start-DscConfiguration -Wait -Force -Verbose -Path $YourPath -ComputerName $YourComputerName