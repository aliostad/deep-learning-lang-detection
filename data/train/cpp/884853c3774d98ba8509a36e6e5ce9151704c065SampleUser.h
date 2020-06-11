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
#ifndef __YTPKING_SMP_SampleUser_h
#define __YTPKING_SMP_SampleUser_h


	namespace ytpking
	{
	namespace smp
	{


class Sample;
class SampleManager;


/** Base class for classes which are affected when a Sample is added or removed. */
class SampleUser
{
friend class SampleManager;

public:
	explicit SampleUser( SampleManager &manager );
	virtual ~SampleUser( void );
private:
	explicit SampleUser( SampleUser &);
	void operator=( const SampleUser & );
protected:
	/** A new Sample has been added to SampleManager object.
	\param sampleName  The name of the added Sample.
	\param speakerName The name of the speaker
	\param addedSample The newly added Sample. */
	virtual void
		onAddSample( char const *sampleName, char const *speakerName, Sample *addedSample );

	/** Called when a Sample is selected.
	\param selectedSample The newly selected Sample */
	virtual void
		onSelectSample( Sample *selectedSample );

	/** Called when a Sample is about to be deleted.
	If a pointer matching deletedSample is held, it should be set to NULL or otherwise
	set to no longer match the sample, as that data is soon to be destroyed.
	\param deletedSample The sample which will soon be destroyed by SampleManager */
	virtual void
		onDeleteSample( Sample *deletedSample );

	/** Called when a Sample has been renamed.
	\param newSampleName The new name of the sample
	\param sample        A pointer to the sample being renamed. */
	virtual void
		onRenameSample( char const *newSampleName, Sample *sample );

	/** Called when a Sample's speaker has been changed.
	\param newSampleName The new name of the sample
	\param sample        A pointer to the sample being renamed. */
	virtual void
		onChangeSampleSpeaker( char const *speakerName, Sample *sample );

	/** Called when all the samples should be (re)loaded from the beginning. */
	virtual void
		onLoadAllSamples( void );

	virtual void
		onChangeSampleRange( Sample *sample );


private:

	SampleManager *m_manager;

};


	} }


#endif