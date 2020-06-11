
#include "C3DmodelLoader.h"
namespace engine { namespace graphics{
C3DmodelLoader::C3DmodelLoader()
{
 init();
}

C3DmodelLoader::~C3DmodelLoader()
{


}
void C3DmodelLoader::init(void)
{
}



void C3DmodelLoader::load3DModel(C3Dmodel *model)
{


    char buf[255];
    FILE *fp;
    unsigned short intNormal=0;
    unsigned short intVertex=0;
    unsigned short intTexture=0;
    unsigned short intTest=0;

    //buf=(char*)malloc(255);
    fp=fopen(model->fileName,"rb");
    if(fp==NULL)
    {
     writeError("%s","Obj Dosyası Açılamıyor ");
     exit(0);
    }



    while(fscanf(fp, "%s", buf) != EOF)
    {
        switch(buf[0])
        {
            case '#':
                fgets(buf, 255, fp);
            break;


            case 'v':
                if (buf[1]== '\0')
                {
                    model->NoV++;
                    model->vertexList=(float*)realloc(
                                                model->vertexList
                                                ,model->NoV*sizeof(float)*3);
                    fscanf(fp, "%f", &model->vertexList[(model->NoV-1)*3]);
                    fscanf(fp, "%f", &model->vertexList[(model->NoV-1)*3+1]);
                    fscanf(fp, "%f", &model->vertexList[(model->NoV-1)*3+2]);

                }

                if(buf[1]=='n')
                {
                    model->NoN++;
                    model->normalList=(float*)realloc(
                        model->normalList
                        ,model->NoN*sizeof(float)*3);

                    fscanf(fp, "%f", &model->normalList[(model->NoN-1)*3]);
                    fscanf(fp, "%f", &model->normalList[(model->NoN-1)*3]+1);
                    fscanf(fp, "%f", &model->normalList[(model->NoN-1)*3+2]);
                }

                if(buf[1]=='t')
                {
                    model->NoT++;
                    model->textureList=(float*)realloc(
                    model->textureList
                    ,model->NoT*sizeof(float)*2);
                    fscanf(fp, "%f",&model->textureList[(model->NoT-1)*2]);
                    fscanf(fp, "%f",&model->textureList[(model->NoT-1)*2+1]);
                }
            break;
            case 't':
            //
            break;
            case 'f':



                fscanf(fp, "%s", buf);
                if (strstr(buf, "//"))
                {
                    model->NoVi++;
                    model->NoNi++;

                    model->vindices=(unsigned short*)realloc(
                        model->vindices
                        ,model->NoVi*sizeof(unsigned short)*3);

                    model->nindices=(unsigned short*)realloc(
                        model->nindices
                        ,model->NoNi*sizeof(unsigned short)*3);

                    sscanf(buf, "%hu//%hu", &intVertex,&intNormal);
                    model->vindices[(model->NoVi-1)*3] = intVertex;
                    model->nindices[(model->NoNi-1)*3] = intNormal;

                    fscanf(fp, "%hu//%hu", &intVertex, &intNormal);
                    model->vindices[(model->NoVi-1)*3+1] = intVertex;
                    model->nindices[(model->NoNi-1)*3+1] = intNormal;

                    fscanf(fp, "%hu//%hu", &intVertex, &intNormal);
                    model->vindices[(model->NoVi-1)*3+2] = intVertex;
                    model->nindices[(model->NoNi-1)*3+2] = intNormal;

                }
                else if (sscanf(buf, "%hu/%hu/%hu", &intVertex, &intTexture, &intNormal) == 3)
                {
                    model->NoVi++;
                    model->NoNi++;
                    model->NoTi++;

                    model->vindices=(unsigned short*)realloc(
                        model->vindices
                        ,model->NoVi*sizeof(unsigned short)*3);

                    model->nindices=(unsigned short*)realloc(
                        model->nindices
                        ,model->NoNi*sizeof(unsigned short)*3);

                    model->tindices=(unsigned short*)realloc(
                        model->tindices
                        ,model->NoTi*sizeof(unsigned short)*3);

                    model->vindices[(model->NoVi-1)*3] = intVertex;
                    model->tindices[(model->NoTi-1)*3]= intTexture;
                    model->nindices[(model->NoNi-1)*3] = intNormal;
                    fscanf(fp, "%hu/%hu/%hu", &intVertex, &intTexture, &intNormal);
                    model->vindices[(model->NoVi-1)*3+1] = intVertex;
                    model->tindices[(model->NoTi-1)*3+1]= intTexture;
                    model->nindices[(model->NoNi-1)*3+1] = intNormal;
                    fscanf(fp, "%hu/%hu/%hu", &intVertex, &intTexture, &intNormal);
                    model->vindices[(model->NoVi-1)*3+2] = intVertex;
                    model->tindices[(model->NoTi-1)*3+2]= intTexture;
                    model->nindices[(model->NoNi-1)*3+2] = intNormal;
                }
                else if (sscanf(buf, "%hu/%hu", &intVertex, &intTexture) == 2)
                {
                    model->NoVi++;
                    model->NoTi++;

                    model->vindices=(unsigned short*)realloc(
                        model->vindices
                        ,model->NoVi*sizeof(unsigned short)*3);


                    model->tindices=(unsigned short*)realloc(
                        model->tindices
                        ,model->NoTi*sizeof(unsigned short)*3);

                    sscanf(buf, "%hu/%hu"
                                ,&model->vindices[(model->NoVi-1)*3]
                                ,&model->tindices[(model->NoTi-1)*3]);
                    fscanf(fp, "%hu/%hu"
                               ,&model->vindices[(model->NoVi-1)*3+1]
                               ,&model->tindices[(model->NoTi-1)*3+1]);

                    fscanf(fp, "%hu/%hu"
                               ,&model->vindices[(model->NoVi-1)*3+2]
                               ,&model->tindices[(model->NoTi-1)*3+2]);

                }
                else
                {
                    model->NoVi++;


                    model->vindices=(unsigned short*)realloc(
                        model->vindices
                        ,model->NoVi*sizeof(unsigned short)*3);

                    sscanf(buf, "%hu", &intVertex);
                    model->vindices[(model->NoVi-1)*3] = intVertex;
                    fscanf(fp, "%hu", &intVertex);
                    model->vindices[(model->NoVi-1)*3+1] = intVertex;
                    fscanf(fp, "%hu", &intVertex);
                    model->vindices[(model->NoVi-1)*3+2] = intVertex;
                }

            break;

            default:
            // eat up rest of line
            fgets(buf, sizeof(buf), fp);
            break;
        }

    }


  //model->dump(strcat(model->fileName,".txt"));
}
}}

