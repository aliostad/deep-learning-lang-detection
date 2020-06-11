using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using Concert.DataAccessLayer;
using Concert.DBObjectDefinition;

namespace Concert.PresentationLayer
{
    public partial class InstrumentControl : Form
    {
        public InstrumentControl()
        {
            InitializeComponent();
            LoadInstruments();
        }

        public void LoadInstruments()
        {
            dataGridViewInstrument.Rows.Clear();
            foreach (Instrument instrument in DBObjectController.GetAllInstruments())
            {
                DataGridViewRow row = new DataGridViewRow();
                row.CreateCells(dataGridViewInstrument, new object[] { Name = instrument.Name });
                row.Tag = instrument;
                dataGridViewInstrument.Rows.Add(row);
            }
        }

        private void dataGridViewInstrument_SelectionChanged(object sender, EventArgs e)
        {
            if (dataGridViewInstrument.CurrentRow != null)
            {
                textBoxCurrentInstrumentName.Text = ((Instrument)dataGridViewInstrument.CurrentRow.Tag).Name;
            }
            else
            {
                textBoxCurrentInstrumentName.Clear();
            }

        }

        private void buttonSave_Click(object sender, EventArgs e)
        {
            if (dataGridViewInstrument.CurrentRow != null)
            {
                SimpleTextValidation( textBoxCurrentInstrumentName, new CancelEventArgs());
                if (NoErrorProviderMsg())
                {
                    string name = textBoxCurrentInstrumentName.Text;

                    dataGridViewInstrument.CurrentRow.Cells[0].Value         = name;
                    ((Instrument)dataGridViewInstrument.CurrentRow.Tag).Name = name;

                    DBObjectController.StoreObject((Instrument)dataGridViewInstrument.CurrentRow.Tag);
                }
            }
        }

        private bool NoErrorProviderMsg()
        {
            return string.IsNullOrEmpty(errorProviderInstrument.GetError(textBoxCurrentInstrumentName));
        }

        private void SimpleTextValidation(object sender, CancelEventArgs e)
        {
            if (string.IsNullOrWhiteSpace(((TextBox)sender).Text) || ((TextBox)sender).Text == string.Empty)
            {
                errorProviderInstrument.SetError((TextBox)sender, "Empty fields are not allowed");
            }
            else
            {
                errorProviderInstrument.SetError((TextBox)sender, string.Empty);
            }
        }

        private void dataGridViewInstrument_UserDeletingRow(object sender, DataGridViewRowCancelEventArgs e)
        {
            DBObjectController.DeleteObject((Instrument)dataGridViewInstrument.CurrentRow.Tag);
        }

        private void buttonAdd_Click(object sender, EventArgs e)
        {
            if (ValidateChildren() && string.IsNullOrEmpty(errorProviderInstrument.GetError(textBoxInstrument)))
            {
                string name = textBoxInstrument.Text;

                Instrument instrument = new Instrument() { Name = name };

                DBObjectController.StoreObject(instrument);

                DataGridViewRow row = new DataGridViewRow();

                row.CreateCells(dataGridViewInstrument, new object[] { Name = instrument.Name });

                row.Tag = instrument;

                dataGridViewInstrument.Rows.Add(row);

                textBoxInstrument.Clear();
            }
        }

        private void InstrumentControl_FormClosing(object sender, FormClosingEventArgs e)
        {
            if (MdiParent != null)
            {
                MdiParent.MainMenuStrip.Enabled = true;
            }
        }

        private void InstrumentControl_Load(object sender, EventArgs e)
        {
            if (MdiParent != null)
            {
                MdiParent.MainMenuStrip.Enabled = false;
            }
        }
    }
}
