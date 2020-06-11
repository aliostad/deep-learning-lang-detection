using System;
using System.Collections.Generic;
namespace SmartQuant
{
	public class SubscriptionManager
	{
		private Framework framework;
		private Dictionary<int, Dictionary<Instrument, int>> subscriptions;
		public SubscriptionManager(Framework framework)
		{
			this.framework = framework;
			this.subscriptions = new Dictionary<int, Dictionary<Instrument, int>>();
		}
		public void Subscribe(int providerId, Instrument instrument)
		{
			IDataProvider provider = this.framework.ProviderManager.GetProvider(providerId) as IDataProvider;
			this.Subscribe(provider, instrument);
		}
		public void Subscribe(IDataProvider provider, Instrument instrument)
		{
			if (provider.Status != ProviderStatus.Connected)
			{
				provider.Connect();
			}
			Dictionary<Instrument, int> dictionary = null;
			if (!this.subscriptions.TryGetValue((int)provider.Id, out dictionary))
			{
				dictionary = new Dictionary<Instrument, int>();
				this.subscriptions[(int)provider.Id] = dictionary;
			}
			int num = 0;
			bool flag = false;
			if (!dictionary.TryGetValue(instrument, out num))
			{
				flag = true;
				num = 1;
			}
			else
			{
				if (num == 0)
				{
					flag = true;
				}
				num++;
			}
			dictionary[instrument] = num;
			if (flag)
			{
				provider.Subscribe(instrument);
			}
		}
		public void Unsubscribe(int providerId, Instrument instrument)
		{
			IDataProvider provider = this.framework.ProviderManager.GetProvider(providerId) as IDataProvider;
			this.Unsubscribe(provider, instrument);
		}
		public void Unsubscribe(IDataProvider provider, Instrument instrument)
		{
			Dictionary<Instrument, int> dictionary;
			(dictionary = this.subscriptions[(int)provider.Id])[instrument] = dictionary[instrument] - 1;
			if (this.subscriptions[(int)provider.Id][instrument] == 0)
			{
				provider.Unsubscribe(instrument);
			}
		}
		public void Subscribe(IDataProvider provider, InstrumentList instruments)
		{
			if (provider.Status != ProviderStatus.Connected)
			{
				provider.Connect();
			}
			InstrumentList instrumentList = new InstrumentList();
			for (int i = 0; i < instruments.Count; i++)
			{
				Instrument byIndex = instruments.GetByIndex(i);
				if (!this.subscriptions.ContainsKey((int)provider.Id))
				{
					this.subscriptions[(int)provider.Id] = new Dictionary<Instrument, int>();
				}
				if (!this.subscriptions[(int)provider.Id].ContainsKey(byIndex) || this.subscriptions[(int)provider.Id][byIndex] == 0)
				{
					this.subscriptions[(int)provider.Id][byIndex] = 0;
					instrumentList.Add(byIndex);
				}
				Dictionary<Instrument, int> dictionary;
				Instrument key;
				(dictionary = this.subscriptions[(int)provider.Id])[key = byIndex] = dictionary[key] + 1;
			}
			if (instrumentList.Count > 0)
			{
				provider.Subscribe(instrumentList);
			}
		}
		public void Unsubscribe(IDataProvider provider, InstrumentList instruments)
		{
			InstrumentList instrumentList = new InstrumentList();
			for (int i = 0; i < instruments.Count; i++)
			{
				Instrument byIndex = instruments.GetByIndex(i);
				Dictionary<Instrument, int> dictionary;
				Instrument key;
				(dictionary = this.subscriptions[(int)provider.Id])[key = byIndex] = dictionary[key] - 1;
				if (this.subscriptions[(int)provider.Id][byIndex] == 0)
				{
					instrumentList.Add(byIndex);
				}
			}
			provider.Unsubscribe(instrumentList);
		}
		public void Clear()
		{
			this.subscriptions.Clear();
		}
	}
}
