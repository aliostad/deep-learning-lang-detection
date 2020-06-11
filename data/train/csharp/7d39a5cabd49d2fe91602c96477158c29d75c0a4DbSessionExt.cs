



using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using PP.WaiMai.IRepository;

namespace PP.WaiMai.Repository
{
	public partial class DbSession : IDbSession 
    { 

		#region 数据接口 ICommentRepository
		private ICommentRepository _CommentRepository;
        public ICommentRepository CommentRepository 
        {
            get
            {
                if (_CommentRepository == null)
                {
                    _CommentRepository = new CommentRepository();
                }
                return _CommentRepository; 
            }
            set
            {
                _CommentRepository = value;
            }
        }
		#endregion


		#region 数据接口 IConfigRepository
		private IConfigRepository _ConfigRepository;
        public IConfigRepository ConfigRepository 
        {
            get
            {
                if (_ConfigRepository == null)
                {
                    _ConfigRepository = new ConfigRepository();
                }
                return _ConfigRepository; 
            }
            set
            {
                _ConfigRepository = value;
            }
        }
		#endregion


		#region 数据接口 IExpendLogRepository
		private IExpendLogRepository _ExpendLogRepository;
        public IExpendLogRepository ExpendLogRepository 
        {
            get
            {
                if (_ExpendLogRepository == null)
                {
                    _ExpendLogRepository = new ExpendLogRepository();
                }
                return _ExpendLogRepository; 
            }
            set
            {
                _ExpendLogRepository = value;
            }
        }
		#endregion


		#region 数据接口 IFeedbackRepository
		private IFeedbackRepository _FeedbackRepository;
        public IFeedbackRepository FeedbackRepository 
        {
            get
            {
                if (_FeedbackRepository == null)
                {
                    _FeedbackRepository = new FeedbackRepository();
                }
                return _FeedbackRepository; 
            }
            set
            {
                _FeedbackRepository = value;
            }
        }
		#endregion


		#region 数据接口 IFoodMenuRepository
		private IFoodMenuRepository _FoodMenuRepository;
        public IFoodMenuRepository FoodMenuRepository 
        {
            get
            {
                if (_FoodMenuRepository == null)
                {
                    _FoodMenuRepository = new FoodMenuRepository();
                }
                return _FoodMenuRepository; 
            }
            set
            {
                _FoodMenuRepository = value;
            }
        }
		#endregion


		#region 数据接口 IFoodMenuCategoryRepository
		private IFoodMenuCategoryRepository _FoodMenuCategoryRepository;
        public IFoodMenuCategoryRepository FoodMenuCategoryRepository 
        {
            get
            {
                if (_FoodMenuCategoryRepository == null)
                {
                    _FoodMenuCategoryRepository = new FoodMenuCategoryRepository();
                }
                return _FoodMenuCategoryRepository; 
            }
            set
            {
                _FoodMenuCategoryRepository = value;
            }
        }
		#endregion


		#region 数据接口 IOrderRepository
		private IOrderRepository _OrderRepository;
        public IOrderRepository OrderRepository 
        {
            get
            {
                if (_OrderRepository == null)
                {
                    _OrderRepository = new OrderRepository();
                }
                return _OrderRepository; 
            }
            set
            {
                _OrderRepository = value;
            }
        }
		#endregion


		#region 数据接口 IRechargeRepository
		private IRechargeRepository _RechargeRepository;
        public IRechargeRepository RechargeRepository 
        {
            get
            {
                if (_RechargeRepository == null)
                {
                    _RechargeRepository = new RechargeRepository();
                }
                return _RechargeRepository; 
            }
            set
            {
                _RechargeRepository = value;
            }
        }
		#endregion


		#region 数据接口 IRestaurantRepository
		private IRestaurantRepository _RestaurantRepository;
        public IRestaurantRepository RestaurantRepository 
        {
            get
            {
                if (_RestaurantRepository == null)
                {
                    _RestaurantRepository = new RestaurantRepository();
                }
                return _RestaurantRepository; 
            }
            set
            {
                _RestaurantRepository = value;
            }
        }
		#endregion


		#region 数据接口 ISarcasmRepository
		private ISarcasmRepository _SarcasmRepository;
        public ISarcasmRepository SarcasmRepository 
        {
            get
            {
                if (_SarcasmRepository == null)
                {
                    _SarcasmRepository = new SarcasmRepository();
                }
                return _SarcasmRepository; 
            }
            set
            {
                _SarcasmRepository = value;
            }
        }
		#endregion


		#region 数据接口 IUserRepository
		private IUserRepository _UserRepository;
        public IUserRepository UserRepository 
        {
            get
            {
                if (_UserRepository == null)
                {
                    _UserRepository = new UserRepository();
                }
                return _UserRepository; 
            }
            set
            {
                _UserRepository = value;
            }
        }
		#endregion


    }

}