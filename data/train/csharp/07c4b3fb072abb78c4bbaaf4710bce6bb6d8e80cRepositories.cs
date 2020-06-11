


 
 
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using PP.WaiMai.Model;
using PP.WaiMai.IRepository; 

namespace PP.WaiMai.Repository
{

	public class CommentRepository : BaseRepository<Comment>,ICommentRepository
    {

    }

	public class ConfigRepository : BaseRepository<Config>,IConfigRepository
    {

    }

	public class ExpendLogRepository : BaseRepository<ExpendLog>,IExpendLogRepository
    {

    }

	public class FeedbackRepository : BaseRepository<Feedback>,IFeedbackRepository
    {

    }

	public class FoodMenuRepository : BaseRepository<FoodMenu>,IFoodMenuRepository
    {

    }

	public class FoodMenuCategoryRepository : BaseRepository<FoodMenuCategory>,IFoodMenuCategoryRepository
    {

    }

	public class OrderRepository : BaseRepository<Order>,IOrderRepository
    {

    }

	public class RechargeRepository : BaseRepository<Recharge>,IRechargeRepository
    {

    }

	public class RestaurantRepository : BaseRepository<Restaurant>,IRestaurantRepository
    {

    }

	public class SarcasmRepository : BaseRepository<Sarcasm>,ISarcasmRepository
    {

    }

	public class UserRepository : BaseRepository<User>,IUserRepository
    {

    }

}