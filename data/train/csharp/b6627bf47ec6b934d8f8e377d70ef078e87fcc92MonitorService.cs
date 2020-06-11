using System;
using System.Linq;
using System.Threading.Tasks;
using RpcLite.Monitor.Contract;
using RpcLite.Monitor.Service.Dal;

namespace RpcLite.Monitor.Service
{
	public class MonitorService : IMonitorService
	{
		public async Task AddInvokesAsync(InvokeInfo[] invokes)
		{
			if (invokes?.Length == 0) return;
			try
			{
				using (var ctx = new ServiceDataContext())
				{
					var entities = invokes.Select(invoke => new Models.InvokeItem
					{
						//Id = invoke.Id,
						Service = invoke.Service,
						Action = invoke.Action,
						StartDate = invoke.StartDate,
						EndDate = invoke.EndDate,
						Duration = invoke.Duration,
					});
					ctx.Invoke.AddRange(entities);
					await ctx.SaveChangesAsync();
				}
			}
			catch (Exception ex)
			{
				Console.WriteLine(ex);
				throw;
			}
		}

	}
}
