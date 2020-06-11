using Dargon.Processes.Watching;

namespace Dargon.LeagueOfLegends.Processes
{
   public delegate void LeagueProcessDetectedHandler(LeagueProcessDetectedArgs args);
   public class LeagueProcessDetectedArgs
   {
      public LeagueProcessType ProcessType { get; private set; }
      public CreatedProcessDescriptor ProcessDescriptor { get; private set; }

      public LeagueProcessDetectedArgs(
         LeagueProcessType leagueProcessType,
         CreatedProcessDescriptor createdProcessDescriptor)
      {
         ProcessType = leagueProcessType;
         ProcessDescriptor = createdProcessDescriptor;
      }
   }
}
