/********************************************************************
 *           YaST2-GTK - http://en.opensuse.org/YaST2-GTK           *
 ********************************************************************/

/* YGtkTreeModel, C++ wrapper for gtk+ */
// check the header file for information about this wrapper

#include <gtk/gtk.h>
#include "ygtktreemodel.h"

#define YGTK_TYPE_WRAP_MODEL	        (ygtk_wrap_model_get_type ())
#define YGTK_WRAP_MODEL(obj)	        (G_TYPE_CHECK_INSTANCE_CAST ((obj), \
                                         YGTK_TYPE_WRAP_MODEL, YGtkWrapModel))
#define YGTK_WRAP_MODEL_CLASS(klass)    (G_TYPE_CHECK_CLASS_CAST ((klass), \
                                         YGTK_TYPE_WRAP_MODEL, YGtkWrapModelClass))
#define YGTK_IS_WRAP_MODEL(obj)	        (G_TYPE_CHECK_INSTANCE_TYPE ((obj), YGTK_TYPE_WRAP_MODEL))
#define YGTK_IS_WRAP_MODEL_CLASS(klass) (G_TYPE_CHECK_CLASS_TYPE ((klass), YGTK_TYPE_WRAP_MODEL))
#define YGTK_WRAP_MODEL_GET_CLASS(obj)  (G_TYPE_INSTANCE_GET_CLASS ((obj), \
                                         YGTK_TYPE_WRAP_MODEL, YGtkWrapModelClass))

struct YGtkWrapModel
{
	GObject parent;
	YGtkTreeModel *model;
	struct Notify;
	Notify *notify;
};

struct YGtkWrapModelClass
{
	GObjectClass parent_class;
};

// bridge as we don't want to mix c++ class polymorphism and gobject
static void ygtk_wrap_model_entry_changed (YGtkWrapModel *model, int row);
static void ygtk_wrap_model_entry_inserted (YGtkWrapModel *model, int row);
static void ygtk_wrap_model_entry_deleted (YGtkWrapModel *model, int row);

struct YGtkWrapModel::Notify : public YGtkTreeModel::Listener {
YGtkWrapModel *model;
	Notify (YGtkWrapModel *model) : model (model) {}
	virtual void rowChanged (int row)
	{ ygtk_wrap_model_entry_changed (model, row); }
	virtual void rowInserted (int row)
	{ ygtk_wrap_model_entry_inserted (model, row); }
	virtual void rowDeleted (int row)
	{ ygtk_wrap_model_entry_deleted (model, row); }
};

static void ygtk_wrap_model_tree_model_init (GtkTreeModelIface *iface);

G_DEFINE_TYPE_WITH_CODE (YGtkWrapModel, ygtk_wrap_model, G_TYPE_OBJECT,
	G_IMPLEMENT_INTERFACE (GTK_TYPE_TREE_MODEL, ygtk_wrap_model_tree_model_init))

static void ygtk_wrap_model_init (YGtkWrapModel *zmodel)
{}

static void ygtk_wrap_model_finalize (GObject *object)
{
	YGtkWrapModel *ymodel = YGTK_WRAP_MODEL (object);
	delete ymodel->model;
	ymodel->model = NULL;
	delete ymodel->notify;
	ymodel->notify = NULL;
	G_OBJECT_CLASS (ygtk_wrap_model_parent_class)->finalize (object);
}

static GtkTreeModelFlags ygtk_wrap_model_get_flags (GtkTreeModel *model)
{ return (GtkTreeModelFlags) (GTK_TREE_MODEL_ITERS_PERSIST|GTK_TREE_MODEL_LIST_ONLY); }

static gboolean ygtk_wrap_model_get_iter (GtkTreeModel *model, GtkTreeIter *iter,
                                          GtkTreePath  *path)
{  // from Path to Iter
	YGtkWrapModel *ymodel = YGTK_WRAP_MODEL (model);
	gint index = gtk_tree_path_get_indices (path)[0];
	iter->user_data = GINT_TO_POINTER (index);
	int rowsNb = ymodel->model->rowsNb();
	if (!rowsNb && index == 0 && ymodel->model->showEmptyEntry())
		return TRUE;
	return index < rowsNb;
}

static GtkTreePath *ygtk_wrap_model_get_path (GtkTreeModel *model, GtkTreeIter *iter)
{  // from Iter to Path
	int index = GPOINTER_TO_INT (iter->user_data);
	GtkTreePath *path = gtk_tree_path_new();
	gtk_tree_path_append_index (path, index);
	return path;
}

static gboolean ygtk_wrap_model_iter_next (GtkTreeModel *model, GtkTreeIter *iter)
{
	YGtkWrapModel *ymodel = YGTK_WRAP_MODEL (model);
	int index = GPOINTER_TO_INT (iter->user_data) + 1;
	iter->user_data = GINT_TO_POINTER (index);
	int rowsNb = ymodel->model->rowsNb();
	return index < rowsNb;
}

static gboolean ygtk_wrap_model_iter_parent (GtkTreeModel *, GtkTreeIter *, GtkTreeIter *)
{ return FALSE; }

static gboolean ygtk_wrap_model_iter_has_child (GtkTreeModel *, GtkTreeIter *)
{ return FALSE; }

static gint ygtk_wrap_model_iter_n_children (GtkTreeModel *model, GtkTreeIter *iter)
{ return 0; }

static gboolean ygtk_wrap_model_iter_nth_child (GtkTreeModel *model, GtkTreeIter *iter,
                                                GtkTreeIter  *parent, gint index)
{
	if (parent) return FALSE;
	YGtkWrapModel *ymodel = YGTK_WRAP_MODEL (model);
	iter->user_data = GINT_TO_POINTER (index);
	int rowsNb = ymodel->model->rowsNb();
	if (!rowsNb && index == 0 && ymodel->model->showEmptyEntry())
		return TRUE;
	return index < rowsNb;
}

static gboolean ygtk_wrap_model_iter_children (
	GtkTreeModel *model, GtkTreeIter *iter, GtkTreeIter  *parent)
{ return ygtk_wrap_model_iter_nth_child (model, iter, parent, 0); }

void ygtk_wrap_model_entry_changed (YGtkWrapModel *model, int row)
{
	GtkTreeIter iter;
	iter.user_data = GINT_TO_POINTER (row);
	GtkTreePath *path = ygtk_wrap_model_get_path (GTK_TREE_MODEL (model), &iter);
	gtk_tree_model_row_changed (GTK_TREE_MODEL (model), path, &iter);
	gtk_tree_path_free (path);
}

void ygtk_wrap_model_entry_inserted (YGtkWrapModel *ymodel, int row)
{
	GtkTreeModel *model = GTK_TREE_MODEL (ymodel);
	GtkTreeIter iter;
	iter.user_data = GINT_TO_POINTER (row);
	GtkTreePath *path = ygtk_wrap_model_get_path (model, &iter);

	if (row == 0 && ymodel->model->rowsNb() == 1 && ymodel->model->showEmptyEntry())
		gtk_tree_model_row_changed (model, path, &iter);
	else
		gtk_tree_model_row_inserted (model, path, &iter);
	gtk_tree_path_free (path);
}

void ygtk_wrap_model_entry_deleted (YGtkWrapModel *ymodel, int row)
{
	GtkTreeModel *model = GTK_TREE_MODEL (ymodel);
	GtkTreeIter iter;
	iter.user_data = GINT_TO_POINTER (row);
	GtkTreePath *path = ygtk_wrap_model_get_path (model, &iter);

	if (row == 0 && ymodel->model->rowsNb() == 1 && ymodel->model->showEmptyEntry())
		gtk_tree_model_row_changed (model, path, &iter);
	else
		gtk_tree_model_row_deleted (model, path);
	gtk_tree_path_free (path);
}

static gint ygtk_wrap_model_get_n_columns (GtkTreeModel *model)
{
	YGtkWrapModel *ymodel = YGTK_WRAP_MODEL (model);
	return ymodel->model->columnsNb();
}

static GType ygtk_wrap_model_get_column_type (GtkTreeModel *model, gint column)
{
	YGtkWrapModel *ymodel = YGTK_WRAP_MODEL (model);
	return ymodel->model->columnType (column);
}

static void ygtk_wrap_model_get_value (GtkTreeModel *model, GtkTreeIter *iter,
                                       gint column, GValue *value)
{
	int row = GPOINTER_TO_INT (iter->user_data);
	YGtkWrapModel *ymodel = YGTK_WRAP_MODEL (model);
	g_value_init (value, ymodel->model->columnType (column));
	if (row == 0 && ymodel->model->rowsNb() == 0)
		row = -1;
	ymodel->model->getValue (row, column, value);
}

GtkTreeModel *ygtk_tree_model_new (YGtkTreeModel *model)
{
	YGtkWrapModel *ymodel = (YGtkWrapModel *) g_object_new (YGTK_TYPE_WRAP_MODEL, NULL);
	ymodel->model = model;
	ymodel->notify = new YGtkWrapModel::Notify (ymodel);
	model->listener = ymodel->notify;
	return GTK_TREE_MODEL (ymodel);
}

YGtkTreeModel *ygtk_tree_model_get_model (GtkTreeModel *model)
{
	YGtkWrapModel *ymodel = YGTK_WRAP_MODEL (model);
	return ymodel->model;
}

static void ygtk_wrap_model_class_init (YGtkWrapModelClass *klass)
{
	GObjectClass *gobject_class = G_OBJECT_CLASS (klass);
	gobject_class->finalize = ygtk_wrap_model_finalize;
}

static void ygtk_wrap_model_tree_model_init (GtkTreeModelIface *iface)
{
	iface->get_flags = ygtk_wrap_model_get_flags;
	iface->get_n_columns = ygtk_wrap_model_get_n_columns;
	iface->get_column_type = ygtk_wrap_model_get_column_type;
	iface->get_iter = ygtk_wrap_model_get_iter;
	iface->get_path = ygtk_wrap_model_get_path;
	iface->get_value = ygtk_wrap_model_get_value;
	iface->iter_next = ygtk_wrap_model_iter_next;
	iface->iter_children = ygtk_wrap_model_iter_children;
	iface->iter_has_child = ygtk_wrap_model_iter_has_child;
	iface->iter_n_children = ygtk_wrap_model_iter_n_children;
	iface->iter_nth_child = ygtk_wrap_model_iter_nth_child;
	iface->iter_parent = ygtk_wrap_model_iter_parent;
}

