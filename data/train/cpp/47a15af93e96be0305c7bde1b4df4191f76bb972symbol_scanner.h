//
// Created by 王安然 on 15/8/7.
//

#ifndef DCODE_SYMBOL_SCANNER_H
#define DCODE_SYMBOL_SCANNER_H

#include "utils/utils.h"
#include "Physical.h"
#include "locator_scanner.h"

class Symbol_scanner{
private:
    Pixel_reader* reader_;
public:
    Symbol_scanner(Pixel_reader* reader);

    struct Block_anchor{
        Locator_scanner::Locator_scanner_result
                *left_top,
                *right_top,
                *left_bottom,
                *right_bottom;

        Block_anchor(const Locator_scanner::Locator_scanner_result* _left_top, const Locator_scanner::Locator_scanner_result* _right_top,
                     const Locator_scanner::Locator_scanner_result* _left_bottom, const Locator_scanner::Locator_scanner_result* _right_bottom):
                left_top(_left_top),right_top(_right_top), left_bottom(_left_bottom), right_bottom(_right_bottom){}

    };

    Mat<Option<Block_anchor>> get_anchors(Mat<Option<Locator_scanner::Locator_scanner_result>>& map);
};
#endif //DCODE_SYMBOL_SCANNER_H
