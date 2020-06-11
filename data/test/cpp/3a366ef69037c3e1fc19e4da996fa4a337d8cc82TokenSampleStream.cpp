#include "TokenSampleStream.h"
#include "S.h"

namespace opennlp
{
    namespace tools
    {
        namespace tokenize
        {
            using opennlp::tools::util::FilterObjectStream;
            using opennlp::tools::util::ObjectStream;

            TokenSampleStream::TokenSampleStream(ObjectStream<std::string> *sampleStrings, const std::string &separatorChars) : opennlp.tools.util.FilterObjectStream<String, TokenSample>(sampleStrings)
            {


              if (sampleStrings == 0 || separatorChars == "")
              {
                throw IllegalArgumentException("parameters must not be null!");
              }

              this->separatorChars = separatorChars;
            }

            TokenSampleStream::TokenSampleStream(ObjectStream<std::string> *sentences)
            {
            }

            opennlp::tools::tokenize::TokenSample *TokenSampleStream::read() throw(IOException)
            {
              std::string sampleString = samples->read();

              if (sampleString != "")
              {
                return TokenSample::parse(sampleString, separatorChars);
              }
              else
              {
                return 0;
              }
            }
        }
    }
}
