using System;
using Core.Model.InvokeMethods.Base.Invoke.DataModel;

namespace Core.Model.Data.DataModel
{
	/// <summary>
	/// Исполняемые данные.
	/// </summary>
	public class DataInvoke : DataBase
	{
		#region Properties

		/// <summary>
		/// Данные запрашиваются.
		/// </summary>
		public bool IsRequestData { get; set; }
		
		/// <summary>
		/// Тип исполнения.
		/// </summary>
		public InvokeType? InvokeType { get; set; }

		#endregion

		#region Constructor

		/// <summary>
		/// Инициализирует по идентификатору и значению.
		/// </summary>
		/// <param name="id">Идентфиикатор.</param>
		/// <param name="value">Значение.</param>
		public DataInvoke(Guid id, object value)
			: base(id, value)
		{
			InvokeType = InvokeMethods.Base.Invoke.DataModel.InvokeType.Auto;
		}

		/// <summary>
		/// Инициализирует по идентификатору с пустым начением.
		/// </summary>
		/// <param name="id">Идентфиикатор.</param>
		public DataInvoke(Guid id)
			: base(id)
		{
			InvokeType = InvokeMethods.Base.Invoke.DataModel.InvokeType.Auto;
		}

		/// <summary>
		/// Инициализирует с новым идентификатором и пустым значением.
		/// </summary>
		public DataInvoke() 
			: this(Guid.NewGuid())
		{
			InvokeType = InvokeMethods.Base.Invoke.DataModel.InvokeType.Auto;
		}

		/// <summary>
		/// Инициализирует с указанным значением и новым идентфиикатором.
		/// </summary>
		/// <param name="value">Значение.</param>
		public DataInvoke(object value)
			: this(Guid.NewGuid(), value)
		{
			InvokeType = InvokeMethods.Base.Invoke.DataModel.InvokeType.Auto;
		}

		#endregion

		public static implicit operator DataInvoke(double data)
		{
			return new DataInvoke(data);
		}

		public static implicit operator DataInvoke(int data)
		{
			return new DataInvoke(data);
		}

		public static implicit operator DataInvoke(string data)
		{
			return new DataInvoke(data);
		}

		public DataInvoke<T> SetType<T>()
		{
			DataInvoke<T> result;
			if (HasValue)
			{
				result = new DataInvoke<T>(Id, (T)Value);
			}
			else
			{
				result = new DataInvoke<T>(Id);
			}

			result.InvokeType = InvokeType;
			result.IsRequestData = IsRequestData;
			result.InputIds = InputIds;

			return result;
		}
	}

	public class DataInvoke<T> : DataInvoke
	{
		#region Properties

		/// <summary>
		/// Данные запрашиваются.
		/// </summary>
		public bool IsRequestData { get; set; }

		/// <summary>
		/// Тип исполнения.
		/// </summary>
		public InvokeType? InvokeType { get; set; }

		public new T Value
		{
			get { return (T)base.Value; }
			set { _value = value; }
		}

		#endregion

		#region Constructor

		/// <summary>
		/// Инициализирует по идентификатору и значению.
		/// </summary>
		/// <param name="id">Идентфиикатор.</param>
		/// <param name="value">Значение.</param>
		public DataInvoke(Guid id, T value)
			: base(id, value)
		{
			InvokeType = InvokeMethods.Base.Invoke.DataModel.InvokeType.Auto;
		}

		/// <summary>
		/// Инициализирует по идентификатору с пустым начением.
		/// </summary>
		/// <param name="id">Идентфиикатор.</param>
		public DataInvoke(Guid id)
			: base(id)
		{
			InvokeType = InvokeMethods.Base.Invoke.DataModel.InvokeType.Auto;
		}

		/// <summary>
		/// Инициализирует с новым идентификатором и пустым значением.
		/// </summary>
		public DataInvoke()
			: this(Guid.NewGuid())
		{
			InvokeType = InvokeMethods.Base.Invoke.DataModel.InvokeType.Auto;
		}

		/// <summary>
		/// Инициализирует с указанным значением и новым идентфиикатором.
		/// </summary>
		/// <param name="value">Значение.</param>
		public DataInvoke(T value)
			: this(Guid.NewGuid(), value)
		{
			InvokeType = InvokeMethods.Base.Invoke.DataModel.InvokeType.Auto;
		}

		#endregion

		public static implicit operator DataInvoke<T>(T data)
		{
			return new DataInvoke<T>(data);
		}
	}
}