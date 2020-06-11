using System;
using System.Collections;
using System.Collections.Generic;
using B4F.TotalGiro.Dal;

namespace B4F.TotalGiro.Instruments
{
    /// This class is used to instantiate InstrumentExchange objects
    /// The data is retrieved from the database using an instance of the Data Access Library <see cref="T:B4F.TotalGiro.DAL.NHSession">NHSession</see> class.
    public class InstrumentExchangeMapper
    {
        /// <summary>
        /// Get InstrumentExchange by ID
        /// </summary>
        /// <param name="session">Data access object</param>
        /// <param name="InstrumentExchangeID">Identifier</param>
        /// <returns>InstrumentExchange</returns>
        public static InstrumentExchange GetInstrumentExchange(IDalSession session, int InstrumentExchangeID)
        {
            return (InstrumentExchange)session.GetObjectInstance(typeof(InstrumentExchange), InstrumentExchangeID);
        }

        /// <summary>
        /// Get collection of system InstrumentExchanges
        /// </summary>
        /// <param name="session">Data access object</param>
        /// <returns>Collection of InstrumentExchanges</returns>
        public static IList GetInstrumentExchanges(IDalSession session)
        {
            return session.GetList(typeof(InstrumentExchange));
        }
    }
}
