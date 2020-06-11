// (c) 2014 by Navibyte.

#include "samplelistmodel.h"


// -------------------------------------------------------------------
// LIST HANDLING METHODS (NEEDED WHEN CREATING LIST PROPERTY ON CONSTRUCTOR)

static void sampleListAppend(QQmlListProperty<SampleData> *prop, SampleData *val)
{
    SampleListModelPrivate *d = static_cast<SampleListModelPrivate*>(prop->data);
    d->sampleListData.append(val);
}

static SampleData *sampleListAt(QQmlListProperty<SampleData> *prop, int index)
{
    return (static_cast<SampleListModelPrivate*>(prop->data))->sampleListData.at(index);
    }

static int sampleListCount(QQmlListProperty<SampleData> *prop)
{
    return static_cast<SampleListModelPrivate*>(prop->data)->sampleListData.size();
}

static void sampleListClear(QQmlListProperty<SampleData> *prop)
{
    static_cast<SampleListModelPrivate*>(prop->data)->sampleListData.clear();
}

// -------------------------------------------------------------------
// CONSTRUCTION

SampleListModel::SampleListModel(QObject *parent) :
    QObject(parent),
    d(new SampleListModelPrivate)
{
    // mark that not yet populated
    d->isPopulated = false;

    // create list property
    d->sampleList
            = new QQmlListProperty<SampleData>(this, d,
                                               sampleListAppend,
                                               sampleListCount,
                                               sampleListAt,
                                               sampleListClear);
}

SampleListModel::~SampleListModel() {
    // TODO : not sure what instances must be deleted here....

    delete d;
}

// -------------------------------------------------------------------
// POPULATING DATA

void SampleListModel::populateSampleList() {

    // TODO : how to synchronize?

    if(!d->isPopulated) {
        qDebug("Populating SampleListModel...");

        // JUST SOME DUMMY SAMPLES
        d->sampleListData.append(new SampleData(this, "four", "The Fourth One"));
        d->sampleListData.append(new SampleData(this, "five", "The Fifth One"));
        d->sampleListData.append(new SampleData(this, "six", "The Sixth One"));

        // must remember to call signal to let QML side know about populated items..
        sampleListChanged();

        // mark flag
        d->isPopulated = true;
    }
}
