/*  Starshatter OpenSource Distribution
    Copyright (c) 1997-2004, Destroyer Studios LLC.
    All Rights Reserved.

    Redistribution and use in source and binary forms, with or without
    modification, are permitted provided that the following conditions are met:

    * Redistributions of source code must retain the above copyright notice,
      this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright notice,
      this list of conditions and the following disclaimer in the documentation
      and/or other materials provided with the distribution.
    * Neither the name "Destroyer Studios" nor the names of its contributors
      may be used to endorse or promote products derived from this software
      without specific prior written permission.

    THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
    AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
    IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
    ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
    LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
    CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
    SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
    INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
    CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
    ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
    POSSIBILITY OF SUCH DAMAGE.

    SUBSYSTEM:    Stars
    FILE:         LoadScreen.cpp
    AUTHOR:       John DiCamillo

*/

#include "MemDebug.h"
#include "LoadScreen.h"
#include "LoadDlg.h"
#include "CmpLoadDlg.h"
#include "Starshatter.h"

#include "Game.h"
#include "Video.h"
#include "Screen.h"
#include "FormDef.h"
#include "Window.h"
#include "ActiveWindow.h"
#include "Mouse.h"
#include "Color.h"
#include "Bitmap.h"
#include "Font.h"
#include "FontMgr.h"
#include "DataLoader.h"
#include "Resource.h"

// +--------------------------------------------------------------------+

LoadScreen::LoadScreen()
: screen(0), load_dlg(0), cmp_load_dlg(0), isShown(false)
{ }

LoadScreen::~LoadScreen()
{
    TearDown();
}

// +--------------------------------------------------------------------+

void
LoadScreen::Setup(Screen* s)
{
    if (!s)
    return;

    screen        = s;

    DataLoader* loader = DataLoader::GetLoader();
    loader->UseFileSystem(true);

    // create windows
    FormDef load_def("LoadDlg", 0);
    load_def.Load("LoadDlg");
    load_dlg = new(__FILE__,__LINE__) LoadDlg(screen, load_def);

    FormDef cmp_load_def("CmpLoadDlg", 0);
    cmp_load_def.Load("CmpLoadDlg");
    cmp_load_dlg = new(__FILE__,__LINE__) CmpLoadDlg(screen, cmp_load_def);

    loader->UseFileSystem(Starshatter::UseFileSystem());
    ShowLoadDlg();
}

// +--------------------------------------------------------------------+

void
LoadScreen::TearDown()
{
    if (screen) {
        if (load_dlg)     screen->DelWindow(load_dlg);
        if (cmp_load_dlg) screen->DelWindow(cmp_load_dlg);
    }

    delete load_dlg;
    delete cmp_load_dlg;

    load_dlg       = 0;
    cmp_load_dlg   = 0;
    screen         = 0;
}

// +--------------------------------------------------------------------+

void
LoadScreen::ExecFrame()
{
    Game::SetScreenColor(Color::Black);

    if (load_dlg && load_dlg->IsShown())
    load_dlg->ExecFrame();

    if (cmp_load_dlg && cmp_load_dlg->IsShown())
    cmp_load_dlg->ExecFrame();
}

// +--------------------------------------------------------------------+

bool
LoadScreen::CloseTopmost()
{
    return false;
}

void
LoadScreen::Show()
{
    if (!isShown) {
        ShowLoadDlg();
        isShown = true;
    }
}

void
LoadScreen::Hide()
{
    if (isShown) {
        HideLoadDlg();
        isShown = false;
    }
}

// +--------------------------------------------------------------------+

void
LoadScreen::ShowLoadDlg()
{
    if (load_dlg)     load_dlg->Hide();
    if (cmp_load_dlg) cmp_load_dlg->Hide();

    Starshatter* stars = Starshatter::GetInstance();

    // show campaign load dialog if available and loading campaign
    if (stars && cmp_load_dlg) {
        if (stars->GetGameMode() == Starshatter::CLOD_MODE ||
                stars->GetGameMode() == Starshatter::CMPN_MODE) {
            cmp_load_dlg->Show();
            Mouse::Show(false);
            return;
        }
    }

    // otherwise, show regular load dialog
    if (load_dlg) {
        load_dlg->Show();
        Mouse::Show(false);
    }
}

// +--------------------------------------------------------------------+

void
LoadScreen::HideLoadDlg()
{
    if (load_dlg && load_dlg->IsShown())
    load_dlg->Hide();

    if (cmp_load_dlg && cmp_load_dlg->IsShown())
    cmp_load_dlg->Hide();
}
