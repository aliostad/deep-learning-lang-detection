/*  Project Starshatter 4.5
	Destroyer Studios LLC
	Copyright © 1997-2004. All Rights Reserved.

	SUBSYSTEM:    Stars.exe
	FILE:         LoadScreen.h
	AUTHOR:       John DiCamillo

*/

#ifndef LoadScreen_h
#define LoadScreen_h

#include "Types.h"
#include "Bitmap.h"
#include "Screen.h"

// +--------------------------------------------------------------------+

class LoadDlg;
class CmpLoadDlg;

class Bitmap;
class DataLoader;
class Font;
class Screen;
class Video;
class VideoFactory;

// +--------------------------------------------------------------------+

class LoadScreen
{
public:
	LoadScreen();
	virtual ~LoadScreen();

	virtual void         Setup(Screen* screen);
	virtual void         TearDown();
	virtual bool         CloseTopmost();

	virtual bool         IsShown()         const { return isShown; }
	virtual void         Show();
	virtual void         Hide();

	virtual void         ShowLoadDlg();
	virtual void         HideLoadDlg();
	virtual LoadDlg*     GetLoadDlg()            { return load_dlg;      }
	virtual CmpLoadDlg*  GetCmpLoadDlg()         { return cmp_load_dlg;  }

	virtual void         ExecFrame();

private:
	Screen*              screen;
	LoadDlg*             load_dlg;
	CmpLoadDlg*          cmp_load_dlg;

	bool                 isShown;
};

// +--------------------------------------------------------------------+

#endif LoadScreen_h

