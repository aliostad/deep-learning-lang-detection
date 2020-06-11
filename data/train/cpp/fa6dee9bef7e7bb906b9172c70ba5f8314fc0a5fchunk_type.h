#ifndef FWT_CHUNK_TYPE_H
#define FWT_CHUNK_TYPE_H

#include "type.h"

#define FOREACH_CHUNK(CHUNK) \
        CHUNK(DATV)     \
        CHUNK(PROV)     \
        CHUNK(UDID)     \
        CHUNK(FDAT)     \
        CHUNK(DEND)     \
        CHUNK(CHUNK_NUM)

typedef enum {
    FOREACH_CHUNK(GENERATE_ENUM)
} CHUNK_TYPE;

// static, internal linkage
static const char *CHUNK_STRINGS[] = {
        FOREACH_CHUNK(GENERATE_STRING)
};

inline CHUNK_TYPE CHUNK_NAME_TO_TYPE(const char *name) {
    return (CHUNK_TYPE)STRING_TO_ENUM_STARTS(name, CHUNK_STRINGS, CHUNK_NUM);
}

inline CHUNK_TYPE FILE_NAME_TO_TYPE(const char *name) {
    return (CHUNK_TYPE)STRING_TO_ENUM_CONTAINS(name, CHUNK_STRINGS, CHUNK_NUM);
}

#endif //FWT_CHUNK_TYPE_H
