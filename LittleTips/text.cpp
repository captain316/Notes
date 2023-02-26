#include <iostream>
#include <string>
#include <array>
using namespace std;
#include <tuple>
#include <vector>
#include <functional>   
#include <algorithm>
#include <thread>
#include <chrono>
#include<cstring>
#include<iostream>

class A{
	public:
	virtual void print(){ cout << "m" << endl;}
};

class C:public A{
	public:
	void print(int S= 0) { cout <<"S"<< endl;}
};

int main(){
	
	A *ap = new C;
	ap->print();
return 0;
}
