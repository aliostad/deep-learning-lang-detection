using System;
using PowerLanguage;

namespace Zeghs.Events {
	/// <summary>
	///   Instrument 商品資料更動事件(當 Instrument 商品資料新增或修改時會觸發此事件)
	/// </summary>
	public sealed class InstrumentChangeEvent : EventArgs {
		private int __iDataStream = 0;
		private IInstrument __cInstrument = null;
		
		/// <summary>
		///   [取得] IInstrument 商品資料
		/// </summary>
		public IInstrument Data {
			get {
				return __cInstrument;
			}
		}

		/// <summary>
		///   [取得] 資料串流的編號
		/// </summary>
		public int data_stream {
			get {
				return __iDataStream;
			}
		}

		internal InstrumentChangeEvent(IInstrument instrument, int dataIndex) {
			__cInstrument = instrument;
			__iDataStream = dataIndex + 1;
		}
	}
}