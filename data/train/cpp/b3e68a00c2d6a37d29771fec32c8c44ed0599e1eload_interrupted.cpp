/*
 * Copyright (c) 2016 by Alexander Schroeder
 */
#include "agge/asset/load_interrupted.hpp"

namespace agge {
    namespace asset {

        load_interrupted::load_interrupted()
        {
        }

        load_interrupted::load_interrupted(const load_interrupted& e)
                        : agge::core::exception(e)
        {
        }

        load_interrupted::load_interrupted(const char *file, int line)
                        : agge::core::exception(file, line)
        {
        }

        load_interrupted::~load_interrupted()
        {
        }

        load_interrupted&
        load_interrupted::operator =(const load_interrupted& e)
        {
            agge::core::exception::operator =(e);
            return *this;
        }

    }
}
