// CDlgFruRepoSettingCm.cpp : 实现文件
//

#include "stdafx.h"
#include "IpmTool.h"
#include "DlgFruRepoSettingCm.h"
#include "afxdialogex.h"

////////////////////////////////////////////
#define MAX_CHECK_ID IDC_CHECK11

// CDlgFruRepoSettingCm 对话框

IMPLEMENT_DYNAMIC(CDlgFruRepoSettingCm, CDlgFruRepoSetting)
CDlgFruRepoSettingCm::CDlgFruRepoSettingCm(CWnd* pParent /*=NULL*/)
	: CDlgFruRepoSetting(CDlgFruRepoSettingCm::IDD, pParent)
{

}

CDlgFruRepoSettingCm::~CDlgFruRepoSettingCm()
{
}

void CDlgFruRepoSettingCm::DoDataExchange(CDataExchange* pDX)
{
	CDlgFruRepoSetting::DoDataExchange(pDX);
}


BEGIN_MESSAGE_MAP(CDlgFruRepoSettingCm, CDlgFruRepoSetting)
	ON_COMMAND_RANGE(IDC_CHECK1, MAX_CHECK_ID, CDlgFruRepoSetting::OnCheckBox)
END_MESSAGE_MAP()


// CDlgFruRepoSettingCm 消息处理程序
BOOL CDlgFruRepoSettingCm::OnInitDialog()
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
