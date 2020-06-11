
using Sinoze.Engine;

[Module]
public sealed partial class SinozeAssetLoader : AdaptableService
{
	public LoadJob Load(LoadInstruction instruction)
	{
		// do load via adaptor
		var loadJob = (LoadJob)InvokeAdaptor("Load", instruction);
		this.EnqueueJob(loadJob);
		return loadJob;
	}

	// api to load multiple items
	public LoadJobCollection Load(LoadInstructionCollection instructions)
	{
		var result = new LoadJobCollection();
		foreach(var inst in instructions)
		{
			var loadJob = this.Load(inst);
			loadJob.ParentCollection = result;
			result.Add(loadJob);
		}
		return result;
	}
}