using System;
using System.Collections.Generic;
using Core.Model.Data.DataModel;
using Core.Model.Data.Service;
using Core.Model.InvokeMethods.Base.Invoke.DataModel;
using Core.Model.InvokeMethods.Base.Methods.Service;
using Core.Model.InvokeMethods.Local.CSharp.Assembly.Service;
using Core.Model.InvokeMethods.Local.CSharp.Invoke.Service;
using Core.Model.InvokeMethods.Local.CSharp.Methods.DataModel;
using Core.Model.InvokeMethods.Local.CSharp.Methods.Service;
using Core.Model.InvokeMethods.Local.ExecutableFile.Invoke.Service;
using Core.Model.InvokeMethods.Local.ExecutableFile.Methods.DataModel;
using Core.Model.InvokeMethods.Local.ExecutableFile.Methods.Service;
using Core.Model.InvokeMethods.Remote.Service;
using Core.Model.Network.Service;

namespace Core.Model.InvokeMethods.Base.Invoke.Service
{
	/// <summary>
	/// Фабрика сервисов исполнения.
	/// </summary>
	public class InvokeServiceFactory : IInvokeServiceFactory
	{
		#region Fields

		/// <summary>
		/// Сервис для работы и хранения методов.
		/// </summary>
		private readonly IMethodService _methodService;

		/// <summary>
		/// Сервис для работы с библиотеками C#.
		/// </summary>
		private readonly IAssemblyService _assemblyService;

		/// <summary>
		/// Сервис координации.
		/// </summary>
		private readonly ICoordinationService _coordinationService;

		/// <summary>
		/// Сервис хранения данных.
		/// </summary>
		private readonly IDataService<DataInvoke> _dataService;

		/// <summary>
		/// 
		/// </summary>
		private readonly IWebServerService _webServerService;

		/// <summary>
		/// Словарь сервисов исполнения.
		/// </summary>
		private readonly Dictionary<Type, IInvokeService> _serviceDictionary;

		private readonly RemoteInvokeService _remoteInvokeService;

		#endregion

		#region Constructor

		/// <summary>
		/// Инициализирует сервисы.
		/// </summary>
		/// <param name="method_service">Сервис для работы и хранения методов.</param>
		/// <param name="assembly_service">Сервис для работы с библиотеками C#.</param>
		/// <param name="coordination_service">Сервис координации.</param>
		/// <param name="data_service">Сервис хранения данных.</param>
		/// <param name="web_server_service"></param>
		public InvokeServiceFactory(IMethodService method_service, IAssemblyService assembly_service, ICoordinationService coordination_service,
			IDataService<DataInvoke> data_service, IWebServerService web_server_service, RemoteInvokeService remote_invoke_service)
		{
			_methodService = method_service;
			_assemblyService = assembly_service;
			_coordinationService = coordination_service;
			_webServerService = web_server_service;

			_remoteInvokeService = remote_invoke_service;// new RemoteInvokeService(_coordinationService, _webServerService);
			var invoke_c_sharp_method = new InvokeCSharpService(_assemblyService, _methodService, data_service);
			var invoke_executable_file = new InvokeExecutableFileService(new ExecutableFileMethodService(), data_service);
			
			_serviceDictionary = new Dictionary<Type, IInvokeService>
			{
				/*{typeof(RemoteInvokeService), remote_invoke_service},
				{typeof(InvokeCSharpService), invoke_c_sharp_method},*/
				{typeof(CSharpMethod), invoke_c_sharp_method},
				{typeof(ExecutableFileMethod), invoke_executable_file}
			};
		}

		#endregion

		#region Methods/Public

		/// <summary>
		/// Добавляет событие при извлечении из очереди.
		/// </summary>
		/// <param name="action">Событие.</param>
		public void AddOnDequeueEvent(Action<DataInvoke> action)
		{
			_remoteInvokeService.OnAfterInvoke += action;
			foreach (var service in _serviceDictionary)
			{
				service.Value.OnAfterInvoke += action;
			}
		}
		
		/// <summary>
		/// Возвращает подходящий сервис для исполнения.
		/// </summary>
		/// <param name="invoked_data">Исполняемые данные.</param>
		/// <param name="invoke_type">Тип исполнения.</param>
		/// <returns>Серис исполнения.</returns>
		public IInvokeService GetInvokeService(DataInvoke invoked_data, InvokeType invoke_type = InvokeType.Manual)
		{
			switch (invoke_type)
			{
				case InvokeType.Manual:
					switch (invoked_data.InvokeType)
					{
						case InvokeType.Remote:
							return _remoteInvokeService;
						case InvokeType.Local:
							return _serviceDictionary[invoked_data.Method.MethodType];
					}
					break;
				case InvokeType.Remote:
					return _remoteInvokeService;
				case InvokeType.Local:
					return _serviceDictionary[invoked_data.Method.MethodType];
			}

			throw new Exception(string.Format("InvokeServiceFactory.GetInvokeService -> Тип {0} недопустим.", invoked_data.InvokeType));
		}

		#endregion
	}
}
