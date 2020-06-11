namespace BookShop.Repository.Interfaces
{
    public interface IUnitOfWork
    {
        IAuthorRepository AuthorRepository { get; }
        IAuthorReviewRepository AuthorReviewRepository { get; }
        IBookRepository BookRepository { get; }
        IBookCategoryRepository BookCategoryRepository { get; }
        IBookReviewRepository BookReviewRepository { get; }
        IDeliveryRepository DeliveryRepository { get; }
        IMainCategoryRepository MainCategoryRepository { get; }
        IPaymentRepository PaymentRepository { get; }
        IPublishingRepository PublishingRepository { get; }
        IPublishingReviewRepository PublishingReviewRepository { get; }
        ISubMainCategoryRepository SubMainCategoryRepository { get; }
        ITransactionRepository TransactionRepository { get; }
        ITransactionBookQuantityRepository TransactionBookQuantityRepository { get; }
    }
}