using System;
using System.Windows.Forms;
using JsonHelper;
using InvokeDLL;

namespace WinCEPage
{
    public partial class InvokeForm : Form
    {
        public InvokeForm()
        {
            InitializeComponent();
        }

        // URL
        // string url = "http://222.66.83.59/c2m2/api/NativeInvokeAPI/GetOrderAmount";
        string url = "http://192.168.15.31:8090/Fabric/GetFabricDetail";

        // 调用
        private void btnInvoke_Click(object sender, EventArgs e)
        {
            // 赋值
            InvokeEntity entity = new InvokeEntity();
            entity.FabricId = txtInput.Text;
            // entity.Code = "T201508180000039630";

            // 序列化成JSON
            string json = Converter.Serialize(entity);

            // 传值
            InvokeWebAPI invoke = new InvokeWebAPI();
            string msg = invoke.CreatePostHttpResponse(url, json);

            // 接收返回值绑定到页面
            lblMessage.Text = msg;
        }
    }
}