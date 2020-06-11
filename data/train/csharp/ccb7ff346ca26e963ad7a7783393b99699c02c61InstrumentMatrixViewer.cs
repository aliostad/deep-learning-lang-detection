using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace BRE.Tests.InstrumentMatrixTest
{
    using UV.Lib.Products;

    using BRE.Lib.TermStructures;
    using BRE.Lib.TermStructures.InstrumentMatrix;

    public partial class InstrumentMatrixViewer : Form
    {
        private List<InstrumentName> m_InstrumentNames;
        private int m_CellHeight = 50;
        private int m_CellWidth = 130;
        public bool IsShutDown = false;

        public InstrumentMatrixViewer()
        {
            InitializeComponent();

            this.dataGridViewInstrumentMatrix.DataBindingComplete += new DataGridViewBindingCompleteEventHandler(DataGridViewInstrumentMatrix_DataBindingComplete);
        }

        private void DataGridViewInstrumentMatrix_DataBindingComplete(object sender, DataGridViewBindingCompleteEventArgs e)
        {
            int instrumentCount = m_InstrumentNames.Count;
            for (int index = 0; index < instrumentCount; ++index)
            {
                DataGridViewRow dataGridViewRow = this.dataGridViewInstrumentMatrix.Rows[index];
                dataGridViewRow.Height = m_CellHeight;
                string instrumentNameString = m_InstrumentNames[index].FullName;
                dataGridViewRow.HeaderCell.Value = instrumentNameString;
            }
        }

        public void ShowInstrumentMatrix(List<InstrumentName> instrumentNames, InstrumentMatrix instrumentMatrix)
        {
            this.m_InstrumentNames = instrumentNames;
            DataTable dataTable = new DataTable("InstrumentMatrix");
            int instrumentCount = instrumentNames.Count;
            for (int index = 0; index < instrumentCount; ++index)
            {
                string instrumentNameString = instrumentNames[index].FullName;
                dataTable.Columns.Add(instrumentNameString, typeof(string));
            }
            for (int index = 0; index < instrumentCount; ++index)
            {
                dataTable.Rows.Add(new object[instrumentCount]);
            }

            this.dataGridViewInstrumentMatrix.SuspendLayout();
            this.dataGridViewInstrumentMatrix.ColumnHeadersHeight = m_CellHeight;
            this.dataGridViewInstrumentMatrix.DataSource = dataTable;

            for (int xIndex = 0; xIndex < instrumentCount; ++xIndex)
            {
                for (int yIndex = 0; yIndex < instrumentCount; ++yIndex)
                {
                    InstrumentName quoteInstrument = instrumentNames[xIndex];
                    InstrumentName hedgeInstrument = instrumentNames[yIndex];
                    ResultingInstrument resultingInstrument;
                    if (instrumentMatrix.TryFindResultingInstrument(quoteInstrument, 0, hedgeInstrument, 0, out resultingInstrument))
                    {
                        dataTable.Rows[yIndex][xIndex] = resultingInstrument.ResultingInstrumentNameTT;
                    }
                }
            }

            foreach (DataGridViewColumn column in this.dataGridViewInstrumentMatrix.Columns)
            {
                column.Width = m_CellWidth;
                column.SortMode = DataGridViewColumnSortMode.NotSortable;
            }

            this.dataGridViewInstrumentMatrix.AutoResizeRowHeadersWidth(DataGridViewRowHeadersWidthSizeMode.AutoSizeToAllHeaders);
            this.dataGridViewInstrumentMatrix.AutoResizeRows(DataGridViewAutoSizeRowsMode.AllCells);
            this.dataGridViewInstrumentMatrix.AutoResizeColumns(DataGridViewAutoSizeColumnsMode.AllCells);
            this.dataGridViewInstrumentMatrix.SelectionMode = DataGridViewSelectionMode.CellSelect;
            this.dataGridViewInstrumentMatrix.ClipboardCopyMode = DataGridViewClipboardCopyMode.EnableAlwaysIncludeHeaderText;
            this.dataGridViewInstrumentMatrix.DefaultCellStyle.WrapMode = DataGridViewTriState.True;
            
            this.WindowState = FormWindowState.Maximized;
            this.Show();
            this.dataGridViewInstrumentMatrix.ResumeLayout();
        }

        private void InstrumentMatrixViewer_FormClosed(object sender, FormClosedEventArgs e)
        {
            if (!IsShutDown)
                IsShutDown = true;
        }
    }
}
