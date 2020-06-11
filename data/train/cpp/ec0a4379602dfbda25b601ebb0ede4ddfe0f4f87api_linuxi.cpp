#include <precomp.h>
#include "api_linuxi.h"
#include "linuxapi.h"

api_linux *linuxApi;

api_linuxI::api_linuxI() {
  LinuxAPI::init();
}

api_linuxI::~api_linuxI() {
  LinuxAPI::kill();
}

#ifdef XWINDOW
Display *api_linuxI::linux_getDisplay() {
  return LinuxAPI::getDisplay();
}

XContext api_linuxI::linux_getContext() {
  return LinuxAPI::getContext();
}
#endif

int api_linuxI::linux_getIPCId() {
  return LinuxAPI::getIPCId();
}

#ifdef XWINDOW
XShmSegmentInfo *api_linuxI::linux_createXShm( int n ) {
  return LinuxAPI::createXShm( n );
}

void api_linuxI::linux_destroyXShm( XShmSegmentInfo *shm ) {
  LinuxAPI::destroyXShm( shm );
}

const XineramaScreenInfo *api_linuxI::linux_getXineramaInfo(int *num) {
  return LinuxAPI::getXineramaInfo(num);
}
#endif

