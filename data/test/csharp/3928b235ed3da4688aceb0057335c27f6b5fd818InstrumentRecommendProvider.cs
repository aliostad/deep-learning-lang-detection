#region Using
using System;
using System.Collections.Generic;
using System.Text;
using System.Data;
using System.Data.SqlClient;
using CY.CSTS.Core.Business;
using CY.Utility.DBUtility;
#endregion Using

namespace CY.CSTS.DALProviders.SqlServerProvider
{
	public class InstrumentRecommendProvider : CY.CSTS.Core.Providers.DALProvider.IInstrumentRecommendProvider
	{
		#region Sql
		private static readonly string SqlSelectInstrumentRecommend = "SELECT [Id], [Autor],[RecommendDate],[Commend] FROM [InstrumentRecommend] WHERE  [Id]=@Id";

		private static readonly string SqlInsertInstrumentRecommend = "INSERT INTO [InstrumentRecommend]([Autor],[RecommendDate],[Commend]) values(@Autor,@RecommendDate,@Commend);SELECT SCOPE_IDENTITY();";

		private static readonly string SqlUpdateInstrumentRecommend = "UPDATE [InstrumentRecommend] SET [Autor] = @Autor,[RecommendDate] = @RecommendDate,[Commend] = @Commend WHERE  [Id]=@Id";

		private static readonly string SqlDeleteInstrumentRecommend = "DELETE [InstrumentRecommend] WHERE  [Id]=@Id";

		private static readonly string SqlGetAllInstrumentRecommend = "SELECT [Id], [Autor],[RecommendDate],[Commend] FROM [InstrumentRecommend]";
		#endregion

		#region IInstrumentRecommendProvider Members
		public Core.Business.InstrumentRecommend Select(Guid id)
		{
			SqlServerUtility sql = new SqlServerUtility();

			sql.AddParameter("@Id", SqlDbType.UniqueIdentifier, id);
			SqlDataReader reader = sql.ExecuteSqlReader(SqlSelectInstrumentRecommend);

			if (reader != null && !reader.IsClosed && reader.Read())
			{
				Core.Business.InstrumentRecommend instrumentRecommend = new Core.Business.InstrumentRecommend();

				if (!reader.IsDBNull(0)) instrumentRecommend.Id = reader.GetGuid(0);
				if (!reader.IsDBNull(1)) instrumentRecommend.Autor = reader.GetGuid(1);
				if (!reader.IsDBNull(2)) instrumentRecommend.RecommendDate = reader.GetDateTime(2);
				if (!reader.IsDBNull(3)) instrumentRecommend.Commend = reader.GetString(3);

				reader.Close();
				return instrumentRecommend;
			}
			else
			{
				if (reader != null && !reader.IsClosed)
					reader.Close();

				return null;
			}
		}

		public void Insert(Core.Business.InstrumentRecommend instrumentRecommend)
		{
			SqlServerUtility sql = new SqlServerUtility();

			sql.AddParameter("@Autor", SqlDbType.UniqueIdentifier, instrumentRecommend.Autor);
			sql.AddParameter("@RecommendDate", SqlDbType.DateTime, instrumentRecommend.RecommendDate);
			sql.AddParameter("@Commend", SqlDbType.NVarChar, instrumentRecommend.Commend);
			SqlDataReader reader = sql.ExecuteSqlReader(SqlInsertInstrumentRecommend);

			if (reader != null && !reader.IsClosed && reader.Read())
			{
				if (!reader.IsDBNull(0)) instrumentRecommend.Id = reader.GetGuid(0);

				reader.Close();
			}
			else
			{
				if (reader != null && !reader.IsClosed)
					reader.Close();
			}
		}

		public void Update(Core.Business.InstrumentRecommend instrumentRecommend)
		{
			SqlServerUtility sql = new SqlServerUtility();

			sql.AddParameter("@Autor", SqlDbType.UniqueIdentifier, instrumentRecommend.Autor);
			sql.AddParameter("@RecommendDate", SqlDbType.DateTime, instrumentRecommend.RecommendDate);
			sql.AddParameter("@Commend", SqlDbType.NVarChar, instrumentRecommend.Commend);
			sql.AddParameter("@Id", SqlDbType.UniqueIdentifier, instrumentRecommend.Id);
			sql.ExecuteSql(SqlUpdateInstrumentRecommend);
		}

		public void Delete(Core.Business.InstrumentRecommend instrumentRecommend)
		{
			SqlServerUtility sql = new SqlServerUtility();

			sql.AddParameter("@Id", SqlDbType.UniqueIdentifier, instrumentRecommend.Id);
			sql.ExecuteSql(SqlDeleteInstrumentRecommend);
		}

		public IList<Core.Business.InstrumentRecommend> GetAllInstrumentRecommend()
		{
			IList<Core.Business.InstrumentRecommend> instrumentRecommendlist = new List<Core.Business.InstrumentRecommend>();
			SqlServerUtility sql = new SqlServerUtility();

			SqlDataReader reader = sql.ExecuteSqlReader(SqlGetAllInstrumentRecommend);

			if(reader != null)
			{
				while(reader.Read())
				{
					Core.Business.InstrumentRecommend instrumentRecommend = new Core.Business.InstrumentRecommend();

					if (!reader.IsDBNull(0)) instrumentRecommend.Id = reader.GetGuid(0);
					if (!reader.IsDBNull(1)) instrumentRecommend.Autor = reader.GetGuid(1);
					if (!reader.IsDBNull(2)) instrumentRecommend.RecommendDate = reader.GetDateTime(2);
					if (!reader.IsDBNull(3)) instrumentRecommend.Commend = reader.GetString(3);

					instrumentRecommend.MarkOld();
					instrumentRecommendlist.Add(instrumentRecommend);
				}
				reader.Close();
			}
			return instrumentRecommendlist;
		}
		#endregion
	}
}
