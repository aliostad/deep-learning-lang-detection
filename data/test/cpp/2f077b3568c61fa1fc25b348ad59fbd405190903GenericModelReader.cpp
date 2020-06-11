#include "GenericModelReader.h"
#include "perceptron/PerceptronModelReader.h"
#include "maxent/io/GISModelReader.h"
#include "model/GenericModelWriter.h"

namespace opennlp
{
    namespace model
    {
        using opennlp::maxent::io::GISModelReader;
        using opennlp::perceptron::PerceptronModelReader;

        GenericModelReader::GenericModelReader(File *f) throw(IOException) : AbstractModelReader(f)
        {
        }

        GenericModelReader::GenericModelReader(DataReader *dataReader) : AbstractModelReader(dataReader)
        {
        }

        void GenericModelReader::checkModelType() throw(IOException)
        {
          std::string modelType = readUTF();
          if (modelType == "Perceptron")
          {
            delegateModelReader = new PerceptronModelReader(this->dataReader);
          }
          else if (modelType == "GIS")
          {
            delegateModelReader = new GISModelReader(this->dataReader);
          }
          else
          {
            throw IOException("Unknown model format: " + modelType);
          }
        }

        opennlp::model::AbstractModel *GenericModelReader::constructModel() throw(IOException)
        {
          return delegateModelReader->constructModel();
        }

        void GenericModelReader::main(std::string args[]) throw(IOException)
        {
          AbstractModel *m = (new GenericModelReader(new File(args[0])))->getModel();
          (new GenericModelWriter(m, new File(args[1])))->persist();
        }
    }
}
