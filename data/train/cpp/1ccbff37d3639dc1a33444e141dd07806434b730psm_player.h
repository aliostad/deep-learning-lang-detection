#pragma once

namespace voip_core{

    struct psm_stream;
    class psm_player{
        bool is_pause_;
        bool is_stop_;
    public:
        // stream
        psm_stream*  start_stream(int channels, int type, int rate);
        int queue_data(psm_stream* stream, void* data, size_t size);
        int pause_stream(psm_stream* stream, bool bpause);
        int stop_stream(psm_stream* stream);
        bool is_pause(psm_stream* stream);
        bool is_stop(psm_stream* stream);

        // segment
        void play_psm(void* data, size_t size);

    protected:
        int _begin_stream(psm_stream* stream, void* data, size_t size);
        int _update_stream(psm_stream* stream, void* data, size_t size);
    };

}