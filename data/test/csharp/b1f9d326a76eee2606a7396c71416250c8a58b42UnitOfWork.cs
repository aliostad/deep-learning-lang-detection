using System;
using Economic.DAL.Implementations;
using Economic.DAL.Interfaces;
using Economic.EntityModel;

namespace Economic.DAL
{
    public class UnitOfWork : IDisposable
    {
        private readonly Entities _context;
        private IClientgroupsRepository _clientgroupRepository;
        private IGoodtypesRepository _goodTypesRepository;
        private IGoodsRepository _goodsRepository;
        private IPricehierarhyRepository _pricehierarhyRepository;
        private ISimplepricelistRepository _simplePriceListsRepository;
        private IEnteranceRepository _enteranceRepository;
        private IEnteranceItemsRepository _enteranceItemsRepository;
        private IUsersRepository _usersRepository;
        private IMarketingChangesRepository _marketingchangesRepository;

        public UnitOfWork()
        {
            _context = new Entities();
        }

        public UnitOfWork(Entities context)
        {
            _context = context; 
        }

        virtual public IClientgroupsRepository ClientgroupRepository => _clientgroupRepository ?? (_clientgroupRepository = new ClientgroupsRepository(_context));

        virtual public IGoodtypesRepository GoodTypesRepository => _goodTypesRepository ?? (_goodTypesRepository = new GoodtypesRepository(_context));

        virtual public IGoodsRepository GoodsRepository => _goodsRepository ?? (_goodsRepository = new GoodsRepository(_context));

        virtual public IPricehierarhyRepository PricehierarhyRepository => _pricehierarhyRepository ?? (_pricehierarhyRepository = new PricehierarhyRepository(_context));

        virtual public ISimplepricelistRepository SimplePriceListsRepository => _simplePriceListsRepository ?? (_simplePriceListsRepository = new SimplepricelistRepository(_context));

        virtual public IEnteranceRepository EnteranceRepository => _enteranceRepository ?? (_enteranceRepository = new EnteranceRepository(_context));

        virtual public IEnteranceItemsRepository EnteranceItemsRepository => _enteranceItemsRepository ?? (_enteranceItemsRepository = new EnteranceItemsRepository(_context));

        virtual public IUsersRepository UsersRepository => _usersRepository ?? (_usersRepository = new UsersRepository(_context));

        virtual public IMarketingChangesRepository MarketingChangesRepository => _marketingchangesRepository ?? (_marketingchangesRepository = new MarketingChangesRepository(_context));

        public void Dispose()
        {
            _context.Dispose();
        }
    }
}
