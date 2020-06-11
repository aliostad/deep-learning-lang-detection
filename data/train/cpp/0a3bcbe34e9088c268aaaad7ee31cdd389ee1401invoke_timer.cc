#include "net/event_loop.h"
#include "net/libevent_watcher.h"

InvokeTimer::InvokeTimer(EventLoop* evloop, Duration timeout, const Functor& f, bool periodic)
    : loop_(evloop)
	, timeout_(timeout)
	, functor_(f)
	, periodic_(periodic) 
{
    
}

InvokeTimer::InvokeTimer(EventLoop* evloop, Duration timeout, Functor&& f, bool periodic)
    : loop_(evloop)
	, timeout_(timeout)
	, functor_(std::move(f)), periodic_(periodic) 
{
   
}

std::shared_ptr<InvokeTimer> InvokeTimer::Create(EventLoop* evloop, Duration timeout, const Functor& f, bool periodic) {
    std::shared_ptr<InvokeTimer> it(new InvokeTimer(evloop, timeout, f, periodic));
    it->self_ = it;
    return it;
}

std::shared_ptr<InvokeTimer> InvokeTimer::Create(EventLoop* evloop, Duration timeout, Functor&& f, bool periodic) {
    std::shared_ptr<InvokeTimer> it(new InvokeTimer(evloop, timeout, std::move(f), periodic));
    it->self_ = it;
    return it;
}

InvokeTimer::~InvokeTimer() {
   
}

void InvokeTimer::Start() {
    auto f = [this]() {
        timer_.reset(new TimerEventWatcher(loop_, std::bind(&InvokeTimer::OnTimerTriggered, shared_from_this()), timeout_));
        timer_->SetCancelCallback(std::bind(&InvokeTimer::OnCanceled, shared_from_this()));
        timer_->Init();
        timer_->AsyncWait();
    };
    loop_->RunInLoop(std::move(f));
}

void InvokeTimer::Cancel() {
    if (timer_) {
        loop_->QueueInLoop(std::bind(&TimerEventWatcher::Cancel, timer_));
    }
}

void InvokeTimer::OnTimerTriggered() {
	functor_();

    if (periodic_) {
        timer_->AsyncWait();
    } else {
        functor_ = Functor();
        timer_.reset();
        self_.reset();
    }
}

void InvokeTimer::OnCanceled() {
    periodic_ = false;
    if (cancel_callback_) {
        cancel_callback_();
        cancel_callback_ = Functor();
    }
    timer_.reset();
    self_.reset();
}

