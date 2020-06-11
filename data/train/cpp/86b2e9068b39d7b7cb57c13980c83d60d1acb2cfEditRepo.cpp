// EditRepo.cpp : implementation file
//

#include "stdafx.h"
#include "gedtree.h"
#include "EditRepo.h"
#include "gedtreedoc.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CEditRepo dialog


CEditRepo::CEditRepo(wxWindow* pParent /*=NULL*/)
	: wxDialog(CEditRepo::IDD, pParent)
{
	//{{AFX_DATA_INIT(CEditRepo)
	m_strName = _T("");
	m_strAddr = _T("");
	//}}AFX_DATA_INIT
}


void CEditRepo::DoDataExchange(CDataExchange* pDX)
{
	wxDialog::DoDataExchange(pDX);

	if (!pDX->m_bSaveAndValidate)
	{
		ValueToData();
	}

	//{{AFX_DATA_MAP(CEditRepo)
	DDX_Text(pDX, IDC_NAME, m_strName);
	DDX_Text(pDX, IDC_ADDR, m_strAddr);
	//}}AFX_DATA_MAP

	if (pDX->m_bSaveAndValidate)
	{
		DataToValue();
	}
}

void CEditRepo::DataToValue()
{
	m_repo.m_strName = m_strName;
	m_repo.m_strAddr = m_strAddr;
	m_repo.Calc();
}

void CEditRepo::ValueToData()
{
	m_strName = m_repo.m_strName;
	m_strAddr = m_repo.m_strAddr;
}

BEGIN_EVENT_TABLE(CEditRepo, wxDialog)
	//{{AFX_MSG_MAP(CEditRepo)
	ON_BN_CLICKED(IDC_DELETE, OnDelete)
	//}}AFX_MSG_MAP
END_EVENT_TABLE()

/////////////////////////////////////////////////////////////////////////////
// CEditRepo message handlers

void CEditRepo::OnDelete() 
{
	if (m_repo.m_i<0)
	{
		OnCancel();
	}
	else
	{
		if (theApp.ConfirmDelete("repository"))
		{
			if (m_repo.m_pDoc->HasChildren(m_repo))
			{
				AfxMessageBox(_T("You cannot delete this repository because it has other ")
					_T("records that depend on it.\nYou must remove all dependencies ")
					_T("before you can delete this repository."));
			}
			else
			{
				EndDialog(IDC_DELETE);
			}
		}
	}
}

BOOL CEditRepo::OnInitDialog() 
{
	wxDialog::OnInitDialog();
	SetIcon(theApp.LoadIcon(IDD),TRUE);
	return TRUE;
}
