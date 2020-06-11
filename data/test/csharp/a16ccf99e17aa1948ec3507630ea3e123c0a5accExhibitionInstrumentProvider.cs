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
    public class ExhibitionInstrumentProvider : CY.CSTS.Core.Providers.DALProvider.IExhibitionInstrumentProvider
    {

        #region IExhibitionInstrumentProvider Members
        public Core.Business.ExhibitionInstrument Select(Guid id)
        {
            SqlServerUtility sql = new SqlServerUtility();

            sql.AddParameter("@Id", SqlDbType.UniqueIdentifier, id);
            SqlDataReader reader = sql.ExecuteSPReader("usp_SelectExhibitionInstrument");

            if (reader != null && !reader.IsClosed && reader.Read())
            {
                Core.Business.ExhibitionInstrument exhibitionInstrument = new Core.Business.ExhibitionInstrument();

                if (!reader.IsDBNull(0)) exhibitionInstrument.Id = reader.GetGuid(0);
                if (!reader.IsDBNull(1)) exhibitionInstrument.InstrumentID = reader.GetGuid(1);
                if (!reader.IsDBNull(2)) exhibitionInstrument.ExhibitionDate = reader.GetDateTime(2);
                if (!reader.IsDBNull(3)) exhibitionInstrument.SequenceNumber = reader.GetInt32(3);
                if (!reader.IsDBNull(4)) exhibitionInstrument.IsShowinHomePage = reader.GetInt32(4);

                reader.Close();
                return exhibitionInstrument;
            }
            else
            {
                if (reader != null && !reader.IsClosed)
                    reader.Close();

                return null;
            }
        }

        public void Insert(Core.Business.ExhibitionInstrument exhibitionInstrument)
        {
            SqlServerUtility sql = new SqlServerUtility();

            sql.AddParameter("@InstrumentID", SqlDbType.UniqueIdentifier, exhibitionInstrument.InstrumentID);
            sql.AddParameter("@ExhibitionDate", SqlDbType.DateTime, exhibitionInstrument.ExhibitionDate);
            sql.AddParameter("@SequenceNumber", SqlDbType.Int, exhibitionInstrument.SequenceNumber);
            sql.AddParameter("@IsShowinHomePage", SqlDbType.Int, exhibitionInstrument.IsShowinHomePage);
            sql.AddOutputParameter("@Id", SqlDbType.UniqueIdentifier);
            SqlDataReader reader = sql.ExecuteSPReader("usp_InsertExhibitionInstrument");

            if (reader != null && !reader.IsClosed && reader.Read())
            {
                if (!reader.IsDBNull(0)) exhibitionInstrument.Id = reader.GetGuid(0);

                reader.Close();
            }
            else
            {
                if (reader != null && !reader.IsClosed)
                    reader.Close();
            }
        }

        public void Update(Core.Business.ExhibitionInstrument exhibitionInstrument)
        {
            SqlServerUtility sql = new SqlServerUtility();

            sql.AddParameter("@InstrumentID", SqlDbType.UniqueIdentifier, exhibitionInstrument.InstrumentID);
            sql.AddParameter("@ExhibitionDate", SqlDbType.DateTime, exhibitionInstrument.ExhibitionDate);
            sql.AddParameter("@SequenceNumber", SqlDbType.Int, exhibitionInstrument.SequenceNumber);
            sql.AddParameter("@IsShowinHomePage", SqlDbType.Int, exhibitionInstrument.IsShowinHomePage);
            sql.AddParameter("@Id", SqlDbType.UniqueIdentifier, exhibitionInstrument.Id);
            sql.ExecuteSP("usp_UpdateExhibitionInstrument");
        }

        public void Delete(Core.Business.ExhibitionInstrument exhibitionInstrument)
        {
            SqlServerUtility sql = new SqlServerUtility();

            sql.AddParameter("@Id", SqlDbType.UniqueIdentifier, exhibitionInstrument.Id);
            sql.ExecuteSP("usp_DeleteExhibitionInstrument");
        }

        public IList<Core.Business.ExhibitionInstrument> GetAllExhibitionInstrument(string strWhere)
        {
            IList<Core.Business.ExhibitionInstrument> exhibitionInstrumentlist = new List<Core.Business.ExhibitionInstrument>();
            SqlServerUtility sql = new SqlServerUtility();
            string sqlSelAll = "SELECT ExhibitionInstrument.[Id],[InstrumentID],[ExhibitionDate],[SequenceNumber],[IsShowinHomePage]FROM [dbo].[ExhibitionInstrument]";
            sqlSelAll += strWhere;
            SqlDataReader reader = sql.ExecuteSqlReader(sqlSelAll);

            if (reader != null)
            {
                while (reader.Read())
                {
                    Core.Business.ExhibitionInstrument exhibitionInstrument = new Core.Business.ExhibitionInstrument();

                    if (!reader.IsDBNull(0)) exhibitionInstrument.Id = reader.GetGuid(0);
                    if (!reader.IsDBNull(1)) exhibitionInstrument.InstrumentID = reader.GetGuid(1);
                    if (!reader.IsDBNull(2)) exhibitionInstrument.ExhibitionDate = reader.GetDateTime(2);
                    if (!reader.IsDBNull(3)) exhibitionInstrument.SequenceNumber = reader.GetInt32(3);
                    if (!reader.IsDBNull(4)) exhibitionInstrument.IsShowinHomePage = reader.GetInt32(4);

                    exhibitionInstrument.MarkOld();
                    exhibitionInstrumentlist.Add(exhibitionInstrument);
                }
                reader.Close();
            }
            return exhibitionInstrumentlist;
        }

        public IList<Core.Business.ExhibitionInstrument> GetExhibitionInstrumentByPage(string sqlwhere, int pagenumber, int pagesize)
        {
            IList<Core.Business.ExhibitionInstrument> exhibitionInstrumentlist = new List<Core.Business.ExhibitionInstrument>();
            SqlServerUtility sql = new SqlServerUtility();
            sql.AddParameter("@Tables", SqlDbType.VarChar, "ExhibitionInstrument");
            sql.AddParameter("@PK", SqlDbType.VarChar, "Id");
            sql.AddParameter("@PageNumber", SqlDbType.Int, pagenumber);
            sql.AddParameter("@PageSize", SqlDbType.Int, pagesize);
            //sql.AddParameter("@LawSortID", SqlDbType.UniqueIdentifier, sortId);
            sql.AddParameter("@Filter", SqlDbType.VarChar, sqlwhere);
            SqlDataReader reader = sql.ExecuteSPReader("Paging_RowCount");
            if (reader != null)
            {
                while (reader.Read())
                {
                    Core.Business.ExhibitionInstrument exhibitionInstrument = new Core.Business.ExhibitionInstrument();

                    if (!reader.IsDBNull(0)) exhibitionInstrument.Id = reader.GetGuid(0);
                    if (!reader.IsDBNull(1)) exhibitionInstrument.InstrumentID = reader.GetGuid(1);
                    if (!reader.IsDBNull(2)) exhibitionInstrument.ExhibitionDate = reader.GetDateTime(2);
                    if (!reader.IsDBNull(3)) exhibitionInstrument.SequenceNumber = reader.GetInt32(3);
                    if (!reader.IsDBNull(4)) exhibitionInstrument.IsShowinHomePage = reader.GetInt32(4);
                    
                    exhibitionInstrument.MarkOld();
                    exhibitionInstrumentlist.Add(exhibitionInstrument);
                }
                reader.Close();
            }
            return exhibitionInstrumentlist;
        }

        public IList<Core.Business.ExhibitionInstrument> GetExhibitionInstrumentTopBySequenceNumber(int num)
        {
            IList<Core.Business.ExhibitionInstrument> exhibitionInstrumentlist = new List<Core.Business.ExhibitionInstrument>();
            SqlServerUtility sql = new SqlServerUtility();
            string sqlSelAll = "SELECT top "+num+" ExhibitionInstrument.[Id],[InstrumentID],[ExhibitionDate],[SequenceNumber],[IsShowinHomePage]FROM [dbo].[ExhibitionInstrument]";
            sqlSelAll += "order by SequenceNumber ASC";
            SqlDataReader reader = sql.ExecuteSqlReader(sqlSelAll);
            if (reader != null)
            {
                while (reader.Read())
                {
                    Core.Business.ExhibitionInstrument exhibitionInstrument = new Core.Business.ExhibitionInstrument();

                    if (!reader.IsDBNull(0)) exhibitionInstrument.Id = reader.GetGuid(0);
                    if (!reader.IsDBNull(1)) exhibitionInstrument.InstrumentID = reader.GetGuid(1);
                    if (!reader.IsDBNull(2)) exhibitionInstrument.ExhibitionDate = reader.GetDateTime(2);
                    if (!reader.IsDBNull(3)) exhibitionInstrument.SequenceNumber = reader.GetInt32(3);
                    if (!reader.IsDBNull(4)) exhibitionInstrument.IsShowinHomePage = reader.GetInt32(4);

                    exhibitionInstrument.MarkOld();
                    exhibitionInstrumentlist.Add(exhibitionInstrument);
                }
                reader.Close();
            }
            return exhibitionInstrumentlist;
        }
        #endregion
    }
}
