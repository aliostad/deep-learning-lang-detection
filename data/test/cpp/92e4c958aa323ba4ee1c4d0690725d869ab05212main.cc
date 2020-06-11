#include <iostream>
#include <string>

using namespace std;

class pimpl_sample {

    struct impl;
    impl* pimpl_;

public:
  pimpl_sample();
  ~pimpl_sample();
  void do_something();
};

struct pimpl_sample::impl {
  void do_something_() {
    std::cout << s_ << "\n";
  }

  std::string s_;
};

pimpl_sample::pimpl_sample()
  : pimpl_(new impl) {
  pimpl_->s_ = "This is the pimpl idiom";
}

pimpl_sample::~pimpl_sample() {
  delete pimpl_;
}

void pimpl_sample::do_something() {
  pimpl_->do_something_();
}

int main( int argc, char** argv )
{
    cout << "constructing pimpl_sample" << endl;
    pimpl_sample p;
    p.do_something();

  return 0;
}


