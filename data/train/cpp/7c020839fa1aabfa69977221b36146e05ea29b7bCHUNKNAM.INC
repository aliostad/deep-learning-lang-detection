{ Chunk names }


  const

        MingChunk_BASI               = $49534142; { BASI }
        MingChunk_DEFI               = $49464544; { DEFI }
        MingChunk_FRAM               = $4D415246; { FRAM }
        MingChunk_GAMA               = $414D4167; { gAMA }
        MingChunk_IDAT               = $54414449; { IDAT }
        MingChunk_IEND               = $444E4549; { IEND }
        MingChunk_IHDR               = $52444849; { IHDR }
        MingChunk_JHDR               = $5244484A; { JHDR }
        MingChunk_JDAT               = $5441444A; { JDAT }
        MingChunk_JSEP               = $00000000; { JSEP }
        MingChunk_MEND               = $444E454D; { MEND }
        MingChunk_MHDR               = $5244484D; { MHDR }
        MingChunk_PLTE               = $45544C50; { PLTE }
        MingChunk_TEXT               = $74584574; { tEXt }
        MingChunk_ZTXT               = $7458547A; { zTXt }

        MingChunk_NoChunk            = $40402020;


  { Long chunk names }
  const MingChunk_MiNGHead           = MingChunk_MHDR;
        MingChunk_EndOfFile          = MingChunk_MEND;
        MingChunk_EndOfImage         = MingChunk_IEND;
        MingChunk_PiNGHead           = MingChunk_IHDR;
        MingChunk_DefineObj          = MingChunk_DEFI;
        MingChunk_ImageData          = MingChunk_IDAT;
        MingChunk_PiNGPalette        = MingChunk_PLTE;
        MingChunk_LatinText          = MingChunk_TEXT;
        MingChunk_CompressedText     = MingChunk_ZTXT;
        MingChunk_GammaExp           = MingChunk_GAMA;
        MingChunk_FrameDef           = MingChunk_FRAM;
        MingChunk_JiNGHead           = MingChunk_JHDR;
        MingChunk_JingData           = MingChunk_JDAT;
        MingChunk_JingAlphaData      = MingChunk_IDAT;
        MingChunk_JingSeparator      = MingChunk_JSEP;


