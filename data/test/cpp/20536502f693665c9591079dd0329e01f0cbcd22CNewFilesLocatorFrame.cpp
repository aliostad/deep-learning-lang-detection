// DiskArcher.
// Implementation of the CNewFilesLocatorFrame class.
// (C) Marat Mirgaleev, 2002.
// Modifications:
//   (1) 25.07.2004. Locator reconstruction.
//==================================================================

#include "stdafx.h"
#include "../MArc2.h"

#include "CNewFilesLocator.h"
#include "CNewFilesLocatorFrame.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif


IMPLEMENT_DYNCREATE(CNewFilesLocatorFrame, CMDIChildWnd)

BEGIN_MESSAGE_MAP(CNewFilesLocatorFrame, CMDIChildWnd)
	//{{AFX_MSG_MAP(CNewFilesLocatorFrame)
	ON_WM_CREATE()
	ON_WM_CLOSE()
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()


BOOL CNewFilesLocatorFrame::PreCreateWindow(CREATESTRUCT& cs)
{
	if( !CMDIChildWnd::PreCreateWindow(cs) )
		return FALSE;

	return TRUE;
}


// CNewFilesLocatorFrame diagnostics
//==================================================================

#ifdef _DEBUG
void CNewFilesLocatorFrame::AssertValid() const
{
	CMDIChildWnd::AssertValid();
}

void CNewFilesLocatorFrame::Dump(CDumpContext& dc) const
{
	CMDIChildWnd::Dump(dc);
}

#endif //_DEBUG



// CNewFilesLocatorFrame message handlers
//==================================================================


int CNewFilesLocatorFrame::OnCreate(LPCREATESTRUCT lpCreateStruct) // M
{
	if (CMDIChildWnd::OnCreate(lpCreateStruct) == -1)
		return -1;
	
	if( !m_wndToolBar.CreateEx(this, TBSTYLE_FLAT, WS_CHILD | WS_VISIBLE | CBRS_TOP
		| CBRS_GRIPPER | CBRS_TOOLTIPS | CBRS_FLYBY | CBRS_SIZE_DYNAMIC ) ||
		!m_wndToolBar.LoadToolBar( IDR_LOCATOR ) )
			return -1;
	m_wndToolBar.EnableDocking(CBRS_ALIGN_ANY);
	EnableDocking( CBRS_ALIGN_ANY );
	DockControlBar(&m_wndToolBar);

// (1) Disabled ((CMainFrame*)AfxGetMainWnd())->m_pLocatorFrame = this;
	
	return 0;
}


void CNewFilesLocatorFrame::OnClose() 
{
    m_pLocator->m_pFrame = NULL;
	
	CMDIChildWnd::OnClose();
}
