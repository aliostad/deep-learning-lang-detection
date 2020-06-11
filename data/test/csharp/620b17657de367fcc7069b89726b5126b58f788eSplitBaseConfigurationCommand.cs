using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SplitBaseConfigurationCommand : BaseCommand
{
    public override void Execute()
    {
        Retain();
        dispatcher.Dispatch(EventGlobal.E_SplitSegmentForLevel, 0);
        dispatcher.Dispatch(EventGlobal.E_SplitSegmentForLevel, 0);
        dispatcher.Dispatch(EventGlobal.E_SplitSegmentForLevel, 1);
        dispatcher.Dispatch(EventGlobal.E_SplitSegmentForLevel, 1);
        dispatcher.Dispatch(EventGlobal.E_SplitSegmentForLevel, 2);
        dispatcher.Dispatch(EventGlobal.E_SplitSegmentForLevel, 3);
        Release();
    }
}