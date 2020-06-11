using CodeSensei.Interfaces;
using CodeSensei.Repositories;

namespace CodeSensei.Models
{
    public class Aggregator : IAggregator
    {
        public Aggregator()
        {
            UserRepository = new UserRepository();
            EntitiesRepository = new EntitiesRepository();
            ResourcesRepository = new ResourcesRepository();
            IntentionsRepository = new IntentionsRepository();
            DifficultyLevelsRepository = new DifficultyLevelsRepository();
        }

        public IUserRepository UserRepository { get; set; }
        public IEntitiesRepository EntitiesRepository { get; set; }
        public IResourcesRepository ResourcesRepository { get; set; }
        public IIntentionsRepository IntentionsRepository { get; set; }
        public IDifficultyLevelsRepository DifficultyLevelsRepository { get; set; }
    }
}