//===============================================================
// Filename: editJobDispatch.aspx.cs
// Date: 18/11/08
// --------------------------------------------------------------
// Description:
//   View dispatch
// --------------------------------------------------------------
// Dependencies :
//   None
// --------------------------------------------------------------
// Original author: PRD 18/11/08
// Revision history:
//===============================================================

using System;
using System.Data;
using System.Data.Common;
using System.Data.SqlClient;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using Telerik.Web.UI;
using Axiom.BusinessObjects;

public partial class jobs_editJobDispatch : AxiomPage
{
    //===============================================================
    // Function: Page_Load
    //===============================================================
    protected void Page_Load(object sender, EventArgs e)
    {
        int jobID = int.Parse(Request.QueryString["JID"]);
        int jobDispatchID = int.Parse(Request.QueryString["JDID"]);

        Job job = new Job(jobID);

        if (!IsPostBack)
        {
            jobDetailsPanel.job = job;
            jobDetailsTabs.job = job;
            jobDetailsTabs.selectedTab = "JobDispatch";

            PopulatePage(jobID, jobDispatchID);

            //rightFooterToolbar.Skin = Session["ExtranetCompanyThemeName"].ToString();
        }
    }

    //===============================================================
    // Function: PopulatePage
    //===============================================================
    private void PopulatePage(int jobID, int jobDispatchID)
    {
        JobDispatch jobDispatch = new JobDispatch(jobID, jobDispatchID);
        DispatchMediaType dmt = new DispatchMediaType(jobDispatch.jobDispatchStatusID);

        deliverToNameLabel.Text = jobDispatch.deliveryToName;
        jobDispatchStatusLabel.Text = jobDispatch.statusName;
        deliveryAddressLabel.Text = jobDispatch.deliveryAddress.Replace("\n", "<br/>");
        dispatchReferenceLabel.Text = jobDispatch.dispatchReference;
        dispatchMediaTypeLabel.Text = dmt.mediaTypeName;
        filenameLabel.Text = jobDispatch.filename;
        deliveryInstructionsLabel.Text = jobDispatch.deliveryInstructions;
        deliveryMethodLabel.Text = jobDispatch.deliveryMethod;
        receivedByLabel.Text = jobDispatch.receivedBy;
        if (jobDispatch.scheduledDate > DateTime.MinValue)
        {
            scheduledDateLabel.Text = jobDispatch.scheduledDate.ToString("dd/MM/yyyy");
        }
        else
        {
            scheduledDateLabel.Text = "";
        }
        if (jobDispatch.actualDispatchDate > DateTime.MinValue)
        {
            actualDispatchDateLabel.Text = jobDispatch.actualDispatchDate.ToString("dd/MM/yyyy");
        }
        else
        {
            actualDispatchDateLabel.Text = "";
        }
        if (jobDispatch.deliveryRequiredDate > DateTime.MinValue)
        {
            deliverOnDateLabel.Text = jobDispatch.deliveryRequiredDate.ToString("dd/MM/yyyy");
        }
        else
        {
            deliverOnDateLabel.Text = "";
        }
        if (jobDispatch.receivedDate > DateTime.MinValue)
        {
            receivedDateLabel.Text = jobDispatch.receivedDate.ToString("dd/MM/yyyy");
        }
        else
        {
            receivedDateLabel.Text = "";
        }

        if (jobDispatch.jobDispatchDocument1 != "")
        {
            fileLink1.NavigateUrl = "~/assets/jobFiles/" + jobDispatch.jobDispatchDocument1;
            fileLink1.Text = "Download file: " + jobDispatch.jobDispatchDocument1;
            fileRow1.Visible = true;
        }
        else
        {
            fileRow1.Visible = false;
        }
        if (jobDispatch.jobDispatchDocument2 != "")
        {
            fileLink2.NavigateUrl = "~/assets/jobFiles/" + jobDispatch.jobDispatchDocument2;
            fileLink2.Text = "Download file: " + jobDispatch.jobDispatchDocument2;
            fileRow2.Visible = true;
        }
        else
        {
            fileRow2.Visible = false;
        }
        if (jobDispatch.jobDispatchDocument3 != "")
        {
            fileLink3.NavigateUrl = "~/assets/jobFiles/" + jobDispatch.jobDispatchDocument3;
            fileLink3.Text = "Download file: " + jobDispatch.jobDispatchDocument3;
            fileRow3.Visible = true;
        }
        else
        {
            fileRow3.Visible = false;
        }
        if (jobDispatch.jobDispatchDocument4 != "")
        {
            fileLink4.NavigateUrl = "~/assets/jobFiles/" + jobDispatch.jobDispatchDocument4;
            fileLink4.Text = "Download file: " + jobDispatch.jobDispatchDocument4;
            fileRow4.Visible = true;
        }
        else
        {
            fileRow4.Visible = false;
        }
        if (jobDispatch.jobDispatchDocument5 != "")
        {
            fileLink5.NavigateUrl = "~/assets/jobFiles/" + jobDispatch.jobDispatchDocument5;
            fileLink5.Text = "Download file: " + jobDispatch.jobDispatchDocument5;
            fileRow5.Visible = true;
        }
        else
        {
            fileRow5.Visible = false;
        }
    }

    //===============================================================
    // Function: backButton_Click
    //===============================================================
    protected void backButton_Click(object sender, EventArgs e)
    {
        int jobID = int.Parse(Request.QueryString["JID"]);
        Response.Redirect("jobDispatch.aspx?JID=" + jobID.ToString());
    }

    //===============================================================
    // Function: saveButton_Click
    //===============================================================
    protected void saveButton_Click(object sender, EventArgs e)
    {
        int jobID = int.Parse(Request.QueryString["JID"]);
    }
}
