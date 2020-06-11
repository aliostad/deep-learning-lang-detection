#ifndef IRESOURCEFROMSTREAMDATA_HPP
#define IRESOURCEFROMSTREAMDATA_HPP
#include "APGE/Core/CoreTypes.hpp"
#include "SFML_INCLUDES.hpp"

namespace APGE
{
namespace Resource
{
  class IResourceFromStreamData
  {
  public:
    IResourceFromStreamData() : stream_()
    {
    }

    IResourceFromStreamData(std::shared_ptr<sf::InputStream> stream)
      : stream_(stream)
    {
    }

    inline std::shared_ptr<sf::InputStream> getStreamPointer()
    {
      return stream_;
    }

    inline void setStreamPointer(std::shared_ptr<sf::InputStream> stream)
    {
      stream_ = stream;
    }

  private:
    std::shared_ptr<sf::InputStream> stream_;
  };
}
}
#endif // IRESOURCEFROMSTREAMDATA_HPP
