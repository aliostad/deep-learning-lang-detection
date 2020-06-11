// Copyright (c) 2015 Yhgenomics. All rights reserved.
// Description:  BinaryTree implement
// Creator: Shubo Yang
// Date: 2015/08/27

#ifndef BASE_PAIR_LOCATOR_H_
#define BASE_PAIR_LOCATOR_H_

#include "Stella.h"
#include "SharedGeneData.h"

class BasePairSequenceLocator
{
public:

    BasePairSequenceLocator();
    ~BasePairSequenceLocator();

    void SetData(SharedGeneData* data);
    BasePairIndex* Search(unsigned code);

private:

    SharedGeneData* geneData_;
    size_t tail_;
    size_t cur_;
};

#endif //BASE_PAIR_LOCATOR_H_