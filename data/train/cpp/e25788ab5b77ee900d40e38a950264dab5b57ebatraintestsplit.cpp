#include "traintestsplit.h"

TrainTestSplit::TrainTestSplit() {
	this->train_sample_part.count = 0;
	this->train_sample_part_mode = 0;
	this->mix = false;
}
    
TrainTestSplit::TrainTestSplit( int train_sample_count, bool mix) {
	this->train_sample_part.count = train_sample_count;
	this->train_sample_part_mode = 0;
	this->mix = mix;
}

TrainTestSplit::TrainTestSplit( float train_sample_portion, bool mix) {
	this->train_sample_part.portion = train_sample_portion;
	this->train_sample_part_mode = 1;
	this->mix = mix;
}

TrainTestSplit::TrainTestSplit( double train_sample_portion, bool mix) {
    this->train_sample_part.portion = (float) train_sample_portion;
    this->train_sample_part_mode = 1;
    this->mix = mix;
}
