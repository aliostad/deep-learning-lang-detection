//===============================================================
// Filename: DispatchMediaTypes.cs
// Date: 01/01/07
// --------------------------------------------------------------
// Description:
//   DispatchMediaTypes class
// --------------------------------------------------------------
// Dependencies :
//   None
// --------------------------------------------------------------
// Original author: PRD 01/01/07
// Revision history:
//===============================================================

using System;
using System.Configuration;
using System.Collections.Generic;
using System.Text;
using System.Data;
using System.Data.Common;
using System.Data.SqlClient;
using NLog;

namespace Axiom.BusinessObjects
{
    public class DispatchMediaType
    {
        private static Logger logger = LogManager.GetCurrentClassLogger();

        private int             m_dispatchMediaTypeID;
        private string          m_mediaTypeName;

        #region GetSetVariables
        public int dispatchMediaTypeID
        {
            get { return m_dispatchMediaTypeID; }
        }
        public string mediaTypeName
        {
            get { return m_mediaTypeName; }
            set { m_mediaTypeName = value; }
        }
        #endregion

        //===============================================================
        // Function: DispatchMediaType (Constructor)
        //===============================================================
        public DispatchMediaType()
        {
            m_mediaTypeName = "";
        }

        //===============================================================
        // Function: DispatchMediaType (Constructor)
        //===============================================================
        public DispatchMediaType(int dispatchMediaTypeID)
        {
            m_dispatchMediaTypeID = dispatchMediaTypeID;

            ReadDispatchMediaTypeDetails();
        }

        //===============================================================
        // Function: ReadDispatchMediaTypeDetails
        //===============================================================
        public void ReadDispatchMediaTypeDetails()
        {
            DbConnection conn = new SqlConnection(GlobalSettings.connectionString);
            try
            {
                conn.Open();

                DbCommand cmdDispatchMediaTypeDetails = conn.CreateCommand();
                cmdDispatchMediaTypeDetails.CommandType = CommandType.StoredProcedure;
                cmdDispatchMediaTypeDetails.CommandText = "spSelectDispatchMediaTypeDetails";
                DbParameter param = cmdDispatchMediaTypeDetails.CreateParameter();
                param.ParameterName = "@DispatchMediaTypeID";
                param.Value = m_dispatchMediaTypeID;
                cmdDispatchMediaTypeDetails.Parameters.Add(param);
                DbDataReader rdrDispatchMediaTypeDetails = cmdDispatchMediaTypeDetails.ExecuteReader();
                rdrDispatchMediaTypeDetails.Read();
                if (!rdrDispatchMediaTypeDetails.IsDBNull(rdrDispatchMediaTypeDetails.GetOrdinal("MediaTypeName")))
                    m_mediaTypeName = (string)rdrDispatchMediaTypeDetails["MediaTypeName"];
                rdrDispatchMediaTypeDetails.Close();
            }
            catch (Exception ex)
            {
                logger.Error(ex.Message); 
                throw ex;
            }
            finally
            {
                conn.Close();
            }
        }

        //===============================================================
        // Function: AddNew
        //===============================================================
        public void AddNew()
        {
            SqlConnection conn = new SqlConnection(GlobalSettings.connectionString);
            try
            {
                conn.Open();

                SqlCommand cmd = new SqlCommand("spAddDispatchMediaType", conn);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@MediaTypeName", SqlDbType.NVarChar, 200).Value = m_mediaTypeName;
                SqlParameter paramDispatchMediaTypeID = cmd.CreateParameter();
                paramDispatchMediaTypeID.ParameterName = "@DispatchMediaTypeID";
                paramDispatchMediaTypeID.SqlDbType = SqlDbType.Int;
                paramDispatchMediaTypeID.Direction = ParameterDirection.Output;
                cmd.Parameters.Add(paramDispatchMediaTypeID);

                cmd.ExecuteNonQuery();
                m_dispatchMediaTypeID = (int)paramDispatchMediaTypeID.Value;
            }
            catch (Exception ex)
            {
                logger.Error(ex.Message); 
                throw ex;
            }
            finally
            {
                conn.Close();
            }
        }

        //===============================================================
        // Function: Update
        //===============================================================
        public void Update()
        {
            SqlConnection conn = new SqlConnection(GlobalSettings.connectionString);
            try
            {
                conn.Open();

                SqlCommand cmd = new SqlCommand("spUpdateDispatchMediaType", conn);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@DispatchMediaTypeID", SqlDbType.Int).Value = m_dispatchMediaTypeID;
                cmd.Parameters.Add("@MediaTypeName", SqlDbType.NVarChar, 200).Value = m_mediaTypeName;
                cmd.ExecuteNonQuery();
            }
            catch (Exception ex)
            {
                logger.Error(ex.Message); 
                throw ex;
            }
            finally
            {
                conn.Close();
            }
        }

        //===============================================================
        // Function: Delete
        //===============================================================
        public void Delete()
        {
            SqlConnection conn = new SqlConnection(GlobalSettings.connectionString);
            try
            {
                conn.Open();

                SqlCommand cmd = new SqlCommand("spDeleteDispatchMediaType", conn);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@DispatchMediaTypeID", SqlDbType.Int).Value = m_dispatchMediaTypeID;
                cmd.ExecuteNonQuery();

                m_dispatchMediaTypeID = -1;
            }
            catch (Exception ex)
            {
                logger.Error(ex.Message); 
                throw ex;
            }
            finally
            {
                conn.Close();
            }
        }
    }
}
