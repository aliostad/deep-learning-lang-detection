/*
 * InvocationWrapper.cpp
 *
 *  Created on: May 6, 2013
 *      Author: Bakhshi
 */

#include <bb/system/InvokeManager>

#include "InvocationWrapper.hpp"

InvocationWrapper::InvocationWrapper(QObject* parent) :
		QObject(parent) {
}

QString InvocationWrapper::mimeType() const {
	return mInvokeRequest.mimeType();
}

void InvocationWrapper::setMimeType(const QString& mimeType) {
	if (mimeType != mInvokeRequest.mimeType()) {
		mInvokeRequest.setMimeType(mimeType);
		emit mimeTypeChanged(mimeType);
	}
}

QUrl InvocationWrapper::uri() const {
	return mInvokeRequest.uri();
}

void InvocationWrapper::setUri(const QUrl& uri) {
	if (uri != mInvokeRequest.uri()) {
		mInvokeRequest.setUri(uri);
		emit uriChanged(uri);
	}
}

QString InvocationWrapper::invokeActionId() const {
	return mInvokeRequest.action();
}

void InvocationWrapper::setInvokeActionId(const QString& actionId) {
	if (actionId != mInvokeRequest.action()) {
		mInvokeRequest.setAction(actionId);
		emit invokeActionIdChanged(actionId);
	}
}

QString InvocationWrapper::invokeTargetId() const {
	return mInvokeRequest.target();
}

void InvocationWrapper::setInvokeTargetId(const QString& targetId) {
	if (targetId != mInvokeRequest.target()) {
		mInvokeRequest.setTarget(targetId);
		emit invokeTargetIdChanged(targetId);
	}
}

void InvocationWrapper::invoke() {
	bb::system::InvokeManager manager;

	manager.invoke(mInvokeRequest);
}
