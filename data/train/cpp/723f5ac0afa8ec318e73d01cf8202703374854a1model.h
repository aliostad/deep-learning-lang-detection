//Scott Lee, 2013
#ifndef MODEL_H
#define MODEL_H
#include <usrp_subdev_spec.h>

class model
{
public:
    model();
    // accessors
    void   set_model_freq(double freq) { model_freq = freq; }
    double get_model_freq() { return model_freq; }
    void   set_model_gain(double gain) { model_gain = gain; }
    int    get_model_gain() { return model_gain; }
    void   set_model_volume(int volume){ model_volume = volume; }
    int    get_model_volume() { return model_volume; }
    void   set_model_spec(usrp_subdev_spec spec) { model_spec = spec; }
    usrp_subdev_spec&   get_model_spec() {  return model_spec; }

    // public consts
    static int  model_hw_decim;
private:
    double            model_freq;
    int               model_gain;
    int               model_volume;
    usrp_subdev_spec  model_spec;
};

#endif // MODEL_H

