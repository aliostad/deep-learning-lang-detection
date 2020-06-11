#ifndef SENSORWIDGET_H
#define SENSORWIDGET_H

#include <QWidget>
#include "sensormodel.h"

namespace Ui {
class SensorWidget;
}

class SensorWidget : public QWidget
{
    Q_OBJECT
    
public:
    explicit SensorWidget(QWidget *parent = 0);
    ~SensorWidget();
    
    void setModel(SensorModel * model) {
        sensorModel = model;
    }

    SensorModel & model() {
        return *sensorModel;
    }

    void refresh();

private:
    Ui::SensorWidget *ui;
    SensorModel *sensorModel;
};

#endif // SENSORWIDGET_H
