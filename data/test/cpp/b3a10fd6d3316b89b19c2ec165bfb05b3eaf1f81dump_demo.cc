#include <stdint.h>

#include "r.h"
#include "r_dump_stl.h"

#define DUMP(type) dump(#type ": ", (type)(0))

// TODO(pts): Add a custom class which is actually dumpable.
class C {};

int main() {
  DUMP(bool);

  DUMP(char);
  DUMP(unsigned char);
  DUMP(signed char);
  DUMP(short);
  DUMP(unsigned short);
  DUMP(int);
  DUMP(unsigned int);
  DUMP(long);
  DUMP(unsigned long);
  DUMP(long long);
  DUMP(unsigned long long);
  DUMP(int8_t);
  DUMP(uint8_t);
  DUMP(int16_t);
  DUMP(uint16_t);
  DUMP(int32_t);
  DUMP(uint32_t);
  DUMP(int64_t);
  DUMP(uint64_t);

  DUMP(float);
  DUMP(double);
  DUMP(long double);

  sout << "---\n";
  dump("Hel\3456l\234o!\0not-truncated");
  dump((const char*)"Hel\345lo!\0truncated");  // "Hello\345!".
  dump(std::string("Hello!\n"));
  dump(std::string("Hel\0lo!\n", 8));
  dump(StrPiece("Hel\0lo!\n", 8));
  dump(StrPiece("Hello!\n", 7));
  char ca[] = {33, 44, 00, 55};  // No \0 at end.
  dump(ca);

  // dump(C());  // This won't compile, missing wrdump for C.

  char const *msg = "Bye";
  int a[3] = {55, 66, 77};
  std::vector<int> b;
  b.resize(3);
  b[2] = 44;

  dump(true);
  dump(-42);
  dump(a);
  dump(b);
  dump(std::list<int>());
  dump(std::make_pair(55, 77.0));
  std::queue<double> q;
  q.push(55);
  q.push(-66);
  q.push(77);
  dump(q);
  std::priority_queue<float> pq;
  pq.push(55);
  pq.push(-66);
  pq.push(77);
  dump(pq);
  std::stack<double> st;
  st.push(55);
  st.push(-66);
  st.push(77);
  dump(st);
  std::map<std::string, int> m;
  m["answer"] = 42;
  m["other"] = 137;
  dump(m);
  std::multimap<double, const char*> mm;
  mm.insert(std::make_pair(12.34, "hello"));
  mm.insert(std::make_pair(12.34, "world"));
  dump(mm);
  std::set<double> s;
  s.insert(66);
  s.insert(55);
  s.insert(-44);
  s.insert(55);
  dump(s);
  std::multiset<double> ms;
  ms.insert(66);
  ms.insert(55);
  ms.insert(-44);
  ms.insert(55);
  dump(ms);

#if __GXX_EXPERIMENTAL_CXX0X__ || __cplusplus >= 201100
  sout << "--- C++11:\n";
  dump(std::make_tuple(55, 77.0, "hi"));
  dump(std::array<double, 3>());
  // To avoid warning here: g++ -std=c++0x -fno-deduce-init-list
  dump(std::initializer_list<int>({8, 9, 10}));
  // dump({8, 9, 10});  // This doesn't compile, can't infer type int.
  std::unordered_map<std::string, int> um;
  um["answer"] = 42;
  um["other"] = 137;
  dump(um);
  std::unordered_multimap<double, const char*> umm;
  umm.insert(std::make_pair(12.34, "hello"));
  umm.insert(std::make_pair(12.34, "world"));
  dump(umm);
  std::unordered_set<double> us;
  us.insert(66);
  us.insert(55);
  us.insert(-44);
  us.insert(55);
  dump(us);
  std::unordered_multiset<double> ums;
  ums.insert(66);
  ums.insert(55);
  ums.insert(-44);
  ums.insert(55);
  dump(ums);
#ifndef __clang__
  dump(std::forward_list<int>({8, 9, 10}));
#endif
#endif

  dump("Answer: ", 42);
  dump("Foo: ", 7, 6, 5);

  // TODO(pts): stdout << dump(42) << "\n";
  std::string str; str << dump(42) << dump(-5) << '.';
  // s << Formatter<const char*>(";.");  // Works.
  // s << Formatter(";.");  // Doesn't compile.
  str << ";." << "x" << msg << -42 << msg;
  // s << 12.34;
  printf("<%s>\n", str.c_str());
  // Unfortunately, `stdout << "HI"' will never compile, because both sides
  // of `<<` are basic types, so `operator<<' declarations are not
  // considered.
  FileObj(stdout) << "HI:" << dump(42) << dump(-6);
  stdout << dump(-7) << " " << dump(89) << dump('\'') << dump('\t') << ' '
         << dump('\376') << dump('x');
  printf("\n");

  return 0;
}
