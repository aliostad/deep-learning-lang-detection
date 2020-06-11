#ifndef HANDWRITING_FUNCTIONS_MODEL_H
#define HANDWRITING_FUNCTIONS_MODEL_H

#include "onyx/base/base.h"
#include "onyx/ui/ui.h"

namespace handwriting
{

class HandwritingFunctionsModel
{
    HandwritingFunctionsModel();
    HandwritingFunctionsModel(const HandwritingFunctionsModel & right);
public:
    static HandwritingFunctionsModel & instance()
    {
        static HandwritingFunctionsModel model;
        return model;
    }
    ~HandwritingFunctionsModel();

    void getModel(QStandardItemModel & functions_model);
    void onItemClicked(const QModelIndex & index, QStandardItemModel & functions_model);
    QModelIndex getIndexBySetting(int setting, QStandardItemModel & functions_model);

private:
    QVector<int> getDefaultSettings();
    void sort(QStandardItemModel & functions_model);
};

};

#endif
