using System;
using System.Collections.Generic;
using System.Reflection;
namespace SmartQuant
{
	public class SellSideInstrumentStrategy : SellSideStrategy
	{
		private IdArray<List<SellSideInstrumentStrategy>> strategyByInstrument;
		private IdArray<SellSideInstrumentStrategy> strategyByPortfolio;
		private IdArray<SellSideInstrumentStrategy> strategyBySynthInstrument;
		private new List<Strategy> strategies;
		protected Instrument Instrument;
		public IdArray<SellSideInstrumentStrategy> StrategyByInstrument
		{
			get
			{
				return this.strategyBySynthInstrument;
			}
		}
		public SellSideInstrumentStrategy(Framework framework, string name) : base(framework, name)
		{
			this.raiseEvents = false;
			this.strategyByInstrument = new IdArray<List<SellSideInstrumentStrategy>>(1000);
			this.strategyByPortfolio = new IdArray<SellSideInstrumentStrategy>(1000);
			this.strategyBySynthInstrument = new IdArray<SellSideInstrumentStrategy>(1000);
			this.strategies = new List<Strategy>();
		}
		public override void Subscribe(InstrumentList instruments)
		{
			foreach (Instrument current in instruments)
			{
				this.Subscribe(current);
			}
		}
		public override void Subscribe(Instrument instrument)
		{
			if (instrument.Parent != null)
			{
				this.strategyBySynthInstrument[instrument.Id] = this.strategyBySynthInstrument[instrument.Parent.Id];
				this.strategyBySynthInstrument[instrument.Id].OnSubscribe(instrument);
				return;
			}
			SellSideInstrumentStrategy sellSideInstrumentStrategy = (SellSideInstrumentStrategy)Activator.CreateInstance(base.GetType(), new object[]
			{
				this.framework,
				string.Concat(new object[]
				{
					base.Name,
					"(",
					instrument,
					")"
				})
			});
			this.SetupStrategy(sellSideInstrumentStrategy);
			sellSideInstrumentStrategy.Instrument = instrument;
			this.strategyBySynthInstrument[instrument.Id] = sellSideInstrumentStrategy;
			sellSideInstrumentStrategy.OnSubscribe(instrument);
			sellSideInstrumentStrategy.dataProvider = base.DataProvider;
			sellSideInstrumentStrategy.executionProvider = base.ExecutionProvider;
			sellSideInstrumentStrategy.raiseEvents = true;
			base.AddStrategy(sellSideInstrumentStrategy, false);
			sellSideInstrumentStrategy.OnStrategyStart();
		}
		public override void Unsubscribe(Instrument instrument)
		{
			if (instrument.Parent != null)
			{
				this.strategyBySynthInstrument[instrument.Id].OnUnsubscribe(instrument);
				this.strategyBySynthInstrument.Remove(instrument.Id);
			}
		}
		public override void Send(ExecutionCommand command)
		{
			SellSideStrategy sellSideStrategy = this.strategyBySynthInstrument[command.order.instrument.Id];
			switch (command.Type)
			{
			case ExecutionCommandType.Send:
				sellSideStrategy.OnSendCommand(command);
				return;
			case ExecutionCommandType.Cancel:
				sellSideStrategy.OnCancelCommand(command);
				return;
			case ExecutionCommandType.Replace:
				sellSideStrategy.OnReplaceCommand(command);
				return;
			default:
				return;
			}
		}
		public override void Unsubscribe(InstrumentList instruments)
		{
			foreach (Instrument current in instruments)
			{
				SellSideInstrumentStrategy sellSideInstrumentStrategy = this.strategyBySynthInstrument[current.Id];
				sellSideInstrumentStrategy.OnUnsubscribe(current);
			}
		}
		private void SetupStrategy(SellSideInstrumentStrategy strategy)
		{
			FieldInfo[] fields = strategy.GetType().GetFields(BindingFlags.Instance | BindingFlags.Public | BindingFlags.NonPublic);
			for (int i = 0; i < fields.Length; i++)
			{
				FieldInfo fieldInfo = fields[i];
				if (fieldInfo.GetCustomAttributes(typeof(ParameterAttribute), true).Length > 0)
				{
					fieldInfo.SetValue(strategy, fieldInfo.GetValue(this));
				}
			}
		}
	}
}
