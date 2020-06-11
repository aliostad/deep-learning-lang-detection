#ifndef DY_SAMPLE_H
#define DY_SAMPLE_H

#include <string>
#include <iostream>
#include "TChain.h"
#include "TColor.h"

namespace dy
{
    // simple Sample class
    class Sample
    {
        public:
            // list of available samples
            enum value_type
            {
                data,
                dyll,
                dytt,
                wjets,
                ttdil,
                ttslq,
                tthad,
                qcdmu15,
                ww2l2nu,
                wz2l2q,
                wz3lnu,
                zz2l2nu,
                zz2l2q,
                zz4l,

                static_size
            };

            // sample information
            struct Info
            {
                std::string name;        // short name
                std::string title;       // ROOT TLatex title
                std::string latex;       // real latex title
                std::string ntuple_path; // logical name for path
                Color_t color;           // color for plots
                double filter_eff;       // SD filter efficiency
                value_type sample;       // redundant process enum
            };

            // members: 
            static void SetPsetPath(const std::string& pset_path);
            static const std::string& GetPsetPath();
            static const std::vector<dy::Sample::Info>& GetInfos();
    };

    // operators:
    bool operator < (const Sample::Info& s1, const Sample::Info& s2);
    std::ostream& operator << (std::ostream& out, const Sample::Info& sample_info);

    // print all available sample infos
    void PrintSampleInfos(std::ostream& out = std::cout);

    // get the Sample from a string/number
    Sample::value_type GetSampleFromName(const std::string& sample_name);
    Sample::value_type GetSampleFromNumber(const int sample_num);

    // test if a string is on of the samples
    bool IsSample(const std::string& sample_name);

    // wrapper function to get the Sample::Info
    Sample::Info GetSampleInfo(const Sample::value_type& sample);
    Sample::Info GetSampleInfo(const std::string& sample_name);
    Sample::Info GetSampleInfo(const int sample_num);

    // get the chain from the Sample
    TChain* GetSampleTChain(const Sample::value_type& sample); 

} // namespace dy

#endif //DY_SAMPLE_H
