using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Akka.Actor;
using BinaryOption.DAL.Repositories;
using BinaryOption.OptionServer.Contract;
using BinaryOption.OptionServer.Contract.DTO;
using BinaryOption.OptionServer.Contract.Events;
using BinaryOption.OptionServer.Contract.Requests;
using BinaryOptions.DAL.Data;

namespace BinaryOptions.OptionServer.Services
{
    public class RatesService : ReceiveActor
    {
        private readonly InstrumentRepository m_instrumentRepository;
        private readonly Protocol m_protocol;
        private InstrumentRateRepository m_rateRepository = new InstrumentRateRepository();
        
        public RatesService(InstrumentRepository instrumentRepository, Protocol protocol)
        {
            m_instrumentRepository = instrumentRepository;
            m_protocol = protocol;

            Receive<OneSecondElapsed>(e => Handle(e));
            Receive<InstrumentsRequest>(c => GetInstrumentNames(c));
        }

        private void GetInstrumentNames(InstrumentsRequest instrumentsRequest)
        {
            Sender.Tell(new InstrumentsReply(m_instrumentRepository.GetInstrumentsNames()), Self);
        }

        private void Handle(OneSecondElapsed @event)
        {
            // first let's generate fake rates to all instruments.
            GenerateFakeRates();

            // now lets publish those fake rates to our Rates Subscriber.
            var ratesSubscriber = Context.ActorSelection(m_protocol.GenerateTcpPath("EventsListener"));
            
            foreach (Instrument instrument in m_instrumentRepository.GetInstruments())
            {
                ratesSubscriber.Tell(new InstrumentUpdated(instrument.Name, instrument.Rate), Self);
            }
        }

        private void GenerateFakeRates() 
        {
            Random rand = new Random();

            foreach (var instrument in m_instrumentRepository.GetInstruments())
            {
                double d = Math.Round(rand.NextDouble() * (instrument.Max - instrument.Min) + instrument.Min, 4);
                instrument.Update(d);
                m_instrumentRepository.Update(instrument);
            }
        }

        private void HandleInstrumentRates(InstrumentRatesRequest instrumentRatesRequest)
        {
            IList<InstrumentRate> instrumentRates = m_rateRepository.GetInstrumentById(instrumentRatesRequest.Id);

            IList<InstrumentRateReply> ratesReply = instrumentRates.Select(i => new InstrumentRateReply(i.Id, i.Rate, i.Time)).ToList();

            InstrumentRatesReply reply = new InstrumentRatesReply(ratesReply);

            Sender.Tell(reply, Self);
        }
    }
}
