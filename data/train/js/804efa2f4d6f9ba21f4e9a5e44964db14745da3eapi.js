// Load after jquery

api = {}

api._callbacks = [];

api._callback = function(id, arr) {
  //console.log("callback " + id + " | " + arr);
  api._callbacks[id].apply(null, arr);
}

api._register_callback = function(callback) {
  api._callbacks.push(callback);
  return api._callbacks.length - 1;
}

$(function(){window._api.callback.connect(api._callback);});

api.invokeRubySubprocess = function(args, callback) {
  return window._api.invokeRubySubprocess(args, api._register_callback(callback));
}

api.killSubprocess = window._api.killSubprocess;

api.readThumbnail = window._api.readThumbnail;

api.exifTime = window._api.exifTime;

api.droppedFilesRecursive = window._api.droppedFilesRecursive;

api.makeDirectory = window._api.makeDirectory;

api.writeFile = window._api.writeFile;

api.readFile = window._api.readFile;

api.readFileDialog = window._api.readFileDialog;

api.saveAsDialog = window._api.saveAsDialog;

api.setDeleteMenu = window._api.setDeleteMenu;

api.setUndoMenu = window._api.setUndoMenu;

api.setRedoMenu = window._api.setRedoMenu;

api.getOpenedProjectPath = window._api.getOpenedProjectPath;

api.setNewProjectMenu = window._api.setNewProjectMenu;

api.setOpenProjectMenu = window._api.setOpenProjectMenu;

api.setSaveMenu = window._api.setSaveMenu;

api.setSaveAsMenu = window._api.setSaveAsMenu;

api.setAddImagesMenu = window._api.setAddImagesMenu;

api.setAddFoldersMenu = window._api.setAddFoldersMenu;

api.setRecentlyAddedMenu = window._api.setRecentlyAddedMenu;

api.openBrowser = window._api.openBrowser;

api.makeFullDirectoryPath = window._api.makeFullDirectoryPath;

api.fileExists = window._api.fileExists;

api.closeApp = window._api.doCloseApp;

api.getRootAppPath = window._api.getRootAppPath;
