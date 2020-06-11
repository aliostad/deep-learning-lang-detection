using System;
using System.Collections;
using TiS.Core.TisCommon.Services;
using System.Collections.Generic;

namespace TiS.Core.TisCommon.Customizations
{
    public class TisInvokeTypesMngr
	{
        private DictionaryWithEvents<string, ITisInvokeType> m_oInvokeTypes;
        private TisGetInvokerDelegate m_oGetInvokerDelegate;

		public TisInvokeTypesMngr (
            DictionaryWithEvents<string, ITisInvokeType> invokeTypes, 
			TisGetInvokerDelegate oGetInvokerDelegate)
		{
            m_oInvokeTypes = invokeTypes;
            m_oGetInvokerDelegate = oGetInvokerDelegate;

            foreach (var invokeType in invokeTypes.Values)
			{
                invokeType.OnGetInvoker += m_oGetInvokerDelegate;
			}
		}

        #region IDisposable Members

        public void Dispose()
        {
            foreach (ITisInvokeType oInvokeType in m_oInvokeTypes.Values)
            {
                oInvokeType.OnGetInvoker -= m_oGetInvokerDelegate;
            }

            m_oInvokeTypes.Clear();
        }

        #endregion

		#region ITisInvokeTypesMngr Members

		public ITisInvokeType[] All
		{
			get
			{
				ITisInvokeType[] _InvokeTypes = (ITisInvokeType[]) Array.CreateInstance (typeof (ITisInvokeType), m_oInvokeTypes.Values.Count);


				m_oInvokeTypes.Values.CopyTo (_InvokeTypes, 0);

				return _InvokeTypes;
			}
		}

		public List<string> InvokeTypeNames
		{
			get
			{
				return new List<string>(m_oInvokeTypes.Keys);
			}
		}

		public ITisInvokeType GetInvokeType (string sInvokeTypeName)
		{
			return (ITisInvokeType) m_oInvokeTypes [sInvokeTypeName];
		}

		public bool Contains(string sInvokeTypeName)
		{
			return m_oInvokeTypes.ContainsKey (sInvokeTypeName);
		}

		#endregion
    }
}
