#ifndef SAMPLEPARAMS_H
#define SAMPLEPARAMS_H

#include <QWidget>
#include "sample.h"

namespace Ui {
	class SampleParams;
}

class SampleParams : public QWidget
{
	Q_OBJECT

public:
	SampleParams(Sample * sample, QWidget *parent = 0);
	~SampleParams();
	Sample * sample() const
	{
		return mySample;
	}

protected:
	void changeEvent(QEvent *e);
	QString msToString(unsigned int msecs);

private:
	Ui::SampleParams *ui;
	Sample * mySample;
public slots:
	void onSampleStarted();
	void onSampleStopped();
	void updateSampleInfo();

private slots:
	void onKeyComboChanged(int index);
	void onRadioChanged(bool on);
};

#endif // SAMPLEPARAMS_H
