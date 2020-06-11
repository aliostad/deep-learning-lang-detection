using System;
using System.Collections.Generic;
using System.Text;
using System.Collections;

namespace SESD.MRP.REF
{
    public class DispatchProducts
    {
        private DispatchNote _objDispatchNote;

        public DispatchNote DispatchNote
        {
            get { return _objDispatchNote; }
            set { _objDispatchNote = value; }
        }

        private FinishProduct _objFinishProduct;

        public FinishProduct DispatchFinishProduct
        {
            get { return _objFinishProduct; }
            set { _objFinishProduct = value; }
        }

        private Decimal _lngDispatchQty;

        public Decimal DispatchQty
        {
            get { return _lngDispatchQty; }
            set { _lngDispatchQty = value; }
        }

        private String _strItem;
        public String Item
        {
            get 
            {
                _strItem = DispatchFinishProduct.Code;
                return _strItem; 
            }
        }
	
	}

    public class DispatchProductsCollec:CollectionBase
    {
        public void Add(DispatchProducts objDispatchNoteList)
        {
            this.InnerList.Add(objDispatchNoteList);
        }

        public void Delete(DispatchProducts objDispatchNoteList)
        {
            this.InnerList.Remove(objDispatchNoteList);
        }
    }
}
