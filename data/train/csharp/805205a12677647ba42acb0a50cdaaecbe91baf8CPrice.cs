using System;
using System.Collections.Generic;
using System.Text;
namespace LimsProject.BusinessLayer
{
	public class CPrice: BusinessObjectBase
	{

		#region InnerClass
		public enum CPriceFields
		{
			Idprice,
			Cod_price,
			Dispatch_person,
			Dispatch_mail,
			Dispatch_curier,
			Dispatch_transport,
			Dispatch_fax,
			Dispatch_otro,
			Request_reference
		}
		#endregion

		#region Data Members

			int _idprice;
			string _cod_price;
			short? _dispatch_person;
			short? _dispatch_mail;
			short? _dispatch_curier;
			short? _dispatch_transport;
			short? _dispatch_fax;
			short? _dispatch_otro;
			int? _request_reference;

		#endregion

		#region Properties

		public int  Idprice
		{
			 get { return _idprice; }
			 set
			 {
				 if (_idprice != value)
				 {
					_idprice = value;
					 PropertyHasChanged("Idprice");
				 }
			 }
		}

		public string  Cod_price
		{
			 get { return _cod_price; }
			 set
			 {
				 if (_cod_price != value)
				 {
					_cod_price = value;
					 PropertyHasChanged("Cod_price");
				 }
			 }
		}

		public short?  Dispatch_person
		{
			 get { return _dispatch_person; }
			 set
			 {
				 if (_dispatch_person != value)
				 {
					_dispatch_person = value;
					 PropertyHasChanged("Dispatch_person");
				 }
			 }
		}

		public short?  Dispatch_mail
		{
			 get { return _dispatch_mail; }
			 set
			 {
				 if (_dispatch_mail != value)
				 {
					_dispatch_mail = value;
					 PropertyHasChanged("Dispatch_mail");
				 }
			 }
		}

		public short?  Dispatch_curier
		{
			 get { return _dispatch_curier; }
			 set
			 {
				 if (_dispatch_curier != value)
				 {
					_dispatch_curier = value;
					 PropertyHasChanged("Dispatch_curier");
				 }
			 }
		}

		public short?  Dispatch_transport
		{
			 get { return _dispatch_transport; }
			 set
			 {
				 if (_dispatch_transport != value)
				 {
					_dispatch_transport = value;
					 PropertyHasChanged("Dispatch_transport");
				 }
			 }
		}

		public short?  Dispatch_fax
		{
			 get { return _dispatch_fax; }
			 set
			 {
				 if (_dispatch_fax != value)
				 {
					_dispatch_fax = value;
					 PropertyHasChanged("Dispatch_fax");
				 }
			 }
		}

		public short?  Dispatch_otro
		{
			 get { return _dispatch_otro; }
			 set
			 {
				 if (_dispatch_otro != value)
				 {
					_dispatch_otro = value;
					 PropertyHasChanged("Dispatch_otro");
				 }
			 }
		}

		public int?  Request_reference
		{
			 get { return _request_reference; }
			 set
			 {
				 if (_request_reference != value)
				 {
					_request_reference = value;
					 PropertyHasChanged("Request_reference");
				 }
			 }
		}


		#endregion

		#region Validation

		internal override void AddValidationRules()
		{
			ValidationRules.AddRules(new Validation.ValidateRuleNotNull("Idprice", "Idprice"));
			ValidationRules.AddRules(new Validation.ValidateRuleStringMaxLength("Cod_price", "Cod_price",20));
		}

		#endregion

	}
}
