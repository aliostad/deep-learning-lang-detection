#include "siete.h"
#include <iostream>

Siete::Siete(int x, int y) :Cover(x,y)
{
  image1.load("sietei1.png");
  image2.load("sietei3.png");
  image3.load("sietei2.png");
  image4.load("sietei4.png");

  image5.load("sieten1.png");
  image6.load("sieten3.png");
  image7.load("sieten2.png");
  image8.load("sieten4.png");

  image9.load("sieteo1.png");
  image10.load("sieteo3.png");
  image11.load("sieteo2.png");
  image12.load("sieteo4.png");
  Cover::rect = image1.rect();
  Cover::rect.translate(x, y);

}


QImage & Siete::getImage(int x,int T)
{ 
 if(x==1){
  if(T==1)
  return image1;
  if(T==2)
  return image2;
  if(T==3)
  return image3;
  if(T==4)
  return image4;}

else if(x==2){
  
  if(T==1)
  return image5;
  if(T==2)
  return image6;
  if(T==3)
  return image7;
  if(T==4)
  return image8;}
else if(x==3){
  
 if(T==1)
  return image9;
  if(T==2)
  return image10;
  if(T==3)
  return image11;
  if(T==4)
  return image12;
}
}





