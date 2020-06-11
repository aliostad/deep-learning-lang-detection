using System;
using System.Text;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
using WIMARTS.DB.BusinessObjects;
using WIMARTS.DB.DAL;

namespace WIMARTS.DB.BLL
{
	public partial class DispatchMasterBLL
	{
       
		private DispatchMasterDAO _DispatchMasterDAO;

		public DispatchMasterDAO DispatchMasterDAO
		{
			get { return _DispatchMasterDAO; }
			set { _DispatchMasterDAO = value; }
		}

		public DispatchMasterBLL()
		{
			DispatchMasterDAO = new DispatchMasterDAO();
		}
        public List<DispatchMaster> GetDispatchMasters(BLLManager.MasterStatus Flag)
		{
			try
			{
				return DispatchMasterDAO.GetDispatchMasters((int)Flag);
			}
			catch(Exception ex)
			{
				throw ex;
			}
		}
		public DispatchMaster GetDispatchMaster(int DispMasterID)
		{
			try
			{
				return DispatchMasterDAO.GetDispatchMaster(DispMasterID);
			}
			catch(Exception ex)
			{
				throw ex;
			}
		}
		public int AddDispatchMaster(DispatchMaster oDispatchMaster)
		{
			try
			{
				return DispatchMasterDAO.AddDispatchMaster(oDispatchMaster);
			}
			catch (Exception ex)
			{
				throw ex;
			}
		}
		public int UpdateDispatchMaster(DispatchMaster oDispatchMaster)
		{
			try
			{
				return DispatchMasterDAO.UpdateDispatchMaster(oDispatchMaster);
			}
			catch (Exception ex)
			{
				throw ex;
			}
		}
		public int RemoveDispatchMaster(DispatchMaster oDispatchMaster)
		{
			try
			{
				return DispatchMasterDAO.RemoveDispatchMaster(oDispatchMaster);
			}
			catch (Exception ex)
			{
				throw ex;
			}
		}
		public int RemoveDispatchMaster(int DispMasterID)
		{
			try
			{
				return DispatchMasterDAO.RemoveDispatchMaster(DispMasterID);
			}
			catch (Exception ex)
			{
				throw ex;
			}
		}
		public List<DispatchMaster> DeserializeDispatchMasters(string Path)
		{
			try
			{
				return GenericXmlSerializer<List<DispatchMaster>>.Deserialize(Path);
			}
			catch (Exception ex)
			{
				throw ex;
			}
		}
		public void SerializeDispatchMasters(string Path, List<DispatchMaster> DispatchMasters)
		{
			try
			{
				GenericXmlSerializer<List<DispatchMaster>>.Serialize(DispatchMasters, Path);
			}
			catch (Exception ex)
			{
				throw ex;
			}
		}
	}
}
