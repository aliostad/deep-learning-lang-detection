using System;
using SCOUT.Core.Data;
using SCOUT.Core.Materials.Messages;

namespace SCOUT.Core.Modules.Materials
{
    public class StationMaterialsConsumptionTracker : MaterialsConsumptionTracker
    {
        private RouteStationProcess m_process;

        public void MonitorProcess(RouteStationProcess process)
        {
            if (m_process != null)
                UnHookListeners(m_process);

            m_process = process;
            HookListeners(m_process);

        }

        private void HookListeners(RouteStationProcess process)
        {
            process.RepairComponentAdded += process_RepairComponentAdded;            
        }

        void process_RepairComponentAdded(RepairComponent obj)
        {         
            Process(new MaterialsPartConsumed() { Part = obj.PartIn, Qty = 1});            
        }

        private void UnHookListeners(RouteStationProcess process)
        {
            if(process != null)
                process.RepairComponentAdded -= process_RepairComponentAdded;
        }
    }
}