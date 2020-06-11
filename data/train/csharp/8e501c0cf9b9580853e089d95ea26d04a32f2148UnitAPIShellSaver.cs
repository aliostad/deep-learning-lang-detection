using System.Linq;
using System.Threading.Tasks;
using SQLite;

namespace UnitAnroidPrinterApp
{
    class UnitAPIShellSaver : UnitAPIShell
    {
        public UnitAPIShellSaver(string login, string pass) : base(login, pass) { }

        public void SaveLocalData(DispatchDB dispatch)
        {
            using (var _dataBase = new SQLiteConnection(_dbUnitAndroidPrinterAppCurrent))
            {
                _dataBase.InsertOrReplace(dispatch);
            }
        }

		public DispatchDB[] GetLocalData()
        {
            using (var dbConnection = new SQLiteConnection(_dbUnitAndroidPrinterAppCurrent))
            {
                return dbConnection.Table<DispatchDB>().Cast<DispatchDB>().ToArray();
            }
        }

        public void DeleteData(DispatchDB dispatch)
        {
            using(var dbConnection = new SQLiteConnection(_dbUnitAndroidPrinterAppCurrent))
            {
                dbConnection.Delete<DispatchDB>(dispatch.IdDevice);
            }
        }

        public void PushData(DispatchDB dispatch)
        {
            PushPrinterEntry(dispatch);
        }

        public async Task PushDataAsync(DispatchDB dispatch)
        {
            await PushPrinterEntryAsync(dispatch);
        }
    }

}