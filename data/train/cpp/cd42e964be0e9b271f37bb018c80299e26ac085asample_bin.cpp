#include "sample_bin.h"

#include <algorithm>
#include <allegro5/allegro5.h>
#include <allegro5/allegro_memfile.h>

#include <string>
//#include <iostream>
#include <sstream>


#include <allegro5/allegro_audio.h>
#include <allegro5/allegro_acodec.h>

#include <vector>


struct SampleRecord;

class SampleBin
{
private:
	std::vector<SampleRecord *> sample;
	char path[64];

public:
	SampleBin(const char *path="");
	~SampleBin();

	void set_path(const char *path);

	bool preload_sample(const char *filename);

	ALLEGRO_SAMPLE *get_sample(const char *filename);

	bool destroy_sample(const char *filename);
	void clear_samples();
	size_t size();
};


//static SampleBin *_current_sample_bin = NULL;

using std::vector;
//using std::string;


#ifdef WIN32
	#undef strcpy
	#define strcpy strcpy_s
	#undef strcat
	#define strcat strcat_s
	#undef strncpy
	#define strncpy strncpy_s
	#undef strncat
	#define strncat strncat_s
#endif

struct SampleRecord
{
	char basename[64];
	ALLEGRO_SAMPLE *sample;
};

/**********************/

static const int SAMPLE_NO_INDEX = -1;
static ALLEGRO_SAMPLE *default_sample = NULL;
SampleBin *primary_sample_bin;

static inline bool sample_sort_algorithm(const SampleRecord *r1, const SampleRecord *r2)
{
	return (strncmp(r1->basename, r2->basename, 64)<0);
}

static inline void sort_samples(vector<SampleRecord *> &bin)
{
	std::sort(bin.begin(), bin.end(), sample_sort_algorithm);
}

static inline int get_index(vector<SampleRecord *> *bin, const char *basename)
{
	int first, last, mid, comp;

	if (bin->empty()) return SAMPLE_NO_INDEX;

	first = 0;
	last = bin->size()-1;

	while (first <= last)
	{
		mid = (first + last) / 2;  // compute mid point.
		comp = strcmp(bin->at(mid)->basename, basename);

		if (comp < 0) first = mid + 1;  // repeat search in top half.
		else if (comp > 0) last = mid - 1; // repeat search in bottom half.
		else return mid;     // found it. return position
	}

	return SAMPLE_NO_INDEX;
}

// this function loads and appends an sample into the bin and sorts the bin.
// there are no checks in this function if the sample already exists in the bin.
static inline ALLEGRO_SAMPLE *load_sample(vector<SampleRecord *> *bin, const char *path, const char *basename, const char *extension=".ogg")
{
	bin->push_back(new SampleRecord());
	char full_filename[64];
	strcpy(bin->back()->basename, basename);

	strncpy(full_filename, path, 64);
	strncat(full_filename, basename, 64);
	strncat(full_filename, extension, 64);
	bin->back()->sample = al_load_sample(full_filename);

	if (!bin->back()->sample)
	{
		bin->back()->sample = default_sample;
		//std::cout << " ! could not load sample \"" << basename << "\"." << std::endl;
	}
	else
	{
		//std::cout << " - loaded sample \"" << basename << "\"." << std::endl;
	}
	ALLEGRO_SAMPLE *img = bin->back()->sample;
	sort_samples(*bin);
	return img;
}

static bool create_default_sample();
static bool first_bin_created = false;

/**********************/

SampleBin::SampleBin(const char path[64])
{
	clear_samples();
	strcpy(this->path, path);
	if (!first_bin_created)
	{
		create_default_sample();
	}
	primary_sample_bin = this;
}

SampleBin::~SampleBin()
{
	clear_samples();
}

bool SampleBin::preload_sample(const char *basename)
{
	if (load_sample(&sample, path, basename) != default_sample) return true;
	return false;
}

ALLEGRO_SAMPLE *SampleBin::get_sample(const char *basename)
{
	int index = get_index(&sample, basename);
	if (index == SAMPLE_NO_INDEX) return load_sample(&sample, path, basename);
	return sample[index]->sample;
}

bool SampleBin::destroy_sample(const char *basename)
{
	int index = get_index(&sample, basename);
	if (index == SAMPLE_NO_INDEX) return false;
	if (sample[index]->sample != default_sample)
		al_destroy_sample(sample[index]->sample);
	sample.erase(sample.begin()+index);
	return true;
}

void SampleBin::clear_samples()
{
	for (int i=0; i<(int)sample.size(); i++)
		if (sample[i]->sample != default_sample)
			al_destroy_sample(sample[i]->sample);
	sample.clear();
}

size_t SampleBin::size()
{
	return sample.size();
}

/**********************/


static bool create_default_sample()
{
	if (default_sample) return true;

	default_sample = al_load_sample("data/default.wav");
	if (!default_sample)
	{
		//std::cout << "(!) Critical - could not load default.wav" << std::endl;
		return false;
	}

	return true;
}


void SampleBin::set_path(const char *path)
{
	strcpy(this->path, path);
}


inline static SampleBin* get_sample_bin_instance()
{
	if (!primary_sample_bin) primary_sample_bin = new SampleBin("data/sounds/");
	return primary_sample_bin;
}


/**********************/

ALLEGRO_SAMPLE *get_sample(const char *basename)
{
	return get_sample_bin_instance()->get_sample(basename);
}

void set_sample_path(const char *path)
{
	get_sample_bin_instance()->set_path(path);
}