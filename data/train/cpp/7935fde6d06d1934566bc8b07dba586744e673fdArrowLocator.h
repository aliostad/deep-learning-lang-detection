#pragma once


//----------------------------------------------------------------------------------
//	Include
//----------------------------------------------------------------------------------

#include "Util/STG/ArrowLocator.h"
#include "Input/Input.h"
#include "Input/Controller.h"


//----------------------------------------------------------------------------------
//	Class
//----------------------------------------------------------------------------------

namespace Defs
{
namespace Util
{
	typedef Game::Util::STG::ArrowLocator GameArrowLocator;

	class ArrowLocator
		: public GameArrowLocator
	{
	public:
		ArrowLocator( int initArrowPos, int top, int bottom )
			: GameArrowLocator( Input::Input::getController().GetPtr(), initArrowPos, top, bottom )
		{}
		ArrowLocator( int initArrowPos, int top, int bottom, 
				bool loop )
				: GameArrowLocator( Input::Input::getController().GetPtr(), initArrowPos, top, bottom, loop )
		{}
		ArrowLocator( int initArrowPos, int top, int bottom, 
				bool loop, bool horizontal )
				: GameArrowLocator( Input::Input::getController().GetPtr(), initArrowPos, top, bottom, loop, horizontal )
		{}

		int GetTop() const
		{
			return GameArrowLocator::GetInterval().upper();
		}
		void SetTop( int top )
		{
			GameArrowLocator::SetInterval( top, GetBottom() );
		}
		int GetBottom() const
		{
			return GameArrowLocator::GetInterval().lower();
		}
		void SetBottom( int bottom )
		{
			GameArrowLocator::SetInterval( GetTop(), bottom );
		}

		void SetHorizontal( bool horizontal )
		{
			GameArrowLocator::SetHorizontal( horizontal );
		}

		void SetRepeatWait( float wait )
		{
			GameArrowLocator::SetRepeatWait( wait );
		}
		void SetRepeatInterval( float itv )
		{
			GameArrowLocator::SetRepeatInterval( itv );
		}

		Input::Controller GetController() const
		{
			return Input::Controller( GameArrowLocator::GetController() );
		}
		void SetController( const Input::Controller &controller )
		{
			GameArrowLocator::SetController( controller.GetPtr() );
		}
	};
}
}