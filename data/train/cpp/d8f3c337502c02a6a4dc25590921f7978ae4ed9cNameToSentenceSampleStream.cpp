#include "NameToSentenceSampleStream.h"

namespace opennlp
{
    namespace tools
    {
        namespace formats
        {
            using opennlp::tools::namefind::NameSample;
            using opennlp::tools::tokenize::Detokenizer;
            using opennlp::tools::util::ObjectStream;

            NameToSentenceSampleStream::NameToSentenceSampleStream(Detokenizer *detokenizer, ObjectStream<NameSample*> *samples, int chunkSize) : AbstractToSentenceSampleStream<opennlp.tools.namefind.NameSample>(detokenizer, samples, chunkSize)
            {
            }

            std::string *NameToSentenceSampleStream::toSentence(NameSample *sample)
            {
              return sample->getSentence();
            }
        }
    }
}
