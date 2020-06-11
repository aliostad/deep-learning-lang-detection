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
#ifndef __YTPKING_SMP_SampleManager_h
#define __YTPKING_SMP_SampleManager_h

#include <set>
#include <map>
#include <string>

#include "ytpking/SamplesDataFile.h"
#include "ytpking/Guid.h"


	namespace ytpking
	{
	namespace smp
	{


class Sample;
class SampleUser;


class SampleManager
{
public:
	SampleManager( void );

	/** Destructor. All samples will safely be freed on destruct. */
	~SampleManager( void );
private:
	explicit SampleManager( SampleManager & );
	void operator=( const SampleManager & );
public:

	void
		loadAll( void );

	// TODO should be private, friend

	/** Register a SampleUser with this class.
	    Callbacks on this SampleUser will then be called.
	\param  sampleUser the SampleUser instance to be registered. */
	void
		registerSampleUser( SampleUser *sampleUser );

	/** Removes a SampleUser from this object.
	    This is done by the SampleUser's destructor, so this normally shouldn't need
		to be called.
	\param sampleUser The SampleUser to unregister. */
	void
		unregisterSampleUser( SampleUser *sampleUser );


	/** Get the currently active sample. */
	Sample
		*getSelectedSample( void ) const;

	/** Set the currently active sample. */
	void
		selectSample( Sample *sample );


	/** Adds a new Sample.
	    SampleUser::onAdd will be called.
	\param filename The filename of the sample.
	\param name     The name of the sample, such as "What's for dinner"
	\param speakerName The name of the speaker, e.g. The King
	\param nodeReference If NULL, the speaker will be created in the save DataFile. */
	Sample
		*addSample( const char *filename, const char *name, const char *speakerName,
					const Guid &guid,
		            SamplesDataFile::NodeReference *nodeReference = NULL );

	/** Deletes a Sample, freeing the memeory.
	    Once freed, all remaining pointers will dangle, be sure that any
		class using them has SampleUser::onDelete defined to do so.
	\param sample The sample to delete. */
	void
		deleteSample( Sample *sample );

	/** Renames a sample.
	\param sample The sample to rename.
	\param speechName   The new name. */
	void
		renameSample( Sample *sample, const char *speechName );

	/** Changes the speaker of sample.
	\param sample The sample to rename.
	\param speakerName   The new name. */
	void
		changeSpeaker( Sample *sample, const char *speakerName );

	void
		setSampleRange( Sample *sample, unsigned int start, unsigned int end );
	void
		setSampleStart( Sample *sample, unsigned int start );
	void
		setSampleEnd( Sample *sample, unsigned int end );

	Sample
		*getSampleByGuid( const char *guid ) const;



private:

	Sample          *m_selectedSample;

	typedef std::set<SampleUser *> SampleUserSet;
	typedef std::map<std::string, Sample *> SampleMap;

	SampleMap m_samples;

	SampleUserSet m_sampleUsers;

};


#ifdef YTPKING_GST_GNL_SampleManager_cpp
	SampleManager *sampleManager = NULL;
#else
	extern SampleManager *sampleManager;
#endif


	} }


#endif
