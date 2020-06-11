using UniRx;
using Noroshi.Repositories.Server;

namespace Noroshi.Repositories
{
    public class RepositoryManager
    {
        public PlayerCharacterRepository PlayerCharacterRepository;
        public PlayerStatusRepository PlayerStatusRepository;
        public PlayerStoryStageRepository PlayerStoryStageRepository;
        public PlayerStoryEpisodeRepository PlayerStoryEpisodeRepository;
        public PlayerStoryChapterRepository PlayerStoryChapterRepository;
        public PlayerArenaRepository PlayerArenaRepository;
        public PlayerDrugRepository PlayerDrugRepository;
        public PlayerGearEnchantMaterialRepository PlayerGearEnchantMaterialRepository;
        public PlayerGearPieceRepository PlayerGearPieceRepository;
        public PlayerGearRepository PlayerGearRepository;
        public PlayerSoulRepository PlayerSoulRepository;
        public PlayerRaidTicketRepository PlayerRaidTicketRepository;
        public PlayerExchangeCashGiftRepository PlayerExchangeCashGiftRepository;
        public InventoryRepository InventoryRepository;


        public readonly ShadowCharacterRepository ShadowCharacterRepository;
        public readonly CharacterRepository CharacterRepository;
        public readonly ActionRepository ActionRepository;
        public readonly AttributeRepository AttributeRepository;
        public readonly GearRecipeRepository GearRecipeRepository;
        public readonly CharacterEffectRepository CharacterEffectRepository;
        public readonly LevelMasterRepository LevelMasterRepository;
        public readonly DefensiveWarRepository DefensiveWarRepository;
        public readonly StoryEpisodeRepository StoryEpisodeRepository;
        public readonly StoryStageRepository StoryStageRepository;
        public readonly DrugRepository DrugRepository;
        public readonly GearEnchantMaterialRepository GearEnchantMaterialRepository;
        public readonly GearRepository GearRepository;
        public readonly GearPieceRepository GearPieceRepository;
        public readonly SoulRepository SoulRepository;
        public readonly RaidTicketRepository RaidTicketRepository;
        public readonly ExchangeCashGiftRepository ExchangeCashGiftRepository;
        public readonly CharacterEvolutionTypeRepository CharacterEvolutionTypeRepository;

        public RepositoryManager()
        {

            CharacterRepository = new CharacterRepository();
            ActionRepository = new ActionRepository();
            AttributeRepository = new AttributeRepository();
            ShadowCharacterRepository = new ShadowCharacterRepository();
            DrugRepository = new DrugRepository();
            GearEnchantMaterialRepository = new GearEnchantMaterialRepository();
            GearRepository = new GearRepository();
            GearPieceRepository = new GearPieceRepository();
            GearRecipeRepository = new GearRecipeRepository();
            CharacterEffectRepository = new CharacterEffectRepository();
            LevelMasterRepository = new LevelMasterRepository();
            SoulRepository = new SoulRepository();
            StoryStageRepository = new StoryStageRepository();
            StoryEpisodeRepository = new StoryEpisodeRepository();
            ExchangeCashGiftRepository = new ExchangeCashGiftRepository();
            RaidTicketRepository = new RaidTicketRepository();
            PlayerCharacterRepository = new PlayerCharacterRepository();
            PlayerStatusRepository = new PlayerStatusRepository();
            PlayerStoryChapterRepository = new PlayerStoryChapterRepository();
            PlayerStoryEpisodeRepository = new PlayerStoryEpisodeRepository();
            PlayerStoryStageRepository = new PlayerStoryStageRepository();
            PlayerArenaRepository = new PlayerArenaRepository();
            PlayerSoulRepository = new PlayerSoulRepository();
            PlayerDrugRepository = new PlayerDrugRepository();
            PlayerGearEnchantMaterialRepository = new PlayerGearEnchantMaterialRepository();
            PlayerGearPieceRepository = new PlayerGearPieceRepository();
            PlayerGearRepository = new PlayerGearRepository();
            PlayerSoulRepository = new PlayerSoulRepository();
            PlayerExchangeCashGiftRepository = new PlayerExchangeCashGiftRepository();
            PlayerRaidTicketRepository = new PlayerRaidTicketRepository();
            InventoryRepository = new InventoryRepository();
            CharacterEvolutionTypeRepository = new CharacterEvolutionTypeRepository();
        }

        /// プレイヤーキャラクターID指定でデータを引きつつ、キャラクターステータスを返してくれるメソッド。
        /// バトル依存ではないのでキャラクターステータスクラスの名前空間は後で変える。
        /// バルク処理も後で考える。
        public IObservable<BattleScene.CharacterStatus> LoadCharacterStatusByPlayerCharacterID(uint id)
        {
            return PlayerCharacterRepository.Get(id).SelectMany(playerData =>
                {
                    return CharacterRepository.Get(playerData.CharacterID)
                        .Select(masterData => new BattleScene.CharacterStatus(playerData, masterData))
                        .SelectMany(cs => cs.LoadGears());
                });
        }
        public IObservable<BattleScene.CharacterStatus> LoadCharacterStatus(Core.Game.Character.IPersonalCharacter personalCharacter)
        {
            return CharacterRepository.Get(personalCharacter.CharacterID)
                .Select(masterData => new BattleScene.CharacterStatus(personalCharacter, masterData))
                .SelectMany(cs => cs.LoadGears());
        }
        public IObservable<BattleScene.CharacterStatus> LoadCharacterStatusByShadowCharacterID(uint id)
        {
            return ShadowCharacterRepository.Get(id)
                .SelectMany(shadowData =>
                {
                    return CharacterRepository.Get(shadowData.CharacterID)
                        .Select(masterData => new BattleScene.CharacterStatus(shadowData, masterData))
                        .SelectMany(cs => cs.LoadGears());
                });
        }
    }
}