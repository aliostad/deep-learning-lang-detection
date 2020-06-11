#include "datawidgetmodel.h"
#include "datawidget.h"

DataWidget::DataWidget(QWidget *parent) :
    QWidget(parent),
    m_model(0)
{
}

void DataWidget::setModel(DataWidgetModel *model)
{
    m_model = model;
    connect(model, SIGNAL(dataChanged()), SLOT(dataChanged()));
}

void DataWidget::dataChanged()
{
    if (m_model)
    {
        setData(m_model->data());
        setEnabled(m_model->enabled());
    }
}

DataWidgetModel *DataWidget::model()
{
    return m_model;
}

void DataWidget::onDataChanged(QVariant data)
{
    if (m_model)
        m_model->updateData(data);
}
