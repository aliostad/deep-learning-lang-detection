#ifndef _Model_OBJECT3D_H
#define _Model_OBJECT3D_H

#include <nds.h>
#include <stdlib.h>

#include <GOEN_Model_Vector.h>
#include <GOEN_Model_Face.h>


class Model_Object
{
    public:

        uint16 nb_faces;
        Model_Face * list_faces;
        uint16 nb_vectors;
        Model_Vector * list_vectors;
        uint16 nb_normals;
        Model_Vector * list_normals;
        uint16 nb_texcoords;
        Model_Vector * list_texcoords;

        Model_Object();
        ~Model_Object();
};



#endif // _Model_OBJECT3D_H
