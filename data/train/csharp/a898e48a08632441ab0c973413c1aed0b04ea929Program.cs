using System;
using System.Collections.Generic;
using Common.DTO;
using WebApiClient;
using WebApiClient.Controllers;

namespace Rest4WebApi
{
	class Program
	{
		static void Main(string[] args)
		{
			//Versions API usage example
			WebApiConnection.GetApi<ClientVersionApi>().GetClientVersions();
			WebApiConnection.GetApi<ClientVersionApi>().DownloadVersion("Test_name");
			WebApiConnection.GetApi<ClientVersionApi>().DeleteVersion("Test_name");

			//Task API usage example
			WebApiConnection.GetApi<TaskApi>().CreateTask(
				new TaskDto
				{
					Guid = Guid.NewGuid(),
					CreationTime = DateTime.UtcNow,
					AssignedDevices = new List<int>()
				});

			WebApiConnection.GetApi<TaskApi>().GetAllTasks();
		}
	}
}
