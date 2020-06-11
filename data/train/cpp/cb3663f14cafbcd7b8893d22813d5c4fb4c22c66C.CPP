//PROGRAM TO SHOW THE USE OF CONSTRUCTORS
//BY LAVISH KOTHARI

#include<iostream.h>
#include<conio.h>

class sample
{
	int a;
	char b;
	public:
		sample();
		sample(int);
		sample(int,char);
		sample(sample&);
};

sample::sample()
{
	a=0;
	b='\0';
	cout<<"DEFAULT CONSTRUCTOR CALLED"<<endl;
}


sample::sample(int x)
{
	a=x;
	b='\0';
	cout<<"SINGLE ARGUMENTED CONSTRUCTOR CALLED"<<endl<<a<<endl;
}

sample::sample(int x,char c)
{
	a=x;
	b=c;
	cout<<"TWO ARGUMENTED CONSTRUCTOR CALLED"<<endl<<a<<endl<<b<<endl;
}

sample::sample(sample&)
{
	cout<<"COPY CONSTRUCTOR CALLED";
}


int main()
{
	clrscr();
	sample s1,s2=5,s3(10,'t');
	sample s=s1;
	getch();
	return 1;
}

