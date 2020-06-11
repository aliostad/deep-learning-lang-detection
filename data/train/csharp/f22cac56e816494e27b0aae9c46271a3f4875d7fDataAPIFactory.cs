using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Dao.DataAPI
{
    public class DataAPIFactory
    {
        public enum APIType
        {
            DefaultAPI
        }

        private static APIType apiType = APIType.DefaultAPI;
        private static IDataAPI dataAPI = null;

        public static IDataAPI GetDataAPI(APIType type){
            if (dataAPI != null && apiType == type )
            {
                return dataAPI;
            }

            apiType = type;
            switch(type){
                case APIType.DefaultAPI:
                    dataAPI = new SinaDataAPI();
                    break;
            }

            return dataAPI;
        }
    }
}
