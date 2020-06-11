using System;
using System.Reflection;
namespace SmartQuant
{
	public class InstrumentStrategy : Strategy
	{
		internal Instrument instrument;
		private Strategy strategy_;
		public Instrument Instrument
		{
			get
			{
				return this.instrument;
			}
		}
		public Position Position
		{
			get
			{
				return this.portfolio.GetPosition(this.instrument);
			}
		}
		public InstrumentStrategy(Framework framework, string name) : base(framework, name)
		{
			this.raiseEvents = false;
		}
		internal override void OnStrategyStart_()
		{
			this.status = StrategyStatus.Running;
			foreach (Instrument current in base.Instruments)
			{
				InstrumentStrategy instrumentStrategy = (InstrumentStrategy)Activator.CreateInstance(base.GetType(), new object[]
				{
					this.framework,
					base.Name + " (" + current.symbol + ")"
				});
				instrumentStrategy.instrument = current;
				instrumentStrategy.instruments.Add(current);
				instrumentStrategy.raiseEvents = true;
				instrumentStrategy.dataProvider = base.DataProvider;
				instrumentStrategy.executionProvider = base.ExecutionProvider;
				base.AddStrategy(instrumentStrategy, false);
				FieldInfo[] fields = instrumentStrategy.GetType().GetFields(BindingFlags.Instance | BindingFlags.Public | BindingFlags.NonPublic);
				for (int i = 0; i < fields.Length; i++)
				{
					FieldInfo fieldInfo = fields[i];
					if (fieldInfo.GetCustomAttributes(typeof(ParameterAttribute), true).Length > 0)
					{
						fieldInfo.SetValue(instrumentStrategy, fieldInfo.GetValue(this));
					}
				}
				if (this.strategies.Count == 1)
				{
					this.bars = instrumentStrategy.bars;
					this.equity = instrumentStrategy.equity;
				}
				instrumentStrategy.OnStrategyStart();
			}
		}
		private void Add(InstrumentStrategy strategy)
		{
			base.AddStrategy(strategy, false);
		}
		public void AddInstance(Instrument instrument, InstrumentStrategy strategy)
		{
			strategy.instruments.Add(instrument);
			strategy.instrument = instrument;
			strategy.raiseEvents = true;
			strategy.dataProvider = this.dataProvider;
			strategy.executionProvider = this.executionProvider;
			this.Add(strategy);
			if (base.Instruments.GetById(instrument.id) == null)
			{
				base.Instruments.Add(instrument);
			}
			strategy.status = StrategyStatus.Running;
			strategy.OnStrategyStart();
		}
	}
}
