// EditRepo.h : header file
//

#include "repo.h"

/////////////////////////////////////////////////////////////////////////////
// CEditRepo dialog

class CEditRepo : public wxDialog
{
// Construction
public:
	CEditRepo(wxWindow* pParent = NULL);   // standard constructor

// Dialog Data
	CRepository m_repo;
	//{{AFX_DATA(CEditRepo)
	enum { IDD = IDD_REPO };
	wxString	m_strName;
	wxString	m_strAddr;
	//}}AFX_DATA


// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CEditRepo)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support
	//}}AFX_VIRTUAL

// Implementation
protected:
	void DataToValue();
	void ValueToData();

	// Generated message map functions
	//{{AFX_MSG(CEditRepo)
	afx_msg void OnDelete();
	virtual BOOL OnInitDialog();
	//}}AFX_MSG
	DECLARE_EVENT_TABLE()
};
