using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Drawing;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace WindowsFormsApplication4
{
    public partial class Dispatch_Orders : UserControl
    {
        Database db = new Database();
        private static Dispatch_Orders _instance;
        public static Dispatch_Orders Instance
        {
            get
            {
                if (_instance == null)
                    _instance = new Dispatch_Orders();
                return _instance;
            }
        }
        public Dispatch_Orders()
        {
            InitializeComponent();
        }

        private void orderIdDispatch_OnValueChanged(object sender, EventArgs e)
        {

        }

        private void orderIdDispatch_Enter(object sender, EventArgs e)
        {
            if (orderIdDispatch.Text == "Order Id")
            {
                orderIdDispatch.Text = "";

                orderIdDispatch.ForeColor = Color.Black;
            }
        }

        private void orderIdDispatch_Leave(object sender, EventArgs e)
        {
            if (orderIdDispatch.Text == "")
            {
                orderIdDispatch.Text = "Order Id";

                orderIdDispatch.ForeColor = Color.DimGray;
            }
        }

        private void reasonDispatch_Enter(object sender, EventArgs e)
        {
            if (reasonDispatch.Text == "Reason")
            {
                reasonDispatch.Text = "";

                reasonDispatch.ForeColor = Color.Black;
            }
        }

        private void reasonDispatch_OnValueChanged(object sender, EventArgs e)
        {

        }

        private void reasonDispatch_Leave(object sender, EventArgs e)
        {
            if (reasonDispatch.Text == "")
            {
                reasonDispatch.Text = "Reason";

                reasonDispatch.ForeColor = Color.DimGray;
            }
        }

        private void button2_Click(object sender, EventArgs e)
        {
            DataSet ds = db.dbse("SELECT itemId,stockNo,ItemName,status,reason_dispatch FROM item");
            bunifuCustomDataGrid1.DataSource = ds.Tables["load"];
        }

        private void button1_Click(object sender, EventArgs e)
        {
            
            string qu = "update item set status = 'bad' reason_dispatch = '"+reasonDispatch.Text+"'  where itemId = '"+ orderIdDispatch.Text + "'";
            db.Dbupdate(qu);

            DataSet ds = db.dbse("SELECT itemId,stockNo,ItemName,status,reason_dispatch FROM item");
            bunifuCustomDataGrid1.DataSource = ds.Tables["load"];
        }
    }
}
