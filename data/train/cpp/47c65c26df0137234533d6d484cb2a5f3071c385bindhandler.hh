#ifndef __INC_MVDS_BINDHANDLER_HH__
#define __INC_MVDS_BINDHANDLER_HH__

#include "../EventHandler/eventhandler.hh"

namespace mvds {


  /**
   *
   *
   */
  template <typename Next, typename... ArgsPass>
  class BindHandler : public EventHandler<ArgsPass...> {
  public:
   
    BindHandler(EventHandler<ArgsPass...,Next> *handler, Next next)
      : d_handler(handler), d_next(next)
    {

    }

    virtual ~BindHandler()
    {
      if (d_handler)
	delete d_handler;
    }

    virtual void operator()(ArgsPass... args)
    {
      (*d_handler)(args...,d_next);
    }

  private:

    EventHandler<ArgsPass...,Next> *d_handler;
    Next d_next;

  };

  template <typename... Args, typename Next>
  inline EventHandler<Args...> *bindAfter(EventHandler<Args...,Next> *handler, Next next)
  {
    return new BindHandler<Next,Args...>(handler,next);
  }

};


#endif // __INC_MVDS_BINDHANDLER_HH__

