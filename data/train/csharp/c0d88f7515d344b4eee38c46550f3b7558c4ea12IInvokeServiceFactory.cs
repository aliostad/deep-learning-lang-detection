using System;
using Core.Model.Data.DataModel;
using Core.Model.InvokeMethods.Base.Invoke.DataModel;

namespace Core.Model.InvokeMethods.Base.Invoke.Service
{
	/// <summary>
	/// Интерфейс фабрики сервисов исполнения.
	/// </summary>
	public interface IInvokeServiceFactory
	{
		/// <summary>
		/// Добавляет событие при извлечении из очереди.
		/// </summary>
		/// <param name="action">Событие.</param>
		void AddOnDequeueEvent(Action<DataInvoke> action);

		/// <summary>
		/// Возвращает подходящий сервис для исполнения.
		/// </summary>
		/// <param name="invoked_data">Исполняемые данные.</param>
		/// <param name="invoke_type">Тип исполнения.</param>
		/// <returns>Серис исполнения.</returns>
		IInvokeService GetInvokeService(DataInvoke invoked_data, InvokeType invoke_type);
	}
}
