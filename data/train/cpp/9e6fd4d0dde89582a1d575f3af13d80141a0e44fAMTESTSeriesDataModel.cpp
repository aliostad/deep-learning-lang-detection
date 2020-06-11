#include "AMTESTSeriesDataModel.h"

AMTESTSeriesDataModel::AMTESTSeriesDataModel(const QString &name, quint32 bufferSize, quint32 updateRate, QObject *parent)
	: AMTESTDataModel(name, parent)
{
	data_ = AMTESTRingBuffer(bufferSize*updateRate);
	dataModel_ = new AMTESTSeriesData(bufferSize, updateRate);
}

AMTESTSeriesDataModel::~AMTESTSeriesDataModel()
{
	delete dataModel_;
}

void AMTESTSeriesDataModel::addData(const QVector<qreal> &newData)
{
	data_.addValues(newData);
	dataModel_->addData(newData);
}

void AMTESTSeriesDataModel::clear()
{
	data_.clear();
	dataModel_->clear();
}

