#ifndef TEXTASSISTANT_NGRAMCONTROLLERTEST_H
#define TEXTASSISTANT_NGRAMCONTROLLERTEST_H

#include <gtest/gtest.h>
#include "../NGramController.h"
#include "../database/NGramRepo.h"

namespace text_assistant {

    TEST (NGramsTest, EqualityOfN) {
        ConnectionSettings settings;
        settings.server = "localhost";
        settings.user = "root";
        settings.password = "";
        settings.database = "text_assistant1";

        NGramRepo repo(10, settings);

        NGramController controller(repo);
        ASSERT_TRUE (controller.n == 10);
    }

}

#endif //TEXTASSISTANT_NGRAMCONTROLLERTEST_H
