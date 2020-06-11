var EXPORTED_SYMBOLS = [];
Components.utils.import("resource://foxcub/foxcubService.js");

FoxcubService.functions = new FoxcubService.Functions();
FoxcubService.functions.crc32 = new FoxcubService.Crc32();
FoxcubService.functions.md5 = new FoxcubService.MD5Obj();
FoxcubService.functions.encoding = new FoxcubService.Encoding();
FoxcubService.windowHelper = new FoxcubService.WindowHelper();
FoxcubService.logger = new FoxcubService.Logger();
FoxcubService.pref = new FoxcubService.PreferencesContainer(FoxcubService.FOXCUB_PREF_BRANCH);
FoxcubService.config = new FoxcubService.Config();
FoxcubService.register = new FoxcubService.Register();
FoxcubService.install = new FoxcubService.Install();
FoxcubService.email = new FoxcubService.Email();
FoxcubService.speedDial = new FoxcubService.SpeedDial();
FoxcubService.baseManager = new FoxcubService.BaseManager();
