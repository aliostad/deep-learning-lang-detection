using DL.GuildWars2Api.Contracts.V2;

namespace DL.GuildWars2Api.V2
{
    internal class Version2Facade : IVersion2Api
    {
        private string key;

        public Version2Facade()
            : this(string.Empty)
        {
        }

        public Version2Facade(string apiKey)
        {
            this.key = apiKey;
            this.Account = new AccountApi(apiKey);
            this.Character = new CharacterApi(apiKey);
            this.Currency = new CurrencyApi();
            this.Dungeon = new DungeonApi();
            this.Guild = new GuildApi(apiKey);
            this.Item = new ItemApi();
            this.Raid = new RaidApi();
            this.Skin = new SkinApi();
            this.World = new WorldApi();
        }

        public string ApiKey
        {
            get => this.key;
            set
            {
                this.key = value;
                this.Account.Key = value;
                this.Character.Key = value;
                this.Guild.Key = value;
            }
        }

        public IAuthenticatedAccountApi Account { get; }
        public IAuthenticatedCharacterApi Character { get; }
        public ICurrencyApi Currency { get; }
        public IDungeonApi Dungeon { get; }
        public IAuthenticatedGuildApi Guild { get; }
        public IItemApi Item { get; }
        public IRaidApi Raid { get; }
        public ISkinApi Skin { get; }
        public IWorldApi World { get; }
    }
}
