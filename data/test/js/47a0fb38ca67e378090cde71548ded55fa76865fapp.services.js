///////////////////////////////////////////
// ---- REGISTER ALL SERVICES MODULE ----//
//////////////////////////////////////////


function registerAllServicesModule(app){


    //register Auth service
    const authService = require("./auth/auth.service");
    authService(app);

    //profile service
    const profileService = require("./profile/profile.services");
    profileService(app);

    //firebase storage service
    const storageService = require("./firebase-storage/firebase.storage.service");
    storageService(app);

    //chat service
    const chatService = require("./chat/chat.service");
    chatService(app);

    //user service
    const userService = require("./user/user.service");
    userService(app);
}

module.exports = registerAllServicesModule;