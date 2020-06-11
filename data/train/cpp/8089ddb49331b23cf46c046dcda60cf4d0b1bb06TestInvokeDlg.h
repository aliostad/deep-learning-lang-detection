#pragma once

#include "InvokeServerMethod.h"
// CTestInvokeDlg 对话框

class CTestInvokeDlg : public CDialogEx
{
	DECLARE_DYNAMIC(CTestInvokeDlg)

public:
	CTestInvokeDlg(InvokeServerMethod *pInvokeObj,CWnd* pParent = NULL);   // 标准构造函数
	virtual ~CTestInvokeDlg();

// 对话框数据
	enum { IDD = IDD_DLG_TEST_INVOKE };

protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV 支持

	DECLARE_MESSAGE_MAP()
public:
	afx_msg void OnBnClickedOk();
	CString m_strFunName;
	CString m_strParam;
private:
	InvokeServerMethod * m_pInvokeObj;
public:
	afx_msg void OnNcDestroy();
};
