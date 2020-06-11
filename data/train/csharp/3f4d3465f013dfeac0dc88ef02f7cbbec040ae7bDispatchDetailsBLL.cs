using System;
using System.Text;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
using WIMARTS.DB.BusinessObjects;
using WIMARTS.DB.DAL;

namespace WIMARTS.DB.BLL
{
	public partial class DispatchDetailsBLL
	{
		private DispatchDetailsDAO _DispatchDetailsDAO;

		public DispatchDetailsDAO DispatchDetailsDAO
		{
			get { return _DispatchDetailsDAO; }
			set { _DispatchDetailsDAO = value; }
		}

		public DispatchDetailsBLL()
		{
			DispatchDetailsDAO = new DispatchDetailsDAO();
		}
		public List<DispatchDetails> GetDispatchDetailss()
		{
			try
			{
				return DispatchDetailsDAO.GetDispatchDetailss();
			}
			catch(Exception ex)
			{
				throw ex;
			}
		}
		public DispatchDetails GetDispatchDetails(int DispDetailsID)
		{
			try
			{
				return DispatchDetailsDAO.GetDispatchDetails(DispDetailsID);
			}
			catch(Exception ex)
			{
				throw ex;
			}
		}
		public int AddDispatchDetails(DispatchDetails oDispatchDetails)
		{
			try
			{
				return DispatchDetailsDAO.AddDispatchDetails(oDispatchDetails);
			}
			catch (Exception ex)
			{
				throw ex;
			}
		}
		public int UpdateDispatchDetails(DispatchDetails oDispatchDetails)
		{
			try
			{
				return DispatchDetailsDAO.UpdateDispatchDetails(oDispatchDetails);
			}
			catch (Exception ex)
			{
				throw ex;
			}
		}
		public int RemoveDispatchDetails(DispatchDetails oDispatchDetails)
		{
			try
			{
				return DispatchDetailsDAO.RemoveDispatchDetails(oDispatchDetails);
			}
			catch (Exception ex)
			{
				throw ex;
			}
		}
		public int RemoveDispatchDetails(int DispDetailsID)
		{
			try
			{
				return DispatchDetailsDAO.RemoveDispatchDetails(DispDetailsID);
			}
			catch (Exception ex)
			{
				throw ex;
			}
		}
		public List<DispatchDetails> DeserializeDispatchDetailss(string Path)
		{
			try
			{
				return GenericXmlSerializer<List<DispatchDetails>>.Deserialize(Path);
			}
			catch (Exception ex)
			{
				throw ex;
			}
		}
		public void SerializeDispatchDetailss(string Path, List<DispatchDetails> DispatchDetailss)
		{
			try
			{
				GenericXmlSerializer<List<DispatchDetails>>.Serialize(DispatchDetailss, Path);
			}
			catch (Exception ex)
			{
				throw ex;
			}
		}
	}
}
