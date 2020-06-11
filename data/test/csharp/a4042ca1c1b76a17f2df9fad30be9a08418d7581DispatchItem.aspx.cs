using ERPWebForms.Business.Inventory.Controllers;
using ERPWebForms.Business.Inventory.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ERPWebForms.Inventory
{
    public partial class DispatchItem : BasePage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Security 
            if (Request.Cookies["user"] == null)
            {
                Response.Redirect("~/Default.aspx");
            }
            //else
            //{
            //    if (!new UserSecurity().CheckFormPermission((int)Global.formSecurity.AddBank, Request.Cookies["user"]["Permission"].ToString()))
            //        Response.Redirect("~/Finance_Module/UnAuthorized.aspx");
            //}

            if (!IsPostBack)
            {
                if (Request.QueryString["alert"] == "notpass")
                {
                    Response.Write("<script>alert('لم يتم الحفظ');</script>");
                }

                if (Request.QueryString["id"].ToString() != null)
                {
                    if (Convert.ToInt32(Request.QueryString["id"].ToString()) > 0)
                    {
                        Dispatch dispatch = new ClsDispatch().get(Convert.ToInt32(Request.QueryString["id"].ToString()));
                        ddlProduct.SelectedValue = dispatch.ProductID.ToString();
                        ddlStuff.SelectedValue = dispatch.StuffID.ToString();
                        ddlWarehouse.SelectedValue = dispatch.WarehouseID.ToString();
                        txtRemarks.Text = dispatch.Remarks;
                        txtQuantity.Text = dispatch.Amount.ToString();
                        btnSave.Visible = false;
                        btnEdit.Visible = true;
                    }
                    else
                    {
                        btnSave.Visible = true;
                        btnEdit.Visible = false;
                    }
                }
            }
        }

        protected void btnEdit_Click(object sender, EventArgs e)
        {
            Dispatch dispatch = new Dispatch();
            dispatch.ProductID = Convert.ToInt32(ddlProduct.SelectedValue.ToString());
            dispatch.StuffID = Convert.ToInt32(ddlStuff.SelectedValue.ToString());
            dispatch.WarehouseID = Convert.ToInt32(ddlWarehouse.SelectedValue.ToString());
            dispatch.Amount = Convert.ToInt32(txtQuantity.Text);
            dispatch.Remarks = txtRemarks.Text;
            dispatch.Active = 1;
            HttpCookie myCookie = Request.Cookies["user"];
            dispatch.OperatorID = Convert.ToInt32(myCookie.Values["userid"].ToString());
            int res = new ClsDispatch().update(Convert.ToInt32(Request.QueryString["id"].ToString()), dispatch);
            if (res > 0)
            {
                Response.Redirect("~/Inventory/ListDispatches.aspx?alert=success");
            }
            else
            {
                Response.Redirect("~/Inventory/DispatchItem.aspx?id=0&&alret=notpass");
            }
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            Dispatch dispatch = new Dispatch();
            dispatch.ProductID = Convert.ToInt32(ddlProduct.SelectedValue.ToString());
            dispatch.StuffID = Convert.ToInt32(ddlStuff.SelectedValue.ToString());
            dispatch.WarehouseID = Convert.ToInt32(ddlWarehouse.SelectedValue.ToString());
            dispatch.Amount = Convert.ToInt32(txtQuantity.Text);
            dispatch.Remarks = txtRemarks.Text;
            dispatch.Active = 1;
            HttpCookie myCookie = Request.Cookies["user"];
            dispatch.OperatorID = Convert.ToInt32(myCookie.Values["userid"].ToString());
            int res = new ClsDispatch().insert(dispatch);
            if (res > 0)
            {
                Response.Redirect("~/Inventory/ListDispatches.aspx?alert=success");
            }
            else
            {
                Response.Redirect("~/Inventory/DispatchItem.aspx?id=0&&alret=notpass");
            }
        }

        protected void btnCancel_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/Inventory/ListDispatches.aspx");
        }
    }
}