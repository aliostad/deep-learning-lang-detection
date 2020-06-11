/* 
 * File:   HandlerFactoryConfigure.h
 * Author: wo1fsea
 *
 * Created on March 22, 2014, 10:56 PM
 */

#ifndef HANDLERFACTORYCONFIGURE_H
#define	HANDLERFACTORYCONFIGURE_H

/* The Handler List*/
/* For a new feature handler, add c++ head here. */
/* For example: 
 *      #include "DummyHandler.h"
 */
#include "Handler.h"
#include "DummyHandler.h"
#include "SigninHandler.h"
#include "SignoutHandler.h"
#include "SignupHandler.h"
#include "FetchNodesHandler.h"
#include "FetchBriefsHandler.h"
#include "FetchArticlesHandler.h"
#include "CreateArticleHandler.h"
#include "ChangeArticleHandler.h"
#include "DeleteArticleHandler.h"
#include "CreateNodeHandler.h"
#include "ChangeNodeHandler.h"
#include "DeleteNodeHandler.h"
#include "SyncHandler.h"
#include "DummySyncHandler.h"

/* For a new feature handler, add the macro here. */
/* For example: 
 *      CREATE_HANDLER(DummyHandler,"/dummy.cgi")  
 */
#define CREATE_HANDLERS                                     \
 CREATE_HANDLER(DummyHandler,"/dummy.cgi")                  \
 CREATE_HANDLER(SigninHandler,"/signin.cgi")                \
 CREATE_HANDLER(SignoutHandler,"/signout.cgi")              \
 CREATE_HANDLER(SignupHandler,"/signup.cgi")                \
 CREATE_HANDLER(FetchNodesHandler,"/fetchnodes.cgi")        \
 CREATE_HANDLER(FetchBriefsHandler,"/fetchbriefs.cgi")      \
 CREATE_HANDLER(FetchArticlesHandler,"/fetcharticles.cgi")  \
 CREATE_HANDLER(CreateArticleHandler,"/createarticle.cgi")  \
 CREATE_HANDLER(ChangeArticleHandler,"/changearticle.cgi")  \
 CREATE_HANDLER(DeleteArticleHandler,"/deletearticle.cgi")  \
 CREATE_HANDLER(CreateNodeHandler,"/createnode.cgi")        \
 CREATE_HANDLER(ChangeNodeHandler,"/changenode.cgi")        \
 CREATE_HANDLER(DeleteNodeHandler,"/deletenode.cgi")        \
 CREATE_HANDLER(SyncHandler,"/sync.cgi")                    \
 CREATE_HANDLER(DummySyncHandler,"/dummysync.cgi")                    \
 
#endif	/* HANDLERFACTORYCONFIGURE_H */

