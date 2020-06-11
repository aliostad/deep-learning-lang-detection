using ZephirCollection.Domain.Interfaces;
using ZephirCollection.Domain.Interfaces.Services;
using ZephirCollection.Domain.Interfaces.Repositories;
using ZephirCollection.Domain.Entities;
using System.Collections.Generic;
using System.Linq;
using System;

namespace ZephirCollection.Domain.Services
{
    public class PokemonCardListTestService : ServiceBase<PokemonCard>, IPokemonCardListTestService
        //ICardRepository, 
        //IRarityRepository,
        //ISeriesRepository,
        //ICollectorRepository,
        //ICollectionRepository
    {
        private readonly IPokemonCardRepository _pokemonCardRepository;
        private readonly ICardRepository _cardRepository;
        private readonly IRarityRepository _rarityRepository;
        private readonly ISeriesRepository _seriesRepository;
        private readonly ICollectorRepository _collectorRepository;
        private readonly ICollectionRepository _collectionRepository;

        public PokemonCardListTestService(IPokemonCardRepository pokemonCardRepository, 
            ICardRepository cardRepository, 
            IRarityRepository rarityRepository,
            ISeriesRepository seriesRepository,
            ICollectorRepository collectorRepository,
            ICollectionRepository collectionRepository
            )
            : base(pokemonCardRepository)//, cardRepository, rarityRepository, seriesRepository, collectorRepository, collectionRepository)
        {
            _pokemonCardRepository = pokemonCardRepository;
            _cardRepository = cardRepository;
            _rarityRepository = rarityRepository;
            _seriesRepository = seriesRepository;
            _collectorRepository = collectorRepository;
            _collectionRepository = collectionRepository;
        }

        public IEnumerable<PokemonCard> GetAllPokemonCardList()
        {
            return _pokemonCardRepository.GetAllPokemonCardList();
            //return _pokemonCardRepository.GetAllPokemonCardList();
        }
    }
}
