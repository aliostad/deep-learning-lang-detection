using System;
using System.Collections;
using QuantBox.CSharp2CTPZQ;
using System.Collections.Generic;

namespace QuantBox.Helper.CTPZQ
{
    public sealed class CTPZQAPI
    {
        private static readonly CTPZQAPI instance = new CTPZQAPI();
        private CTPZQAPI()
        {
        }
        public static CTPZQAPI GetInstance()
        {
            return instance;
        }


        private IntPtr m_pMdApi = IntPtr.Zero;      //行情对象指针
        private IntPtr m_pTdApi = IntPtr.Zero;      //交易对象指针

        public void __RegTdApi(IntPtr pTdApi)
        {
            m_pTdApi = pTdApi;
        }

        public void __RegMdApi(IntPtr pMdApi)
        {
            m_pMdApi = pMdApi;
        }

        #region 合列列表
        private Dictionary<string, CZQThostFtdcInstrumentField> _dictInstruments = null;
        public void __RegInstrumentDictionary(Dictionary<string, CZQThostFtdcInstrumentField> dict)
        {
            _dictInstruments = dict;
        }

        public delegate void RspQryInstrument(CZQThostFtdcInstrumentField pInstrument);
        public event RspQryInstrument OnRspQryInstrument;
        public void FireOnRspQryInstrument(CZQThostFtdcInstrumentField pInstrument)
        {
            if (null != OnRspQryInstrument)
            {
                OnRspQryInstrument(pInstrument);
            }
        }

        public void ReqQryInstrument(string instrument)
        {
            if (null != _dictInstruments)
            {
                CZQThostFtdcInstrumentField value;
                if (_dictInstruments.TryGetValue(instrument, out value))
                {
                    FireOnRspQryInstrument(value);
                    return;
                }
            }

            if (!string.IsNullOrEmpty(instrument)
                    && null != m_pTdApi
                    && IntPtr.Zero != m_pTdApi)
            {
                TraderApi.TD_ReqQryInstrument(m_pTdApi, instrument);
            }
        }
        #endregion

        #region 保证金率
        //private Dictionary<string, CZQThostFtdcInstrumentMarginRateField> _dictMarginRate = null;
        //public void __RegInstrumentMarginRateDictionary(Dictionary<string, CZQThostFtdcInstrumentMarginRateField> dict)
        //{
        //    _dictMarginRate = dict;
        //}
        //public void ReqQryInstrumentMarginRate(string instrument)
        //{
        //    if (null != _dictMarginRate)
        //    {
        //        CZQThostFtdcInstrumentMarginRateField value;
        //        if (_dictMarginRate.TryGetValue(instrument, out value))
        //        {
        //            FireOnRspQryInstrumentMarginRate(value);
        //            return;
        //        }
        //    }

        //    if (!string.IsNullOrEmpty(instrument)
        //        && null != m_pTdApi
        //        && IntPtr.Zero != m_pTdApi)
        //    {
        //        TraderApi.TD_ReqQryInstrumentMarginRate(m_pTdApi, instrument);
        //    }
        //}        

        //public delegate void RspQryInstrumentMarginRate(CThostFtdcInstrumentMarginRateField pInstrumentMarginRate);
        //public event RspQryInstrumentMarginRate OnRspQryInstrumentMarginRate;
        //public void FireOnRspQryInstrumentMarginRate(CThostFtdcInstrumentMarginRateField pInstrumentMarginRate)
        //{
        //    if (null != OnRspQryInstrumentMarginRate)
        //    {
        //        OnRspQryInstrumentMarginRate(pInstrumentMarginRate);
        //    }
        //}
        #endregion

        #region 手续费率
        private Dictionary<string, CZQThostFtdcInstrumentCommissionRateField> _dictCommissionRate = null;
        public void __RegInstrumentCommissionRateDictionary(Dictionary<string, CZQThostFtdcInstrumentCommissionRateField> dict)
        {
            _dictCommissionRate = dict;
        }

        public void ReqQryInstrumentCommissionRate(string instrument)
        {
            if (null != _dictCommissionRate)
            {
                CZQThostFtdcInstrumentCommissionRateField value;
                if (_dictCommissionRate.TryGetValue(instrument, out value))
                {
                    FireOnRspQryInstrumentCommissionRate(value);
                    return;
                }
            }

            if (!string.IsNullOrEmpty(instrument)
                && null != m_pTdApi
                && IntPtr.Zero != m_pTdApi)
            {
                TraderApi.TD_ReqQryInstrumentCommissionRate(m_pTdApi, instrument);
            }
        }

        public delegate void RspQryInstrumentCommissionRate(CZQThostFtdcInstrumentCommissionRateField pInstrumentCommissionRate);
        public event RspQryInstrumentCommissionRate OnRspQryInstrumentCommissionRate;
        public void FireOnRspQryInstrumentCommissionRate(CZQThostFtdcInstrumentCommissionRateField pInstrumentCommissionRate)
        {
            if (null != OnRspQryInstrumentCommissionRate)
            {
                OnRspQryInstrumentCommissionRate(pInstrumentCommissionRate);
            }
        }
        #endregion

        #region 深度行情1
        private Dictionary<string, CZQThostFtdcDepthMarketDataField> _dictDepthMarketData = null;
        public void __RegDepthMarketDataDictionary(Dictionary<string, CZQThostFtdcDepthMarketDataField> dict)
        {
            _dictDepthMarketData = dict;
        }

        public void ReqQryDepthMarketData(string instrument)
        {
            if (null != _dictDepthMarketData)
            {
                CZQThostFtdcDepthMarketDataField value;
                if (_dictDepthMarketData.TryGetValue(instrument, out value))
                {
                    FireOnRspQryDepthMarketData(value);
                    return;
                }
            }

            if (!string.IsNullOrEmpty(instrument)
                && null != m_pTdApi
                && IntPtr.Zero != m_pTdApi)
            {
                TraderApi.TD_ReqQryDepthMarketData(m_pTdApi, instrument);
            }
        }

        public delegate void RspQryDepthMarketData(CZQThostFtdcDepthMarketDataField pDepthMarketData);
        public event RspQryDepthMarketData OnRspQryDepthMarketData;
        public void FireOnRspQryDepthMarketData(CZQThostFtdcDepthMarketDataField pDepthMarketData)
        {
            if (null != OnRspQryDepthMarketData)
            {
                OnRspQryDepthMarketData(pDepthMarketData);
            }
        }
        #endregion

        #region 深度行情2
        public delegate void RtnDepthMarketData(CZQThostFtdcDepthMarketDataField pDepthMarketData);
        public event RtnDepthMarketData OnRtnDepthMarketData;
        public void FireOnRtnDepthMarketData(CZQThostFtdcDepthMarketDataField pDepthMarketData)
        {
            if (null != OnRtnDepthMarketData)
            {
                OnRtnDepthMarketData(pDepthMarketData);
            }
        }
        #endregion

        #region 交易所状态
        public delegate void RtnInstrumentStatus(CZQThostFtdcInstrumentStatusField pInstrumentStatus);
        public event RtnInstrumentStatus OnRtnInstrumentStatus;
        public void FireOnRtnInstrumentStatus(CZQThostFtdcInstrumentStatusField pInstrumentStatus)
        {
            if (null != OnRtnInstrumentStatus)
            {
                OnRtnInstrumentStatus(pInstrumentStatus);
            }
        }
        #endregion

        #region OnStrategyStart
        public EventHandler OnLive;
        public void EmitOnLive()
        {
            if (OnLive != null)
                OnLive(null, EventArgs.Empty);
        }
        #endregion
    }
}
