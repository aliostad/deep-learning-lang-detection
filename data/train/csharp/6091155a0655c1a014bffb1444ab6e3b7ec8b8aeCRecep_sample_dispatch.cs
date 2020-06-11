using System;
using System.Collections.Generic;
using System.Text;
namespace LimsProject.BusinessLayer
{
	public class CRecep_sample_dispatch: BusinessObjectBase
	{

		#region InnerClass
		public enum CRecep_sample_dispatchFields
		{
			Idrecep_sample,
			Dispatch_person,
			Dispatch_mail,
			Dispatch_curier,
			Dispatch_transport,
			Dispatch_fax,
			Dispatch_otro,
			Usernew,
			Datenew,
			Useredit,
			Dateedit,
			Status
		}
		#endregion

		#region Data Members

			long _idrecep_sample;
			short? _dispatch_person;
			short? _dispatch_mail;
			short? _dispatch_curier;
			short? _dispatch_transport;
			short? _dispatch_fax;
			short? _dispatch_otro;
			string _usernew;
			DateTime? _datenew;
			string _useredit;
			DateTime? _dateedit;
			bool? _status;

		#endregion

		#region Properties

		public long  Idrecep_sample
		{
			 get { return _idrecep_sample; }
			 set
			 {
				 if (_idrecep_sample != value)
				 {
					_idrecep_sample = value;
					 PropertyHasChanged("Idrecep_sample");
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

		public string  Usernew
		{
			 get { return _usernew; }
			 set
			 {
				 if (_usernew != value)
				 {
					_usernew = value;
					 PropertyHasChanged("Usernew");
				 }
			 }
		}

		public DateTime?  Datenew
		{
			 get { return _datenew; }
			 set
			 {
				 if (_datenew != value)
				 {
					_datenew = value;
					 PropertyHasChanged("Datenew");
				 }
			 }
		}

		public string  Useredit
		{
			 get { return _useredit; }
			 set
			 {
				 if (_useredit != value)
				 {
					_useredit = value;
					 PropertyHasChanged("Useredit");
				 }
			 }
		}

		public DateTime?  Dateedit
		{
			 get { return _dateedit; }
			 set
			 {
				 if (_dateedit != value)
				 {
					_dateedit = value;
					 PropertyHasChanged("Dateedit");
				 }
			 }
		}

		public bool?  Status
		{
			 get { return _status; }
			 set
			 {
				 if (_status != value)
				 {
					_status = value;
					 PropertyHasChanged("Status");
				 }
			 }
		}


		#endregion

		#region Validation

		internal override void AddValidationRules()
		{
			ValidationRules.AddRules(new Validation.ValidateRuleNotNull("Idrecep_sample", "Idrecep_sample"));
			ValidationRules.AddRules(new Validation.ValidateRuleStringMaxLength("Usernew", "Usernew",20));
			ValidationRules.AddRules(new Validation.ValidateRuleStringMaxLength("Useredit", "Useredit",20));
		}

		#endregion

	}
}
