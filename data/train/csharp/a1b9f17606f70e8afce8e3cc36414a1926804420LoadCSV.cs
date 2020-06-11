using System.Collections.Generic;

namespace Core.R.States
{
    public class LoadCSV
    {
        public enum LoadCSVStates
        {
            NotLoaded,
            FailedLoad,
            SuccessfullyLoad
        }

        public static Dictionary<LoadCSVStates, string> LoadCSVStateNames = new Dictionary<LoadCSVStates, string>
        {
            {LoadCSVStates.NotLoaded, "Not Loaded"},
            {LoadCSVStates.FailedLoad, "Failed to Load"},
            {LoadCSVStates.SuccessfullyLoad, "Successfully Loaded"}
        };

        public static Dictionary<LoadCSVStates, string> LoadCSVStateColors = new Dictionary<LoadCSVStates, string>
        {
            {LoadCSVStates.NotLoaded, "Yellow"},
            {LoadCSVStates.FailedLoad, "Red"},
            {LoadCSVStates.SuccessfullyLoad, "Green"}
        };
    }
}
