/*
 * Model.h
 *
 *  Created on: 21 Aug 2016
 *      Author: SNiLD
 */

#ifndef SRC_MODEL_H_
#define SRC_MODEL_H_

#include <QPersistentModelIndex>
#include <QString>

class Model
{
public:
    Model(const QString& model, const QPersistentModelIndex& index);
    virtual ~Model();

    const QString& getModel() const;
    const QPersistentModelIndex& getIndex() const;
    QPersistentModelIndex getYear(int year) const;
    QList<QPersistentModelIndex> getYearsBefore(int year) const;

    void addYear(int year, const QPersistentModelIndex& index);

private:
    QString m_model;
    QPersistentModelIndex m_index;
    QHash<int, QPersistentModelIndex> m_years;
};

#endif /* SRC_MODEL_H_ */
