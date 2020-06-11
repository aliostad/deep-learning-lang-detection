//        Copyright Tomasz Kamiński 2013 - 2014.
// Distributed under the Boost Software License, Version 1.0.
//   (See accompanying file ../LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)

#include "invoke_option2.hpp"
#include "invoke_option1.hpp"
#include "test_classes.hpp"

using namespace test_classes;

Base base;
Class clazz;
Derived derived;
Class* rawPointer;
Pointer smartPointer;
ValueConversion valueConversion;
ReferenceConversion referenceConversion;
Mixed mixed;
ConstMixed constMixed;

int main()
{
  using functional::option2::invoke;
 
  invoke(&Class::normal, Class{});
  //invoke(&Class::normal, base);
  invoke(&Class::normal, clazz);
  invoke(&Class::normal, derived);
  invoke(&Class::normal, rawPointer);
  invoke(&Class::normal, smartPointer);
  invoke(&Class::normal, valueConversion);
  invoke(&Class::normal, referenceConversion);
  invoke(&Class::normal, mixed);
  //invoke(&Class::normal, constMixed);
 
  //invoke(&Class::reference, Class{});
  //invoke(&Class::reference, base);
  invoke(&Class::reference, clazz);
  invoke(&Class::reference, derived);
  invoke(&Class::reference, rawPointer);
  invoke(&Class::reference, smartPointer);
  //invoke(&Class::reference, valueConversion);
  invoke(&Class::reference, referenceConversion);
  invoke(&Class::reference, mixed);
  //invoke(&Class::reference, constMixed);

  invoke(&Class::member, Class{});
  //invoke(&Class::member, base);
  invoke(&Class::member, clazz);
  invoke(&Class::member, derived);
  invoke(&Class::member, rawPointer);
  invoke(&Class::member, smartPointer);
  invoke(&Class::member, valueConversion);
  invoke(&Class::member, referenceConversion);
  invoke(&Class::member, mixed);
  //invoke(&Class::member, constMixed);

  invoke(&Class::rreference, Class{});
  //invoke(&Class::rreference, base);
  invoke(&Class::rreference, std::move(clazz));
  invoke(&Class::rreference, std::move(derived));
  //invoke(&Class::rreference, rawPointer);
  //invoke(&Class::rreference, smartPointer);
  invoke(&Class::rreference, valueConversion);
  //invoke(&Class::rreference, referenceConversion);
  //invoke(&Class::rreference, mixed);
  //invoke(&Class::rreference, constMixed);


  invoke([](int) {}, 1);
}
