/*
 * Copyright (c) 2016 by Alexander Schroeder
 */
#ifndef AGGE_ASSET_LOAD_INTERRUPTED_HPP
#define AGGE_ASSET_LOAD_INTERRUPTED_HPP

#include "dllexport.hpp"
#include "agge/core/exception.hpp"

namespace agge {
    namespace asset {

    /**
     * @class load_interrupted
     * @brief Exception thrown if an asset load is being interrupted.
     */
    class AGGE_ASSET_EXPORT load_interrupted : public agge::core::exception
    {
    public:
        load_interrupted();
        load_interrupted(const load_interrupted& e);
        load_interrupted(const char *file, int line);
        virtual ~load_interrupted();
        load_interrupted& operator=(const load_interrupted& e);

        template <typename T>
        load_interrupted& operator <<(const T& t)
        {
            agge::core::exception::operator <<(t);
            return *this;
        }
    };

}
}

#endif
