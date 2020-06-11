
requirejs([
  "config",
  "app/app",
  "app/header/service",
  "app/settings/service",
  "app/tweets/service"
], function (Config, Application, HeaderService,
  SettingsService, TweetsService) {

    Application.start();

    Application.headerService = new HeaderService({
      container: Application.layout.headerRegion
    });

    Application.settingsService = new SettingsService({
      container: Application.layout.settingsRegion
    });

    Application.tweetsService = new TweetsService({
      container: Application.layout.tweetsRegion
    });

    Application.commands.setHandler("refresh:tweets", function () {
      // Close old view
      Application.layout.tweetsRegion.reset();
      delete Application.tweetsService;
      Application.layout.settingsRegion.reset();
      delete Application.settingsService;

      // Rerender
      Application.tweetsService = new TweetsService({
        container: Application.layout.tweetsRegion
      });
      Application.settingsService = new SettingsService({
        container: Application.layout.settingsRegion
      });
    });

});
