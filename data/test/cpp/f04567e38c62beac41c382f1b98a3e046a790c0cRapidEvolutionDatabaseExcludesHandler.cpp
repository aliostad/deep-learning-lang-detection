//
//  RapidEvolutionDatabaseExcludesHandler.cpp
//  soul-sifter
//
//  Created by Robby Neale on 11/5/12.
//
//

#include "RapidEvolutionDatabaseExcludesHandler.h"

#include <xercesc/sax2/DefaultHandler.hpp>

#include "DTAbstractHandler.h"

using namespace xercesc;

namespace dogatech {
namespace soulsifter {

RapidEvolutionDatabaseExcludesHandler::RapidEvolutionDatabaseExcludesHandler(SAX2XMLReader* parser,
                                                                             DTAbstractHandler* parentHandler) :
DTAbstractHandler::DTAbstractHandler(parser, parentHandler),
qname(XMLString::transcode("config")) {
}
    
}
}
