//===============================================================
// Filename: editDispatchMediaType.aspx.cs
// Date: 01/01/07
// --------------------------------------------------------------
// Description:
//   Edit dispatch media type
// --------------------------------------------------------------
// Dependencies :
//   None
// --------------------------------------------------------------
// Original author: PRD 01/01/07
// Revision history:
//===============================================================

using System;
using System.Data;
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

public partial class admin_editDispatchMediaType : AxiomPage
{
    //===============================================================
    // Function: Page_Load
    //===============================================================
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            int dispatchMediaTypeID = int.Parse(Request.QueryString["DMTID"].ToString());

            DispatchMediaType dispatchMediaType = new DispatchMediaType(dispatchMediaTypeID);

            dispatchMediaTypeTextBox.Text = dispatchMediaType.mediaTypeName;

            SetFocus(dispatchMediaTypeTextBox.ClientID);
        }
    }

    //===============================================================
    // Function: deleteButton_Click
    //===============================================================
    protected void deleteButton_Click(object sender, EventArgs e)
    {
        int dispatchMediaTypeID = int.Parse(Request.QueryString["DMTID"].ToString());

        string dispatchMediaTypeText = dispatchMediaTypeTextBox.Text;

        DispatchMediaType dispatchMediaType = new DispatchMediaType(dispatchMediaTypeID);
        dispatchMediaType.mediaTypeName = dispatchMediaTypeText;
        dispatchMediaType.Delete();

        Response.Redirect("dispatchMediaTypesList.aspx");
    }

    //===============================================================
    // Function: backButton_Click
    //===============================================================
    protected void backButton_Click(object sender, EventArgs e)
    {
        Response.Redirect("dispatchMediaTypesList.aspx");
    }

    //===============================================================
    // Function: saveButton_Click
    //===============================================================
    protected void saveButton_Click(object sender, EventArgs e)
    {
        int dispatchMediaTypeID = int.Parse(Request.QueryString["DMTID"].ToString());

        // Save the form
        string dispatchMediaTypeText = dispatchMediaTypeTextBox.Text;

        DispatchMediaType dispatchMediaType = new DispatchMediaType(dispatchMediaTypeID);
        dispatchMediaType.mediaTypeName = dispatchMediaTypeText;
        dispatchMediaType.Update();
    }
}