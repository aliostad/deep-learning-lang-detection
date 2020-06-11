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
    IBidRepository BidRepository { get; }
    IDifferentRepository DifferentRepository { get; }    
    IInvoiceRepository InvoiceRepository { get; }
  }
}