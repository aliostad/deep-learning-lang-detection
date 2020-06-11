//
//  Sample_Rate.h
//  Oscillators
//
//  Created by Alexander Zywicki on 8/6/14.
//  Copyright (c) 2014 Alexander Zywicki. All rights reserved.
//

#ifndef __Oscillators__Sample_Rate__
#define __Oscillators__Sample_Rate__


namespace DSG {
    
    
        
        class SampleRate {
        public:
            static void Set(double const& value);
            static double const& Sample_Rate();
            static double const& Sample_Rate_Inverse();
        protected:
            static double sample_rate;
            static double sample_rate_inverse;
        };
        
        
        
        inline double const& Sample_Rate(){
            return SampleRate::Sample_Rate();
        }
        inline double const Sample_Rate_Inverse(){
            return SampleRate::Sample_Rate_Inverse();
        }
        inline void Sample_Rate(double const& rate){
            SampleRate::Set(rate);
        }
    
}

#endif /* defined(__Oscillators__Sample_Rate__) */
