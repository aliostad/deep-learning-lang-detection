#ifndef DMZ_FOUNDATION_STREAM_ZIP_DOT_H
#define DMZ_FOUNDATION_STREAM_ZIP_DOT_H

#include <dmzFoundationExport.h>
#include <dmzFoundationReaderWriterZip.h>
#include <dmzSystemStream.h>

namespace dmz {

class DMZ_FOUNDATION_LINK_SYMBOL StreamZip : public Stream, public WriterZip {

   public:
      StreamZip ();
      virtual ~StreamZip ();

      // Stream Interface
      virtual Stream &write_raw_data (const UInt8 *Data, const Int32 Size);
      virtual Stream &flush ();
      virtual Stream &newline ();
      virtual Stream &operator<< (const UInt16 Value);
      virtual Stream &operator<< (const UInt32 Value);
      virtual Stream &operator<< (const UInt64 Value);
      virtual Stream &operator<< (const Int16 Value);
      virtual Stream &operator<< (const Int32 Value);
      virtual Stream &operator<< (const Int64 Value);
      virtual Stream &operator<< (const Float32 Value);
      virtual Stream &operator<< (const Float64 Value);
      virtual Stream &operator<< (const String &Value);
      virtual Stream &operator<< (const char Value);
      virtual Stream &operator<< (const char *Data);
      virtual Stream &operator<< (const void *Value);
      virtual Stream &operator<< (stream_operator_func func);

   private:
      StreamZip (const StreamZip &);
      const StreamZip &operator= (const StreamZip &);
};

};

#endif // DMZ_FOUNDATION_STREAM_ZIP_DOT_H
