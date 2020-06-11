using System;
using System.Collections.Generic;
using System.Text;
using System.Text.RegularExpressions;

namespace BRE.Lib.TermStructures
{
    using UV.Lib.Hubs;
    using UV.Lib.Products;

    using UV.Lib.DatabaseReaderWriters.Queries;
    using BRE.Lib.Utilities;

    /// <summary>
    /// This class will read the information loaded from the database.
    /// It will also parse the information out to the hedge options information.
    /// </summary>
    public class HedgeOptionsReader
    {

        #region Members
        // *****************************************************************
        // ****                     Members                             ****
        // *****************************************************************
        //    
        private Dictionary<InstrumentName, HedgeOptions> m_HedgeOptionsByInstrumentName;
        private LogHub m_Log;
        #endregion// members


        #region Constructors
        // *****************************************************************
        // ****                     Constructors                        ****
        // *****************************************************************
        //
        //
        //       
        public HedgeOptionsReader(LogHub log)
        {
            m_Log = log;
            m_HedgeOptionsByInstrumentName = new Dictionary<InstrumentName, HedgeOptions>();
        }
        #endregion//Constructors


        #region no Properties
        // *****************************************************************
        // ****                     Properties                          ****
        // *****************************************************************
        //
        //
        #endregion//Properties


        #region Public Methods
        // *****************************************************************
        // ****                     Public Methods                      ****
        // *****************************************************************
        //
        //
        //
        //
        //
        //
        /// <summary>
        /// This function will read the hedge options information from the resulting query.
        /// One instrument hedge options can only be read once, otherwise error jumps out.
        /// </summary>
        /// <param name="queryResult"></param>
        /// <returns></returns>
        public bool TryReadHedgeOptionsInformation(InstrumentInfoQuery queryResult)
        {
            bool isSuccess = false;
            InstrumentName quoteInstrument = queryResult.InstrumentName;
            List<InstrumentInfoItem> instrumentInfoItems = queryResult.Results;

            // Normally only one element in the list above is relevant and the dimension for the result is 1 normally.
            foreach (InstrumentInfoItem instrumentInfoItem in instrumentInfoItems)
            {
                if (m_HedgeOptionsByInstrumentName.ContainsKey(quoteInstrument))
                {
                    m_Log.NewEntry(LogLevel.Error, "Hedge options already setup for instrument {0}.", quoteInstrument);
                    continue;
                }
                else
                {
                    string instrumentNameTT = instrumentInfoItem.InstrumentNameTT;
                    string instrumentNameDatabase = instrumentInfoItem.InstrumentNameDatabase;
                    HedgeOptions hedgeOptions;
                    if (HedgeOptions.TryCreateHedgeOptions(quoteInstrument, instrumentNameTT, instrumentNameDatabase, m_Log, out hedgeOptions))
                    {
                        if (!TryGenerateHedgeOptions(quoteInstrument, instrumentInfoItem, hedgeOptions))
                            m_Log.NewEntry(LogLevel.Error, "Failed to generate hedge options for instrument {0}.", quoteInstrument);
                        else
                        {
                            m_HedgeOptionsByInstrumentName.Add(quoteInstrument, hedgeOptions);
                            isSuccess = true;
                        }
                    }
                    else
                        m_Log.NewEntry(LogLevel.Error, "Failed to create hedge options for instrument {0}.", quoteInstrument);
                }
            }
            return isSuccess;
        }
        //
        //
        /// <summary>
        /// Get the hedge options by instrument name dictionary.
        /// </summary>
        /// <returns></returns>
        public Dictionary<InstrumentName, HedgeOptions> GetHedgeOptionsByInstrumentName()
        {
            return m_HedgeOptionsByInstrumentName;
        }
        #endregion//Public Methods


        #region Private Methods
        // *****************************************************************
        // ****                     Private Methods                     ****
        // *****************************************************************
        //
        //
        //
        //
        /// <summary>
        /// This function will generate resulting instruments for the quote instrument.
        /// Also, it will generate the ratios and hedge instruments in that resulting instrument.
        /// </summary>
        /// <param name="instrumentInfoItem"></param>
        /// <returns></returns>
        public bool TryGenerateHedgeOptions(InstrumentName quoteInstrument, InstrumentInfoItem instrumentInfoItem, HedgeOptions hedgeOptions)
        {
            bool isSuccess = false;
            string hedgeOptionString = instrumentInfoItem.HedgeOptions;

            // Consider the target example: 
            // 1x{1xGE_U4.-1xGE_Z4}-1x{1xGE_Z4.-1xGE_H5}=1x{1xGE_U4.-2xGE_Z4.1xGE_H5}|-1x{1xGE_U4.-1xGE_Z4}+1x{1xGE_M4.-1xGE_U4}=1x{1xGE_M4.-2xGE_U4.1xGE_Z4}
            // |2x{1xGE_U4.-1xGE_Z4}-1x{1xGE_U4.-1xGE_H5}=1x{1xGE_U4.-2xGE_Z4.1xGE_H5}|-2x{1xGE_U4.-1xGE_Z4}+1x{1xGE_M4.-1xGE_Z4}=1x{1xGE_M4.-2xGE_U4.1xGE_Z4}
            // |-3x{1xGE_U4.-1xGE_Z4}+1x{1xGE_M4.-1xGE_H5}=1x{1xGE_M4.-3xGE_U4.3xGE_Z4.-1xGE_H5}

            // First step: Parse different hedges and resulting instruments.
            char seperator = '|';
            string[] hedgeOptionUnits = hedgeOptionString.Split(new char[] { seperator }, StringSplitOptions.RemoveEmptyEntries);
            if (hedgeOptionUnits.Length > 0)
            {
                string exchangeName = quoteInstrument.Product.Exchange;
                List<string> matchedResults = new List<string>();
                foreach (string hedgeOptionUnit in hedgeOptionUnits)
                {
                    // Second step: Parse hedge instruments and resulting instruments.
                    // Target: 1x{1xGE_U4.-1xGE_Z4}-1x{1xGE_Z4.-1xGE_H5}=1x{1xGE_U4.-2xGE_Z4.1xGE_H5}
                    seperator = '=';
                    string[] hedgeAndResultingInstruments = hedgeOptionUnit.Split(new char[] { seperator }, StringSplitOptions.RemoveEmptyEntries);
                    if (hedgeAndResultingInstruments.Length == 2)
                    {
                        HedgeOption hedgeOption = null;
                        bool isQuoteInstrument = false;                                     // Quote instrument always the first.

                        // Third step: Parse hedge instruments further by their weights.
                        // Target: 1x{1xGE_U4.-1xGE_Z4}-1x{1xGE_Z4.-1xGE_H5}
                        string hedgeInstrumentsPart = hedgeAndResultingInstruments[0];
                        string pattern = @"-?\d+x{[^}]+}";
                        matchedResults.Clear();
                        MatchCollection matchCollection = Regex.Matches(hedgeInstrumentsPart, pattern);
                        foreach (Match match in matchCollection)
                        {
                            string matchedValue = match.Value;
                            matchedResults.Add(matchedValue);
                        }

                        // Fourth step: Parse weight and instrument name for each hedge instrument.
                        // Target: 1x{1xGE_U4.-1xGE_Z4}
                        foreach (string matchedInstrument in matchedResults)
                        {
                            int weight = 0;

                            // 1. Weight:
                            string firstPart = matchedInstrument.Substring(0, matchedInstrument.IndexOf('x'));
                            if (int.TryParse(firstPart, out weight) && weight != 0)
                            {
                                // 2. Name:
                                pattern = @"\{(?<hedgeName>\S+)\}";
                                Match match = Regex.Match(matchedInstrument, pattern);
                                string name = match.Groups["hedgeName"].Value;

                                // Fifth step: Parse instrument name out.
                                //// There may be alternative way to do it. The data base contains the instrument name TT and we may use that.
                                // Target: 1xGE_U4.-1xGE_Z4
                                InstrumentName instrumentComposed = quoteInstrument;
                                if (QTMath.TryComposeInstrumentName(name, quoteInstrument, m_Log, out instrumentComposed))
                                {
                                    if (!isQuoteInstrument)
                                    {
                                        hedgeOption = new HedgeOption();
                                        hedgeOption.QuoteInstrument = instrumentComposed;
                                        hedgeOption.QuoteWeight = weight;
                                        hedgeOption.TryAddInstrumentAndWeight(instrumentComposed, weight);
                                        isQuoteInstrument = true;
                                    }
                                    else
                                    {
                                        if (instrumentComposed != quoteInstrument)
                                        {
                                            hedgeOption.TryAddInstrumentAndWeight(instrumentComposed, weight);
                                        }
                                        else
                                        {
                                            m_Log.NewEntry(LogLevel.Error, "instrument composed same as quote instrument {0}.", instrumentComposed);
                                            return isSuccess;
                                        }
                                    }
                                }
                                else
                                {
                                    m_Log.NewEntry(LogLevel.Error, "Failed to compose instrument name for string {0}.", name);
                                    return isSuccess;
                                }
                            }
                            else
                            {
                                m_Log.NewEntry(LogLevel.Error, "instrument weight parse failed for {0}.", matchedInstrument);
                                return isSuccess;
                            }
                        }

                        // If the hedge option exists.
                        if (hedgeOption != null)
                        {
                            // Sixth step: Continue to read the resulting instrument if hedge option is valid.
                            // Target: 1x{1xGE_U4.-2xGE_Z4.1xGE_H5}
                            string resultingInstrumentPart = hedgeAndResultingInstruments[1];

                            // 1.Weight:
                            string weightString = resultingInstrumentPart.Substring(0, resultingInstrumentPart.IndexOf('x'));
                            int resultingWeight = 0;
                            if (int.TryParse(weightString, out resultingWeight) && resultingWeight != 0)
                            {
                                // 2.Name:
                                pattern = @"\{(?<resultingName>\S+)\}";
                                Match match = Regex.Match(resultingInstrumentPart, pattern);
                                string resultingInstrumentName = match.Groups["resultingName"].Value;

                                ResultingInstrument resultingInstrument = new ResultingInstrument();
                                resultingInstrument.ResultingInstrumentNameDataBase = resultingInstrumentName;
                                hedgeOption.ResultingInstrument = resultingInstrument;
                                hedgeOption.ResultingWeight = resultingWeight;

                                // 3. Compose resulting instrument name:
                                InstrumentName instrumentComposed = quoteInstrument;
                                if (QTMath.TryComposeInstrumentName(resultingInstrumentName, quoteInstrument, m_Log, out instrumentComposed))
                                {
                                    resultingInstrument.ResultingInstrumentName = instrumentComposed;
                                    resultingInstrument.ResultingInstrumentNameTT = instrumentComposed.FullName;
                                    if (!hedgeOptions.TryAddHedgeOption(hedgeOption))
                                    {
                                        m_Log.NewEntry(LogLevel.Error, "Failed to add hedge option for instrument {0}.", quoteInstrument);
                                        return isSuccess;
                                    }
                                }
                                else
                                {
                                    m_Log.NewEntry(LogLevel.Error, "Failed to compose instrument name for string {0}.", resultingInstrumentName);
                                    return isSuccess;
                                }
                            }
                        }
                    }
                    else
                    {
                        m_Log.NewEntry(LogLevel.Error, "hedge and resulting instruments parse failed for string {0}.", hedgeOptionUnit);
                        return isSuccess;
                    }
                }
                isSuccess = true;
            }
            else
            {
                m_Log.NewEntry(LogLevel.Error, "hedge options parse failed for string {0}.", hedgeOptionString);
                return isSuccess;
            }

            return isSuccess;
        }
        #endregion//Private Methods


        #region no Event Handlers
        // *****************************************************************
        // ****                     Event Handlers                     ****
        // *****************************************************************
        //
        //
        #endregion//Event Handlers

    }
}
