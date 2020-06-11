// CDlgFruRepoSettingPm.cpp : 实现文件
//

#include "stdafx.h"
#include "IpmTool.h"
#include "DlgFruRepoSettingPm.h"
#include "afxdialogex.h"


// CDlgFruRepoSettingPm 对话框
#define MAX_CHECK_ID IDC_CHECK11

IMPLEMENT_DYNAMIC(CDlgFruRepoSettingPm, CDlgFruRepoSetting)
CDlgFruRepoSettingPm::CDlgFruRepoSettingPm(CWnd* pParent /*=NULL*/)
	: CDlgFruRepoSetting(CDlgFruRepoSettingPm::IDD, pParent)
{
	for(int i = IDC_CHECK1; i <= MAX_CHECK_ID; i++)
	{
		m_isCheckedArray.Add(0);
	}
}

CDlgFruRepoSettingPm::~CDlgFruRepoSettingPm()
{
}

void CDlgFruRepoSettingPm::DoDataExchange(CDataExchange* pDX)
{
	CDlgFruRepoSetting::DoDataExchange(pDX);
}


BEGIN_MESSAGE_MAP(CDlgFruRepoSettingPm, CDlgFruRepoSetting)
	ON_COMMAND_RANGE(IDC_CHECK1, MAX_CHECK_ID, OnCheckBox)
END_MESSAGE_MAP()


// CDlgFruRepoSettingPm 消息处理程序
BOOL CDlgFruRepoSettingPm::OnInitDialog()
{
	CDlgFruRepoSetting::OnInitDialog();

	for(DWORD i = IDC_CHECK3; i <= MAX_CHECK_ID - 1; i++)
	{
		((CButton*)GetDlgItem(i))->SetCheck(TRUE);
		 m_isCheckedArray[i - IDC_CHECK1] = TRUE;
	}

	((CButton*)GetDlgItem(MAX_CHECK_ID))->SetCheck(FALSE);
	return TRUE;
}

void CDlgFruRepoSettingPm::OnCheckBox(UINT id)
{
	BOOL isCheck = ((CButton*)GetDlgItem(id))->GetCheck();
	m_isCheckedArray[id-IDC_CHECK1] = ((CButton*)GetDlgItem(id))->GetCheck();
}
