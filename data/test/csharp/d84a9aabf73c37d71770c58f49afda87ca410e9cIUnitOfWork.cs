using System;
namespace Mono.Data
{
    public interface IUnitOfWork
    {
        CategoryRepository CategoryRepository { get; }
        CategorySizeRepository CategorySizeRepository { get; }
        FoodIngredientRepository FoodIngredientRepository { get; }
        FoodRepository FoodRepository { get; }
        IngredientRepository IngredientRepository { get; }
        OfferRepository OfferRepository { get; }
        OrderRepository OrderRepository { get; }
        PhotoRepository PhotoRepository { get; }
        RestaurantRepository RestaurantRepository { get; }
        UserRepository UserRepository { get; }

        void Dispose();
        void Save();
    }
}
