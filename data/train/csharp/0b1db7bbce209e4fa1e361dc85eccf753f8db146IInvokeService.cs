using System;
using Core.Model.Data.DataModel;

namespace Core.Model.InvokeMethods.Base.Invoke.Service
{
	/// <summary>
	/// Интерфейс сервиса исполнения.
	/// </summary>
	public interface IInvokeService
	{
		/// <summary>
		/// Событие после исполнения.
		/// </summary>
		Action<DataInvoke> OnAfterInvoke { get; set; }
		
		/// <summary>
		/// Отправка данных на исполнение.
		/// </summary>
		/// <param name="invoked_data">Данные для исполнения.</param>
		void Invoke(DataInvoke invoked_data);
	}
}
