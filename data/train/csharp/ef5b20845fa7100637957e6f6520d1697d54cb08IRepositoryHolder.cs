using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;



namespace ISharpConvertor.DAL.Abstract
{
    public interface IRepositoryHolder:IDisposable
    
    {
        Entity.ISharpConvertorEntities Context { get; }
        IAdressRepository AdressRepository { get; }
        IBankRepository BankRepository { get; }
        ICominsRepository CominsRepository { get; }
        ICurrencyRepository CurrencyRepository { get; }
        ICurrencyRateRepository CurrencyRateRepository { get; }
        IExpodentureRepository ExpodentureRepository { get; }
        IIncomeRepository IncomeRepository { get; }
        INewsRepository NewsRepository { get; }
        IOperationCominsRepository OperationCominsRepository { get; }
        IOperationDetailsRepository OperationDetailsRepository { get; }
        IOperationRepository OperationRepository { get; }
        IRateRepository RateRepository { get; }
        IRssUserNewsRepository RssUserNewsRepository { get; }
        IRssUserRepository RssUserRepository { get; }
        ISystemCominRepository SystemCominRepository { get; }
        IUserCominRepository UserCominRepository { get; }
        IVideosRepository VideosRepository { get; }
        IFromWhoRepository FromWhoRepository { get; }
        void SaveChanges();
    }
}
