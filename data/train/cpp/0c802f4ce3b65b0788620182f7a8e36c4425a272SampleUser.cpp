/*  YTP King - Easy to use sentence mixer
 *  Copyright (C) 2013  Alex "rainChu" Haddad et al.
 *
 *  This program is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *  
 *  You should have received a copy of the GNU General Public License
 *  along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/
#include "SampleUser.h"

#include "SampleManager.h"


	namespace ytpking
	{
	namespace smp
	{


SampleUser::SampleUser( SampleManager &manager ) :
	m_manager( &manager )
{
	manager.registerSampleUser( this );
}


SampleUser::~SampleUser( void )
{
	m_manager->unregisterSampleUser( this );
}


void
SampleUser::onAddSample( char const *sampleName, char const *speakerName, Sample *addedSample )
{
}


void
SampleUser::onSelectSample( Sample *selectedSample )
{
}


void
SampleUser::onDeleteSample( Sample *deletedSample )
{
}


void
SampleUser::onRenameSample( char const *newSampleName, Sample *sample )
{
}

void
SampleUser::onChangeSampleSpeaker( char const *speakerName, Sample *sample )
{
}


void
SampleUser::onLoadAllSamples( void )
{
}


void
SampleUser::onChangeSampleRange( Sample *sample )
{
}


	} }
