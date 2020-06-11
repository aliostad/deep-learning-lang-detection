using BC.AppCloud.DAL;
using BC.AppCloud.Entity.ApiCloud;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BC.AppCloud.BLL.ApiCloud
{
    public partial class ApiCloud_ApiListItemBLL : BaseBLL<ApiCloud_ApiListItem>
    {
        private readonly BaseDAL<ApiCloud_ApiListItem> _ApiCloud_ApiListItemDal;
        public ApiCloud_ApiListItemBLL()
            : base()
        {
            _ApiCloud_ApiListItemDal = base.Dal;
        }
    }
}
    