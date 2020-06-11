using System.Collections.Generic;
using System.Linq;
using Musicfy.Dal.Contracts;
using Musicfy.Dal.Entities;
using Neo4jClient;
using Neo4jClient.Transactions;

namespace Musicfy.Dal.Repositories
{
    public class InstrumentRepository : BaseRepository, IInstrumentRepository
    {
        public InstrumentRepository(IGraphClient graphClient) : base(graphClient)
        {
        }

        public IEnumerable<Instrument> GetAll()
        {
            return _graphClient.Cypher
                .Match("(instrument:Instrument)")
                .With("instrument")
                .OrderBy("instrument.name")
                .Return(instrument => instrument.As<Instrument>())
                .Results;
        }

        public Instrument GetById(string id)
        {
            return _graphClient.Cypher
                .Match("(instrument:Instrument)")
                .Where((Instrument instrument) => instrument.Id == id)
                .Return(instrument => instrument.As<Instrument>())
                .Results
                .FirstOrDefault();
        }

        public Instrument GetByName(string name)
        {
            return _graphClient.Cypher
                .Match("(instrument:Instrument)")
                .Where((Instrument instrument) => instrument.Name == name)
                .Return(instrument => instrument.As<Instrument>())
                .Results
                .FirstOrDefault();
        }

        public void Add(Instrument instrument)
        {
            _graphClient.Cypher
                .Create("(instrument:Instrument {newInstrument})")
                .WithParam("newInstrument", instrument)
                .ExecuteWithoutResults();
        }

        public void Update(Instrument updatedInstrument)
        {
            _graphClient.Cypher
                .Match("(instrument:Instrument)")
                .Where((Instrument instrument) => instrument.Id == updatedInstrument.Id)
                .Set("instrument.name = {newName}")
                .WithParam("newName", updatedInstrument.Name)
                .ExecuteWithoutResults();
        }

        public void Delete(string id)
        {
            var transactionClient = (ITransactionalGraphClient) _graphClient;

            using (var transaction = transactionClient.BeginTransaction())
            {
                _graphClient.Cypher
                    .OptionalMatch("(instrument:Instrument)-[r]-()")
                    .Where((Instrument instrument) => instrument.Id == id)
                    .Delete("r, instrument")
                    .ExecuteWithoutResults();

                _graphClient.Cypher
                    .Match("(instrument:Instrument)")
                    .Where((Instrument instrument) => instrument.Id == id)
                    .Delete("instrument")
                    .ExecuteWithoutResults();

                transaction.Commit();
            }
        }
    }
}