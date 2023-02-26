# 引言

在面向对象高级编程(上)中，侯捷老师分别从**基于对象**、**面向对象**，讲述了C++编程过程中相关的知识点、注意事项以及如何写好规范的代码。

1.**Object Based(基于对象)：**面对的是单一class的设计

- Class without pointer member(s) —— complex类
- Class with pointer member(s)       ——string类

2.**Object Oriented（面向对象）：**面对的是多重classes的设计。classes和classes之间的关系。  

接下来，将依托这个分类类分别叙述知识点。



# Ⅰ：**Object Based(基于对象)：**面对的是单一class的设计

在基于对象编程中，由两个例子贯穿始终。一个是：complex类，另一个是：string类。

## 一、Class without pointer member(s) —— complex类

complex(复数)类中，不含指针，用默认的析构函数即可，所以这就是本案例写了构造函数，但没有写析构函数的原因。

### 1.头文件与类的声明

在写一个带指针的类时，一定要特别小心！如果一个类不带指针，则多半可以不写析构函数。

**头文件的防卫式声明**

作用：防止同一个文件被包含多次

 1）#ifndef

```cpp
#ifndef  __COMPLEX__
#define   __COMPLEX__

... ... // 声明、定义语句

#endif
```

特点：

- 跨平台
- 可针对文件也可针对代码片段。
- 编译慢，有宏命名冲突的风险。

2）**#pragmaonce**

```cpp
#pragmaonce

... ... // 声明、定义语句
```

特点：

- 不跨平台
- 只能针对文件
- 编译快，无宏命名冲突的风险。



### 2.构造函数

在class body 内定义的函数自动inline，在类外要加inline关键字。inline函数可以让编译变快，你可以试着把所有函数都定义inline，但编译器inline不inline就不一定了，换句话说，你只是提交了一份inline“申请”，如果inline的函数简单，编译器就给你通过”申请“。

函数重载常常发生在构造函数中。

如果有一个构造函数已经有默认值，可以重载其他的构造函数，但不能重载与它冲突的那一个。例如：

```cpp
class complex{
public:
	complex(double r =0, double i =0)
	:re(r), im(i)
	{}
	complex():re(0), im(0){}  //ERROR!
	....
private:
	double re, im;
};

//否则，该调用那个呢？有两个作用一样的构造函数。
complex c1;
complex c2();
```



构造函数放到private中，则外界不能创建该类的实例。在**单例Singleton模式**中就用到了这一点：

<img src="C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1660717365763.png" alt="1660717365763" style="zoom: 67%;" />

在一个类中，一定要将不**会改变数据**的成员声明为**const**。



### 3.参数传递与返回值

> 如果可以的话，参数传递与返回值的传递尽量**by reference**

参数传递的三种方式，设计类成员函数时，要提前考虑好那些函数的数据会改变，如果不改变请加上const。

- pass by value
- pass by reference
- pass by reference to const (推荐！)

返回值传递的时候，如果可以，建议使用return by reference。



**那什么时候不能return by reference 呢？**

首先考虑，如果一个函数操作得到一个结果B，那该结果放到什么位置上呢？

- 情况一：在**该函数区域**，创建一个新的变量i，将B传给它。（不能return by reference）
- 情况二：将结果B传递给该函数已存在的一个变量。 （可以return by reference）

对情况一，此时`return i`的话，返回的是创建的新变量i，但请记住，i是一个局部变量，它的生命周期仅在创建它的函数中。此时如果return by reference的话就会报错！

对情况二则没有此限制，如下，请留意**函数第一个参数并不是`const reference`：**

```cpp
inline complex&            //可以return by reference
__doapl(complex* ths, const complex& r){
	ths->re += r.re;       //ths是一个已存在的变量
	ths->im += r.im; 
	return *ths; 
}

inline complex&
complex::operator += (const complex& r)
{
	return __doapl (this, r);
}
```



**友元（friend）**函数可以取得类的private中的数据，但不建议这么做，因为会破坏封装性。

但有一点请记住：**相同class内的各objects互为友元！**所以下面类中的函数取用private数据合法。

<img src="C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1660719116776.png" alt="1660719116776" style="zoom:67%;" />



### 4.操作符重载与临时对象

**（一）操作符重载之成员函数**

- 任何成员函数都有一个**隐藏的pointer（即this）**,操作符重载也不例外。这个pointer(this)就指向调用者。对双目运算符来说，调用者就是左边的那个。

<img src="C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1660731112890.png" alt="1660731112890" style="zoom: 67%;" />



- **传递者**无需知道**接收者**是以**reference形式**接收。
- “+=”操作符的重载不能返回`void`类型是因为：用户有可能会进行**连加**操作。

<img src="C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1660732178870.png" alt="1660732178870" style="zoom:67%;" />



**（二）操作符重载之非成员函数**

<img src="C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1660732700071.png" alt="1660732700071" style="zoom:67%;" />

与之前的区别在于这种重载无this指针，它是**全域/局函数。**



**（三）临时对象**

仔细考虑一下，为什么**（二）**中的三种重载返回值不是by reference 而是by value？

这是因为**在函数中创建了一个临时对象！**故只能by value。

<img src="C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1660733346079.png" alt="1660733346079" style="zoom: 67%;" />



**（四）千万不要把一些特殊的操作符重载写成员函数**

![1660734459529](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1660734459529.png)



### 5.complex类的完整实现

**complex.h**

```cpp
#ifndef __MYCOMPLEX__
#define __MYCOMPLEX__

class complex; 
complex&
  __doapl (complex* ths, const complex& r);
complex&
  __doami (complex* ths, const complex& r);
complex&
  __doaml (complex* ths, const complex& r);


class complex
{
public:
  complex (double r = 0, double i = 0): re (r), im (i) { }
  complex& operator += (const complex&);
  complex& operator -= (const complex&);
  complex& operator *= (const complex&);
  complex& operator /= (const complex&);
  double real () const { return re; }
  double imag () const { return im; }
private:
  double re, im;

  friend complex& __doapl (complex *, const complex&);
  friend complex& __doami (complex *, const complex&);
  friend complex& __doaml (complex *, const complex&);
};


inline complex&
__doapl (complex* ths, const complex& r)
{
  ths->re += r.re;
  ths->im += r.im;
  return *ths;
}
 
inline complex&
complex::operator += (const complex& r)
{
  return __doapl (this, r);
}

inline complex&
__doami (complex* ths, const complex& r)
{
  ths->re -= r.re;
  ths->im -= r.im;
  return *ths;
}
 
inline complex&
complex::operator -= (const complex& r)
{
  return __doami (this, r);
}
 
inline complex&
__doaml (complex* ths, const complex& r)
{
  double f = ths->re * r.re - ths->im * r.im;
  ths->im = ths->re * r.im + ths->im * r.re;
  ths->re = f;
  return *ths;
}

inline complex&
complex::operator *= (const complex& r)
{
  return __doaml (this, r);
}
 
inline double
imag (const complex& x)
{
  return x.imag ();
}

inline double
real (const complex& x)
{
  return x.real ();
}

inline complex
operator + (const complex& x, const complex& y)
{
  return complex (real (x) + real (y), imag (x) + imag (y));
}

inline complex
operator + (const complex& x, double y)
{
  return complex (real (x) + y, imag (x));
}

inline complex
operator + (double x, const complex& y)
{
  return complex (x + real (y), imag (y));
}

inline complex
operator - (const complex& x, const complex& y)
{
  return complex (real (x) - real (y), imag (x) - imag (y));
}

inline complex
operator - (const complex& x, double y)
{
  return complex (real (x) - y, imag (x));
}

inline complex
operator - (double x, const complex& y)
{
  return complex (x - real (y), - imag (y));
}

inline complex
operator * (const complex& x, const complex& y)
{
  return complex (real (x) * real (y) - imag (x) * imag (y),
			   real (x) * imag (y) + imag (x) * real (y));
}

inline complex
operator * (const complex& x, double y)
{
  return complex (real (x) * y, imag (x) * y);
}

inline complex
operator * (double x, const complex& y)
{
  return complex (x * real (y), x * imag (y));
}

complex
operator / (const complex& x, double y)
{
  return complex (real (x) / y, imag (x) / y);
}

inline complex
operator + (const complex& x)
{
  return x;
}

inline complex
operator - (const complex& x)
{
  return complex (-real (x), -imag (x));
}

inline bool
operator == (const complex& x, const complex& y)
{
  return real (x) == real (y) && imag (x) == imag (y);
}

inline bool
operator == (const complex& x, double y)
{
  return real (x) == y && imag (x) == 0;
}

inline bool
operator == (double x, const complex& y)
{
  return x == real (y) && imag (y) == 0;
}

inline bool
operator != (const complex& x, const complex& y)
{
  return real (x) != real (y) || imag (x) != imag (y);
}

inline bool
operator != (const complex& x, double y)
{
  return real (x) != y || imag (x) != 0;
}

inline bool
operator != (double x, const complex& y)
{
  return x != real (y) || imag (y) != 0;
}

#include <cmath>

inline complex
polar (double r, double t)
{
  return complex (r * cos (t), r * sin (t));
}

inline complex
conj (const complex& x) 
{
  return complex (real (x), -imag (x));
}

inline double
norm (const complex& x)
{
  return real (x) * real (x) + imag (x) * imag (x);
}

#endif   //__MYCOMPLEX__
```

**complex_text.cpp:**

```cpp
#include <iostream>
#include "complex.h"

using namespace std;

ostream&
operator << (ostream& os, const complex& x)
{
  return os << '(' << real (x) << ',' << imag (x) << ')';
}

int main()
{
  complex c1(2, 1);
  complex c2(4, 0);

  cout << c1 << endl;
  cout << c2 << endl;
  
  cout << c1+c2 << endl;
  cout << c1-c2 << endl;
  cout << c1*c2 << endl;
  cout << c1 / 2 << endl;
  
  cout << conj(c1) << endl;
  cout << norm(c1) << endl;
  cout << polar(10,4) << endl;
  
  cout << (c1 += c2) << endl;
  
  cout << (c1 == c2) << endl;
  cout << (c1 != c2) << endl;
  cout << +c2 << endl;
  cout << -c2 << endl;
  
  cout << (c2 - 2) << endl;
  cout << (5 + c2) << endl;
  
  return 0;
}
```



## 二、Class with pointer member(s)       ——string类

该string类，内含指针，所以要自己写析构函数，不能使用默认析构函数。



### 6.三大构造函数：拷贝构造、拷贝赋值、析构

1）class with pointer members 必须有拷贝构造和拷贝赋值，否则就会**造成浅拷贝**。

<img src="C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1660807308673.png" alt="1660807308673" style="zoom:67%;" />



2）为了避免浅拷贝，所以要把指针所指的内容也要拷贝过来了，这叫**深拷贝。**

<img src="C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1660807672075.png" alt="1660807672075" style="zoom:67%;" />



3）拷贝赋值的经典**四步曲**

以`s1 = s2`为例(s1、s2是两个字符串)：

- 第一步：**检测自我赋值**。（否则有可能导致未定义情况）
- 第二步：清理掉s1的数据。
- 第三步：为s1分配一块与s2一样大的内存空间
- 第四步：将s2拷贝到s1中。

<img src="C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1660808396210.png" alt="1660808396210" style="zoom:67%;" />



### 7.堆、栈与内存管理

这部分内容建议看视频，视频比文字要来的清晰的多。这里只对截取一些概念、特征做一下说明。

**（一）Stack(栈)**

**概念：**是存在于某作用域 (scope) 的一块內存空间(memory space)。例如当你调用函数，函数本身即会形成一个stack 用來放置它所接收的参数，以及返回地址。
在函数本体 (function body) 內声明的任何变量，其所使用的內存块都取自上述 stack。



**（二）heap(堆)**

概念：或謂 system heap，是指由操作系統提供的一塊 global 內存空間，程序可動態分配 (dynamic allocated) 從某中獲得若干區塊 (blocks)。

<img src="C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1660816745000.png" alt="1660816745000" style="zoom:67%;" />



**（三）生命周期**

1）stack objects 的生命期

<img src="C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1660816822479.png" alt="1660816822479" style="zoom:67%;" />

2）static local objects 的生命期

<img src="C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1660816867178.png" alt="1660816867178" style="zoom:67%;" />

3）global objects 的生命期

<img src="C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1660816896628.png" alt="1660816896628" style="zoom:67%;" />



**（四）new 与 delete的工作流程（这里以string类为例，原视频中还讲了complex类）**

1）**new:**先分配内存，再调用构造函数

![1660817188031](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1660817188031.png)

2）**delete：**先调用析构函数，在释放内存

![1660817245615](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1660817245615.png)



**（五）动态分配所得的內存块(memory block), in VC**

这部分侯捷老师深入了编译底层进行了讲解，视频中侯捷老师提到：目前市面上的书籍资料都没有

如此详细的对内存块的剖析。所以如果想了解，请移步原视频观看。

<img src="C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1660817659311.png" alt="1660817659311" style="zoom: 80%;" />

<img src="C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1660817647918.png" alt="1660817647918" style="zoom: 67%;" />



### 8.String类的完整实现

VS编译器在这里可能会遇到一个问题：

```cpp
' strcpy': This function or variable may be unsafe. Consider using strcpy_s instead. To disable deprecation, use_CRT_SECURE_NO_WARNINGS. See online help for details.
```

这是在使用头文件#include<cstring>中的strcpy()和strcat()函数时出现了一个错误(ctime函数也会报这个错)

可能的原因：因为这些C库函数很多没有内部检查，微软担心这些函数可能造成栈溢出，所以改写了这些函数，并在原来的函数名字后加上_s以和C库函数区分。

**解决办法**：找到**项目属性**，点击**C/C++**里的**预处理器**，对预处理器进行编辑，在里面加入：`_CRT_SECURE_NO_WARNINGS`即可解决问题。

原代码如下：

**string.h**

```cpp
#pragma once
#include <cstring>
#include <iostream>
class String {
public:
	String(const char* cstr = 0);
	String(const String& str);
	String& operator=(const String& str);
	~String();
	char* get_c_str() const { return m_data; }
private:
	char* m_data;
};

inline
String::String(const char* cstr)
{
	if (cstr) {
		m_data = new char[strlen(cstr) + 1];
		strcpy(m_data, cstr);
	}
	else {
		m_data = new char[1];
		*m_data = '\0';
	}
}

inline
String::~String()
{
	delete[] m_data;
}

inline
String& String::operator= (const String& str)
{
	if (this == &str)
		return *this;

	delete[] m_data;
	m_data = new char[strlen(str.m_data) + 1];
	strcpy(m_data, str.m_data);
	return *this;
}

inline
String::String(const String& str)
{
	m_data = new char[strlen(str.m_data) + 1];
	strcpy(m_data, str.m_data);
}

std::ostream& operator << (std::ostream& os, const String& str)
{
	os << str.get_c_str();
	return os;
}
```

**string_text.cpp**

```cpp
#include "string.h"
#include <iostream>

using namespace std;

int main()
{
  String s1("hello"); 
  String s2("world");
    
  String s3(s2);
  cout << s3 << endl;
  
  s3 = s1;
  cout << s3 << endl;     
  cout << s2 << endl;  
  cout << s1 << endl;      
}
```



### 9.拓展补充：staic、类模板、函数模板及其他

**（一）static**

- 静态成员函数只能操作静态数据。
- 静态成员函数**没有this指针**。
- **静态数据一定要在类外进行定义**。
- 调用静态函数的方法有两种：（1）通过对象调用；（2）通过类名调用。

<img src="C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1660831559757.png" alt="1660831559757" style="zoom:67%;" />

除此之外，还需要知晓：**一个函数中static的东西，只有当该静态的东西被调用的时候，它才会被创建**，且离开该函数作用域后它依然存在。（下面的单例模式中，就用到了这一点。）



**（二）把构造函数放到private区域**

![1660832678796](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1660832678796.png)



（三）cout

**（四）class template类模板**

<img src="C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1660833376734.png" alt="1660833376734" style="zoom:67%;" />



**（五）函数模板**

<img src="C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1660833491830.png" alt="1660833491830" style="zoom:67%;" />





# Ⅱ：**Object Oriented（面向对象）：**面对的是多重classes的设计

即：**Object Oriented Programming, Object Oriented Design**（OOP，OOD）

面对对象编程中，牢固掌握以下”三把大刀“就足够应付绝大多数情况。

- **Inheritance (继承)**     ——  is - a
- **Composition (复合)**   ——  has-a
- **Delegation (委託)**



### 10.复合、委托与继承

**（一）Composition (复合)，表示has-a**

（1）Adapter(改造)：A类若复合B类，如果有需要，则A类可以使用B类中的东西进行改造。

<img src="C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1660884831536.png" alt="1660884831536" style="zoom:67%;" />

（2）一个复合类的大小 = 该类数据大小 + 该类中复合类的大小

<img src="C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1660884908485.png" alt="1660884908485" style="zoom:67%;" />

（3）Composition**复合关系下的构造和析构**

<img src="C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1660885205019.png" alt="1660885205019" style="zoom:67%;" />

（4）在**复合**中，类和其复合的类是**同时创建**的。



**（二）Delegation(委托)，或者称作：Composition by reference**

通俗的讲，委托就是我拜托/委托别的类，来帮助我实现一些东西。我只创建一个指针，指向我委托的那个类，让我的功能，都在我委托的那个类中实现。

委托其实和复合的功能很像，其实这就是对不同的实现分配到不同术语，你只需简单的记住，A类内含一个指针指向另一个类B(该类中实现了A的功能)就可以称作委托。

还有一点要注意，委托和复合他们中的类创建的时间不一样：在**复合**中，类和其复合的类是**同时创建**的；而在**委托**中，我委托的那个类创建的时间我不清楚，反正一定比A类晚，即**不同步创建**。

**Handle/Body（pimpl）**手法，其实就是一种委托，在Handle中创建一个指针作为接口指向另一个类Body，在Body中实现Handle的功能。

<img src="C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1660886889967.png" alt="1660886889967" style="zoom:67%;" />



**（三）Inheritance (继承), 表示is-a**

不同于其他语言，C++中的继承除了public继承外，还有private、protect继承，其中public最重要，用的最多。

**Inheritance继承关系下的构造和析构，**其实和复合关系下的构造和析构很像：

<img src="C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1660887730688.png" alt="1660887730688" style="zoom:67%;" />



### 11.最后：虚函数与多态、委托相关设计

这部分内容主要讲了一些设计模式的内容，即如何利用复合、委托、继承设计出一个良好的类。建议看一下原视频，这里就不再进行叙述。

- non-virtual 函数：你不希望derived class 重新定义(override, 覆写) 它.
- virtual 函数：你希望derived class 重新定义(override, 覆写) 它，且你對它已有默认定义。
- pure virtual 函数：你希望derived class 一定要重新定义(override 覆写) 
  它，你对它沒有默认定义。



