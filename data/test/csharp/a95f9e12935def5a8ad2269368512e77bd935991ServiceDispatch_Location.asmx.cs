using DataAccess;
using Model;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Script.Services;
using System.Web.Services;

namespace LeatherApp.WebServices
{
    /// <summary>
    /// Summary description for ServiceDispatch_Location
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [System.ComponentModel.ToolboxItem(false)]
    // To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
    [System.Web.Script.Services.ScriptService]
    public class ServiceDispatch_Location : System.Web.Services.WebService
    {

        [WebMethod]
        public void Filter_Get_Dispatch_Location(int iDisplayLength, int iDisplayStart, int iSortCol_0, string sSortDir_0, string sSearch)
        {
            int filteredCount = 0;

            List<Dispatch_Location> Dispatch_Location_List = new List<Dispatch_Location>();

            DataTable dt = Dispatch_Location_DA.Filter_Get_Dispatch_Location(iDisplayLength, iDisplayStart, iSortCol_0, sSortDir_0, sSearch);

            foreach (DataRow row in dt.Rows)
            {

                filteredCount = int.Parse(row["TotalCount"].ToString());

                Dispatch_Location_List.Add(new Dispatch_Location
                {
                    ID = int.Parse(row["ID"].ToString()),
                    Supplier_ID = int.Parse(row["Supplier_ID"].ToString()),
                    Supplier_Code = row["Code"].ToString(),
                    Supplier_Name = row["Supplier_Name"].ToString(),
                    Address = row["Address"].ToString(),
                    ZP = row["Zip/Postal"].ToString(),
                    SP = row["State/Province"].ToString(),
                    City = row["City"].ToString(),
                    Country = row["Country"].ToString(),

                    ForEdit = row["ID"].ToString(),
                    ForDelete = row["ID"].ToString()
                });
            }
            var result = new
            {
                iTotalRecords = GetTotal_Dispatch_Location_Count(),
                iTotalDisplayRecords = filteredCount,
                aaData = Dispatch_Location_List
            };

            JavaScriptSerializer js = new JavaScriptSerializer();
            Context.Response.Write(js.Serialize(result));
        }

        private int GetTotal_Dispatch_Location_Count()
        {
            int totalDispatch_Location_Count = 0;
            string cs = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;
            using (SqlConnection con = new SqlConnection(cs))
            {
                SqlCommand cmd =
                    new SqlCommand("select Count(*) from Dispatch_Location where IsDeleted=0", con);
                con.Open();
                totalDispatch_Location_Count = (int)cmd.ExecuteScalar();
            }
            return totalDispatch_Location_Count;
        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public Dispatch_Location Get_Dispatch_Location_By_Id(int ID)
        {
            Dispatch_Location _Dispatch_Location = new Dispatch_Location();

            DataTable dt = Dispatch_Location_DA.Get_Dispatch_Location_By_Id(ID);

            foreach (DataRow row in dt.Rows)
            {
                ID = int.Parse(row["ID"].ToString());
                _Dispatch_Location.Supplier_ID = int.Parse(row["Supplier_ID"].ToString());
                _Dispatch_Location.Address = row["Address"].ToString();
                _Dispatch_Location.ZP = row["Zip/Postal"].ToString();
                _Dispatch_Location.SP = row["State/Province"].ToString();
                _Dispatch_Location.City = row["City"].ToString();
                _Dispatch_Location.Country = row["Country"].ToString();

            }
            return _Dispatch_Location;
        }

        [WebMethod]
        public bool Delete_Dispatch_Location_By_Id(int ID)
        {
            if (Dispatch_Location_DA.Delete_Dispatch_Location_By_Id(ID) > 0)
            {
                return true;
            }
            else
            {
                return false;
            }
        }

        [WebMethod(EnableSession = true)]
        public string Update(int ID, int Supplier_ID, string Address, string ZP, string SP, string City, string Country)
        {
            Dispatch_Location _Dispatch_Location = new Dispatch_Location();
            _Dispatch_Location.ID = ID;
            _Dispatch_Location.Supplier_ID = Supplier_ID;
            _Dispatch_Location.Address = Address;
            _Dispatch_Location.ZP = ZP;
            _Dispatch_Location.SP = SP;
            _Dispatch_Location.City = City;
            _Dispatch_Location.Country = Country;

            _Dispatch_Location.UpdatedBy = Session["User"].ToString();


            return Dispatch_Location_DA.Update(_Dispatch_Location);
        }

        [WebMethod(EnableSession = true)]
        public string Insert(int Supplier_ID, string Address, string ZP, string SP, string City, string Country)
        {
            Dispatch_Location _Dispatch_Location = new Dispatch_Location();
            _Dispatch_Location.Supplier_ID = Supplier_ID;
            _Dispatch_Location.Address = Address;
            _Dispatch_Location.ZP = ZP;
            _Dispatch_Location.SP = SP;
            _Dispatch_Location.City = City;
            _Dispatch_Location.Country = Country;

            _Dispatch_Location.CreatedBy = Session["User"].ToString();


            return Dispatch_Location_DA.Insert(_Dispatch_Location);
        }
    }
}
