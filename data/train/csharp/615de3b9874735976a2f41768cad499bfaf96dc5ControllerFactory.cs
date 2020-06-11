using GbfRaidfinder.Interfaces;

namespace GbfRaidfinder.Factorys {
    public class ControllerFactory : IControllerFactory {
        public ControllerFactory(ISettingsController settingsController, ITweetObserver tweetObserver,
            IRaidsController raidsController, IRaidlistController raidlistController,
            IBlacklistController blacklistController) {
            GetSettingsController = settingsController;
            GetTweetObserver = tweetObserver;
            GetRaidsController = raidsController;
            GetRaidlistController = raidlistController;
            GetBlacklistController = blacklistController;

            GetSettingsController.Load();
            GetRaidsController.Load();
            GetBlacklistController.Load();
            GetRaidlistController.Load();
        }

        public ISettingsController GetSettingsController { get; }

        public IRaidsController GetRaidsController { get; }

        public IRaidlistController GetRaidlistController { get; }

        public ITweetObserver GetTweetObserver { get; }
        public IBlacklistController GetBlacklistController { get; }
    }
}