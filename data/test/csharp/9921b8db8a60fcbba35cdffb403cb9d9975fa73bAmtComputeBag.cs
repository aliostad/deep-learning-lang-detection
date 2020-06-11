using System;
namespace Magnesium.Metal
{
	public class AmtComputeBag
	{
		public AmtComputeBag()
		{
			Pipelines = new AmtEncoderItemCollection<AmtComputePipeline>();
			Dispatch = new AmtEncoderItemCollection<AmtDispatchRecord>();
			DispatchIndirect = new AmtEncoderItemCollection<AmtDispatchIndirectRecord>();
		}

		public void Clear()
		{
			Pipelines.Clear();
			Dispatch.Clear();
			DispatchIndirect.Clear();
		}

		public AmtEncoderItemCollection<AmtComputePipeline> Pipelines { get; private set;}
		public AmtEncoderItemCollection<AmtDispatchRecord> Dispatch { get; private set;}
		public AmtEncoderItemCollection<AmtDispatchIndirectRecord> DispatchIndirect { get; private set; }
	}
}
