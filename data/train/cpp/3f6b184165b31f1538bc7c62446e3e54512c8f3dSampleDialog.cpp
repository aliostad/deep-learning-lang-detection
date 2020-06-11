// SampleDialog.cpp : implementation file
//

#include "stdafx.h"
#include "derivative.h"
#include "SampleDialog.h"


// SampleDialog dialog

IMPLEMENT_DYNAMIC(SampleDialog, CDialog)

SampleDialog::SampleDialog(CWnd* pParent /*=NULL*/)
	: CDialog(SampleDialog::IDD, pParent)
	, size(0)
{

}

SampleDialog::~SampleDialog()
{
}

void SampleDialog::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	DDX_Text(pDX, IDC_EDIT1, size);
	DDV_MinMaxInt(pDX, size, 0, 100);
}


BEGIN_MESSAGE_MAP(SampleDialog, CDialog)
END_MESSAGE_MAP()


// SampleDialog message handlers
