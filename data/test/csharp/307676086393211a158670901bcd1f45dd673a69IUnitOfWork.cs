using ECmmerce.Data.Infrastructure;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ECmmerce.Data.Infrasctructure
{
    public interface IUnitOfWork : IDisposable
    { 
        void Commit();
     
        
   

IAddressRepository AddressRepository { get; }
ICategoryRepository CategoryRepository { get; }
ICommisionRepository   CommisionRepository    { get; } 
ICreditCardRepository CreditCardRepository{ get; }
IGouvernoratRepository GouvernoratRepository { get; }
IOrderItemRepository OrderItemRepository{ get; }
IOrderRepository OrderRepository{ get; }
IPictureRepository PictureRepository{ get; }
IProductItemRepository ProductItemRepository { get; }
IProductItemSupplierRepository ProductItemSupplierRepository { get; }
IProductRepository ProductRepository { get; }
IPromotionRepository PromotionRepository{ get; }
IReclamationRepository ReclamationRepository{ get; }
IRecommendationRepository  RecommendationRepository     { get; }
IReviewRepository ReviewRepository { get; }
IShoppingCartRepository ShoppingCartRepository{ get; }
IUserRepository UserRepository { get; }


    }
}
