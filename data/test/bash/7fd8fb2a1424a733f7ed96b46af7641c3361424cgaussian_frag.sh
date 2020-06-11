//#extension GL_OES_EGL_image_external : require
precision mediump float
uniform vec2 uTcOffset[25];
varying vec2 vTextureCoord;
uniform sampler2D sTexture;
void main() {
  vec4 sample[25];

  vec2 vCoord = vec2(1.0 - vTextureCoord.x, vTextureCoord.y);

  sample[12] = texture2D(sTexture, vCoord + uTcOffset[12]);

  sample[2] = texture2D(sTexture, vCoord + uTcOffset[2]);
  sample[6] = texture2D(sTexture, vCoord + uTcOffset[6]);
  sample[7] = texture2D(sTexture, vCoord + uTcOffset[7]);
  sample[8] = texture2D(sTexture, vCoord + uTcOffset[8]);
  sample[10] = texture2D(sTexture, vCoord + uTcOffset[10]);
  sample[11] = texture2D(sTexture, vCoord + uTcOffset[11]);

  sample[13] = texture2D(sTexture, vCoord + uTcOffset[13]);
  sample[14] = texture2D(sTexture, vCoord + uTcOffset[14]);
  sample[16] = texture2D(sTexture, vCoord + uTcOffset[16]);
  sample[17] = texture2D(sTexture, vCoord + uTcOffset[17]);
  sample[18] = texture2D(sTexture, vCoord + uTcOffset[18]);
  sample[22] = texture2D(sTexture, vCoord + uTcOffset[22]);


  sample[1] = texture2D(sTexture, vCoord + uTcOffset[1]);
  sample[5] = texture2D(sTexture, vCoord + uTcOffset[5]);
  sample[3] = texture2D(sTexture, vCoord + uTcOffset[3]);
  sample[9] = texture2D(sTexture, vCoord + uTcOffset[9]);
  sample[15] = texture2D(sTexture, vCoord + uTcOffset[15]);
  sample[19] = texture2D(sTexture, vCoord + uTcOffset[19]);
  sample[21] = texture2D(sTexture, vCoord + uTcOffset[21]);
  sample[23] = texture2D(sTexture, vCoord + uTcOffset[23]);

  sample[0] = texture2D(sTexture, vCoord + uTcOffset[0]);
  sample[4] = texture2D(sTexture, vCoord + uTcOffset[4]);
  sample[20] = texture2D(sTexture, vCoord + uTcOffset[20]);
  sample[24] = texture2D(sTexture, vCoord + uTcOffset[24]);

                        // Gaussian weighting:
                        // 1  4  7  4 1
                        // 4 16 26 16 4
                        // 7 26 41 26 7 / 273 (i.e. divide by total of weightings)
                        // 4 16 26 16 4
                        // 1  4  7  4 1

                        //  gl_FragColor = (
                        //       (1.0  * (sample[0] + sample[4]  + sample[20] + sample[24])) +
                        //       (4.0  * (sample[1] + sample[3]  + sample[5]  + sample[9] + sample[15] + sample[19] + sample[21] + sample[23])) +
                        //       (7.0  * (sample[2] + sample[10] + sample[14] + sample[22])) +
                        //       (16.0 * (sample[6] + sample[8]  + sample[16] + sample[18])) +
                        //       (26.0 * (sample[7] + sample[11] + sample[13] + sample[17])) +
                        //       (41.0 * sample[12])
                        //       ) / 273.0;

  vec4 color = (
            (sample[0] + sample[4]  + sample[20] + sample[24]) +
            (sample[1] + sample[3]  + sample[5]  + sample[9] + sample[15] + sample[19] + sample[21] + sample[23]) +
            (sample[2] + sample[10] + sample[14] + sample[22]) +
            (sample[6] + sample[8]  + sample[16] + sample[18]) +
            (sample[7] + sample[11] + sample[13] + sample[17]) +
            sample[12]) / 58.0;
  gl_FragColor = vec4(color.rgb, 1);
}

