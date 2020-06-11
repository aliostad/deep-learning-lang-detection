#include <stdio.h>
#include <math.h>
#include <gl/glut.h>
#include <gl/gl.h>
#include "Model.h"

void LoadModel(char *FileName, TModel* model)
{
  //int mode; //0 = normal    1 = texcoord=x,y   2 = normal
  FILE* f=fopen(FileName,"r");
  int texturetype;
  fscanf(f,"%d",&model->type);
  fscanf(f,"%d",&texturetype);
  fscanf(f,"%d",&model->VCount);
  model->vertex=new float[3*model->VCount];
  model->normal=new float[3*model->VCount];
  model->texcoord=new float[2*model->VCount];
  for(int i=0; i<model->VCount; i++)
  {
    fscanf(f,"%f",&model->vertex[i*3]);
    fscanf(f,"%f",&model->vertex[i*3+1]);
    fscanf(f,"%f",&model->vertex[i*3+2]);
    
    if(texturetype==1)
    {
      model->texcoord[i*2]=model->vertex[i*3];
      model->texcoord[i*2+1]=model->vertex[i*3+1];
    }
    else if(texturetype==2)
    {  
      model->texcoord[i*2]=model->vertex[i*3+0];
      model->texcoord[i*2+1]=model->vertex[i*3+2]+0.423*model->vertex[i*3+1];
    }

    float r=sqrt(model->vertex[i*3]*model->vertex[i*3]+
                 model->vertex[i*3+1]*model->vertex[i*3+1]+
                 model->vertex[i*3+2]*model->vertex[i*3+2]);
    model->normal[i*3]=-model->vertex[i*3]/r;
    model->normal[i*3+1]=-model->vertex[i*3+1]/r;
    model->normal[i*3+2]=-model->vertex[i*3+2]/r;
  }
  fclose(f);
}

void DrawModel(TModel* model)
{
  glEnableClientState(GL_NORMAL_ARRAY);
  glEnableClientState(GL_TEXTURE_COORD_ARRAY);
  glEnableClientState(GL_VERTEX_ARRAY);
  glVertexPointer(3,GL_FLOAT,0,model->vertex);
  glNormalPointer(GL_FLOAT,0,model->normal);
  glTexCoordPointer(2,GL_FLOAT,0,model->texcoord);
  if(model->type==3)
    glDrawArrays(GL_TRIANGLES,0,model->VCount);
  else
    glDrawArrays(GL_QUADS,0,model->VCount);
}

