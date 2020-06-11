using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Text;
using System.Threading.Tasks;
using LiteDispatch.Core.DTOs;
using LiteTracker.UI.DataModel;
using Newtonsoft.Json;

namespace LiteTracker.UI.Services
{
  internal class TrackingServices
  {

    public async Task<IEnumerable<DispatchNoteSummary>> GetDispatchNotes()
    {
      const string uriString = @"http://litedispatch.azurewebsites.net/api/tracking/ActiveDispatchNotes";
      var dispatchNoteSummaries = new List<DispatchNoteSummary>();
      using (var client = new HttpClient())
      {
        using (var response = await client.GetAsync(uriString))
        {
          if (response.IsSuccessStatusCode)
          {
            var result = await response.Content.ReadAsStringAsync();
            var dispatches = JsonConvert.DeserializeObject<List<DispatchNoteDto>>(result);
            dispatches = dispatches.OrderByDescending(d => d.LastUpdate).ToList();

            foreach (var dispatchNoteDto in dispatches)
            {
              dispatchNoteSummaries.Add(DispatchNoteSummary.Create(dispatchNoteDto));
            }
          }
        }
      }
      return dispatchNoteSummaries;
    }
  }
}
