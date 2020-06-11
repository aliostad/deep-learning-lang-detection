using Bakery.Processes;
using Bakery.Processes.Specification;
using Bakery.Processes.Specification.Builder;
using System;
using System.Threading.Tasks;

public static class ProcessFactoryExtensions
{
	public static async Task<IProcess> RunAsync(this IProcessFactory processFactory, IProcessSpecification processSpecification)
	{
		return await processFactory.RunAsync(processSpecification, TimeSpan.FromMinutes(1));
	}

	public static async Task<IProcess> RunAsync(this IProcessFactory processFactory, Func<IProcessSpecificationBuilder, IProcessSpecification> processSpecificationBuilder)
	{
		var processSpecification = processSpecificationBuilder(ProcessSpecificationBuilder.Create());

		return await processFactory.RunAsync(processSpecification);
	}

	public static async Task<IProcess> RunAsync(this IProcessFactory processFactory, IProcessSpecification processSpecification, TimeSpan timeout)
	{
		var process = processFactory.Start(processSpecification);

		await process.WaitForExit(timeout);

		return process;
	}

	public static IStartedProcess Start(this IProcessFactory processFactory, Func<IProcessSpecificationBuilder, IProcessSpecification> processSpecificationBuilder)
	{
		var processSpecification = processSpecificationBuilder(ProcessSpecificationBuilder.Create());

		return processFactory.Start(processSpecification);
	}
}
