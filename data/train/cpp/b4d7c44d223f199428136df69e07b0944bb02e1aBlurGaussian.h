#pragma once

#define STRINGIFY(A) #A

#include "ofxPatches/patches/Base5x5KernelEffect.h"


namespace ofxPatches {
	
	class BlurGaussian : public Base5x5KernelEffect {	
	public:
		BlurGaussian * create() { return new BlurGaussian(); };
		
		BlurGaussian(){
			name = "Gaussian Blur";
			
			fragmentShader += STRINGIFY(
										vec4 sample[25];
										
										void main(void){											
			
											// Sample a grid around and including our texel
											if(pass == 0){											
												for (int i = 0; i < 25; i++){												
													sample[i] = texture2DRect(tex0, gl_TexCoord[0].st + offset[i]);
												}
											}else{
												for (int i = 0; i < 25; i++){												
													sample[i] = texture2DRect(backbuffer, gl_TexCoord[0].st + offset[i]);
												}
											}
											
			
											// Gaussian weighting:
											// 1  4  7  4 1
											// 4 16 26 16 4
											// 7 26 41 26 7 / 273 (i.e. divide by total of weightings)
											// 4 16 26 16 4
											// 1  4  7  4 1
											
											gl_FragColor = (
														   (1.0  * (sample[0] + sample[4]  + sample[20] + sample[24])) +
														   (4.0  * (sample[1] + sample[3]  + sample[5]  + sample[9] + sample[15] + sample[19] + sample[21] + sample[23])) +
														   (7.0  * (sample[2] + sample[10] + sample[14] + sample[22])) +
														   (16.0 * (sample[6] + sample[8]  + sample[16] + sample[18])) +
														   (26.0 * (sample[7] + sample[11] + sample[13] + sample[17])) +
														   (41.0 * sample[12])
														   ) / 273.0;
										}
									   );
		}		
	};
	
}

