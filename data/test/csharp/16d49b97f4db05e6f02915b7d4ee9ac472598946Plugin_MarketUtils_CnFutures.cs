using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace com.wer.sc.plugin.cnfutures.market
{
    public class Plugin_MarketUtils_CnFutures : IPlugin_MarketUtils
    {
        /// <summary>
        /// 将本地的期货代码转换成服务器上的期货代码
        /// 如rb05，是螺纹钢5月合约，现在的螺纹钢5月合约是rb1705
        /// 所以返回rb1705
        /// </summary>
        /// <param name="localInstrumentId"></param>
        /// <returns></returns>
        public string TransferLocalInstrumentIdToRemote(string localInstrumentId)
        {
            /*
             * 期货合约规则
             * 期货合约的交割日一般是每个月第三个周五
             * 
             * 算法简化了，没超过合约月份就按本年合约算
             * TODO 最好还是优化算法
             */
            if (IsFullInstrument(localInstrumentId))
                return localInstrumentId;

            DateTime date = DateTime.Now;
            int month = date.Month;

            int splitIndex = localInstrumentId.Length - 2;
            int instrumentMonth = int.Parse(localInstrumentId.Substring(splitIndex));
            String instrumentPrefix = localInstrumentId.Substring(0, splitIndex);

            if (month > instrumentMonth)
            {
                string nextyear_suffix = (date.Year + 1).ToString().Substring(2, 2);
                return instrumentPrefix + nextyear_suffix + instrumentMonth.ToString();
            }
            string year_suffix = date.Year.ToString().Substring(2, 2);
            return instrumentPrefix + year_suffix + GetMonthString(instrumentMonth);
        }

        private string GetMonthString(int month)
        {
            return month < 10 ? "0" + month : month.ToString();
        }

        private bool IsFullInstrument(string localInstrumentId)
        {
            if (localInstrumentId == null || localInstrumentId.Length <= 4)
                return false;
            string str = localInstrumentId.Substring(localInstrumentId.Length - 4);
            int r;
            return int.TryParse(str, out r);
        }

        public string TransferRemoteInstrumentIdToLocal(string remoteInstrumentId)
        {
            string prefix = remoteInstrumentId.Substring(0, remoteInstrumentId.Length - 4);
            return prefix + remoteInstrumentId.Substring(remoteInstrumentId.Length - 2);
        }
    }
}
