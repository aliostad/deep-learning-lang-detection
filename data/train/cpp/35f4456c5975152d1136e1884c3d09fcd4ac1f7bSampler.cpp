//
//  Sampler.cpp

class Sampler{
public:
	Sampler(){};
	Sampler(int full_x, int full_y);
    bool getSample(Sample* sample);
private:
	int cur_x, cur_y;
    int full_x, full_y;
};



Sampler::Sampler(int fx, int fy){
    cur_x=.5; //needs to be at the center
	cur_y = .5;
    full_x=fx;
    full_y=fy;
    
}

bool Sampler::getSample(Sample* sample) {
    if (cur_x>full_x){
        cur_x=.5;
        if (cur_y>full_y) {
            return false;
        }
        cur_y++;
    }
    *sample = Sample(cur_x, cur_y);
	cur_x += 1;
	return true;
}

