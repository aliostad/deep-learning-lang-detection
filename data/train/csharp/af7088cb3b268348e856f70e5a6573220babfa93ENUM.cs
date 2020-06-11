using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HZ
{
    class ENUM
    {

        public enum API_t
        {
            API_CHECK_LINK = 0,
            API_NEW_EMPLOYEE = 1,
            API_GET_EMPLOYEE = 2,
            API_UPDATE_EMPLOYEE = 3,
            API_DElETE_EMPLOYEE = 4,
            API_NEW_BID = 5,
            API_GET_BID = 6,
            API_GET_BID_ONE = 7,
            API_NEW_PAY = 8,
            API_GET_PAY = 9,
            API_GET_DETAILPAY = 10,
            API_POST_BILLING = 11,
            API_BID_EDIT = 12,
            API_BID_DELETE = 13,
            API_GET_PAY_DATA = 14,
            API_PAY_UPDATE = 15,
            API_PAY_DELETE = 16,
        }
        public enum type
        {
            NEW = 0,
            EDIT = 1,
            INSERT = 2,
            DELETE = 3,
        };
    }
}
