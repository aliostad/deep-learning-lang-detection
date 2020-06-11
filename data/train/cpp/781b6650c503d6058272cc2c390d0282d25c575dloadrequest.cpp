#include "loadrequest.h"

LoadRequest::LoadRequest(const QUrl &url, LoadRequest::LoadStatus loadstatus, QObject *parent): QObject(parent), _url(url), _loadstatus(loadstatus)
{

}

LoadRequest::LoadRequest(const QUrl &url, LoadStatus loadstatus, const QString &errorstring, const QString &errordomain, int errorcode, QObject *parent) : QObject(parent), _url(url), _loadstatus(loadstatus), _errorstring(errorstring), _errordomain(errordomain), _errorcode(errorcode)
{

}

LoadRequest::~LoadRequest()
{

}

const QUrl &LoadRequest::url() const
{
    return this->_url;
}

LoadRequest::LoadStatus LoadRequest::loadStatus() const
{
    return this->_loadstatus;
}

const QString &LoadRequest::errorString()
{
    return this->_errorstring;
}

const QString &LoadRequest::errorDomain()
{
    return this->_errordomain;
}

int LoadRequest::errorCode() const
{
    return this->_errorcode;
}

