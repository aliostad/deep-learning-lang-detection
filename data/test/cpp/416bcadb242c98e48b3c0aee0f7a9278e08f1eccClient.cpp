#include "Client.hpp"
#include "LastHandler.hpp"
#include "NewLocationHandler.hpp"
#include "ComplaintHandler.hpp"
#include "FanHandler.hpp"
#include "SpamHandler.hpp"
#include "Utilities.hpp"

using namespace HFDP::ChainOfResponsibility::GumballEMailHandler;

Client::Client() :
  _lastHandler( new LastHandler() ),
  _newHandler(  new NewLocationHandler( _lastHandler.get() ) ),
  _hateHandler( new ComplaintHandler( _newHandler.get() ) ),
  _fanHandler(  new FanHandler( _hateHandler.get() ) ),
  _spamHandler( new SpamHandler ( _fanHandler.get() ) )
{
  PrintMessage("Client::Client");
}

void Client::handleRequest( std::string request ) const
{
  PrintMessage("Client::handleRequest");
  _spamHandler->handleRequest( request );
}

void Client::print() const
{
  PrintMessage("Client::print");
  _spamHandler->print();
}

