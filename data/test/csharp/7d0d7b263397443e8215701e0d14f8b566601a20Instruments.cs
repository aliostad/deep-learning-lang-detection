using System;
using System.Collections.Generic;
using System.Linq;

namespace Risk
{
    /// <summary>
    /// Инструменты
    /// </summary>
    [Table("Instruments", KeyFields = "SecCode")]
    public class Instruments : Table<Instrument>
    {
        #region Overrides of Table<Instrument>

        /// <summary>
        ///  Trigger on Add, Update, Delete
        /// </summary>
        public override void TriggerAfter(TriggerCollection<Instrument> items)
        {
            base.TriggerAfter(items);

            var orders = Server.Orders.Where(s => string.IsNullOrEmpty(s.InstrumentName)).ToList();

            foreach (var order in orders)
            {
                var instrument = Server.Instruments.FirstOrDefault(s => s.SecCode == order.SecCode);
                if (instrument == null)
                    continue;
                order.InstrumentName = instrument.Name;
                order.InstrumentClassCode = instrument.ClassCode;
                order.InstrumentClassName = instrument.ClassName;
            }

            orders.RemoveAll(s => string.IsNullOrEmpty(s.InstrumentName));

            if (orders.Any())
                ServerBase.Current.Execute(Command.Update("Orders", orders, "InstrumentName,InstrumentClassCode,InstrumentClassName"));
        }

        #endregion
    }
}
