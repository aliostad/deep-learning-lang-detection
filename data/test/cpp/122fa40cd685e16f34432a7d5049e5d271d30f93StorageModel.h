#ifndef STORAGEMODEL_H
#define STORAGEMODEL_H

#include <QList>

class ApplicationModel;
class LoadBalancerModel;
class StorageProcessorModel;
class RaidModel;
class IStorageElement;

class StorageModel
{
    static StorageModel* m_instance;

    ApplicationModel* m_applicationModel;
    LoadBalancerModel* m_loadBalancerModel;
    QList<StorageProcessorModel*> m_storageProcessorModels;
    RaidModel* m_raidModel;

    StorageModel();

public:

    ~StorageModel();

    static StorageModel* getInstance();
    static void deleteStorageModel();

    ApplicationModel* getApplicationModel() const;
    IStorageElement* getLoadBalancerModel() const;
    RaidModel* getRaidModel() const;

    StorageProcessorModel* getOtherStorageProcessor(StorageProcessorModel *sp) const;

    QList<StorageProcessorModel*> getStorageProcessors() const;
    void init();
    void initCaches();
    int getStorageProcessorNumber(const StorageProcessorModel *sp) const;
};

#endif // STORAGEMODEL_H
