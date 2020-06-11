using System.Collections.Generic;

namespace HuaHaoERP.Helper.DataDefinition
{
    static class Process
    {
        public static List<string> ProcessListWithNull
        {
            get 
            {
                List<string> ProcessList = new List<string>();
                ProcessList.Add("无");
                ProcessList.Add("圆片");
                ProcessList.Add("液压");
                ProcessList.Add("冲孔");
                ProcessList.Add("卷边");
                ProcessList.Add("抛光");
                return ProcessList; 
            }
        }
        public static List<string> ProcessListWithAll
        {
            get
            {
                List<string> ProcessList = new List<string>();
                ProcessList.Add("全部工序");
                ProcessList.Add("圆片");
                ProcessList.Add("液压");
                ProcessList.Add("冲孔");
                ProcessList.Add("卷边");
                ProcessList.Add("抛光");
                return ProcessList;
            }
        }

        public static List<string> FiveProcessList
        {
            get
            {
                List<string> ProcessList = new List<string>();
                ProcessList.Add("圆片");
                ProcessList.Add("液压");
                ProcessList.Add("冲孔");
                ProcessList.Add("卷边");
                ProcessList.Add("抛光");
                return ProcessList;
            }
        }
    }
}
