#ifndef PLCTOPOLOGYMODEL_H
#define PLCTOPOLOGYMODEL_H

#include "nodemodel.h"
#include "edgemodel.h"
#include "nodemodel.h"
#include "plcspectrummodel.h"


class PLCTopologyModel
{
public:
    PLCTopologyModel();
    PLCTopologyModel(const PLCSpectrumModel& spectrumModel, const QList<EdgeModel *>& edges,
                     const QList<NodeModel*>& nodes);

    PLCTopologyModel(const QVariantMap& map);
    QVariantMap toVariantMap();
    void fromVariantMap(const QVariantMap& map);

    void setSpectrumModel(const PLCSpectrumModel& spectrumModel){ this->spectrumModel = spectrumModel;}
    void setEdgeList(const QList<EdgeModel *>& newEdges){edges = newEdges;}
    void setNodeList(const QList<NodeModel *>& newNodes){nodes = newNodes;}

    QList<EdgeModel *>* getEdges() {return &edges;}
    QList<NodeModel *>* getNodes() {return &nodes;}
    PLCSpectrumModel getSpectrumModel(){return spectrumModel;}

private:
    PLCSpectrumModel spectrumModel;
    QList<EdgeModel *> edges;
    QList<NodeModel *> nodes;
};

#endif // PLCTOPOLOGYMODEL_H
