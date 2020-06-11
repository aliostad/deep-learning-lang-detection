#include <iostream>
#include <vector>


class Sample {
  private:
    int j;
    int copy_id;
  public:
    static int i;
    Sample() {
      j = i;
      std::cout << "constructor " << j << std::endl;
      i++;
    }
    Sample(const Sample& other) {
      copy_id = i;
      std::cout << "Copy constructor " << j << " other " << other.j << " copy_id = " << copy_id << std::endl;
      i++;
    }
    Sample& operator = (const Sample& other) {
      std::cout << "operator = " << j << " other " << other.j << std::endl;
    }
    ~Sample() {
      std::cout << "destructor " << j << " or copy_id " << copy_id << std::endl;
    }
};

int Sample::i = 0;

int main() {
  Sample x;
  Sample *p;
  p = new Sample[10];
  delete [] p;
  std::vector<Sample> vec(10);
  return 0;
}
