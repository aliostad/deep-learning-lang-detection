#ifndef DMZ_SYSTEM_STREAM_FILE_DOT_H
#define DMZ_SYSTEM_STREAM_FILE_DOT_H

#include <dmzKernelExport.h>
#include <dmzSystemStream.h>
#include <dmzTypesBooleanOperator.h>
#include <stdio.h>

namespace dmz {

   class DMZ_KERNEL_LINK_SYMBOL StreamFile : public Stream {

      public:
         StreamFile ();
         StreamFile (FILE *handle);
         virtual ~StreamFile ();

         FILE *get_file_handle ();

         Boolean operator! () const;
         DMZ_BOOLEAN_OPERATOR;

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
         virtual Stream &operator<< (const char *Value);

         virtual Stream &operator<< (const void *Value);
         virtual Stream &operator<< (stream_operator_func func);

      protected:
         struct State;
         State &_state; //!< Internal state.

      private:
         StreamFile (const StreamFile &);
         const StreamFile &operator= (const StreamFile &);
   };


   class DMZ_KERNEL_LINK_SYMBOL StreamFileOut : public StreamFile {

      public:
         StreamFileOut ();
         virtual ~StreamFileOut ();

      private:
         StreamFileOut (const StreamFileOut &);
         const StreamFileOut &operator= (const StreamFileOut &);
   };

   class DMZ_KERNEL_LINK_SYMBOL StreamFileErr : public StreamFile {

      public:
         StreamFileErr ();
         virtual ~StreamFileErr ();

      private:
         StreamFileErr (const StreamFileErr &);
         const StreamFileErr &operator= (const StreamFileErr &);
   };
};

#endif // DMZ_SYSTEM_STREAM_FILE_DOT_H
