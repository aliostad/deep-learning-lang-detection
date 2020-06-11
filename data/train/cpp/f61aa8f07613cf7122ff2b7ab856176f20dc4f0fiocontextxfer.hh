#ifndef _TEEPEEDEE_LIB_IOCONTEXTXFER_HH
#define _TEEPEEDEE_LIB_IOCONTEXTXFER_HH

#include "unixexception.hh"
#include "iocontextcontrolled.hh"
#include "xferlimit.hh"
#include "sendfile.hh"

class IOContextXfer : public IOContextControlled,public Sendfile
{
  typedef IOContextControlled super;
  
  XferLimit* _limit;

  void
  free()
  {
    if(_limit){
      delete _limit;
      _limit=0;
    }
    if(stream_out() && stream_out()->consumer() == this)
      stream_out()->release_consumer();
    if(stream_in() && stream_in()->consumer() == this)
      stream_in()->release_consumer();
  }

  void
  do_io()
  {
    if(!stream_in() && data_buffered()){
      Sendfile::write_out();
      if(!data_buffered()){
	completed();
	return;
      }
      return;
    }
    if(!stream_in()||!stream_out())
      return;
    bool result = Sendfile::io();

    if(result){
      completed();
      return;
    }
  }
 protected:

  void
  limit_xfer(off_t bytes)
  {
    _limit->xfer(bytes);
    if(bytes)
      made_progress();
  }
  
public:
  IOContextXfer(IOController*ioc,Stream*in=0,Stream*out=0):
    IOContextControlled(ioc),
    Sendfile(in,out),
    _limit(0)
  {
  }

  void
  limit(XferLimit*xl)
  {
    _limit = xl;
  }

  bool
  stream_hungup(Stream&stream)
  {
    if(stream_in() && stream_in()->consumer() == this)
      stream_in()->release_consumer();
    if (stream_out() &&
	&stream==stream_in() && &stream != stream_out()) {
      if(data_buffered()){
	stream_in(0);
	return false;
      }
    }
    if(stream_out() && stream_out()->consumer() == this)
      stream_out()->release_consumer();
    stream_out(0);
    stream_in(0);
    return true;
  }

  std::string
  desc()const
  {
    return "sendfile " + super::desc();
  }
  
  ~IOContextXfer()
  {
    free();
  }

  bool want_write(Stream&stream)
  {
    if(!stream_out()){
      if(stream_in()!=&stream)
	stream_out(&stream);
    }
    if(has_buf() && !data_buffered())
      return false;
    return &stream==stream_out();
  }
  bool want_read(Stream&stream)
  {
    if(!stream_in()){
      if(stream_out()!=&stream)
	stream_in(&stream);
    }
    if(data_buffered())
      return false;
    if(&stream!=stream_in())
      return false;
    if(!has_buf())
      return false;

    return true;
  }

protected:
  void
  read_in(Stream&stream,size_t max)
  {
    if(!stream_in()){
      if(stream_out()!=&stream)
	stream_in(&stream);
    }
    if(&stream!=stream_in())
      return;
    do_io();
  }

  void
  write_out(Stream&stream,size_t max)
  {
    if(!stream_out()){
      if(stream_in()!=&stream)
	stream_out(&stream);
    }
    if(&stream!=stream_out())
      return;
    do_io();
  }
};

#endif
