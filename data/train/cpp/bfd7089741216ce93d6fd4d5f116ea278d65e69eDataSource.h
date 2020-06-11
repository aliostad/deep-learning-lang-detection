/* 
 * File:   DataSource.h
 * Author: jholscher
 *
 * Created on 29. August 2010, 14:37
 */

#ifndef DATASOURCE_H
#define	DATASOURCE_H
#include "MediaLocator.h"
#include "org/esb/util/Log.h"
#include "AV.h"
#include "FormatBaseStream.h"
#include "exports.h"


namespace org {
  namespace esb {
    namespace av {

      class AV_EXPORT DataSource : public FormatBaseStream{
        classlogger("org.esb.av.DataSource");
      public:
        DataSource(MediaLocator);
        virtual ~DataSource();
        virtual void connect();
        virtual void disconnect();
        std::string getContentType();
        MediaLocator getLocator();
        void initCheck();
        void setLocator(MediaLocator);
        void start();
        void stop();
      private:
        friend class Demultiplexer;
        org::esb::av::MediaLocator _locator;
        bool _isValid;
        AVFormatContext * formatCtx;

      };
    }
  }
}

#endif	/* DATASOURCE_H */

