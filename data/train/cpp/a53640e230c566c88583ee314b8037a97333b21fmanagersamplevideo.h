#ifndef MANAGERSAMPLEVIDEO_H
#define MANAGERSAMPLEVIDEO_H

#include "manager.h"
#include "samplevideo.h"

class ManagerSampleVideo : public Manager
{
private :
    QList<SampleVideo*> *listSamplesVideos;
public:
    ManagerSampleVideo();
    ~ManagerSampleVideo();
    void initSystem();
    void saveAll();
    void save(SampleVideo *sampleVideo, QSettings &fichierSampleVideo);
    void loadAll();
    void remove(SampleVideo *sampleVideo);

    QList<SampleVideo*>* getListSamplesVideos();
    QList<SampleVideo*>* getListSamplesVideosActive();

    void addSample(QString name, QString Url);
};

#endif // MANAGERSAMPLEVIDEO_H
