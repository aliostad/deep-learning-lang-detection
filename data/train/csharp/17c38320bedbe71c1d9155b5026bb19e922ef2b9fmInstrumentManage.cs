using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using DevExpress.XtraEditors;
using Elabcare.BloodComponentManage.UI.Biz;
using Elabcare.BloodComponentManage.UI.UC;

namespace Elabcare.BloodComponentManage.UI.MainForm
{
    public partial class fmInstrumentManage : XtraForm, IUCInstrumentControl
    {

        #region 变量
        string _SelectedInstrument = string.Empty;//仪器名称
        string _SelectedInstrumentItem = string.Empty;//仪器项目
        UCInstrumentInfo _UCInstrumentInfo = null;
        InstrumentManageBiz _biz;
        #endregion

        public fmInstrumentManage()
        {
            InitializeComponent();
            Init();
        }

        #region 初始化
        void Init()
        {
            _biz = new InstrumentManageBiz();
            #region 事件初始化
           // this.sbtn_Search.Click += new EventHandler(sbtn_Search_Click);
            this.InstrumentList.EditValueChanged += new EventHandler(InstrumentList_EditValueChanged);
            #endregion

            DataTable dt = _biz.GetInstrumentList();
            this.InstrumentList.Properties.DataSource = dt;
            this.InstrumentList.Properties.ValueMember = "Code";
            this.InstrumentList.Properties.DisplayMember = "Name";
            this.InstrumentList.Properties.NullText = "请选择...";
            this.InstrumentList.EditValue = "离心机";

            //this.InstrumentItemList.Properties.DataSource = list2;
            //this.InstrumentItemList.Properties.DisplayMember = "Name";
            //this.InstrumentItemList.Properties.ValueMember = "Code";
            //this.InstrumentItemList.Properties.NullText = "请选择...";
        }
        #endregion

        #region 事件
        private void sbtn_Search_Click(object sender, EventArgs e)
        {

            if (this.InstrumentList.EditValue == null)
            {
                XtraMessageBox.Show("请选择仪器");
            }
            else
            {
                _SelectedInstrument = this.InstrumentList.Text.ToString();
                CreateSampleReceiveUC();
            }
        }

        private void InstrumentList_EditValueChanged(object sender, EventArgs e)
        {
            string code = this.InstrumentList.EditValue.ToString();
            DataTable dt = _biz.GetInstrumentItemList(code);

            this.InstrumentItemList.Properties.Items.Clear();
            
            this.InstrumentItemList.Properties.DataSource = dt;
            this.InstrumentItemList.Properties.DisplayMember = "Name";
            this.InstrumentItemList.Properties.ValueMember = "Code";
            this.InstrumentItemList.Properties.NullText = "请选择...";
        }
        #endregion

        #region 方法
        private void CreateSampleReceiveUC()
        {
            List<InstrumentObj> list = null;
            list = CreateTaskList();
            this.splitContainerControl1.Panel2.Controls.Clear();
            _UCInstrumentInfo = new UCInstrumentInfo(list, _SelectedInstrument, true);
            _UCInstrumentInfo.Dock = DockStyle.Fill;
            this.splitContainerControl1.Panel2.Controls.Add(_UCInstrumentInfo);
            //_UCInstrumentInfo.ParentDataRefreshEvent += ReloadSampleReceiveList;
        }

        private List<InstrumentObj> CreateTaskList()
        {
            InstrumentObj obj;
            List<InstrumentObj> list = new List<InstrumentObj>();
            list = new List<InstrumentObj>();

            //_SelectedInstrumentItem = this.InstrumentItemList.EditValue != null ? this.InstrumentItemList.EditValue.ToString() : string.Empty;

            if (this.InstrumentItemList.EditValue != null)
            {
                string[] strArr = this.InstrumentItemList.Text.ToString().Split(',');
                for (int m = 0; m < strArr.Length; m++)
                {
                    obj = new InstrumentObj();
                    obj.Caption = _SelectedInstrument+":"+strArr[m];
                    obj.ControlName = _SelectedInstrument;
                    obj.HeaderImage = null;
                    obj.HeaderTag = _SelectedInstrument;
                    list.Add(obj);
                }
            }

            //obj = new InstrumentObj();
            //obj.Caption = "离心机1";
            //obj.ControlName = "12";
            //obj.HeaderImage = null;
            //obj.HeaderTag = _SelectedInstrument;
            //list.Add(obj);

            //InstrumentObj obj2 = new InstrumentObj();
            //obj2.Caption = "离心机2";
            //obj2.ControlName = "25";
            //obj2.HeaderImage = null;
            //obj2.HeaderTag = _SelectedInstrument;
            //list.Add(obj2);

            //InstrumentObj obj3 = new InstrumentObj();
            //obj3.Caption = "离心机3";
            //obj3.ControlName = "95";
            //obj3.HeaderImage = null;
            //obj3.HeaderTag = _SelectedInstrument;
            //list.Add(obj3);

            //foreach (CheckedComboBoxEdit item in (this.InstrumentItemList.Properties.GetCheckedItems()) as IEnumerable<CheckedComboBoxEdit>)
            //{
            //    obj = new InstrumentObj();
            //    obj.Caption = _SelectedInstrument + " : " + item.Text;
            //    obj.ControlName = item.Text;
            //    obj.HeaderImage = null;
            //    obj.HeaderTag = _SelectedInstrument;

            //    if (!list.Contains(obj))
            //        list.Add(obj);
            //}
            return list;
        }
        #endregion

        #region 接口
        /// <summary>
        /// 加载仪器所监控的属性
        /// </summary>
        public void LoadInstrumentProperties()
        {
        }

        /// <summary>
        /// 根据仪器所监控的属性创建相应的UI界面
        /// </summary>
        public void CreateUI()
        { }

        /// <summary>
        /// 将仪器反馈的信息加载到相应的控件中
        /// </summary>
        public void SetDataSource() { }

        /// <summary>
        /// 根据设置的时间进行实时监控： 打开
        /// </summary>
        public void OpenAutoDoWork() { }

        /// <summary>
        /// 根据设置的时间进行实时监控： 关闭
        /// </summary>
        public void CloseAutoDoWork() { }

        #endregion
    }
}
