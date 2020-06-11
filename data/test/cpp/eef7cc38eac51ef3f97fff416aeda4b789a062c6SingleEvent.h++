#ifndef CORE__SIGNALING__SINGLEEVENT_HXX__
#define CORE__SIGNALING__SINGLEEVENT_HXX__

template<typename _EArg>
class SingleEvent;

template<typename _EArg>
struct SingleEvent : public Event<_EArg>
{
    typedef EventHandler<_EArg> Handler;
    SingleEvent() : Event<_EArg>(), Handler_(NULL) {}
    ~SingleEvent() {}

    SingleEvent&
    operator=(Handler* handler)
    { this->Handler_ = handler; return *this; }

    SingleEvent&
    operator+=(Handler* handler)
    { if (this) this->Handler_ = handler; return *this; }

    SingleEvent&
    operator-=(const Handler* handler)
    { if (this && this->Handler_ == handler) this->Handler_ = NULL; return *this; }
    
    SingleEvent&
    operator+=(Handler& handler)
    { if (this) this->Handler_ = &handler; return *this; }

    SingleEvent&
    operator-=(const Handler& handler)
    { if (this && this->Handler_ == &handler) this->Handler_ = NULL; return *this; }

    void
    operator()(_EArg arg)
    { if (this && this->Handler_) (*this->Handler_)(arg); }
private:
    Handler* Handler_;
};

// template<>
// struct SingleEvent<void> : public EventHandler<void>
// {
//     typedef EventHandler<void> Handler;
//     SingleEvent() : Handler_(NULL) {}
//     ~SingleEvent() {}

//     SingleEvent&
//     operator<<(Handler* handler)
//     { this->Handler_ = handler; return *this;}

//     SingleEvent&
//     operator=(Handler* handler)
//     { this->Handler_ = handler; return *this; }

//     SingleEvent&
//     operator+=(Handler* handler)
//     { this->Handler_ = handler; return *this; }

//     SingleEvent&
//     operator-=(Handler* handler)
//     { if (this->Handler_ == handler) this->Handler_ = NULL; return *this; }
    
//     SingleEvent&
//     operator<<(Handler& handler)
//     { this->Handler_ = &handler; return *this; }

//     SingleEvent&
//     operator=(Handler& handler)
//     { this->Handler_ = &handler; return *this; }

//     SingleEvent&
//     operator+=(Handler& handler)
//     { this->Handler_ = &handler; return *this; }

//     SingleEvent&
//     operator-=(Handler& handler)
//     { if (this->Handler_ == &handler) this->Handler_ = NULL; return *this; }

//     void
//     operator()()
//     { if (this->Handler_)(*this->Handler_)(); }
// private:
//     Handler* Handler_;
// };

#endif // CORE__SIGNALING__SINGLEEVENT_HXX__
