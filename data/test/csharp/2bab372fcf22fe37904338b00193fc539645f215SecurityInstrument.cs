using System;
using B4F.TotalGiro.Collections.Persistence;
using B4F.TotalGiro.Instruments.History;

namespace B4F.TotalGiro.Instruments
{
    /// <summary>
    /// Class represents securities
    /// </summary>
    public abstract class SecurityInstrument : TradeableInstrument, ISecurityInstrument
    {
        protected SecurityInstrument() { }

        #region Props

        public virtual bool IsGreenFund { get; set; }
        public virtual bool IsCultureFund { get; set; }
        public virtual bool SupportsStockDividend 
        {
            get { return true; }
        }

        /// <summary>
        /// This is the collection of Corporate Action Instruments that belong to the security.
        /// </summary>
        public virtual IInstrumentCorporateActionCollection CorporateActionInstruments
        {
            get
            {
                IInstrumentCorporateActionCollection col = (InstrumentCorporateActionCollection)corporateActions.AsList();
                if (col.Parent == null) col.Parent = this;
                return col;
            }
        }

        public override bool IsSecurity
        {
            get { return true; }
        }
        public override int ContractSize
        {
            get { return 1; }
        }

        public abstract bool Transform(DateTime changeDate, decimal oldChildRatio, byte newParentRatio, bool isSpinOff,
                string instrumentName, string isin, DateTime issueDate);

        protected bool transform(SecurityInstrument newInstrument, DateTime changeDate, decimal oldChildRatio, byte newParentRatio, bool isSpinOff,
                string instrumentName, string isin, DateTime issueDate)
        {
            if (ParentInstrument != null)
                throw new ApplicationException(string.Format("This instrument already has been transformed to {0} (key {1})", ParentInstrument.Name, ParentInstrument.Key.ToString()));

            newInstrument.AllowNetting = this.AllowNetting;
            newInstrument.CompanyName = this.CompanyName;
            newInstrument.IsGreenFund = this.IsGreenFund;
            newInstrument.IsCultureFund = this.IsCultureFund;
            newInstrument.CreationDate = DateTime.Now;
            newInstrument.CurrencyNominal = this.CurrencyNominal;
            newInstrument.DecimalPlaces = this.DecimalPlaces;
            newInstrument.DefaultExchange = this.DefaultExchange;
            newInstrument.DefaultRoute = this.DefaultRoute;
            newInstrument.HomeExchange = this.HomeExchange;
            newInstrument.IsActive = true;
            newInstrument.Isin = isin;
            newInstrument.IssueDate = issueDate;
            newInstrument.LastUpdated = DateTime.Now;
            newInstrument.Name = instrumentName;
            newInstrument.PriceType = this.PriceType;
            newInstrument.SecCategory = this.SecCategory;
            newInstrument.IsGreenFund = this.IsGreenFund;
            newInstrument.IsCultureFund = this.IsCultureFund;
            this.ParentInstrument = newInstrument;
            this.InActiveDate = changeDate;
            InstrumentHistory history = new InstrumentsHistoryConversion(this, newInstrument, changeDate, oldChildRatio, newParentRatio, isSpinOff);
            this.HistoricalTransformations.Add(history);
            return newInstrument.Validate();
        }

        #endregion

        #region Privates

        private IDomainCollection<IInstrumentCorporateAction> corporateActions = new InstrumentCorporateActionCollection();

        #endregion

    }
}
