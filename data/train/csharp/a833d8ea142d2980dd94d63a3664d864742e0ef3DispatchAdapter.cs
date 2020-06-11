using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace LiteDispatch.Web.BusinessAdapters
{
  using AutoMapper;
  using Domain.Entities;
  using Domain.Models;
  using Domain.Repository;

  public class DispatchAdapter : BaseAdapter
  {
    public DispatchNoteModel GetDispathNoteById(long id)
    {
      return ExecuteCommand(locator => GetDispathNoteByIdImpl(locator, id));
    }

    private DispatchNoteModel GetDispathNoteByIdImpl(IRepositoryLocator locator, long id)
    {
      var instance = locator.GetById<DispatchNote>(id);
      return Mapper.Map<DispatchNote, DispatchNoteModel>(instance);
    }

    public IEnumerable<DispatchNoteModel> GetAllDispatches()
    {
      return ExecuteCommand(GetAllDispatchesImpl);
    }

    private IEnumerable<DispatchNoteModel> GetAllDispatchesImpl(IRepositoryLocator locator)
    {
      var instances = locator.FindAll<DispatchNote>().ToList();
      return Mapper.Map<List<DispatchNote>, List<DispatchNoteModel>>(instances);
    }

    public DispatchNoteModel SaveDispatch(DispatchNoteModel dispatchModel)
    {
      return ExecuteCommand(locator => SaveDispatchImpl(locator, dispatchModel));
    }

    private DispatchNoteModel SaveDispatchImpl(IRepositoryLocator locator, DispatchNoteModel dispatchModel)
    {
      var entity = DispatchNote.Create(locator, dispatchModel);
      locator.FlushModifications(); // need to flush in order to get the Id into the DTO
      return Mapper.Map<DispatchNote, DispatchNoteModel>(entity);
    }

    public DispatchNoteModel GetLastDispatch()
    {
      return ExecuteCommand(GetLastDispatchImpl);
    }
      
    private DispatchNoteModel GetLastDispatchImpl(IRepositoryLocator locator)
    {
      var entity = locator.FindAll<DispatchNote>().OrderByDescending(d => d.CreationDate).FirstOrDefault();
      return Mapper.Map<DispatchNote, DispatchNoteModel>(entity);
    }

    public List<DispatchNoteModel> GetDispatchesBetweenDates(DateTime startDate, DateTime endDate)
    {
      return ExecuteCommand(locator => GetDispatchesBetweenDatesImpl(locator, startDate, endDate));
    }

    private List<DispatchNoteModel> GetDispatchesBetweenDatesImpl(IRepositoryLocator locator, DateTime startDate, DateTime endDate)
    {
      var dispatches = locator.FindAll<DispatchNote>().Where(d => d.CreationDate >= startDate && d.CreationDate <= endDate).ToList();
      return Mapper.Map<List<DispatchNote>, List<DispatchNoteModel>>(dispatches);
    }
  }
}