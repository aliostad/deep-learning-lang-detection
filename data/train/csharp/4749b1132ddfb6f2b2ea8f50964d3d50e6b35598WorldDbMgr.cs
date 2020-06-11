using Codebreak.Framework.Configuration;
using Codebreak.Framework.Database;
using Codebreak.Service.World.Database.Repository;

namespace Codebreak.Service.World.Database
{
    /// <summary>
    /// 
    /// </summary>
    public sealed class WorldDbMgr : DbManager<WorldDbMgr>
    {
        /// <summary>
        /// 
        /// </summary>
        /// <param name="dbConnection"></param>
        public void Initialize(string dbConnection = "")
        {
            AddRepository(ExperienceTemplateRepository.Instance);
            AddRepository(ItemSetRepository.Instance);
            AddRepository(ItemTemplateRepository.Instance);
            AddRepository(CraftEntryRepository.Instance);
            AddRepository(InventoryItemRepository.Instance);
            AddRepository(SpellBookEntryRepository.Instance);
            AddRepository(GuildRepository.Instance);
            AddRepository(TaxCollectorRepository.Instance);
            AddRepository(PaddockRepository.Instance);
            AddRepository(MountTemplateRepository.Instance);
            AddRepository(MountRepository.Instance);
            AddRepository(CharacterWaypointRepository.Instance);
            AddRepository(CharacterGuildRepository.Instance);
            AddRepository(CharacterAlignmentRepository.Instance);
            AddRepository(CharacterJobRepository.Instance);
            AddRepository(CharacterRepository.Instance);
            AddRepository(CharacterQuestRepository.Instance);
            AddRepository(SocialRelationRepository.Instance);
            AddRepository(BankRepository.Instance);
            AddRepository(MapTriggerRepository.Instance);
            AddRepository(MapTemplateRepository.Instance);
            AddRepository(NpcTemplateRepository.Instance);
            AddRepository(NpcInstanceRepository.Instance);
            AddRepository(NpcQuestionRepository.Instance);
            AddRepository(NpcResponseRepository.Instance);
            AddRepository(MonsterSpawnRepository.Instance);
            AddRepository(MonsterSuperRaceRepository.Instance);
            AddRepository(MonsterRaceRepository.Instance);
            AddRepository(MonsterRepository.Instance);
            AddRepository(MonsterGradeRepository.Instance);
            AddRepository(DropTemplateRepository.Instance);
            AddRepository(AuctionHouseRepository.Instance);
            AddRepository(AuctionHouseEntryRepository.Instance);
            AddRepository(AuctionHouseAllowedTypeRepository.Instance);
            AddRepository(SubAreaRepository.Instance);
            AddRepository(AreaRepository.Instance);
            AddRepository(SuperAreaRepository.Instance);
            AddRepository(FightActionRepository.Instance);
            AddRepository(QuestRepository.Instance);
            AddRepository(QuestStepRepository.Instance);
            AddRepository(QuestObjectiveRepository.Instance);
            
            LoadAll(string.IsNullOrWhiteSpace(dbConnection) ? WorldConfig.WORLD_DB_CONNECTION : dbConnection);
        }
    }
}
