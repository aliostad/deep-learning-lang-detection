#ifndef LOADER_H
#define LOADER_H

//load files
#include <QString>
#include <QStringList>

#include "Model/model.h"

#include "Model/Parser/Format_obj/loader_obj.h"

class Model;

class Loader
{
public:
    Loader();
    static Model* import_model(QString path, bool &ok);
    static void export_model_bin(QString path, Model* mdl, bool &ok);

private:
    static Model* import_model_format_bin(QString path, bool &ok);
    static Model* import_model_format_fbx(QString path, bool &ok);
    static Model* import_model_format_obj(QString path, bool &ok);
};

#endif // LOADER_H
