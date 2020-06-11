#include "PaStream.hpp"
#include "PaContext.hpp"
#include "SoundPlayer.hpp"
#include "PaStreamListener.hpp"
#include "../schema/PulseaudioSchema.hpp"

#include "util/error/Log.hpp"

namespace se_pulseaudio {
	PaStream::PaStream(PaContext &c, VorbisSound& sound, int volume, bool shouldLoop) 
		: context_(c), currentSection_(0), bytesWritten_(0), bytesRead_(0), vorbisFile_(0), shouldLoop_(shouldLoop) {
		static int streamId = 0;

		pa_sample_format_t format = PA_SAMPLE_S16LE;
		int channels = sound.channels();
		int samplerate = sound.sampleRate();
		const pa_sample_spec ss = {
			format,
			samplerate,
			channels
		};

		sprintf(name_, "%s_%d_stream", c.name(), streamId++);
		stream_ = pa_stream_new(c.context(), name_, &ss, NULL);
		if(stream_) {
			LogDetail("Stream created!  Getting there!");
		}

		pa_stream_set_write_callback(stream_, PaStream::stream_write_callback, this);
		pa_stream_set_state_callback(stream_, PaStream::stream_state_callback, this);

		pa_volume_t v = PA_VOLUME_NORM* volume / 256;
		pa_cvolume cv;
		pa_stream_connect_playback(stream_, NULL, NULL, (pa_stream_flags_t)0, pa_cvolume_set(&cv, ss.channels, v), NULL);

		sound_ = &sound;
		context_.incStreamRef(this);
	}


	PaStream::~PaStream() {
		LogDetail("Destroy stream " << name_);
		if(sound_ && vorbisFile_) {
			sound_->close(vorbisFile_);
			currentSection_ = 0;
		}
		pa_stream_unref(stream_);
		context_.decStreamRef(this);
	}


	void PaStream::play() {
		currentSection_ = 0;
		bytesWritten_ = bytesRead_ = 0;
		vorbisFile_ = sound_->open();
		LogDetail("New stream " << name_);
		doStreamWrite();
	}

	void PaStream::stop() {
		LogDetail("Corking stream");
		pa_stream_cork(stream_, 1, stream_corked_callback, this);
	}


	void PaStream::doStreamWrite() {
		if(PA_STREAM_READY == pa_stream_get_state(stream_)) {
			size_t writableSize = pa_stream_writable_size(stream_);
			while(doStreamWrite(writableSize) > 0) {
				writableSize = pa_stream_writable_size(stream_);
			}
		}
	}


	int PaStream::doStreamWrite(size_t length) {
		if(!sound_ || length == 0) {
			return 0;
		}


		if(bytesWritten_ >= bytesRead_) {
			bytesWritten_ = 0;
			bytesRead_ = bytesRead_ = sound_->read(pcmout_, sizeof(pcmout_), vorbisFile_, currentSection_);
		}

		if (bytesRead_ < 0) {
			LogWarning("Error in stream");
			sound_ = 0;
			return 0;
		}

		if(bytesRead_ == 0) {
			// End of sound
			isDraining_ = true;
			pa_stream_drain(stream_, stream_drained_callback, this);
			return 0;
		}

		if(PA_STREAM_READY == pa_stream_get_state(stream_)) {
			const size_t writableSize = pa_stream_writable_size(stream_);
			const size_t writeSize = (bytesRead_ - bytesWritten_ < writableSize ? bytesRead_ - bytesWritten_ : writableSize);

			if(writeSize > 0) {
				pa_stream_write(stream_, pcmout_ + bytesWritten_, writeSize, NULL, 0, PA_SEEK_RELATIVE);
			}
			bytesWritten_ += writeSize;
			return writeSize;
		}
	}



	void PaStream::stream_write_callback(pa_stream *stream, size_t length, void *userdata) {
		PaStream* s = (PaStream*)userdata;
		Assert(stream);
		Assert(length > 0);
		Assert(stream == s->stream_);

		s->doStreamWrite();
	}


	void PaStream::stream_drained_callback(pa_stream *stream, int success, void *userdata) {
		AssertWarning(success, "Stream drain failed");
		PaStream* s = (PaStream*)userdata;
		s->isDraining_ = false;
		LogDetail("Stream drained");
		pa_stream_disconnect(s->stream_);

		if(s->context().streamListener()) {
			s->context().streamListener()->streamEnded(s);
		}

		// TODO: Should support loop
	}


	void PaStream::stream_corked_callback(pa_stream *stream, int success, void *userdata) {
		AssertWarning(success, "Corking sound returned failure");
		PaStream* s = (PaStream*)userdata;
		s->isDraining_ = false;

		LogDetail("Stream stopped");
		pa_stream_disconnect(s->stream_);

		if(s->context().streamListener()) {
			s->context().streamListener()->streamStopped(s);
		}
	}


	void PaStream::stream_state_callback(pa_stream *stream, void *userdata) {
		Assert(stream);
		PaStream* s = (PaStream*)userdata;
		Assert(s && s->stream_ == stream);
		switch (pa_stream_get_state(stream)) {
		case PA_STREAM_CREATING:
			LogDetail("PA_STREAM_CREATING");
			break;

		case PA_STREAM_TERMINATED:
			LogDetail("PA_STREAM_TERMINATED");
			delete s;
			break;
 
		case PA_STREAM_READY:
			s->play();
			LogDetail("PA_STREAM_READY");
			break;

		case PA_STREAM_FAILED:
			LogDetail("PA_STREAM_FAILED");
			LogWarning("Stream error: " << pa_strerror(pa_context_errno(pa_stream_get_context(stream))));
			delete s;
			break;

		default:
			LogWarning("Stream error: " << pa_strerror(pa_context_errno(pa_stream_get_context(stream))));
		}
	}
}

