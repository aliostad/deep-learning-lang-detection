#pragma once

#include "UIWindow.h"

class CUIWaveform5 : public CUIWindow
{
	typedef CUIWindow super;

	public :

		CUIWaveform5();
		virtual ~CUIWaveform5();

		virtual void Create(const CREATESTRUCT& cs);
		virtual void Destroy();

		virtual void OnPaint(HDC hDC);

		void SetBuffers(CBuffers* pBuffers) { m_pBuffers = pBuffers; }
		void SetSample(uint32 iSample ) { m_iSample = iSample; }
		void SetSampleSync(uint32 iSampleSync) { m_iSampleSync = iSampleSync; }
//$		void SetSampleFreeze(uint32 iSampleFreeze) { m_iSampleFreeze = iSampleFreeze; }
		void SetSampleStop(uint32 iSampleStop) { m_iSampleStop = iSampleStop; }

	protected :

		uint32		m_nTrailLength;
		uint32		m_iSample;
		uint32		m_iSampleSync;
//$		uint32		m_iSampleFreeze;
		uint32		m_iSampleStop;

		CBuffers*	m_pBuffers;
		uint32		m_cSamples;

		HBITMAP		m_hBitmapMarkerSync;
		HBITMAP		m_hBitmapMarkerFreeze;
		HBITMAP		m_hBitmapMarkerStop;
		HBITMAP		m_hBitmapWaveform;
};
