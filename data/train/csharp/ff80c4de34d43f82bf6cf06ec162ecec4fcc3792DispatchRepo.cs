using System;

namespace Oem.Data.Table.Dispatch
{
    public class DispatchRepo
    {
        /// <summary>
        /// 主键
        /// </summary>
        public long Id { get; set; }
        
        /// <summary>
        /// 派工单号
        /// </summary>
        public string DispatchNumber { get; set; }
        
        /// <summary>
        /// 派工时间
        /// </summary>
        public DateTime DispatchTime { get; set; }
        
        /// <summary>
        /// 被派工人员Id
        /// </summary>
        public long WorkStaff { get; set; }
        
        /// <summary>
        /// 派工人Id
        /// </summary>
        public long DispatchStaff { get; set; }
        
        /// <summary>
        /// 派工类型
        /// </summary>
        public string DispatchType { get; set; }
    }
}