#ifndef MANAGERSAMPLEAUDIO_H
#define MANAGERSAMPLEAUDIO_H

#include "manager.h"
#include "sampleaudio.h"

class ManagerSampleAudio : public Manager
{
private:
    QList<SampleAudio*> *listSamplesAudios;

public:
    ManagerSampleAudio();
    ~ManagerSampleAudio();
    void initSystem();
    void saveAll();
    void save(SampleAudio *sampleAudio, QSettings &fichierSampleAudio);
    void loadAll();
    void remove(SampleAudio *sampleAudio);

    QList<SampleAudio*>* getListSamplesAudios();
    QList<SampleAudio*>* getListSamplesAudiosActive();

    void addSample(QString name, QString Url);
};

#endif // MANAGERSAMPLEAUDIO_H
