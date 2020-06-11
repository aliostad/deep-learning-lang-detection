using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Vauction.Models
{
  public interface IVauctionDataProvider
  {
    IUserRepository UserRepository { get; }
    IAuctionRepository AuctionRepository { get; }
    IEventRepository EventRepository { get; }
    IBidRepository BidRepository { get; }
    IInvoiceRepository InvoiceRepository { get; }
    IGeneralRepository GeneralRepository { get; }
    ICategoryRepository CategoryRepository { get; }
    IReportRepository ReportRepository { get; }
    
    //ICountryRepository CountryRepository { get; }
    //IStateRepository StateRepository { get; }
    //IReportRepository ReportRepository { get; }    
    //IImageRepository ImageRepository { get; }
    //IPersonalShopperRepository PersonalShopperRepository { get; }
    //IVariableRepository VariableRepository { get; }
    //ICommisionProfileRepository CommisionProfileRepository { get; }
    //IListingFreeProfileRepository ListingFreeProfileRepository { get; }
  }
}