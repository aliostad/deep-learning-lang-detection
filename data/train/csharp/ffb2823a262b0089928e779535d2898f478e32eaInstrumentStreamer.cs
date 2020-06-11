using System;
using System.IO;
namespace SmartQuant
{
	public class InstrumentStreamer : ObjectStreamer
	{
		public InstrumentStreamer()
		{
			this.typeId = 100;
			this.type = typeof(Instrument);
		}
		public override object Read(BinaryReader reader)
		{
			reader.ReadByte();
			int id = reader.ReadInt32();
			InstrumentType type = (InstrumentType)reader.ReadByte();
			string symbol = reader.ReadString();
			string description = reader.ReadString();
			byte currencyId = reader.ReadByte();
			string exchange = reader.ReadString();
			Instrument instrument = new Instrument(id, type, symbol, description, currencyId, exchange);
			instrument.tickSize = reader.ReadDouble();
			instrument.maturity = new DateTime(reader.ReadInt64());
			instrument.factor = reader.ReadDouble();
			instrument.strike = reader.ReadDouble();
			instrument.putcall = (PutCall)reader.ReadByte();
			instrument.margin = reader.ReadDouble();
			int num = reader.ReadInt32();
			for (int i = 0; i < num; i++)
			{
				AltId altId = new AltId();
				altId.providerId = reader.ReadByte();
				altId.symbol = reader.ReadString();
				altId.exchange = reader.ReadString();
				instrument.altId.Add(altId);
			}
			return instrument;
		}
		public override void Write(BinaryWriter writer, object obj)
		{
			byte value = 0;
			writer.Write(value);
			Instrument instrument = obj as Instrument;
			writer.Write(instrument.id);
			writer.Write((byte)instrument.type);
			writer.Write(instrument.symbol);
			writer.Write(instrument.description);
			writer.Write(instrument.currencyId);
			writer.Write(instrument.exchange);
			writer.Write(instrument.tickSize);
			writer.Write(instrument.maturity.Ticks);
			writer.Write(instrument.factor);
			writer.Write(instrument.strike);
			writer.Write((byte)instrument.putcall);
			writer.Write(instrument.margin);
			writer.Write(instrument.altId.Count);
			foreach (AltId current in instrument.altId)
			{
				writer.Write(current.providerId);
				writer.Write(current.symbol);
				writer.Write(current.exchange);
			}
		}
	}
}
