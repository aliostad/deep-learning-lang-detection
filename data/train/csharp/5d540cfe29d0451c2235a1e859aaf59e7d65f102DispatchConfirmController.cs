using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using Dalworth.Server.Data;
using Dalworth.Server.Domain;
using Dalworth.Server.Windows;
using DevExpress.XtraDataLayout;
using DevExpress.XtraEditors;
using DevExpress.XtraEditors.Controls;

namespace Dalworth.Server.MainForm.DispatchConfirm
{
    public enum DispatchConfirmResultEnum
    {
        Yes,
        NoContinueDispatch,
        NoCancelDispatch
    }

    public class DispatchConfirmController : Controller<DispatchConfirmModel, DispatchConfirmView>
    {
        #region DispatchConfirmResult

        private DispatchConfirmResultEnum m_dispatchConfirmResult;
        public DispatchConfirmResultEnum DispatchConfirmResult
        {
            get { return m_dispatchConfirmResult; }
        }

        #endregion

        #region OnModelInitialize

        protected override void OnModelInitialize(object[] data)
        {
            Model.Visit = (Visit)data[0];
            Model.DispatchTime = (DateTime)data[1];

            base.OnModelInitialize(data);
        }

        #endregion

        #region OnInitialize

        protected override void OnInitialize()
        {
            View.m_btnYes.Click += OnYesClick;
            View.m_btnNoContinueDispatch.Click += OnNoContinueDispatchClick;
            View.m_btnNoCancelDispatch.Click += OnNoCancelDispatchClick;
            
        }

        #endregion

        #region OnViewLoad

        protected override void OnViewLoad()
        {
            View.m_lblReasons.Text = Model.GetConfirmationReasons();
        }

        #endregion

        #region OnYesClick

        private void OnYesClick(object sender, EventArgs e)
        {
            m_dispatchConfirmResult = DispatchConfirmResultEnum.Yes;
            View.Destroy();
        }

        #endregion

        #region OnNoContinueDispatchClick

        private void OnNoContinueDispatchClick(object sender, EventArgs e)
        {
            m_dispatchConfirmResult = DispatchConfirmResultEnum.NoContinueDispatch;
            View.Destroy();
        }

        #endregion

        #region OnNoCancelDispatchClick

        private void OnNoCancelDispatchClick(object sender, EventArgs e)
        {
            m_dispatchConfirmResult = DispatchConfirmResultEnum.NoCancelDispatch;
            View.Destroy();
        }

        #endregion

        #region IsConfirmationNotificationExists

        public bool IsConfirmationNotificationExists()
        {
            if (Model.GetConfirmationReasons() == string.Empty)
                return false;
            return true;
        }

        #endregion
    }
}
