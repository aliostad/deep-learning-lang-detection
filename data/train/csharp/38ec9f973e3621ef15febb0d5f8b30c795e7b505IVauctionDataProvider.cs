using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Vauction.Models
{
  public interface IVauctionDataProvider
  {
    IUserRepository UserRepository { get; }
    IEventRepository EventRepository { get; }
    IAuctionRepository AuctionRepository { get; }
    ICategoryRepository CategoryRepository { get; }
    ICountryRepository CountryRepository { get; }
    IBidRepository BidRepository { get; }
    IImageRepository ImageRepository { get; }
    IVariableRepository VariableRepository { get; }
    IInvoiceRepository InvoiceRepository { get; }
  }
}