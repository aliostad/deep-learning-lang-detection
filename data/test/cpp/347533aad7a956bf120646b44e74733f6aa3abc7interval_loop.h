// http://www.apache.org/licenses/LICENSE-2.0
// Copyright 2014 Perttu Ahola <celeron55@gmail.com>
#pragma once
#include <functional>
#include <cstring> // memset()
#include <unistd.h> // usleep()
#include "os.h" // get_timeofday_us()
#include "log.h"

// If f() returns false, loop ends
void interval_loop(int interval_us, std::function<bool(float load_avg)> f)
{
	int64_t t_scheduled_tick_start = get_timeofday_us();
	t_scheduled_tick_start /= interval_us; // Align to round numbers
	t_scheduled_tick_start *= interval_us;
	float load_sum = 0;
	const int load_avg_length = interval_us < 500000 ? 5000000 / interval_us : 1;
	float *load_log = new float[load_avg_length];
	memset(load_log, 0, sizeof(float) * load_avg_length);
	int load_log_i = load_avg_length - 1;
	float last_load_avg = 0;
	for(;;){
		int64_t t_now = get_timeofday_us();
		t_scheduled_tick_start += interval_us;
		int64_t t_until_next_tick = t_scheduled_tick_start - t_now;
		if(t_until_next_tick < 0 || t_until_next_tick > interval_us){
			log_w("loop", "interval_loop(): Delayed by %" PRId64 "ms"
					" (%+.0f%% interval)", -t_until_next_tick / 1000,
					-100.0 * t_until_next_tick / interval_us);
			// Give up if off by too much (100ms)
			if(t_scheduled_tick_start < t_now - 100000){
				t_scheduled_tick_start = t_now;
				t_until_next_tick = 0;
			}
		}
		if(t_until_next_tick > 0)
			usleep(t_until_next_tick);
		int64_t t_tick_start = get_timeofday_us();
		//log_i("loop", "t_tick_start=%" PRId64, t_tick_start);

		if(!f(last_load_avg))
			break;

		int64_t t_tick_end = get_timeofday_us();
		int64_t t_tick_length = t_tick_end > t_tick_start ? t_tick_end -
				t_tick_start : 0;
		float load_ratio = (float)t_tick_length / interval_us;
		//log_i("loop", "load_ratio=%f", load_ratio);
		load_log[load_log_i] = load_ratio;
		load_sum += load_log[load_log_i];
		load_log_i = (load_log_i + 1) % load_avg_length;
		float load_avg = load_sum / load_avg_length;
		//log_i("loop", "load_avg=%f", load_avg);
		last_load_avg = load_avg;
		load_sum -= load_log[load_log_i];
	}
	delete[] load_log;
}

// vim: set noet ts=4 sw=4:
