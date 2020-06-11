#ifndef SCISSY_SESSION_HANDLER_HH
# define SCISSY_SESSION_HANDLER_HH

# include <mimosa/http/handler.hh>

# include "session.hh"

namespace scissy
{
  class SessionHandler : public mimosa::http::Handler
  {
  public:
    SessionHandler(mimosa::http::Handler::Ptr handler);

    static Session & threadSession();

    virtual bool handle(mimosa::http::RequestReader & request,
                        mimosa::http::ResponseWriter & response) const;

  private:
    mimosa::http::Handler::Ptr handler_;
  };
}

#endif /* !SCISSY_SESSION_HANDLER_HH */
