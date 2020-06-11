import ConfigService from './config/config';
import HotkeysService from './config/hotkeys';
import ScrollService from './config/scroll';
import TrayService from './config/tray';


/* App initialization */
let Init = angular.module('Init', [
  ConfigService.name,
  HotkeysService.name,
  ScrollService.name,
  TrayService.name
])
.run(function(ConfigService, HotkeysService, ScrollService, TrayService) {

  /* load config */
  ConfigService.load();
  let configData = ConfigService.configData;

  ScrollService.init();
  if (nw) {
    HotkeysService.init();
    if (configData.tray) TrayService.init();
    if (configData.minimizeOnStart) win.minimize();
  }

    /* fix materialize-css label */
    $(document).on('click', '.input-field label', function() {
      $(this).parent().find('input').focus();
    });
  });

export default Init;
