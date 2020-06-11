using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using OpenQbit.Insurance.Presentation.Web.Models.API;
using OpenQbit.Insurance.Common.Models;

namespace OpenQbit.Insurance.Presentation.Web.Controllers
{
    public class InsuranceController : Controller
    {
        // GET: Insurance
        public ActionResult Index()
        {
            return View();
        }

        
        public ActionResult AddInsurance(ApiInsuranceModel apiInsurance, ApiClientModel apiClient, ApiDocumentModel apiDocument, ApiPolicyCoverageDetailModel apiPolicyCoverageDetail, ApiCoverageModel apiCoverage)
        {
            ApiInsuranceModel insurance = new ApiInsuranceModel
            {
                ID = apiInsurance.ID,
                Joining_Date = apiInsurance.Joining_Date,
                End_Date = apiInsurance.End_Date,
                Total_Value = apiInsurance.Total_Value,
                InsuranceType = apiInsurance.InsuranceType,
                AgentID = apiInsurance.AgentID,

                Client = new ApiClientModel
                {
                    ID = apiClient.ID,
                    First_Name = apiClient.First_Name,
                    Middle_Name = apiClient.Middle_Name,
                    Last_Name = apiClient.Middle_Name,
                    Age = apiClient.Age,
                    Address = apiClient.Address,
                    Date_of_Birth = apiClient.Date_of_Birth,
                    Gender = apiClient.Gender,
                    Nationality = apiClient.Nationality,
                    Religion = apiClient.Religion,
                    BloodGroup = apiClient.BloodGroup,
                    Email = apiClient.Email,
                    Mobile = apiClient.Mobile,
                    Telephone = apiClient.Mobile,
                },
                
                Documents = new ApiDocumentModel
                {
                    ID = apiDocument.ID,
                    InsuranceID = apiDocument.InsuranceID,
                    Authuorization = apiDocument.Authuorization,
                    Document = apiDocument.Document,
                },

                PolicyDetails=new ApiPolicyCoverageDetailModel
                {
                    ID = apiPolicyCoverageDetail.ID,
                    CoverageValue = apiPolicyCoverageDetail.CoverageValue,
                    TotalPolicyValue = apiPolicyCoverageDetail.TotalPolicyValue,
                    Note = apiPolicyCoverageDetail.Note,
                    InsuranceID  = apiPolicyCoverageDetail.InsuranceID,
                    CoverageID = apiPolicyCoverageDetail.CoverageID,
                },
                
                Coverage = new ApiCoverageModel
                {
                    ID = apiCoverage.ID,
                    CoverageType = apiCoverage.CoverageType,
                    Includes = apiCoverage.Includes,
                    conditions = apiCoverage.conditions,
                },

            };
            return View();
        }
   }
}