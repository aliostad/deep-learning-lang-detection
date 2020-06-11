using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Text;
using Manager.Common;
using Manager.Common.QuotationEntities;
using ManagerConsole.Model;
using System.Diagnostics;

namespace ManagerConsole.ViewModel
{
    public class VmQuotationManager
    {
        public static VmQuotationManager Instance = new VmQuotationManager();

        //private bool _MetadataNotLoaded = true;
        private ObservableCollection<VmQuotationSource> _QuotationSources = new ObservableCollection<VmQuotationSource>();
        private ObservableCollection<VmInstrument> _Instruments = new ObservableCollection<VmInstrument>();
        private VmAbnormalQuotationManager _abnormalQuotationManager = new VmAbnormalQuotationManager();

        private VmQuotationManager() { }

        public ObservableCollection<VmQuotationSource> QuotationSources
        {
            get
            {
                //if (this._MetadataNotLoaded)
                //{
                //    this.LoadMetadata();
                //}
                return this._QuotationSources;
            }
        }

        public ObservableCollection<VmInstrument> Instruments
        {
            get
            {
                //if (this._MetadataNotLoaded)
                //{
                //    this.LoadMetadata();
                //}
                return this._Instruments;
            }
        }

        public VmAbnormalQuotationManager AbnormalQuotationManager { get { return this._abnormalQuotationManager; } }

        public void Reset()
        {
            this._QuotationSources.Clear();
            this._Instruments.Clear();
            this._abnormalQuotationManager.Reset();
            //this._MetadataNotLoaded = false;
        }

        public void AddAbnormalQuotation(AbnormalQuotationMessage message)
        {
            this._abnormalQuotationManager.AddAbnormalQuotation(message);
        }

        public void Initialize()
        {
            try
            {
                //if (this._MetadataNotLoaded)
                //{
                    ConfigMetadata metadata = ConsoleClient.Instance.GetConfigMetadata();
                    
                    this._QuotationSources.Clear();
                    foreach (var source in metadata.QuotationSources.Values)
                    {
                        this._QuotationSources.Add(new VmQuotationSource(source));
                    }

                    this._Instruments.Clear();
                    foreach (var instrument in metadata.Instruments.Values)
                    {
                        VmInstrument vmInstrument = new VmInstrument(instrument);
                        if (instrument.IsDerivative)
                        {
                            vmInstrument.VmDerivativeRelation = new VmDerivativeRelation(metadata.DerivativeRelations[instrument.Id]);
                        }
                        else
                        {
                            foreach (Dictionary<string, InstrumentSourceRelation> dict in metadata.InstrumentSourceRelations.Values)
                            {
                                var relation = dict.Values.SingleOrDefault(r => r.InstrumentId == instrument.Id);
                                if (relation != null)
                                {
                                    VmQuotationSource vmQuotationSource = this._QuotationSources.Single(s => s.Id == relation.SourceId);
                                    vmInstrument.SourceRelations.Add(new VmInstrumentSourceRelation(relation, vmInstrument, vmQuotationSource));
                                }
                            }

                            if (!instrument.IsDerivative)
                            {
                                vmInstrument.VmPriceRangeCheckRule = new VmPriceRangeCheckRule(metadata.PriceRangeCheckRules[instrument.Id]);
                                if (metadata.WeightedPriceRules.ContainsKey(instrument.Id))
                                {
                                    vmInstrument.VmWeightedPriceRule = new VmWeightedPriceRule(metadata.WeightedPriceRules[instrument.Id]);
                                }
                                else
                                {
                                    vmInstrument.VmWeightedPriceRule = new VmWeightedPriceRule(new WeightedPriceRule());
                                }
                            }
                        }

                        // set quotation
                        GeneralQuotation generalQuotation;
                        if (metadata.LastQuotations.TryGetValue(instrument.Id, out generalQuotation))
                        {
                            vmInstrument.SetQuotation(generalQuotation, vmInstrument.DecimalPlace);
                        }

                        this._Instruments.Add(vmInstrument);
                    //}
                    //this._MetadataNotLoaded = false;
                }
            }
            catch(Exception exception)
            {
                Logger.TraceEvent(TraceEventType.Error, "VmQuotationManager.LoadMetadata\r\n{0}", exception);
            }
        }

        public void Add(QuotationSource source)
        {
            this._QuotationSources.Add(new VmQuotationSource(source));
        }

        public void Add(Instrument instrument)
        {
            this._Instruments.Add(new VmInstrument(instrument));
        }

        public void Add(InstrumentSourceRelation relation)
        {
            VmInstrument vmInstrument = this._Instruments.Single(i => i.Id == relation.InstrumentId);
            VmQuotationSource vmQuotationSource = this._QuotationSources.Single(s => s.Id == relation.SourceId);
            vmInstrument.SourceRelations.Add(new VmInstrumentSourceRelation(relation, vmInstrument, vmQuotationSource));
        }

        public void Add(PriceRangeCheckRule rule)
        {
            this._Instruments.Single(i => i.Id == rule.Id).VmPriceRangeCheckRule = new VmPriceRangeCheckRule(rule);
        }

        public void Add(WeightedPriceRule rule)
        {
            this._Instruments.Single(i => i.Id == rule.Id).VmWeightedPriceRule = new VmWeightedPriceRule(rule);
        }

        public void Add(DerivativeRelation derivativeRelation)
        {
            this._Instruments.Single(i => i.Id == derivativeRelation.Id).VmDerivativeRelation = new VmDerivativeRelation(derivativeRelation);
        }

        public void Update(Manager.Common.UpdateMetadataMessage message)
        {
            foreach (var item in message.UpdateDatas)
            {
                VmInstrument instrument;
                switch (item.MetadataType)
                {
                    case MetadataType.QuotationSource:
                        VmQuotationSource source = this._QuotationSources.SingleOrDefault(s => s.Id == item.ObjectId);
                        if (source != null)
                        {
                            source.ApplyChangeToUI(item.FieldsAndValues);
                        }
                        break;
                    case MetadataType.Instrument:
                        instrument = this._Instruments.SingleOrDefault(i => i.Id == item.ObjectId);
                        if (instrument != null)
                        {
                            instrument.ApplyChangeToUI(item.FieldsAndValues);
                        }
                        break;
                    case MetadataType.InstrumentSourceRelation:
                        VmInstrumentSourceRelation relation;
                        if (this.FindVmInstrumentSourceRelation(item.ObjectId, out relation, out instrument))
                        {
                            relation.ApplyChangeToUI(item.FieldsAndValues);
                        }
                        break;
                    case MetadataType.DerivativeRelation:
                        instrument = this._Instruments.SingleOrDefault(i => i.Id == item.ObjectId);
                        if (instrument != null)
                        {
                            instrument.VmDerivativeRelation.ApplyChangeToUI(item.FieldsAndValues);
                        }
                        break;
                    case MetadataType.PriceRangeCheckRule:
                        instrument = this._Instruments.SingleOrDefault(i => i.Id == item.ObjectId);
                        if (instrument != null)
                        {
                            instrument.VmPriceRangeCheckRule.ApplyChangeToUI(item.FieldsAndValues);
                        }
                        break;
                    case MetadataType.WeightedPriceRule:
                        instrument = this._Instruments.SingleOrDefault(i => i.Id == item.ObjectId);
                        if (instrument != null)
                        {
                            instrument.VmWeightedPriceRule.ApplyChangeToUI(item.FieldsAndValues);
                        }
                        break;
                    default:
                        break;
                }
            }
        }

        public void Delete(DeleteMetadataObjectMessage message)
        {
            VmInstrument instrument;
            switch (message.MetadataType)
            {
                case MetadataType.QuotationSource:
                    this.RemoveQuotationSource(message.ObjectId);
                    break;
                case MetadataType.Instrument:
                    instrument = this._Instruments.SingleOrDefault(i => i.Id == message.ObjectId);
                    if (instrument != null)
                    {
                        if (instrument.SourceRelations != null)
                        {
                            instrument.SourceRelations.Clear();
                        }
                        instrument.VmDerivativeRelation = null;
                        instrument.VmPriceRangeCheckRule = null;
                        instrument.VmWeightedPriceRule = null;
                        this._Instruments.Remove(instrument);
                    }
                    break;
                case MetadataType.InstrumentSourceRelation:
                    VmInstrumentSourceRelation relation;
                    if(this.FindVmInstrumentSourceRelation(message.ObjectId, out relation, out instrument))
                    {
                        instrument.SourceRelations.Remove(relation);
                    }
                    break;
                case MetadataType.DerivativeRelation:
                    // TODO: Check if this will happen. 
                    break;
                case MetadataType.PriceRangeCheckRule:
                    // TODO: Check if this will happen.
                    break;
                case MetadataType.WeightedPriceRule:
                    // TODO: Check if this will happen.
                    break;
                default:
                    break;
            }
        }

        public void RemoveQuotationSource(int id)
        {
            VmQuotationSource source = this._QuotationSources.SingleOrDefault(s => s.Id == id);
            if (source != null)
            {
                this._QuotationSources.Remove(source);
            }
        }

        public void SetPrimitiveQuotation(PrimitiveQuotation quotation)
        {
            VmInstrument vmInstrument  = this._Instruments.SingleOrDefault(i => i.Id == quotation.InstrumentId);
            if (vmInstrument != null)
            {
                VmInstrumentSourceRelation relation = vmInstrument.SourceRelations.SingleOrDefault(r => r.SourceId == quotation.SourceId);
                if (relation != null)
                {
                    if (relation.SetSourceQuotation(new VmSourceQuotation(quotation)))
                    {
                        for (int i = 0; i < vmInstrument.SourceRelations.Count; i++)
                        {
                            VmInstrumentSourceRelation relation2 = vmInstrument.SourceRelations[i];
                            if (!object.ReferenceEquals(relation2, relation))
                            {
                                relation2.SetSourceQuotation(new VmSourceQuotation(new PrimitiveQuotation() { Timestamp = quotation.Timestamp }));
                            }
                        }
                    }
                }
            }
        }

        internal void SwitchActiveSource(SwitchRelationBooleanPropertyMessage message)
        {
            VmInstrument vmInstrument = this._Instruments.Single(i => i.Id == message.InstrumentId);
            vmInstrument.SourceRelations.Single(r => r.Id == message.NewRelationId).ApplyChangeToUI(message.PropertyName, true);
            vmInstrument.SourceRelations.Single(r => r.Id == message.OldRelationId).ApplyChangeToUI(message.PropertyName, false);
        }

        internal void SetQuotation(QuotationsMessage message)
        {
            foreach (GeneralQuotation generalQuotation in message.Quotations)
            {
                VmInstrument vmInstrument = this._Instruments.SingleOrDefault(i => i.Id == generalQuotation.InstrumentId);
                if (vmInstrument != null)
                {
                    vmInstrument.SetQuotation(generalQuotation, vmInstrument.DecimalPlace);
                }
            }
        }

        private bool FindVmInstrumentSourceRelation(int relationId, out VmInstrumentSourceRelation relation, out VmInstrument instrument)
        {
            relation = null;
            instrument = null;
            foreach (VmInstrument vmInstrument in this._Instruments)
            {
                relation = vmInstrument.SourceRelations.SingleOrDefault(r => r.Id == relationId);
                if (relation != null)
                {
                    instrument = vmInstrument;
                    break;
                }
            }
            return relation != null;
        }
    }
}
