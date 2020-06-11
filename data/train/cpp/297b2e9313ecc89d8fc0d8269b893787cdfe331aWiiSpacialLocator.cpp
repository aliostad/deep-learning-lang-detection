#include "WiiSpacialLocator.h"

namespace SpacialLocation
{
	void WiiSpacialLocator::Process()
	{
		// Call Set WiimoteHid first!
		if (!m_wiimoteCollection) throw "You must call SetWiimoteHid before anything else!";
		
		// We are always interested in finding new wiimotes
		FindWiimotes();
		// Process all Wiimotes for incoming data
		m_wiimoteCollection->Process();
	}

	void WiiSpacialLocator::FindWiimotes()
	{
		// Find any Wiimotes in the system we don't already know about
		m_wiimoteCollection->FindAllWiimotes();
		
		// Loop through all of the Wiimotes and store pointers to them locally
		size_t i = 0;
		while(WiimoteDriver::Wiimote* wiimote = m_wiimoteCollection->GetNextWiimote(i))
		{
			m_wiimotes[wiimote->GetUid()] = wiimote;
		}
	}

	float WiiSpacialLocator::GetPitch()
	{
		// Don't do anything if there are no connected Wiimotes
		if (m_wiimotes.empty()) return 0.0f;
		
		WiimoteDriver::Wiimote& wiimote = *m_wiimotes.begin()->second;
		
		// TODO: Find a Wiimote that can see an LED
		// TODO: Use more then just the first dot
		return ((float)(384 - wiimote.GetDots()[0].y) * -22.5f) / 384.0f;
	}

	float WiiSpacialLocator::GetYaw()
	{
		// Don't do anything if there are no connected Wiimotes
		if (m_wiimotes.empty()) return 0.0f;
		
		WiimoteDriver::Wiimote& wiimote = *m_wiimotes.begin()->second;
		
		// TODO: Find a Wiimote that can see an LED
		// TODO: Use more then just the first dot
		return ((float)(512 - wiimote.GetDots()[0].x) * 22.5f) / 512.0f;
	}

	float WiiSpacialLocator::GetRoll()
	{
		return 0;
	}

	WiiSpacialLocator& WiiSpacialLocator::operator=(const WiiSpacialLocator&)
	{
		return *new WiiSpacialLocator(m_wiimoteCollection);
	}

	void WiiSpacialLocator::UpPressed(size_t /*id*/)
	{
		
	}

	void WiiSpacialLocator::LeftPressed(size_t /*id*/)
	{
		
	}

	void WiiSpacialLocator::RightPressed(size_t /*id*/)
	{
		
	}

	void WiiSpacialLocator::DownPressed(size_t /*id*/)
	{
		
	}

	void WiiSpacialLocator::APressed(size_t /*id*/)
	{
		
	}

	void WiiSpacialLocator::BPressed(size_t /*id*/)
	{
		
	}

	void WiiSpacialLocator::PlusPressed(size_t /*id*/)
	{
		
	}

	void WiiSpacialLocator::MinusPressed(size_t /*id*/)
	{
		
	}

	void WiiSpacialLocator::HomePressed(size_t /*id*/)
	{
		
	}

	void WiiSpacialLocator::OnePressed(size_t /*id*/)
	{
		
	}

	void WiiSpacialLocator::TwoPressed(size_t /*id*/)
	{
		
	}

	void WiiSpacialLocator::UpReleased(size_t /*id*/)
	{
		
	}

	void WiiSpacialLocator::LeftReleased(size_t /*id*/)
	{
		
	}

	void WiiSpacialLocator::RightReleased(size_t /*id*/)
	{
		
	}

	void WiiSpacialLocator::DownReleased(size_t /*id*/)
	{
		
	}

	void WiiSpacialLocator::AReleased(size_t id)
	{
		m_wiimotes[id]->RequestBattery();
	}

	void WiiSpacialLocator::BReleased(size_t /*id*/)
	{
		
	}

	void WiiSpacialLocator::PlusReleased(size_t /*id*/)
	{
		
	}

	void WiiSpacialLocator::MinusReleased(size_t /*id*/)
	{
		
	}

	void WiiSpacialLocator::HomeReleased(size_t /*id*/)
	{
		
	}

	void WiiSpacialLocator::OneReleased(size_t id)
	{
		m_wiimotes[id]->IrMode();
	}

	void WiiSpacialLocator::TwoReleased(size_t id)
	{
		m_wiimotes[id]->LowPowerMode();
	}

	void WiiSpacialLocator::IrMovement(size_t /*id*/, u8 /*dotId*/, const WiimoteDriver::IrDot& /*dot*/)
	{
		
	}

	void WiiSpacialLocator::Battery(size_t /*id*/, u8 /*charge*/)
	{
		
	}
}
