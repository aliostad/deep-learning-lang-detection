using System;
using SalesFiguresAPI.Models;
using DataAccess;
using AutoMapper;

namespace SalesFiguresAPI.Services
{
    public class OrderDispatchService : IOrderDispatchService
    {
        private readonly IOrderDispatchRepository repository;

        public OrderDispatchService(IOrderDispatchRepository repository)
        {
            this.repository = repository;
        }

        public DispatchInfoViewModel GetDispatchInformation()
        {
            return Mapper.Map<DispatchInfoViewModel>(this.repository.GetDispatchInformation());
        }
    }
}