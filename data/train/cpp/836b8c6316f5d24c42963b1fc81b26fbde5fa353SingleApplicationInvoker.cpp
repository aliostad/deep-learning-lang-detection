/*
 * SingleApplicationInvoker.cpp
 *
*  Created on: Jan 14, 2014
 *      Author: sgrigoryan
 */
#include "SingleApplicationInvoker.hpp"
#include <QTimer>
#include <QTime>

#include <bb/system/InvokeManager>
#include <bb/system/InvokeTargetReply>
#include <bb/system/InvokeRequest.hpp>
#include <bb/system/InvokeReplyError.hpp>
#include <bb/system/SystemToast>

SingleApplicationInvoker* SingleApplicationInvoker::m_theInstance = NULL;


SingleApplicationInvoker& SingleApplicationInvoker::instance(){

	if(!m_theInstance){

		m_theInstance =  new SingleApplicationInvoker();
	}

	return *m_theInstance;
}

void SingleApplicationInvoker::destoryInstance(){

	delete m_theInstance;

	m_theInstance = NULL;
}


SingleApplicationInvoker::SingleApplicationInvoker()
: m_invokeScheduler(NULL)
, m_invokeTargetReply(NULL)
{
	//initialize timers
	m_invokeScheduler = new QTimer(this);
	m_invokeScheduler->setInterval(15*60*1000); // 15mins
	connect(m_invokeScheduler, SIGNAL(timeout()), this, SLOT(onScheduleTimeout()));

}



SingleApplicationInvoker::~SingleApplicationInvoker(){
	delete m_invokeScheduler;
}


void SingleApplicationInvoker::start(){

	//start timer
	if(m_invokeScheduler)
			m_invokeScheduler->start();
	invokeApp();
}

void SingleApplicationInvoker::invokeApp(){
	fprintf(stderr, "%s\n", "invokeApp(): ");
	if(m_targetUrl.isEmpty()){
		return;
	}
	bb::system::InvokeManager invokeManager;
	bb::system::InvokeRequest request;
	request.setTarget(m_targetUrl);
	request.setAction("bb.action.OPEN");
	fprintf(stderr, "%s\n", "Invoking Twitter app OPEN " );
	fprintf(stderr, "%s\n",m_targetUrl.toStdString().c_str());
	m_invokeTargetReply = invokeManager.invoke(request);
	connect(m_invokeTargetReply, SIGNAL(finished()), this,  SLOT(onInvokeResult()));

	bb::system::SystemToast* toast = new bb::system::SystemToast(this);
	toast->setBody("OPEN request sent");
	toast->exec();
}

void SingleApplicationInvoker::onInvokeResult()
{
    // Check for errors
    switch(m_invokeTargetReply->error()) {
        // Invocation could not find the target
        // did we use the right target ID?
    case bb::system::InvokeReplyError::NoTarget: {
    	fprintf(stderr, "%s\n", "onInvokeResult(): Error: no target");
            break;
        }
        // There was a problem with the invoke request
        // did we set all the values correctly?
    case bb::system::InvokeReplyError::BadRequest: {
    	fprintf(stderr, "%s\n", "onInvokeResult(): Error: bad request" );
            break;
        }
        // Something went completely
        // wrong inside the invocation request
        // Find an alternate route :(
    case bb::system::InvokeReplyError::Internal: {
    	fprintf(stderr, "%s\n", "onInvokeResult(): Error: internal" );
            break;
        }
        //Message received if the invoke request is successful
    default:
    	fprintf(stderr, "%s\n", "onInvokeResult(): Invoke Succeeded" );
        break;
    }

    // A little house keeping never hurts...
    delete m_invokeTargetReply;
    m_invokeTargetReply = NULL;
}

void SingleApplicationInvoker::stop(){

	if(m_invokeScheduler)
		m_invokeScheduler->stop();
}


void SingleApplicationInvoker::onScheduleTimeout(){

	bb::system::InvokeManager invokeManager;
	bb::system::InvokeRequest request;
	request.setTarget(m_targetUrl);
	request.setAction("bb.action.CLOSETWITTER");
	fprintf(stderr, "%s\n", "Invoking Twitter app CLOSE" );
	m_invokeTargetReply = invokeManager.invoke(request);
	connect(m_invokeTargetReply, SIGNAL(finished()), this,  SLOT(onInvokeResult()));

	bb::system::SystemToast* toast = new bb::system::SystemToast(this);
	toast->setBody("CLOSE request sent");
	toast->exec();
	// reopen app after 1 min delay
	QTimer::singleShot(60000, this, SLOT(invokeApp()));

}

void SingleApplicationInvoker::onDelayerTimeout(){

	start();
}
