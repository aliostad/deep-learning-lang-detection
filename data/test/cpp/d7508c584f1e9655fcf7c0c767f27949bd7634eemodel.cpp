#include <stdio.h>
#include <stdlib.h>
#include "simple_logger.h"
#include "model.h"

constexpr std::size_t __model_max = 1024;

static Model ModelList[__model_max];

static void model_close();

void model_init()
{
    memset(ModelList,0,sizeof(Model)*__model_max);
    atexit(model_close);
}

static void model_delete(Model *model)
{
    if (!model)return;
    
//    FreeTexture(model->texture);
    if (model->vertex_array)
    {
        free(model->vertex_array);
    }
    if (model->attribute_array)
    {
        free(model->attribute_array);
    }
    if (model->triangle_array)
    {
        free(model->triangle_array);
    }
    memset(model,0,sizeof(Model));
}

void model_free(Model *model)
{
    if (!model)return;
    model->used--;
    if (model->used > 0)return;
    model_delete(model);
}

static void model_close()
{
    int i;
    for (i = 0; i < __model_max; i++)
    {
        if (ModelList[i].used)
        {
            model_delete(&ModelList[i]);
        }
    }
}

Model *model_new()
{
    int i;
    for (i = 0; i < __model_max; i++)
    {
        if (ModelList[i].used == 0)
        {
            memset(&ModelList[i],0,sizeof(Model));
            ModelList[i].used = 1;
            return &ModelList[i];
        }
    }
    return nullptr;
}

Model *model_get_by_filename(char *filename)
{
    int i;
    for (i = 0; i < __model_max; i++)
    {
        if ((ModelList[i].used != 0) &&
            (strcmp(ModelList[i].filename,filename) == 0))
        {
            return &ModelList[i];
        }
    }
    return nullptr;
}

void model_assign_texture(Model *model,char *texture)
{
    if (!model) return;
	Texture * sprite = get(hash(texture));
	if (!sprite) return;
    model->texture = sprite;
}

int model_allocate_triangle_buffer(Model *model, GLuint triangles)
{
    if (!model)
    {
        slog("no model specified");
        return -1;
    }
    if (model->triangle_array != nullptr)
    {
        slog("model %s already has a triangle buffer");
        return -1;
    }
    if (!triangles)
    {
        slog("cannot allocate 0 triangles!");
        return -1;
    }
    model->triangle_array = (GLuint *)malloc(sizeof(GLuint)*3*triangles);
    if (!model->triangle_array)
    {
        slog("failed to allocate triangle buffer");
        return -1;
    }
    memset(model->triangle_array,0,sizeof(GLuint)*3*triangles);
    model->num_tris = triangles;
    return 0;
}

int model_set_vertex_buffer(Model *model, float *vertex_buffer, GLuint count)
{
    if (model_allocate_vertex_buffer(model, count) != 0)
    {
        return -1;
    }
    memcpy(model->vertex_array,vertex_buffer,sizeof(float)*count *3);
    return 0;
}

int model_set_attribute_buffer(Model *model, float *attribute_buffer, GLuint count)
{
    if (model_allocate_attribute_buffer(model, count) != 0)
    {
        return -1;
    }
    memcpy(model->attribute_array,attribute_buffer,sizeof(float)*count *6);
    return 0;
}


int model_allocate_vertex_buffer(Model *model, GLuint vertices)
{
    if (!model)
    {
        slog("no model specified");
        return -1;
    }
    if (model->vertex_array != nullptr)
    {
        slog("model %s already has a vertex buffer");
        return -1;
    }
    if (!vertices)
    {
        slog("cannot allocate 0 vertices!");
        return -1;
    }
    model->vertex_array = (float *)malloc(sizeof(float)*3*vertices);
    if (!model->vertex_array)
    {
        slog("failed to allocate vertex buffer");
        return -1;
    }
    memset(model->vertex_array,0,sizeof(float)*3*vertices);
    model->num_vertices = vertices;
    return 0;
}

int model_allocate_attribute_buffer(Model *model, GLuint attributes)
{
    if (!model)
    {
        slog("no model specified");
        return -1;
    }
    if (model->attribute_array != nullptr)
    {
        slog("model %s already has a vertex buffer");
        return -1;
    }
    if (!attributes)
    {
        slog("cannot allocate 0 attributes!");
        return -1;
    }
    model->attribute_array = (float *)malloc(sizeof(float)*6*attributes);
    if (!model->attribute_array)
    {
        slog("failed to allocate vertex buffer");
        return -1;
    }
    memset(model->attribute_array,0,sizeof(float)*6*attributes);
    return 0;
}



size_t model_get_triangle_buffer_size(Model *model)
{
    if (!model)return 0;
    return (sizeof(GLshort)*model->num_tris*3);
}

size_t model_get_vertex_buffer_size(Model *model)
{
    if (!model)return 0;
    return (sizeof(float)*3*model->num_vertices);
}