using COSC4210.MusicalIntruments.Web.Data_Contracts;
using COSC4210.MusicalIntruments.Web.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace COSC4210.MusicalIntruments.Web.Instruments
{
    public class MusicalInstrumentPortal : IMusicalInstrumentPortal
    {

        public void SaveInstrumentType(InstrumentType instrumentType)
        {
            DanielsEntities context = new DanielsEntities();

            COSC4210.MusicalIntruments.Web.Models.Type instrumentItemType = new COSC4210.MusicalIntruments.Web.Models.Type();

            if (instrumentType.ID != 0)
            {
                var etItemType = from t in context.Types
                                 where t.ID == instrumentType.ID
                                 select t;

                instrumentItemType = etItemType.FirstOrDefault();

                instrumentItemType.TypeName = instrumentType.TypeName;

            }
            else
            {
                instrumentItemType.TypeName = instrumentType.TypeName;
                context.Types.Add(instrumentItemType);
            }

            instrumentItemType.LastModified = DateTime.Now;
            instrumentItemType.LastModifiedBy = "Phil";
            context.SaveChanges();
        }

        public InstrumentType GetInstrumentType(int ID)
        {
            DanielsEntities context = new DanielsEntities();

            InstrumentType instrumentType = null;

            var queryType = from t in context.Types
                            where t.ID == ID
                            select new InstrumentType
                            {
                                ID = t.ID,
                                TypeName = t.TypeName
                            };

            instrumentType = queryType.FirstOrDefault();

            return instrumentType;
        }

        public IList<InstrumentType> GetInstrumentTypes()
        {
            DanielsEntities context = new DanielsEntities();

            IQueryable<InstrumentType> queryTypes = from t in context.Types
                                                    orderby t.TypeName
                                                    select new Data_Contracts.InstrumentType
                                                    {
                                                        ID = t.ID,
                                                        TypeName = t.TypeName

                                                    };
            return queryTypes.ToList();
        }















        public void SaveInstrumentCategory(InstrumentCategory instrumentCategory)
        {
            DanielsEntities context = new DanielsEntities();

            COSC4210.MusicalIntruments.Web.Models.Category instrumentItemCategory = new COSC4210.MusicalIntruments.Web.Models.Category();

            if (instrumentCategory.ID != 0)
            {
                var etItemCategory = from t in context.Categories
                                     where t.ID == instrumentCategory.ID
                                     select t;

                instrumentItemCategory = etItemCategory.FirstOrDefault();

                instrumentItemCategory.CategoryName = instrumentCategory.InstrumentCategoryName;
                

            }
            else
            {
                instrumentItemCategory.CategoryName = instrumentCategory.InstrumentCategoryName;
                context.Categories.Add(instrumentItemCategory);
            }

            instrumentItemCategory.LastModified = DateTime.Now;
            instrumentItemCategory.LastModifiedBy = "Phil";
            context.SaveChanges();
        }

        public InstrumentCategory GetInstrumentCategory(int ID)
        {
            DanielsEntities context = new DanielsEntities();

            var queryCategory = from t in context.Categories
                                where t.ID == ID
                                select new InstrumentCategory
                                {
                                    ID = t.ID,
                                    InstrumentCategoryName = t.CategoryName
                                };

            return queryCategory.FirstOrDefault();
        }

        public IList<InstrumentCategory> GetInstrumentCategories()
        {
            DanielsEntities context = new DanielsEntities();

            IQueryable<InstrumentCategory> queryCategorys = from t in context.Categories
                                                            orderby t.CategoryName
                                                            select new Data_Contracts.InstrumentCategory
                                                            {
                                                                ID = t.ID,
                                                                InstrumentCategoryName = t.CategoryName

                                                            };
            return queryCategorys.ToList();
        }















        public IList<MusicalInstrument> GetMusicalInstruments()
        {
            DanielsEntities context = new DanielsEntities();

            IQueryable<MusicalInstrument> queryMusicalInstrument = from t in context.Items
                                                                   orderby t.ItemName
                                                                   select new Data_Contracts.MusicalInstrument
                                                                   {
                                                                       ID = t.ID,
                                                                       Name = t.ItemName,
                                                                       TypeID = t.TypeID,
                                                                       Brand = t.Brand,
                                                                       Price = t.Price
                                                                   };
            return queryMusicalInstrument.ToList();
        }

        public void SaveMusicalInstrument(MusicalInstrument MusicalInstrument)
        {
            DanielsEntities context = new DanielsEntities();

            COSC4210.MusicalIntruments.Web.Models.Item instrumentItem = new COSC4210.MusicalIntruments.Web.Models.Item();

            if (MusicalInstrument.ID != 0)
            {
                var etItem = from t in context.Items
                             where t.ID == MusicalInstrument.ID
                             select t;

                instrumentItem = etItem.FirstOrDefault();
                instrumentItem.ItemName = MusicalInstrument.Name;
                instrumentItem.Brand = MusicalInstrument.Brand;
                instrumentItem.TypeID = MusicalInstrument.TypeID;
                instrumentItem.Price = MusicalInstrument.Price;

            }
            else
            {
                instrumentItem.ItemName = MusicalInstrument.Name;
                instrumentItem.Brand = MusicalInstrument.Brand;
                instrumentItem.Price = MusicalInstrument.Price;
                instrumentItem.TypeID = MusicalInstrument.TypeID;
                context.Items.Add(instrumentItem);
            }


            instrumentItem.LastModified = DateTime.Now;
            instrumentItem.LastModifiedBy = "Phil";
            context.SaveChanges();
        }

        public MusicalInstrument GetMusicalInstrument(int ID)
        {
            DanielsEntities context = new DanielsEntities();

            MusicalInstrument instrument = null;

            var queryItem = from t in context.Items
                            where t.ID == ID
                            select new MusicalInstrument
                            {
                                ID = t.ID,
                                Name = t.ItemName,
                                TypeID = t.TypeID,
                                Brand = t.Brand,
                                Price = t.Price
                            };
            instrument = queryItem.FirstOrDefault();

            instrument.Categories = GetCategoryAssociations(instrument.ID);

            return instrument;
        }

        public IList<InstrumentCategory> DeleteCategoryAssociation(int InstrumentID, int CategoryID)
        {
            DanielsEntities context = new DanielsEntities();

           var assoc = from t in context.ItemCategories
                        where t.ItemID == InstrumentID && t.CategoryID == CategoryID
                        select t;

            ItemCategory category = assoc.FirstOrDefault();

            context.ItemCategories.Remove(category);
            context.SaveChanges();
            return GetCategoryAssociations(InstrumentID);
        }

        public IList<InstrumentCategory> GetCategoryAssociations(int InstrumentID)
        {
            //got this code from Allyson
            DanielsEntities context = new DanielsEntities();

            IList<Data_Contracts.InstrumentCategory> associatedCategories = null;

            //using the ProductId parameter, create a list of Categories that are related to that product
            //first we query the domain model model and get a list and then convert to the from domain model objects to DataContract objects
            var etAssociatedCategories = (from a in context.ItemCategories.Include("Category") //join
                                          where a.ItemID == InstrumentID
                                          select a.Category)  //a.InstrumentCategory is a type in the domain model
                                           .AsEnumerable()  //covert the first expression tree in to an Enumeration of Domain.InstrumentCategory which are objects in the domain model
                                           .Select(c => new Data_Contracts.InstrumentCategory  //now query the Enumeration, a new expression tree is created 
                                           {
                                               InstrumentCategoryName = c.CategoryName,
                                               ID = c.ID
                                           });
            //now etAssociatedCategores is an expression tree that willl create a list of DataContract.Categories

            //execute expression tree and convert to a list
            associatedCategories = etAssociatedCategories.ToList<Data_Contracts.InstrumentCategory>();

            return associatedCategories;
        }

        public IList<InstrumentCategory> AddCategoryAssociation(int InstrumentID, int CategoryID)
        {
            DanielsEntities context = new DanielsEntities();

            Models.ItemCategory association = new ItemCategory();

            association.CategoryID = CategoryID;
            association.ItemID = InstrumentID;
            association.LastModified = DateTime.Now;
            association.LastModifiedBy = "Phil";

            context.ItemCategories.Add(association);

            context.SaveChanges();

            return GetCategoryAssociations(InstrumentID);
        }
    }
}