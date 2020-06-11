/*
    This file is part of Soupe Au Caillou.

    @author Soupe au Caillou - Jordane Pelloux-Prayer
    @author Soupe au Caillou - Gautier Pelloux-Prayer
    @author Soupe au Caillou - Pierre-Eric Pelloux-Prayer

    Soupe Au Caillou is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, version 3.

    Soupe Au Caillou is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Soupe Au Caillou.  If not, see <http://www.gnu.org/licenses/>.
*/

#pragma once

class AdAPI;
class AssetAPI;
class CommunicationAPI;
class ExitAPI;
class GameCenterAPI;
class InAppPurchaseAPI;
class JoystickAPI;
class KeyboardInputHandlerAPI;
class LocalizeAPI;
class MusicAPI;
class NetworkAPI;
class OpenURLAPI;
class SoundAPI;
class StorageAPI;
class StringInputAPI;
class VibrateAPI;
class WWWAPI;

namespace ContextAPI {
    enum Enum {
        Ad,
        Asset,
        Communication,
        Exit,
        GameCenter,
        InAppPurchase,
        Joystick,
        KeyboardInputHandler,
        Localize,
        Music,
        Network,
        OpenURL,
        Sound,
        Storage,
        StringInput,
        Vibrate,
        WWW,
    };
}

struct GameContext {
    GameContext()
        : adAPI(0), assetAPI(0), communicationAPI(0), exitAPI(0),
          gameCenterAPI(0), inAppPurchaseAPI(0), joystickAPI(0),
          keyboardInputHandlerAPI(0), localizeAPI(0), musicAPI(0),
          networkAPI(0), openURLAPI(0), soundAPI(0), storageAPI(0),
          stringInputAPI(0), vibrateAPI(0), wwwAPI(0) {}
    AdAPI* adAPI;
    AssetAPI* assetAPI;
    CommunicationAPI* communicationAPI;
    ExitAPI* exitAPI;
    GameCenterAPI* gameCenterAPI;
    InAppPurchaseAPI* inAppPurchaseAPI;
    JoystickAPI* joystickAPI;
    KeyboardInputHandlerAPI* keyboardInputHandlerAPI;
    LocalizeAPI* localizeAPI;
    MusicAPI* musicAPI;
    NetworkAPI* networkAPI;
    OpenURLAPI* openURLAPI;
    SoundAPI* soundAPI;
    StorageAPI* storageAPI;
    StringInputAPI* stringInputAPI;
    VibrateAPI* vibrateAPI;
    WWWAPI* wwwAPI;
};
