/*
 * InvocationWrapper.hpp
 *
 *  Created on: May 6, 2013
 *      Author: Bakhshi
 */

#ifndef INVOCATIONWRAPPER_HPP_
#define INVOCATIONWRAPPER_HPP_

#include <QObject>
#include <bb/system/InvokeRequest>

class InvocationWrapper: public QObject {
Q_OBJECT

Q_PROPERTY(QString mimeType READ mimeType WRITE setMimeType NOTIFY mimeTypeChanged)
Q_PROPERTY(QUrl uri READ uri WRITE setUri NOTIFY uriChanged)
Q_PROPERTY(QString invokeActionId READ invokeActionId WRITE setInvokeActionId NOTIFY invokeActionIdChanged)
Q_PROPERTY(QString invokeTargetId READ invokeTargetId WRITE setInvokeTargetId NOTIFY invokeTargetIdChanged)

public:
	InvocationWrapper(QObject* parent = 0);

	QString mimeType() const;
	void setMimeType(const QString& mimeType);

	QUrl uri() const;
	void setUri(const QUrl& uri);

	QString invokeActionId() const;

	Q_INVOKABLE
	void setInvokeActionId(const QString& actionId);

	QString invokeTargetId() const;Q_INVOKABLE
	void setInvokeTargetId(const QString& targetId);

	Q_INVOKABLE
	void invoke();

Q_SIGNALS:
	void mimeTypeChanged(const QString&);
	void uriChanged(const QUrl&);
	void invokeActionIdChanged(const QString&);
	void invokeTargetIdChanged(const QString&);

private:
	bb::system::InvokeRequest mInvokeRequest;
};

#endif /* INVOCATIONWRAPPER_HPP_ */
