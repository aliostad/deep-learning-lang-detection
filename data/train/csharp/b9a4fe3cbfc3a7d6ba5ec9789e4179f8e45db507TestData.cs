using ManagerConsole.ViewModel;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ManagerConsole.Model
{
    public class TestData
    {
        public static InstrumentClient GetInstrument(QuotePriceClient quotePriceClient)
        {
            //Property not empty
            InstrumentClient instrument = new InstrumentClient();
            instrument.Id = quotePriceClient.InstrumentId;
            instrument.Code = "GBP" + GetCode();
            instrument.Origin = "1.1";
            instrument.Ask = "1.5";
            instrument.Bid = "1.2";
            instrument.Denominator = 10;
            instrument.NumeratorUnit = 1;
            instrument.MaxAutoPoint = 100;
            instrument.MaxSpread = 100;
            //instrument.AlertPoint = 10;
            instrument.AutoPoint = 1;
            instrument.Spread = 3;

            return instrument;
        }

        public static string GetCode()
        {
            int number;
            char code;
            string checkCode = String.Empty;
            Random random = new Random();
            for (int i = 0; i < 4; i++)
            {
                number = random.Next();
                if (number % 2 == 0)
                    code = (char)('0' + (char)(number % 10));
                else
                    code = (char)('A' + (char)(number % 26));
                checkCode += code.ToString();
            } return checkCode;
        }

        public static Dictionary<Guid, InstrumentClient> GetInitializeTestDataForInstrument()
        {
            Dictionary<Guid, InstrumentClient> instruments = new Dictionary<Guid,InstrumentClient>();
            for (int i = 0; i < 10; i++)
            {
                InstrumentClient instrument = new InstrumentClient();
                string guidStr = "66adc06c-c5fe-4428-867f-be97650eb3b" + i;
                instrument.Id = new Guid(guidStr);
                instrument.Code = "GBPUSA" + i;
                instrument.ExchangeCode = "WF01";
                instrument.Ask = "121.32";
                instrument.Bid = "121.30";
                if (i == 1)
                {
                    instrument.Denominator = 10;
                }
                else
                {
                    instrument.Denominator = 100;
                }
                instrument.NumeratorUnit = 1;
                instrument.MaxSpread = 100;
                instrument.MaxAutoPoint = 100;
                instrument.AcceptDQVariation = 10;
                instrument.Spread = 2;
                instrument.AutoPoint = 10;
                instrument.Origin = "121.30";
                if (i == 3 || i == 2)
                {
                    instrument.IsNormal = false;
                }
                else
                {
                    instrument.IsNormal = true;
                }
                if (i < 3)
                {
                    instrument.SummaryGroupId = new Guid();
                    instrument.SummaryGroupCode = "AAA";
                }
                else if(i == 4)
                {
                    instrument.SummaryGroupId = new Guid();
                    instrument.SummaryGroupCode = "BBB";
                }
                instruments.Add(instrument.Id, instrument);


            }

            return instruments;
        }

        public static Dictionary<Guid, Account> GetInitializeTestDataForAccount()
        {
            Dictionary<Guid, Account> accounts = new Dictionary<Guid, Account>();


            Account account = new Account();
            account.Id = new Guid("9538eb6e-57b1-45fa-8595-58df7aabcfc9");
            account.Code = "DEAccount009";
            Account account2 = new Account();
            account2.Id = new Guid("9538eb6e-57b1-45fa-8595-58df7aabcfc8");
            account2.Code = "DEAccount008";
            Account account3 = new Account();
            account3.Id = new Guid("9538eb6e-57b1-45fa-8595-58df7aabcfc7");
            account3.Code = "DEAccount007";
            accounts.Add(account.Id, account);
            accounts.Add(account2.Id, account2);
            accounts.Add(account3.Id, account3);

            return accounts;
        }
    }
}
