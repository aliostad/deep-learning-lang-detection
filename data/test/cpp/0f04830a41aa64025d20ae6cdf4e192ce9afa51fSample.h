#ifndef FR_SAMPLE_H
#define FR_SAMPLE_H

#include "TColor.h"
#include "TChain.h"

namespace fr
{
    // list of available samples
    struct Sample
    {
        enum value_type
        {
            data,
            data_mu,
            data_el,
            qcd,
            ttbar,
            tthad,
            wjets,
            dy,
            static_size
        };
    };

    // list of available sample types
    struct SampleType
    {
        enum value_type
        {
            data,
            signal,
            bkgd,
            static_size
        };
    };

    // Sample Infomation
    struct SampleInfo
    {
        const char* name;
        const char* title;
        const char* baby_path;
        const char* output_file;
        SampleType::value_type type;
        Color_t color; 
    };

    // Get the sample from a string
    Sample::value_type GetSampleFromName(const std::string& sample_name);

    // wrapper function to get the SampleInfo
    SampleInfo GetSampleInfo(const Sample::value_type& sample);
    SampleInfo GetSampleInfo(const std::string& sample_name);

    // get the chain from the Sample
    // NOTE: user in charge of deleting
    TChain* GetSampleTChain(const Sample::value_type& sample); 

} // namespace fr

#endif // #define FR_SAMPLES_H

