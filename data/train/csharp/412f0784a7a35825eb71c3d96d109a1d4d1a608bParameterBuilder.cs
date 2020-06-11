using StorageControl.Domain.Model.Entities;

namespace StorageControl.DataAccess.Builders
{
    public static class ParameterBuilder
    {
        public static object ToParameterizedObject(this Instrument instrument, bool withoutId)
        {
            if (withoutId)
                return new
                {
                    @manufacturer = instrument.Manufacturer,
                    @model = instrument.Model,
                    @unit_price = instrument.UnitPrice,
                    @amount = instrument.Amount,
                    @category_id = instrument.Category.Id,
                    @type_id = instrument.Type.Id
                };
            else
                return new
                {
                    @id = instrument.Id,
                    @manufacturer = instrument.Manufacturer,
                    @model = instrument.Model,
                    @unit_price = instrument.UnitPrice,
                    @amount = instrument.Amount,
                    @category_id = instrument.Category.Id,
                    @type_id = instrument.Type.Id
                };
        }
        
        public static object ToParameterizedObject(this InstrumentType instrumentType, bool withoutId)
        {
            if (withoutId)
                return new { @name = instrumentType.Name };
            else
                return new { @id = instrumentType.Id, @name = instrumentType.Name };
        }

        public static object ToParameterizedObject(this Category category, bool withoutId)
        {
            if (withoutId)
                return new { @name = category.Name };
            else
                return new { @id = category.Id, @name = category.Name };
        }
    }
}
