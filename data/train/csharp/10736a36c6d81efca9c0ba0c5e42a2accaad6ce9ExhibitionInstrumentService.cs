#region Using
using System;
using System.Collections.Generic;
using System.Text;
using System.Data;
#endregion Using

namespace CY.CSTS.Core.Services.DALService
{
	internal sealed class ExhibitionInstrumentService
	{
		#region Constructor

		static ExhibitionInstrumentService()
		{
			LoadProvider();
		}

		#endregion Constructor

		#region Provider model

		private static volatile Providers.DALProvider.IExhibitionInstrumentProvider provider;
		private static object syncLock = new object();

		private static void LoadProvider()
		{
			if (provider == null)
			{
				lock (syncLock)
				{
					if (provider == null)
					{
						string path = CY.CSTS.Configuration.ConfigurationManager.Providers.DALProviders.Default.Path;
						string className = CY.CSTS.Configuration.ConfigurationManager.Providers.DALProviders.Default.Namespace + ".ExhibitionInstrumentProvider";
						provider = System.Reflection.Assembly.Load(path).CreateInstance(className) as Providers.DALProvider.IExhibitionInstrumentProvider;
					}
				}
			}
		}

		#endregion Provider model

		public static Business.ExhibitionInstrument Select(Guid id)
		{
			return provider.Select(id);
		}

		public static void Update(Business.ExhibitionInstrument exhibitionInstrument)
		{
			provider.Update(exhibitionInstrument);
		}

		public static void Delete(Business.ExhibitionInstrument exhibitionInstrument)
		{
			provider.Delete(exhibitionInstrument);
		}

		public static void Insert(Business.ExhibitionInstrument exhibitionInstrument)
		{
			provider.Insert(exhibitionInstrument);
		}

        public static IList<Core.Business.ExhibitionInstrument> GetAllExhibitionInstrument(string strWhere)
		{
			return provider.GetAllExhibitionInstrument(strWhere);
		}

        public static IList<Core.Business.ExhibitionInstrument> GetExhibitionInstrumentByPage(string sqlwhere, int pagenumber, int pagesize)
        {
            return provider.GetExhibitionInstrumentByPage(sqlwhere, pagenumber, pagesize);
        }
        public static IList<Core.Business.ExhibitionInstrument> GetExhibitionInstrumentTopBySequenceNumber(int num)
        {
            return provider.GetExhibitionInstrumentTopBySequenceNumber(num);
        }
	}
}
