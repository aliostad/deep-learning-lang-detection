#include <emscripten/bind.h>
#include "sample.h"

using namespace emscripten;

EMSCRIPTEN_BINDINGS(cpp_funcs) {
  function("cpp_add", &cpp_add);
  function("cpp_strlen", &cpp_strlen);
}

EMSCRIPTEN_BINDINGS(cpp_class) {
  class_<SampleClassA>("SampleClassA")
    .constructor<int>()
    .property("value", &SampleClassA::getValue, &SampleClassA::setValue)
    .class_function("printSomething", &SampleClassA::printSomething)
    ;
}

class SampleInterfaceWrapper : public wrapper<SampleInterface> {
public:
  EMSCRIPTEN_WRAPPER(SampleInterfaceWrapper);
  void invoke(const std::string& str) {
    return call<void>("invoke", str);
  }
};

EMSCRIPTEN_BINDINGS(cpp_interface) {
  class_<SampleInterface>("SampleInterface")
    .function("invoke", &SampleInterface::invoke, pure_virtual())
    .function("getName", &SampleInterface::getName)
    .allow_subclass<SampleInterfaceWrapper>("SampleInterfaceWrapper")
    ;
}

