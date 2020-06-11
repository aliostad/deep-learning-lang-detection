/* dump_dib.h
 *
 * Copyright (c) 2003 Roger Lipscombe, http://www.differentpla.net/~roger/
 */

#ifndef DUMP_DIB_H
#define DUMP_DIB_H 1

namespace dib {
    /** Dump a bitmap file that you've just loaded into memory. */
    void DumpBitmapFile(const BYTE *pBuffer, unsigned cbBuffer);

    void DumpBitmapInfoHeader(const BITMAPINFOHEADER *bmih);

    void DumpColourTable(const BITMAPINFO *bmi);
    void DumpColourTable(const RGBQUAD *colourTable, int colourCount);

    /** Dump the pixel data from 32-bpp DIBs. */
    void DumpPixelData32(const BITMAPINFOHEADER *bmih);
};  // namespace dib

#endif /* DUMP_DIB_H */
