using System;
using Core.Model.Data.DataModel;
using Core.Model.InvokeMethods.Base.Invoke.DataModel;

namespace Core.Model.InvokeMethods.Base.Invoke.Service
{
	/// <summary>
	/// Базовый класс сервиса исполнения.
	/// </summary>
	public abstract class InvokeServiceBase : IInvokeService
	{
		#region Fields

		/// <summary>
		/// Очередь на исполнение.
		/// </summary>
		private readonly QueueInvoker<DataInvoke> _queueInvoker;

		/// <summary>
		/// Событие после исполнения.
		/// </summary>
		public Action<DataInvoke> OnAfterInvoke { get; set; }

		/// <summary>
		/// Тип исполнения.
		/// </summary>
		protected virtual InvokeType InvokeType
		{
			get
			{
				return InvokeType.Manual;
			}
		}

		#endregion

		#region Constructor

		/// <summary>
		/// Инициализирует очердь на исполнение.
		/// </summary>
		protected InvokeServiceBase()
		{
			_queueInvoker = new QueueInvoker<DataInvoke>(OnDequeue);
		}

		#endregion

		#region Methods

		/// <summary>
		/// Отправка данных на исполнение.
		/// </summary>
		/// <param name="invoked_data">Данные для исполнения.</param>
		public void Invoke(DataInvoke invoked_data)
		{
			switch (InvokeType)
			{
				case InvokeType.Manual:
					break;
				case InvokeType.Local:
				case InvokeType.Remote:
					invoked_data.InvokeType = InvokeType;
					break;
				case InvokeType.Auto:
					invoked_data.InvokeType = GetAutoInvokeType();
					break;
			}

			_queueInvoker.Enqueue(invoked_data);
		}

		/// <summary>
		/// Исполнение метода.
		/// </summary>
		/// <param name="invoked_data">Исполняемые данные.</param>
		/// <param name="callback">Функция, вызываемая по окончанию исполнения.</param>
		protected abstract void InvokeMethod(DataInvoke invoked_data, Action<DataInvoke> callback);
		
		/// <summary>
		/// Событие при извлечении из очереди.
		/// </summary>
		/// <param name="invoked_data">Данные для исполнения.</param>
		private void OnDequeue(DataInvoke invoked_data)
		{
			InvokeMethod(invoked_data, OnAfterInvoke);
		}

		/// <summary>
		/// Автоматический выбор типа исполнения.
		/// </summary>
		/// <returns>Тип исполнения.</returns>
		protected InvokeType GetAutoInvokeType()
		{
			return InvokeType.Local;
		}

		#endregion
	}
}
