using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

/// <summary>
/// Summary description for StockDispatchEntry
/// </summary>
public class StockDispatchEntry
{
	public StockDispatchEntry()
	{
		//
		// TODO: Add constructor logic here
		//
	}
       [Key()]

        public int ID { get; set; }

        public int? EMRID { get; set; }

        public decimal? DispatchQuantity { get; set; }

        public decimal? Rate { get; set; }

        public DateTime? DispatchOn { get; set; }

        public int? DispatchBy { get; set; }

        public string DispatchDocument { get; set; }

}