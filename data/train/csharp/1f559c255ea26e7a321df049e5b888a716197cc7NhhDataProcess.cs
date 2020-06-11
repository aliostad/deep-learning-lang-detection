using NhhDataImport.Entity;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace NhhDataImport.Process
{
    /// <summary>
    /// 立天唐人数据处理
    /// </summary>
    public class NhhDataProcess
    {
        /// <summary>
        /// 校验
        /// </summary>
        /// <param name="fileName"></param>
        /// <param name="sheetNames"></param>
        /// <param name="worker"></param>
        public static void Check(string fileName, List<string> sheetNames, BackgroundWorker worker)
        {
            var processList = new Dictionary<string, INhhDataProcess>();
            processList.Add("品牌", new BrandProcess());
            processList.Add("公司", new CompanyProcess());
            processList.Add("部门", new DepartmentProcess());
            processList.Add("员工", new EmployeeProcess());
            processList.Add("项目", new ProjectProcess());
            processList.Add("楼宇", new ProjectBuildingProcess());
            processList.Add("楼层", new ProjectFloorProcess());
            processList.Add("商铺筹划", new ProjectUnitProcess());
            processList.Add("商户", new MerchantProcess());
            processList.Add("商铺合约", new ContractProcess());

            foreach (var process in processList)
            {
                if (sheetNames.Exists(sheetName => process.Key == sheetName))
                {
                    try
                    {
                        process.Value.CheckData(fileName, worker);
                    }
                    catch (Exception ex)
                    {
                        worker.ReportProgress(20, ex.ToString());
                    }
                }
            }
        }

        /// <summary>
        /// 处理
        /// </summary>
        /// <param name="fileName"></param>
        /// <param name="sheetNames"></param>
        /// <param name="worker"></param>
        public static void Process(string fileName, List<string> sheetNames, BackgroundWorker worker)
        {
            var processList = new Dictionary<string, INhhDataProcess>();
            processList.Add("品牌", new BrandProcess());
            processList.Add("公司", new CompanyProcess());
            processList.Add("部门", new DepartmentProcess());
            processList.Add("员工", new EmployeeProcess());
            processList.Add("项目", new ProjectProcess());
            processList.Add("楼宇", new ProjectBuildingProcess());
            processList.Add("楼层", new ProjectFloorProcess());
            processList.Add("商铺筹划", new ProjectUnitProcess());
            processList.Add("商户", new MerchantProcess());
            processList.Add("商铺合约", new ContractProcess());

            foreach(var process in processList)
            {
                if (sheetNames.Exists(sheetName => process.Key == sheetName))
                {
                    try
                    {
                        process.Value.ProcessData(fileName, worker);
                    }
                    catch (Exception ex)
                    {
                        worker.ReportProgress(20, ex.ToString());
                    }
                }
            }
        }
    }
}
