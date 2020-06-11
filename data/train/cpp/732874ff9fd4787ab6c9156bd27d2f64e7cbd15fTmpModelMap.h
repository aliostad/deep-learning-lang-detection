#ifndef TMPMODELMAP_H
#define TMPMODELMAP_H

#include "Database.h"

/**
*/
struct TmpModelMap {
    typedef std::map<ST,Model *> TM;

    TmpModelMap() : session( 0 ) {}

    inline Model *operator[]( ST ptr_model ) const {
        if ( ptr_model & 3 ) {
            TM::const_iterator iter = data.find( ptr_model );
            return iter != data.end() ? iter->second : 0;
        }
        if ( session )
            return session->db->model_allocator.check( reinterpret_cast<Model *>( ptr_model ) );
        return 0;
    }

    Session *session;
    TM data;
};

#endif // TMPMODELMAP_H
