using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SAM.Spike.Library
{
	public class Dispatch
	{
		public Model Model { get; set; }
		public Action<Accion> Request { get; set; }
		internal Dispatch() { }

		public static Dispatch NewFrom(Model model)
		{
			var dispatch = new DispatchFactory().NewFrom(model);
			return dispatch;
		}
	}


	////////////////////////////////////////////////////////////
	public interface IDispatchFactory
	{
		Dispatch NewFrom(Model model);
	}

	public class DispatchFactory : IDispatchFactory
	{
		public Dispatch NewFrom(Model model)
		{
			var dispatch = new Dispatch();
			dispatch.Model = model;
			dispatch.Request = (accion) =>
			{
				Console.WriteLine("Dispatch [{0}].", accion.Type);
				switch (accion.Type)
				{
					case "INC":
						model.Present("{ increaseBy: 1 }");
						break;
				}
			};
			return dispatch;
		}
	}

}
