// CDlgFruRepoSettingMmc.cpp : 实现文件
//

#include "stdafx.h"
#include "IpmTool.h"
#include "DlgFruRepoSettingMmc.h"
#include "afxdialogex.h"


// CDlgFruRepoSettingMmc 对话框
#define MAX_CHECK_ID IDC_CHECK11

IMPLEMENT_DYNAMIC(CDlgFruRepoSettingMmc, CDlgFruRepoSetting)
CDlgFruRepoSettingMmc::CDlgFruRepoSettingMmc(CWnd* pParent /*=NULL*/)
	: CDlgFruRepoSetting(CDlgFruRepoSettingMmc::IDD, pParent)
{

}

CDlgFruRepoSettingMmc::~CDlgFruRepoSettingMmc()
{
}

void CDlgFruRepoSettingMmc::DoDataExchange(CDataExchange* pDX)
{
	CDlgFruRepoSetting::DoDataExchange(pDX);
}


BEGIN_MESSAGE_MAP(CDlgFruRepoSettingMmc, CDlgFruRepoSetting)
	ON_COMMAND_RANGE(IDC_CHECK1, MAX_CHECK_ID, OnCheckBox)
END_MESSAGE_MAP()


// CDlgFruRepoSettingMmc 消息处理程序
BOOL CDlgFruRepoSettingMmc::OnInitDialog()
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

void CDlgFruRepoSettingMmc::OnCheckBox(UINT id)
{
	BOOL isCheck = ((CButton*)GetDlgItem(id))->GetCheck();
	m_isCheckedArray[id-IDC_CHECK1] = ((CButton*)GetDlgItem(id))->GetCheck();
}
