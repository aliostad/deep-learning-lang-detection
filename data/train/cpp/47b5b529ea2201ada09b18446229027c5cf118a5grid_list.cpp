// (c) by Stefan Roettger, licensed under GPL 2+

#include <mini/miniio.h>
#include <mini/minidir.h>

#include "grid_layer_db.h"
#include "grid_layer_pnm.h"
#include "grid_layer_gdal.h"

#include "grid_list.h"

// default constructor
grid_list::grid_list() {}

// destructor
grid_list::~grid_list()
   {clear();}

// clear layers
void grid_list::clear()
   {
   unsigned int i;

   for (i=0; i<m_layer.getsize(); i++) delete m_layer[i];

   m_layer.setsize(0);
   }

// append layer
void grid_list::append(grid_layer *layer)
   {grid_layers::append(layer);}

// load and append from file
grid_layer *grid_list::load(ministring repo,ministring path)
   {
   grid_layer_db *layer_db;
   grid_layer_pnm *layer_pnm;
   grid_layer_gdal *layer_gdal;

   // check for absolute path:

   if (path.startswith("/") ||
       path.startswith("\\")) repo="";

   // try-load from db:

   layer_db=new grid_layer_db();
   if (layer_db==NULL) MEMERROR();

   layer_db->set_repo(repo);

   if (layer_db->load(path))
      {
      grid_layers::append(layer_db);
      return(layer_db);
      }
   else delete layer_db;

   // try-load from pnm:

   layer_pnm=new grid_layer_pnm();
   if (layer_pnm==NULL) MEMERROR();

   layer_pnm->set_repo(repo);

   if (layer_pnm->load(path))
      {
      grid_layers::append(layer_pnm);
      return(layer_pnm);
      }
   else delete layer_pnm;

   // try-load from gdal:

   layer_gdal=new grid_layer_gdal();
   if (layer_gdal==NULL) MEMERROR();

   layer_gdal->set_repo(repo);

   if (layer_gdal->load(path))
      {
      grid_layers::append(layer_gdal);
      return(layer_gdal);
      }
   else delete layer_gdal;

   return(NULL);
   }

// try to load from file
BOOLINT grid_list::tryload(ministring repo,ministring path)
   {
   grid_layer *layer=load(repo,path);

   if (layer==NULL) return(FALSE);

   remove(layer);

   return(TRUE);
   }

// check for layer existence
BOOLINT grid_list::exists(ministring repo,ministring path)
   {
   if (!repo.empty())
      if (repo.last()!='/' && repo.last()!='\\') repo.append("/");

   return(checkfile((repo+path).c_str())!=0);
   }

// load and append from multiple files
grid_layer *grid_list::multiload(ministring repo,ministring path,
                                 int &layers)
   {
   const char *file;
   ministring fname;

   unsigned int idx;

   grid_layer *layer;

   layers=0;
   layer=NULL;

   if (path.find("*",idx))
      {
      if (!repo.empty())
         if (repo.last()!='/' && repo.last()!='\\') repo.append("/");

      filesearch((repo+path).c_str());

      while ((file=findfile())!=NULL)
         {
         fname=ministring(file);
         fname.substitute(repo,"");

         if (load(repo,fname)!=NULL) layers++;
         }
      }
   else
      {
      layer=load(repo,path);
      if (layer!=NULL) layers++;
      }

   return(layer);
   }

// save to file
BOOLINT grid_list::save(ministring repo,ministring path,grid_layer *layer,
                        double compression)
   {
   BOOLINT success;

   grid_layer_gdal *layer_gdal;

   // convert to gdal layer
   layer_gdal=new grid_layer_gdal(*layer);

   // save to geotiff format
   layer_gdal->set_repo(repo);
   success=layer_gdal->save(path,compression);

   // release gdal layer
   delete layer_gdal;

   return(success);
   }

// save to db file
BOOLINT grid_list::save_db(ministring repo,ministring path,grid_layer *layer,
                           BOOLINT autocompress,BOOLINT zcompress)
   {
   BOOLINT success;

   ministring tmp;

   // save to db format
   tmp=layer->get_repo();
   layer->set_repo(repo);
   success=layer->save_db(path,autocompress,zcompress);
   layer->set_repo(tmp);

   return(success);
   }

// set repo
void grid_list::set_repo(ministring repo)
   {
   unsigned int i;

   ministring path;

   for (i=0; i<m_layer.getsize(); i++)
      {
      path=m_layer[i]->get_repo()+m_layer[i]->get_path();

      if (path.startswith(repo))
         {
         m_layer[i]->set_repo(repo);
         m_layer[i]->set_path(path.suffix(repo));
         }
      else
         {
         m_layer[i]->set_repo("");
         m_layer[i]->set_path(path);
         }
      }
   }

// clone layers from list
grid_list *grid_list::clone()
   {
   unsigned int i;

   grid_list *list;
   grid_layer *layer;

   list=new grid_list();

   for (i=0; i<m_layer.getsize(); i++)
      {
      layer=new grid_layer(*m_layer[i]);
      if (layer==NULL) MEMERROR();
      list->append(layer);
      }

   return(list);
   }

// clone layers from references
void grid_list::clone(const grid_layers *layers)
   {
   unsigned int i;

   grid_layer *layer;

   clear();

   for (i=0; i<layers->get_num(); i++)
      {
      layer=new grid_layer(*layers->get(i));
      if (layer==NULL) MEMERROR();
      append(layer);
      }
   }

// remove layer
void grid_list::remove(unsigned int n)
   {
   delete grid_layers::get(n);
   grid_layers::remove(n);
   }

// remove layer
void grid_list::remove(grid_layer *layer)
   {
   delete layer;
   grid_layers::remove(layer);
   }

// dispose layer (keep order)
void grid_list::dispose(unsigned int n)
   {
   delete grid_layers::get(n);
   grid_layers::dispose(n);
   }

// dispose layer (keep order)
void grid_list::dispose(grid_layer *layer)
   {
   delete layer;
   grid_layers::dispose(layer);
   }
