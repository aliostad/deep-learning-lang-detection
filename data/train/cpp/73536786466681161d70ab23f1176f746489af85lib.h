#include <CoreServices/CoreServices.h>

typedef void (*StreamCallback)(void *target,
                               const char *path,
                               FSEventStreamEventFlags eventFlags,
                               FSEventStreamEventId eventId);

FSEventStreamRef createStream(const char *path,
                              double latency,
                              void *target,
                              StreamCallback callback);
bool scheduleStreamInRunLoop(FSEventStreamRef stream);

void unscheduleStream(FSEventStreamRef stream);
void destroyStream(FSEventStreamRef stream);
