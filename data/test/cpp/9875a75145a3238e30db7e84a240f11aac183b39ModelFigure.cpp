#include "ModelFigure.h"
//#include <SDL/SDL_opengl.h>
#include <GL/glu.h>

#include "util.h"

ModelFigure::ModelFigure(ModelType * model_in){
    model = model_in;
}

void ModelFigure::drawFigure(Camera * cam){
//    GLfloat curr_matrix[16];
//    glGetFloatv (GL_MODELVIEW_MATRIX, curr_matrix);
//    GLfloat inv_matrix[16];
//    inverseMatrix4x4(curr_matrix, inv_matrix);

//    glLoadIdentity();
//    glTranslatef(-cam->point.x, -cam->point.y, -cam->point.z);
//    glMultMatrixf(inv_matrix);

    float x_correct_pos = (this->model->x_top_limit + this->model->x_bot_limit)/2.0;
    float y_correct_pos = (this->model->y_top_limit + this->model->y_bot_limit)/2.0;
    float z_correct_pos = (this->model->z_top_limit + this->model->z_bot_limit)/2.0;

    glTranslatef(this->position.x, this->position.y, this->position.z);

    glRotatef(orientation.x, 1,0,0);
    glRotatef(orientation.y, 0,1,0);
    glRotatef(orientation.z, 0,0,1);
    glScalef(aspect.x*(this->model->x_top_limit - this->model->x_bot_limit),
             aspect.y*(this->model->y_top_limit - this->model->y_bot_limit),
             aspect.z*(this->model->z_top_limit - this->model->z_bot_limit));

    glTranslatef(-x_correct_pos, -y_correct_pos, -z_correct_pos);

//    cam->setLookAt();
//    glMultMatrixf(curr_matrix);
//    glTranslatef(cam->point.x, cam->point.y, cam->point.z);


    if (model->id_texture != -1)
        glBindTexture(GL_TEXTURE_2D, model->id_texture);

    glBegin(GL_TRIANGLES);
    for (int l_index=0;l_index<model->polygons_qty;l_index++){
        //----------------- FIRST VERTEX -----------------
        glNormal3f( model->normal[ model->polygon[l_index].a ].x,
					model->normal[ model->polygon[l_index].a ].y,
					model->normal[ model->polygon[l_index].a ].z);
        if (model->id_texture != -1)
            glTexCoord2f(model->mapcoord[ model->polygon[l_index].a ].u,
                         model->mapcoord[ model->polygon[l_index].a ].v);
        glVertex3f( model->vertex[ model->polygon[l_index].a ].x,
                    model->vertex[ model->polygon[l_index].a ].y,
                    model->vertex[ model->polygon[l_index].a ].z);

        //----------------- SECOND VERTEX -----------------
        glNormal3f( model->normal[ model->polygon[l_index].b ].x,
					model->normal[ model->polygon[l_index].b ].y,
					model->normal[ model->polygon[l_index].b ].z);
        if (model->id_texture != -1)
            glTexCoord2f(model->mapcoord[ model->polygon[l_index].b ].u,
                         model->mapcoord[ model->polygon[l_index].b ].v);
        glVertex3f( model->vertex[ model->polygon[l_index].b ].x,
                    model->vertex[ model->polygon[l_index].b ].y,
                    model->vertex[ model->polygon[l_index].b ].z);

        //----------------- THIRD VERTEX -----------------
        glNormal3f( model->normal[ model->polygon[l_index].c ].x,
					model->normal[ model->polygon[l_index].c ].y,
					model->normal[ model->polygon[l_index].c ].z);
        if (model->id_texture != -1)
            glTexCoord2f(model->mapcoord[ model->polygon[l_index].c ].u,
                         model->mapcoord[ model->polygon[l_index].c ].v);
        glVertex3f( model->vertex[ model->polygon[l_index].c ].x,
                    model->vertex[ model->polygon[l_index].c ].y,
                    model->vertex[ model->polygon[l_index].c ].z);
    }
    glEnd();
    //glDisable(GL_TEXTURE_2D);
}

void ModelFigure::moveFigure(int fps){
    eulerIntegrate(fps);
}
