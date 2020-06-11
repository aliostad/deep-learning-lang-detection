using FreeQuant;
using FreeQuant.FIX;
using System;
using System.IO;
using System.Collections;

namespace FreeQuant.Instruments
{
	public class InstrumentManager
	{
		private static Hashtable instrumentLists;

		public static InstrumentList Instruments { get; private set; }
		public static IInstrumentServer Server { get; set; }
		
        public static event InstrumentEventHandler InstrumentAdded;
		public static event InstrumentEventHandler InstrumentRemoved;

		static InstrumentManager()
		{
			InstrumentManager.Server = new InstrumentDbServer();
            Type connectionType = null;
			string connectionString = String.Empty;
			switch (Framework.Storage.ServerType)
			{
                case DbServerType.MYSQL:
                    connectionType = Type.GetType("MySqlConnection");
                    connectionString = string.Format("Server={0};Database={1};Uid={2};Pwd={3}", "localhost", "freequant", "freequant", "freequant");
                    break;
                case DbServerType.SQLITE:
                    connectionType = Type.GetType("SQLiteConnection");
                    connectionString = string.Format("Data Source={0};Pooling=true;FailIfMissing=false;", Path.Combine(Framework.Installation.DataDir.FullName, "freequant.db"));
                    break;
                default:
                    throw new NotSupportedException("This db is not support yet.");
			}

            InstrumentManager.Server = null;
            InstrumentManager.Server = new InstrumentFileServer();
			InstrumentManager.Server.Open(connectionType, connectionString);
            InstrumentManager.Instruments = InstrumentManager.Server.Load();
//            foreach (Instrument instrument in InstrumentManager.Server.Load())
//            {
//                InstrumentManager.Instruments.Add(instrument);
//            }

            InstrumentManager.instrumentLists = new Hashtable();
		}

		public static void Init()
		{
		}

		public static void Remove(Instrument instrument)
		{
			InstrumentManager.Server.Remove(instrument);
			InstrumentManager.Instruments.Remove(instrument);
			if (InstrumentManager.InstrumentRemoved == null)
				return;
			InstrumentManager.InstrumentRemoved(new InstrumentEventArgs(instrument));
		}

		public static void Remove(string symbol)
		{
			var instrument = InstrumentManager.Instruments[symbol];
			if (instrument == null)
				return;
			InstrumentManager.Remove(instrument);
		}

		public static void AddList(InstrumentList list)
		{
			if (InstrumentManager.instrumentLists.Contains(list.Name))
				InstrumentManager.RemoveList(list.Name);
			InstrumentManager.instrumentLists.Add(list.Name, list);
		}

		public static void RemoveList(string name)
		{
			InstrumentManager.instrumentLists.Remove(name);
		}

		public static InstrumentList GetList(string name)
		{
			return InstrumentManager.instrumentLists[name] as InstrumentList;
		}

		internal static void Add(Instrument instrument)
		{
			InstrumentManager.Instruments.Add(instrument);
			if (InstrumentManager.InstrumentAdded == null)
				return;
			InstrumentManager.InstrumentAdded(new InstrumentEventArgs(instrument));
		}

		internal static void Save(Instrument obj0)
		{
			InstrumentManager.Server.Save(obj0);
			if (InstrumentManager.Instruments.Contains(obj0.Id))
				return;
			InstrumentManager.Instruments.RegisterById(obj0);
		}
	}
}
