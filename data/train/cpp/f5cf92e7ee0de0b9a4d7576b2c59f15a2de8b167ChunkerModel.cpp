#include "ChunkerModel.h"
#include "model/BinaryFileDataReader.h"
#include "model/GenericModelReader.h"

namespace opennlp
{
    namespace tools
    {
        namespace chunker
        {
            using opennlp::model::AbstractModel;
            using opennlp::model::BinaryFileDataReader;
            using opennlp::model::GenericModelReader;
            using opennlp::tools::util::InvalidFormatException;
            using opennlp::tools::util::model::BaseModel;
const std::string ChunkerModel::COMPONENT_NAME = "ChunkerME";
const std::string ChunkerModel::CHUNKER_MODEL_ENTRY_NAME = "chunker.model";

            ChunkerModel::ChunkerModel(const std::string &languageCode, AbstractModel *chunkerModel, Map<std::string, std::string> *manifestInfoEntries) : opennlp.tools.util.model.BaseModel(COMPONENT_NAME, languageCode, manifestInfoEntries)
            {


              artifactMap->put(CHUNKER_MODEL_ENTRY_NAME, chunkerModel);

              checkArtifactMap();
            }

            ChunkerModel::ChunkerModel(const std::string &languageCode, AbstractModel *chunkerModel)
            {
            }

            ChunkerModel::ChunkerModel(InputStream *in_Renamed) throw(IOException, InvalidFormatException) : opennlp.tools.util.model.BaseModel(COMPONENT_NAME, in)
            {
            }

            void ChunkerModel::validateArtifactMap() throw(InvalidFormatException)
            {
              BaseModel::validateArtifactMap();

              if (!(dynamic_cast<AbstractModel*>(artifactMap->get(CHUNKER_MODEL_ENTRY_NAME)) != 0))
              {
                throw InvalidFormatException("Chunker model is incomplete!");
              }
            }

            opennlp::model::AbstractModel *ChunkerModel::getChunkerModel()
            {
              return static_cast<AbstractModel*>(artifactMap->get(CHUNKER_MODEL_ENTRY_NAME));
            }

            void ChunkerModel::main(std::string args[]) throw(FileNotFoundException, IOException)
            {

              if (sizeof(args) / sizeof(args[0]) != 4)
              {
                System::err::println("ChunkerModel -lang code packageName modelName");
                exit(1);
              }

              std::string lang = args[1];
              std::string packageName = args[2];
              std::string modelName = args[3];

              AbstractModel *chunkerModel = (new GenericModelReader(new BinaryFileDataReader(new FileInputStream(modelName))))->getModel();

              ChunkerModel *packageModel = new ChunkerModel(lang, chunkerModel);
              packageModel->serialize(new FileOutputStream(packageName));
            }
        }
    }
}
