using System.Net;
using Newtonsoft.Json;

namespace LiteDispatch.Web.BusinessAdapters
{
  using System;
  using System.Collections.Generic;
  using System.Linq;
  using AutoMapper;
  using Core.DTOs;
  using Domain.Entities;
  using Domain.Repository;

  public class TrackingAdapter : BaseAdapter
  {
    public TrackingResponseDto CreateTrackingNotification(TrackingNotificationDto dto)
    {
      return ExecuteCommand(locator => CreateTrackingNotificationImpl(locator, dto));
    }

    private TrackingResponseDto CreateTrackingNotificationImpl(IRepositoryLocator locator, TrackingNotificationDto dto)
    {
      var response = new TrackingResponseDto
        {
          Accepted = false,
          NotificationId = dto.Id,
          DispatchNoteId = 0,
          Error = string.Empty
        };

      // see if we can fetch dispatch note
      var dispatchNote =
        locator.FindAll<DispatchNote>()
               .FirstOrDefault(d => d.TruckReg.Equals(dto.TruckRegistration, StringComparison.InvariantCultureIgnoreCase));

      if (dispatchNote == null)
      {
        response.Error = "DispatchNote was not found with Truck Registration: " + dto.TruckRegistration;
        return response;
      }
      
      response.DispatchNoteId = dispatchNote.Id;      

      // dispatch found and it is valid
      response = dispatchNote.CreateTrackingNotification(locator, dto, response);
      if (response.Accepted)
      {
        var dispatchEvent = Mapper.Map<DispatchEventBase>(dispatchNote);
        CreateDispatchEvent(dispatchEvent);
      }
      return response;
    }

    public List<DispatchNoteDto> GetActiveDispatchNotes()
    {
      return ExecuteCommand(GetActiveDispatchNotesImpl);
    }

    private List<DispatchNoteDto> GetActiveDispatchNotesImpl(IRepositoryLocator locator)
    {
      var results = locator.FindAll<DispatchNote>()
                    .Where(
                      d =>
                      d.DispatchNoteStatus.Equals(DispatchNote.New) ||
                      d.DispatchNoteStatus.Equals(DispatchNote.InTransit)).ToList();

      return Mapper.Map<List<DispatchNoteDto>>(results);
    }

    private void CreateDispatchEvent(DispatchEventBase dispatchEvent)
    {
      using (var client = new WebClient())
      {
        client.Headers[HttpRequestHeader.ContentType] = "application/json";
        client.Headers.Add("X-ZUMO-APPLICATION", "xJJfEdiYjrioWvkvaQoUgRtlTUpyBp52");
        client.BaseAddress = @"https://litetracker.azure-mobile.net/";

        var json = JsonConvert.SerializeObject(dispatchEvent);
        var result = client.UploadString(GetDispatchEventUri(), "POST", json);
        var dto = JsonConvert.DeserializeObject<DispatchEvent>(result);
      }
    }

    private string GetDispatchEventUri()
    {
      return "tables/DispatchEvent";
    }

  }
}