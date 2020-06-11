//Sample.h
//Zawiera definicje klasy Sample


#ifndef SAMPLE_H
#define SAMPLE_H

#include <string>
#include <vector>

//Rozmiar wektora probki
const int MAX = 10;



class Sample{
public:
  //Konstruktory i destruktor
  Sample();
  Sample(double*); 
  Sample(const Sample &);
  Sample(const std::vector<std::string> & _input);
  ~Sample(){};

  //metody klasy Sample i przeciazenia operatorow
  void DodajNowa(double*);
  bool PokazKlase();
  Sample & operator =(const Sample &);

  void friend operator <<(std::ostream& _o, Sample& _s);
  bool friend operator ==(const Sample &, const Sample &);
  double friend operator -(const Sample &, Sample &);
private:
  double wektor[MAX];
  double OdlegloscWektorow(const Sample& );
  std::ostream & WypiszProbke(std::ostream & _o);
};


#endif //SAMPLE_H
