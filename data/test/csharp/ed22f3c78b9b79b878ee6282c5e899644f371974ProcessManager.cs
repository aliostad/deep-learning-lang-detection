using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using KusumgarBusinessEntities;
using KusumgarDataAccess;
using KusumgarBusinessEntities.Common;

namespace KusumgarModel
{
    public class ProcessManager
    {
        public ProcessRepo _processRepo { get; set; }

        public ProcessManager()
        {
            _processRepo = new ProcessRepo();
        }

        public void Insert_Process(ProcessInfo ProcessInfo)
        {
            _processRepo.Insert_Process(ProcessInfo);
        }

        public void Update_Process(ProcessInfo ProcessInfo)
        {
            _processRepo.Update_Process(ProcessInfo);
        }

        public List<ProcessInfo> Get_Process(ref PaginationInfo pager)
        {
            return _processRepo.Get_Process(ref pager);
        }

        public ProcessInfo Get_Process_By_Process_Id(int process_Id)
        {
            return _processRepo.Get_Process_By_Process_Id(process_Id);
        }

        public List<AutocompleteInfo> Get_Process_By_Name_Autocomplete(string process_Name)
        {
            return _processRepo.Get_Process_By_Name_Autocomplete(process_Name);
        }

        public List<ProcessInfo> Get_Process_By_Id(int process_Id, ref PaginationInfo pager)
        {
            return _processRepo.Get_Process_By_Id(process_Id, ref pager);
        }
    }
}
