#include "Analysis/DrellYan/interface/Sample.h"
#include "AnalysisTools/LanguageTools/interface/StringTools.h"
#include "AnalysisTools/LanguageTools/interface/OSTools.h"
#include <stdexcept>
#include <vector>
#include <string>
#include <iostream>
#include <cassert>
#include "TChain.h"
#include "TColor.h"


#include "FWCore/ParameterSet/interface/ParameterSet.h"
#include "FWCore/PythonParameterSet/interface/MakeParameterSets.h"

namespace dy
{
    // path to file that holds the sample metadata
    std::string& PsetPath()
    {
        static std::string sample_pset_path = "psets/dy_samples_cfg.py";
        return sample_pset_path;
    }
        
    // parameter set vector
    std::vector<edm::ParameterSet>& PsetVector()
    {
        static std::vector<edm::ParameterSet> pset_vec;
        return pset_vec;
    }

    // reset pset
    void ResetPsetVector()
    {
        const edm::ParameterSet& process = edm::readPSetsFrom(PsetPath())->getParameter<edm::ParameterSet>("process");
        PsetVector() = process.getParameter<std::vector<edm::ParameterSet> >("dy_samples");
    }

    // create a sample Info from the pset
    Sample::Info CreateSampleInfo(const Sample::value_type sample, const std::vector<edm::ParameterSet>& pset_vec)
    {
        assert(pset_vec.size() == Sample::static_size);
        const auto& pset = pset_vec[sample];
        Sample::Info info
        {
            pset.getParameter<std::string>("name"),
            pset.getParameter<std::string>("title"),
            pset.getParameter<std::string>("latex"),
            pset.getParameter<std::string>("ntuple_path"),
            static_cast<Color_t>(pset.getParameter<int>("color")),
            pset.getParameter<double>("eff"),
            sample
        };
        return info;
    }

    // re-assign the SampleInfos
    std::vector<Sample::Info> GetInitialSampleInfosFromPset()
    {
        ResetPsetVector();
        assert(PsetVector().size() == Sample::static_size);
        std::vector<Sample::Info> sample_infos;
        sample_infos.reserve(Sample::static_size);
        for (size_t i = 0; i < PsetVector().size(); ++i)
        {
            sample_infos.push_back(CreateSampleInfo(static_cast<Sample::value_type>(i), PsetVector()));
        }
        assert(sample_infos.size() == Sample::static_size);
        return sample_infos;
    }

    // Vector of SampleInfo's with the relevant metadata
    /*static*/ std::vector<Sample::Info>& SampleInfos()
    {
        static std::vector<Sample::Info> sample_infos = GetInitialSampleInfosFromPset();
        assert(sample_infos.size() == Sample::static_size);
        return sample_infos;
    }

    // Vector of SampleInfo's with the relevant metadata
    /*static*/ const std::vector<Sample::Info>& Sample::GetInfos()
    {
        return SampleInfos();
    }

    // re-assign the SampleInfos
    std::vector<Sample::Info> GetSampleInfosFromPset()
    {
        std::vector<Sample::Info> sample_infos;
        sample_infos.reserve(Sample::static_size);
        for (auto& sample_info : Sample::GetInfos())
        {
            sample_infos.push_back(CreateSampleInfo(sample_info.sample, PsetVector()));
        }
        assert(sample_infos.size() == Sample::static_size);
        return sample_infos;
    }

    // rest the pset 
    /*static*/ void Sample::SetPsetPath(const std::string& pset_path)
    {
        PsetPath() = pset_path;
        ResetPsetVector();
        SampleInfos() = GetSampleInfosFromPset();
    }

    // get the current pset
    /*static*/ const std::string& Sample::GetPsetPath()
    {
        return PsetPath();
    }

    // operators:
    bool operator < (const Sample::Info& s1, const Sample::Info& s2)
    {
        return (s1.sample < s2.sample);
    }

    std::ostream& operator << (std::ostream& out, const Sample::Info& sample_info)
    {
        out << Form("Sample::Info = {\n\t%s, \n\t%s, \n\t%s, \n\t%s, \n\t%d, \n\t%f, \n\t%d\n}",
                    sample_info.name.c_str(),
                    sample_info.title.c_str(),
                    sample_info.latex.c_str(),
                    sample_info.ntuple_path.c_str(),
                    sample_info.color,
                    sample_info.filter_eff,
                    sample_info.sample);
        return out;               
    }

    // print all available sample infos
    void PrintSampleInfos(std::ostream& out)
    {
        for (const auto& sample_info : Sample::GetInfos())
        {
            out << sample_info << '\n';
        }
        out << '\n';
    }

    // Get the Sample from a string
    Sample::value_type GetSampleFromName(const std::string& sample_name)
    {
        for (const auto& sample_info : Sample::GetInfos())
        {
            if (sample_info.name == sample_name)
            {
                return sample_info.sample; 
            }
        }

        // throw if not found
        throw std::domain_error(Form("[dy::GetSampleInfo] Error: sample %s not found!", sample_name.c_str()));
    }

    // Get the Sample from a number
    Sample::value_type GetSampleFromNumber(const int sample_num)
    {
        // throw if not found
        if (sample_num < 0 or sample_num >= Sample::static_size)
        {
            throw std::domain_error("[dy::GetSampleInfo] Error: sample number out of bounds!");
        }
        return static_cast<Sample::value_type>(sample_num);
    }


    // test if a string is a sample name 
    bool IsSample(const std::string& sample_name)
    {
        for (const auto& sample_info : Sample::GetInfos())
        {
            if (sample_info.name == sample_name)
            {
                return true; 
            }
        }
        return false;
    }

    // wrapper function to get the SampleInfo
    Sample::Info GetSampleInfo(const Sample::value_type& sample)
    {
        return Sample::GetInfos()[sample]; 
    }

    Sample::Info GetSampleInfo(const std::string& sample_name)
    {
        Sample::value_type sample = GetSampleFromName(sample_name); 
        return GetSampleInfo(sample); 
    }

    Sample::Info GetSampleInfo(const int sample_num)
    {
        Sample::value_type sample = GetSampleFromNumber(sample_num); 
        return GetSampleInfo(sample); 
    }

    // get the chain from the Sample
    TChain* GetSampleTChain(const Sample::value_type& sample)
    {
        const Sample::Info info = GetSampleInfo(sample);

        // build the list of files
        std::vector<std::string> vpath = lt::string_split(info.ntuple_path, ",");

        // build the chain
        TChain* chain = new TChain("Events");
        for (const auto& file : vpath)
        {
            chain->Add(file.c_str());
        }
        return chain;
    }

} // namespace dy
 
