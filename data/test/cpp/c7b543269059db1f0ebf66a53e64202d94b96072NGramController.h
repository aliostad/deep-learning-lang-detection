#ifndef TEXTASSISTANT_NGRAMCONTROLLER_H
#define TEXTASSISTANT_NGRAMCONTROLLER_H

#include "database/MysqlDbController.h"
#include "database/NGramRepo.h"
#include "utils/TextParser.h"
#include "NGram.h"

#define NOT_FOUND_IND -1

namespace text_assistant {

    class NGramRepo;

    class NGramController {
    private:
        const NGramRepo &repo;
    public:
        vector<NGram> nGrams;
        int n;

        void            learnOnTextFile(const char* fullPath);
        string          toString();

                        NGramController(const NGramRepo &nGramRepo);

    private:
        long long          getIndex(NGram nGram);

    };

}

#endif //TEXTASSISTANT_NGRAMCONTROLLER_H
