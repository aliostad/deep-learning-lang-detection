#ifndef PLAYBACKBUFFER_H
#define PLAYBACKBUFFER_H

#include <QList>
#include <QMutexLocker>

#include "frame.h"



class BufferedSample
{
public:
	BufferedSample( Frame *f ) {
		pts = f->pts();
		sample = f->sample;
		f->sample = NULL;
		f->release();
		// release all PBO
		for ( int i = 0; i < sample->frames.count(); ++i ) {
			FrameSample *fs = sample->frames[i];
			if ( fs->frame )
				fs->frame->setPBO( NULL );
			if ( fs->transitionFrame.frame )
				fs->transitionFrame.frame->setPBO( NULL );
		}
	}
	~BufferedSample() {
		if ( sample )
			delete sample;
	}
	
	double pts;
	ProjectSample *sample;
};



class PlaybackBuffer
{
public:
	PlaybackBuffer();
	~PlaybackBuffer();
	void reset( int framerate, double skip );
	void releasedAudioFrame( Frame *f );
	void releasedVideoFrame( Frame *f );
	int getBuffer( double pts, bool back );
	ProjectSample* getVideoSample( double pts );
	ProjectSample* getAudioSample( double pts );

private:
	void reverseAudio( Frame *f );
	void checkAudioReversed( ProjectSample *sample );
	
	QList<BufferedSample*> videoSamples;
	QList<BufferedSample*> audioSamples;
	int maxFrames;
	bool backward;
	double skipPts;
	QMutex mutex;
};

#endif // PLAYBACKBUFFER_H
