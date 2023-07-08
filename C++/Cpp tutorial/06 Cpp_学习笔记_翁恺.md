| mkdir cc      | 创建文件夹“cc”                                               |
| ------------- | ------------------------------------------------------------ |
| cd cc         | 进入文件夹cc                                                 |
| vi hello.cpp  | 打开hello.cpp, 若不存在则新建hello.cpp                       |
| ls -l         | 查看文件的**硬链接数**（硬链接——有多少种方式可以访问文件或者目录） |
| g++ hello.cpp |                                                              |
| ./a.out       |                                                              |



## 1.5 头文件

| 注意事项                                                     |
| :----------------------------------------------------------- |
| difinition   body（.cpp）                                    |
| declaration  prototypes（.h）                                |
| 如果在头文件中声明了一个函数，则必须在用到或定义此函数的地方include此头文件 |
| 如果在头文件中声明了一个类，则必须在用到或定义此类的地方include此头文件 |

#### 1.5.1 C++程序的结构

![image-20220121152434555](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\image-20220121152434555.png)

事例：在Linux终端进行下列操作

第一步：创建文件

<!--创建a.cpp-->

`vi a.cpp`

<!--a.cpp内容--> 

```c++
#include "a.h"

int main()
{
    return 0;
}
```

<!--创建a.h-->

`vi a.h`

<!--a.h内容-->

```c++
void f() ;    // 一个函数

int global;  // 全局变量global
```

第二部：运行

`cpp a.cpp //c preporcess 编译预处理指令  `

![image-20220121165552566](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\image-20220121165552566.png)

`g++ a.cpp --save-temps //用C++编译a.cpp文件并保留所有编译过程中的中间过程文件`

![image-20220121165823578](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\image-20220121165823578.png)

**<u>a.ii 是编译预处理之后的结果</u>**

![image-20220121165918025](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\image-20220121165918025.png)

**可知 “include”做的是“文本的插入”。**即C++编译器拿到的文件就是上图所示的，这个文件经过编译预处理指令把头文件“抄”进来了，然后才是.cpp的内容，这个合起来的大的文本（源代码）文件拿给C++编译器做编译。

注意，上述的a.h文件存在一个错误！

```c++
void f() ;    // 是声明

int global ; // 不是声明，是一个定义
```

假如现在有一个 b.cpp文件，他也想用a.h中所声明的东西

```c++
#include "a.h"

void f()
{
    
}
```

然后将a.cpp b.cpp组合成一个可执行文件 

```
g++ a.cpp b.cpp  // 将a.cpp b.cpp分别编译
```

![image-20220121153234258](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\image-20220121153234258.png)

或：

![image-20220121170316307](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\image-20220121170316307.png)

`小知识1：C++会将所有的名字前加上“_”`

有点难看懂，那么：

![image-20220121153701853](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\image-20220121153701853.png)

或：

![image-20220121170403185](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\image-20220121170403185.png)

 由编译顺序：`.cpp —编译预处理指令—>.ii—编译器—>.s—汇编器—>.o——>a.out`

可知在a.o b.o连起来再加上一些东西形成a.out时出错了,而这个事情就是ld（linker链接器）做的，ld发现a.o和b.o都有一个同名的global（如下图），这是不行的，而编译能通过是因为在编译时只针对一个源代码进行编译，称为编译单元。

![image-20220121154513312](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\image-20220121154513312.png)

![image-20220121154530880](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\image-20220121154530880.png)



修改错误的方法：

将a.h中的definition变为declaration：

```
void f()  ;

ertern int global ; // 
```

如果b.cpp修改为：

```c++
#include "a,h"

void f()
{
    global ++;
}
```

此时进行编译：

![image-20220121155332550](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\image-20220121155332550.png)

或：

![image-20220121170825833](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\image-20220121170825833.png)

错因：只声明了而没有定义！

修改b.cpp：

```
#include "a,h"
int global;
void f()
{
    global ++;
}
```

**因此，由declaration就要有相应的地方做definition**

再假如b.cpp：

```
#include "a,h"
//int global;
void f()
{
//    global ++;
}
```

即我们有一个global的declaration但没有地方用global会如何呢?

![image-20220121155830159](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\image-20220121155830159.png)

可以发现，没有问题。



#### 1.5.2 小总结（Declarations vs. Definitions，#include）

| Declarations vs. Definitions                                 |
| ------------------------------------------------------------ |
| 一个.cpp文件就是一个编译单元                                 |
| .h中只能存在声明，<br />声明包括：extern variables；function prototypes；class/struct declaration |

| #include                                                     |
| ------------------------------------------------------------ |
| #include is to insert the included file into the .cpp file at where the #include statement is. |
| # include "xx.h": first search in the current directory, then the directories declared somewhere |
| #include <xx.h>:search in the specified directories          |
| #include <xx>:same as #include <xx.h>                        |

**.h里放声明而不放定义是为了避免多个.cpp去include同一个.h时linker遇到了重复的定义的东西。**



#### 1.5.3 标准头文件结构：

```
方式一：
#ifndef HEADER_FLAG
#define HEADER_FLAG
// Type declaration here...
#endif // HEADER_FLAG
方式二：
#pragma once
```

**这是为了防止在一个.cpp里include同一个.h多次而出现那个.h里面类的声明被重复出现！**



1.5.4 关于头文件的Tips

| 1. 一个头文件里面只放一个类的声明                            |
| ------------------------------------------------------------ |
| 2.以相同的文件名前缀与一个源文件相关联。  （后缀改为.cpp，里面方函数的body） |
| 3.头文件要用标准头文件所包围起来。                           |



## 3.3 时钟的例子 

抽象abstract：抽象是忽略部分的细节，将注意力集中在问题的更高层次上的能力。  

模块化是将一个整体划分为定义良好的部分的过程，这些部分可以分别构建和检查，并以定义良好的方式相互作用。  

![image-20220122144058447](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\image-20220122144058447.png)

![image-20220122144127900](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\image-20220122144127900.png)

![image-20220122144945901](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\image-20220122144945901.png)

![image-20220122144954506](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\image-20220122144954506.png)

## 3.4 成员变量

局部(本地)变量是在方法内部定义的，其作用域仅限于它们所属的方法。  

成员变量和本地变量的辨析：

三个变量：字段（类的成员变量），参数，本地变量

参数，本地变量是“一样的”，都是本地储存属性，存放在堆栈里，但在堆栈里的位置有所不一样。

成员变量的访问属性是“类”，就意味着在这个类的所有的成员函数里面可以直接使用这些成员变量，也不需要知道它在哪里。

```
字段、参数、局部变量:  
这三种类型的变量都能够存储适合它们所定义的类型的值。  
字段是在构造函数和方法之外定义的。字段用于存储在对象的整个生命周期中持续存在的数据。 因此，它们维护对象的当前状态。 它们的寿命和它们的物品的寿命一样长  
字段具有类作用域:它们的可访问性扩展到整个类，因此它们可以在定义它们的类的任何构造函数或方法中使用。  
```



调用类中的函数

```
Point a;
a.print();
*被调用的函数和被调用的变量之间存在一种关系。  
*函数本身知道它对变量做了些什么。  
```

`this`:隐藏的参数

![image-20220122174903865](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\image-20220122174903865.png)

```
this:指向调用者的指针;  
在成员函数内部，可以使用它作为指向调用函数的变量的指针。  
这是所有不能定义但可以直接使用的类成员函数的自然局部变量。  
```



## 4.2 构造与析构

> - 构造函数不能被主动调用

#### 初始化方法：

> 1. 调用init()函数进行初始化

```c++

#include <iostream>
using namespace std;
 
class Point
{
public:
	void init(int x, int y);
	void print() const;
	void move(int dx, int dy);
private:
	int x;
	int y;
};
 
int main(int argc, const char* argv[])
{
	Point a;
	a.init(1, 2);
	a.move(2, 2);
	a.print();
}
```



> 2. 用构造函数保证初始化  
> If a class has a constructor, the compiler automatically calls that constructor at the point an object is created, before client programmers can get their hands on the object. 
> 如果一个类有一个构造函数，编译器会在创建对象的时候自动调用这个构造函数，在客户端程序员能够得到对象之前。  
> The name of the constructor is the same as the name of the class.
> 构造函数的名称与类的名称相同。  



#### 构造函数是怎么做的?

```c++
class X
{
private:
    int i;
public:
    X();      //构造函数，不能有任何返回值、参数，名称必须和类的名称完全一样（包括大小写）
}；
```

例：

```c++
#include <iostream>
using namespace std;
 
class X
{
private:
	int i;
public:
	X();
	void f();
};
 
X::X()
{
	i = 0;
	printf("X::X()-- this = %p\n", this);
}
 
void X::f()
{
	this->i = 20;
	printf("X::f() -- this = %p\n", this);
	printf("X::f() -- &i = %p\n", &i);
}
 
int main(int argc, const char* argv[])
{
	X x;
	x.f();
}
```

 我们能看到，一旦定义了类X的一个对象x，就会执行构造函数X::X()，程序的运行结果如下图所示：

![image-20220124213450634](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\image-20220124213450634.png)



#### 带参数的构造函数 ：

构造函数可以有参数来允许你指定如何创建一个对象，给它初始化值，等等。  

```c++
Tree(int i){...}
Tree t(12);
```

例：

```C++
#include <iostream>
using namespace std;
 
class Tree
{
private:
	int height;
public:
	Tree(int initialHeight);
	void print();
};
 
Tree::Tree(int initialHeight)
{
	height = initialHeight;
	cout << "inside Tree Constructor" << endl;
}
 
void Tree::print()
{
	cout << "The height is " << height << endl;
}
 
int main(int argc, const char* argv[])
{
	cout << "before opening brace" << endl;
	{
		Tree t(12);                            //构造函数被调用，且被传入参数的情况
		cout << "after Tree t creation" << endl;
		t.print();
	}
	cout << "after closing brace" << endl;
	return 0;
}
```

这样，我们可以很清楚地看到构造函数调用的时刻、构造函数带有参数时是如何被调用的：

```
输出：
before opening brace
inside Tree Constructor
after Tree t creation
The beight is 12
after closing brace
```



#### 析构函数 ：

> - 在c++中，清理和初始化一样重要，因此析构函数可以保证清理。  
> - 析构函数以类名命名，前面加一个波浪符号~。 析构函数从来没有任何实参。  

```c++
class Y
{
public:
    ~Y();          //析构函数没有类型、没有参数
};
```

例：

```c++
#include <iostream>
using namespace std;
 
class Tree                                             //类Tree的声明
{
private:
	int height;
public:
	Tree(int initialHeight);                           //构造函数的声明
	~Tree();                                           //析构函数的声明
	void print();
};
 
Tree::Tree(int initialHeight)                          //构造函数的定义
{
	height = initialHeight;
	cout << "inside Tree Constructor" << endl;
}
 
Tree::~Tree()                                          //析构函数的定义
{
	cout << "inside Tree Destructor" << endl;
	print();
}
 
void Tree::print()
{
	cout << "The height is " << height << endl;
}
 
int main(int argc, const char* argv[])
{
	cout << "before opening brace" << endl;
	{
		Tree t(12);
		cout << "after Tree t creation" << endl;
		t.print();
	}
	cout << "after closing brace" << endl;
	return 0;
}
```

```
before opening brace
inside Tree Constructor
after Tree t creation
The height is 12
inside Tree Destructor
The height is 12  // 析构函数里面调用了print()函数；
after closing brace
```

#### 什么时候调用析构函数?  

> - 当对象超出作用域时，编译器会自动调用析构函数  
> - 析构函数调用的唯一证据是对象周围作用域的右大括号。  



## 4.3 对象初始化

#### 存储分配  

> - 编译器在作用域的左花括号处为作用域分配所有的存储空间。  
> - 在定义对象的序列点之前，构造函数调用不会发生。  

例子:  

```c++
#include <iostream>
using namespace std;
 
class A
{
public:
	A();
	~A();
	void print();
};
 
A::A()
{
	printf("inside A Constructor\n");
}
 
A::~A()
{
	printf("inside A Destructor\n");
}
 
void A::print()
{
	printf("this = %p\n", this);
}
 
int main(int argc, const char* argv[])
{
	A a;
	printf("&a = %p\n", &a);
	A aa;
	printf("&aa = %p\n", &aa);
	return 0;
}
```

从下面的运行结果，可以看到，分配空间是在进入main()的大括号{}的时候就已经给对象a和aa分配了空间，但是对象a和aa的构造函数的调用是在之后才进行的：

```
inside A Constructor
&a = 0x7fff16e780b6
inside A Constructor
&aa = 0x7fff16e780b7
inside A Destructor
inside A Destructor
```

例：下面这种if-else/case语句，会使得跳过对象x1、x2和x3的构造函数，导致编译失败

```c++
#include <iostream>
using namespace std;
 
class X
{
private:
	int x;
};
 
void f(int i);
 
int main(int argc, const char* argv[])
{
	int i;
	scanf("%d", &i);
	f(i);
	return 0;
}
 
void f(int i)
{
	if (i < 10)
	{
		goto jump;
	}
	X x1;                               //Constructor called here
jump:
	switch (i)
	{
	case 1:
		X x2;                           //Constructor called here
		break;
	case 2:
		X x3;                           //Constructor called here
		break;
	}
}
```



#### 聚合初始化

```c++
int a[5] = { 1, 2, 3, 4, 5 };
int b[6] = { 5 };
int c[] = { 1, 2, 3, 4 };
// - sizeof(c) / sizeof(*c);
struct X { int i, float f; char c; };
// - X x1 = { 1, 2.2, 'c' };
X x2[3] = { {1, 1.1, 'a'}, {2, 2.2, 'b'} };
struct Y { float f; int i; Y(int a) };
Y y1[] = { Y(1), Y(2), Y(3) };         //对于对象，我们要调用构造函数才能生成对象
```

#### 默认构造函数  

> 默认构造函数可以不带参数调用。  

```C++
struct Y
{
    float f;
    int i;
    Y(int a);                      //有参数的构造函数，不是default constructor
}
 
Y y1[] = { Y(1), Y(2), Y(3) };
Y y2[2] = { Y(1) };                //错误
```

例：

```C++
#include <iostream>
using namespace std;
 
class X
{
private:
	int i;
public:
	X(int a);
};
 
X::X(int a)
{
	i = a;
}
 
int main(int argc, const char* argv[])
{
	X x(1);
	X x1[2] = { X(1) };
	return 0;
}
```

此时编译器会报错：“X”: 没有合适的默认构造函数可用，因为在x1[1]对象初始化时，没有调用X::X(int a);这样编译器会默认以为需要一个默认的构造函数X::X();来初始化这个对象x1[1]，然而编译器去查找却找不到这样的函数，就会报错。？？？



## 5.1 new&delete

#### 动态存储分配

>     ◆ new 
>         ★ new int;
>     
>         ★ new Stash;
>                                                         
>         ★ new int[10];
>     
>     new要做两件事情：① 分配空间；② 在分配完之后，如果分配的是一个类，那么会调用该类的构造函数来构造一个对象，new运算符的返回值就是地址
>     
>     ◆ delete
>     
>         ★ delete p;
>                                                         
>         ★ delete[] p;

####  new and delete

> - **new**是程序运行时分配内存的方法。 指针成为访问该内存的唯一途径。  
> - 当你用完内存后，**delete**可以让你把内存返回内存池。 

#### 动态数组

```C++
int* psome = new int[10];
```

> - new操作符返回块的第一个元素的地址。  

```C++
delete[] psome;
```

> - 括号的出现告诉程序，它应该释放整个数组，而不仅仅是元素  

  如果没有写“[]”，情况就是不一样的：空间还是会被回收，**但是析构只有第一个会被调用**

```C++
int* p = new int;
int* a = new int[10];
 
Student* q = new Student();
Student* r = new Student[10];
 
delete p;
a++; delete[] a;                    //a++;就会找不到之前分配的空间，报错
delete q;                           //知道指针q的类型，根据类型调用析构函数
delete r;                           //不带“[]”，没有告诉编译器有多个对象，只会调用r所  指的那个对象的析构函数一次，之后的9个就没管，但是空间全部被回收
delete[] r;                         //带“[]”，告诉编译器是数组有多个对象，调用10次析构函数，然后再回收空间
```

例：

```C++
#include <iostream>
using namespace std;
 
class A
{
private:	
	int i;
public:
	void f();
	void set(int i);
	A();
	~A();
};
 
void A::f()
{
	cout << "hello" << endl;
}
 
void A::set(int i)
{
	this->i = i;       //就近原则，成员变量i会被覆盖，使用this->i解决
}
 
A::A()
{
	i = 0;
	cout << "A::A()" << endl;
}
 
A::~A()
{
	cout << "A::~A(), i = " << i << endl;
}
 
int main(int argc, const char* argv[])
{
	A* p = new A[10];
	for (int i = 0; i < 10; i++)
	{
		p[i].set(i);
	}
	delete p;
	return 0;
}
```

 程序的运行结果说明，如果只写delete p; 那么析构函数A::~A(); 只被调用了一次：

![image-20220124224705635](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\image-20220124224705635.png)

 如果将程序改为：

```c++
#include <iostream>
using namespace std;
 
class A
{
private:	
	int i;
public:
	void f();
	void set(int i);
	A();
	~A();
};
 
void A::f()
{
	cout << "hello" << endl;
}
 
void A::set(int i)
{
	this->i = i;                           //就近原则，成员变量i会被覆盖，使用this->i解决
}
 
A::A()
{
	i = 0;
	cout << "A::A()" << endl;
}
 
A::~A()
{
	cout << "A::~A(), i = " << i << endl;
}
 
int main(int argc, const char* argv[])
{
	A* p = new A[10];
	for (int i = 0; i < 10; i++)
	{
		p[i].set(i);
	}
	delete[] p;
	return 0;
}
```

 我们可以看到，类A的析构函数A::~A(); 被调用了10次：

![image-20220124224833496](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\image-20220124224833496.png)



#### new和delete的提示  

> - 不要使用delete来释放new没有分配的内存  
> - 不要连续两次使用delete命令释放同一个内存块。  
> - 如果你使用new[]来分配数组，使用delete[]。  
> - 如果使用new来分配单个实体，请使用delete(无括号)。  
> - 对空指针执行delete操作是安全的(什么都不会发生)。  



#### delete空指针的应用：

```C++
#include <iostream>
using namespace std;
 
class A
{
private:
    int i;
    int* p;
public:
    A();
    ~A();
    void f();
};
 
A::A()
{
    p = 0;
}
 
A::~A()
{
    delete p;
}
 
void A::f()
{
    p = new int;
}
 
int main(int argc, const char* argv[])
{
    return 0;
}
```



## 5.2  C++基础之访问限制

#### 设置限制

> - 让客户端程序员的手远离他们不应该接触的成员。
> - 允许库设计者改变结构的内部工作方式，而不用担心这会对客户端程序员造成什么影响。

#### c++访问控制

> 类的成员可以被编目。标记为:
>
> ```c++
>   - public       //公开的  意味着所有的成员声明对每个人都是可用的
> 
>   - private      //只有类自己的成员函数可以访问 
> 
>   - protected    //只有类自己的成员函数或子类可以访问
> ```

例子：

```C++
#include <iostream>
using namespace std;
 
class A
{
private:
    int i;
public:
    void set(int i);
    void g(A* p);
};
 
void A::set(int i)
{
    this->i = i;
}
 
void A::g(A* p)
{
    cout << p->i << endl;
}
 
int main(int argc, const char* argv[])
{
    A a;
    A b;
    b.set(100);
    a.g(&b);
    return 0;
}
```

![image-20220130184409776](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\image-20220130184409776.png)

 这说明，private的限制仅仅在编译时刻，同一类的不同对象可以借助指针互相访问其私有的成员

####  Friends

> 显式授予非结构成员函数的访问权
>
> 类本身控制哪些代码可以访问它的成员。
>
> 可以将一个全局函数声明为友元，也可以将另一个类的成员函数声明为友元，甚至可以将整个类的成员函数声明为友元。

```c++
struct X;                      //前向声明
 
struct Y
{
    void f(X*);
};
 
struct X
{
private:
    int i;
public:
    void initialize();
    friend void g(X*, int);    //Global friend
    friend void Y::f(X*);      //Struct member friend
    friend struct Z;           //Entire struct is a friend
    friend void h();
};
 
void X::initialize()
{
    i = 0;
}
 
void g(X* x, int i)
{
    x->i = i;
}
 
void Y::f(X* x)
{
    x->i = 47;
}
 
struct Z
{
private:
    int j;
public:
    void ff(X*);
};
 
void Z::ff(X* x)
{
    x->i = 10;
}
```

  friend的授权也是在编译时刻检查的

####   class vs. struct

  ◆ **class** defaults to **private**

  ◆ **struct** defaults to **public**



## 5.3 C++基础之初始化列表

####  Initializer list

```C++
#include <iostream>
using namespace std;
 
class Point
{
private:
	const float x, y;
	Point(float xa = 0.0, float ya = 0.0) :y(ya), x(xa) {}
};
```

> - 可以初始化任何类型的数据
>
>   -伪构造函数调用内置函数
>
>   -不需要在构造函数的主体内执行赋值
>
> - 初始化的顺序就是声明的顺序
>
> ​       -不是列表中的顺序!
>
> ​       -按相反的顺序销毁。

#### Initialization vs. assignment (初始化和赋值)

```C++
Student::Student(string s): name(s) {}
```

初始化在构造函数之前

```C++
Student::Student(string s) {name = s;}
```

赋值

内部构造函数

string必须有一个默认构造函数

```c++
#include <iostream>
using namespace std;
 
class A
{
public:
	A(int i) {}
    //A() {} 加上这个默认构造函数则代码不出错
};
 
class B
{
public:
	A a;
	B() { a = 0; }  // a可以等于0看拷贝构造
};
```

  以上代码会报错：类 "A" 不存在默认构造函数。上例的错误揭示我们在初始化类的对象时，建议使用初始化列表，而不是在构造函数中进行赋值

#### *重点总结：

- **所有成员变量的初始化都应该在Initializer list里初始化，而不能放到构造函数里初始化。**
- **父类的初始化/构造函数调用也必须用Initializer list。**



## 6.1 C++基础之对象组成

组合：

> - 成员变量可以是另一个类的变量
> - 拿已有的对象拼装成另一个对象

两种方式：

> - Fully (那个别人的对象就是我这个对象的一部份) ——**成员变量就是对象本身,需要在Initializer list里做初始化**
> - By reference （那个别人的对象我知道它在哪里，我可以访问到它，我可以调用它的方法，但它不是我身体的一部份） ——**成员变量是一个指针**



For example, an Employee has a
 -Name

- Address 
- Health Plan
- Salary History 

- Collection of Raise objects

-Supervisor 

- Another Employee object!

```c++
class Employee
{
private:
    int num;
    Employee* supervisor;
};
```

```c++
#include <iostream>
using namespace std;
 
class Person
{
private:
    char* name;
    char* address;
public:
    Person(const char* name, const char* address);
    ~Person();
    void print();
};
 
class Currency
{
private:
    int cents;
public:
    Currency(int, int cents);
    ~Currency();
    void print();
};
 
class SavingsAccount   //创建SavingsAccount的对象时里面会创建两个对象
{
public:
    SavingsAccount(const char* name, const char* address, int cents);
    ~SavingsAccount();
    void print();
private:
    Person m_saver;
    Currency m_balance;
};
 
Person::Person(const char* name, const char* address):name((char*)name),address((char*)address)
{
 
}
 
Currency::Currency(int a, int cents) : cents(cents)
{
 
}
 
SavingsAccount::SavingsAccount(const char* name, const char* address, int cents) : m_saver(name, address), m_balance(0, cents)
{
 
}
 
void Person::print()
{
 
}
 
void Currency::print()
{
 
}
 
void SavingsAccount::print()
{
    m_saver.print();
    m_balance.print();
}
 
Person::~Person()
{
 
}
 
Currency::~Currency()
{
 
}
 
SavingsAccount::~SavingsAccount()
{
 
}
 ‘
int main(int argc, const char* argv[])
{
    SavingsAccount myaccount;
    return 0;
}
```

上述代码中可知   类SavingAccount中的成员变量 ： `Person m_saver;` `Currency m_balance;`  是两个对象且没有*号故不是指针，则是Fully类型。



## 6.2 继承

- 拿已有的类做点改造，成为一个类。

> 注意与组合的区别
>
> - 拿已有的对象拼装成另一个对象 （组合）
> - 对象：是实体  类：是概念

特点：

> 可以共享设计中的：
>
> - Member date （一般都是private）
> - Member functions (其中可以有public也可以有private)
> - **Interfaces**  （Member functions 中的public部分构成了Interfaces）

语法：

```c++
class A {....};

class B : public A {....}; //B是A的子类
```

![image-20220206155725770](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\image-20220206155725770.png)



```C++
#include <iostream>
using namespace std;
 
class A
{
public:
	A(): i(0)
	{
		cout << "A::A()" << endl;
	}
	~A()
	{
		cout << "A::~A()" << endl;
	}
	void print()
	{
		cout << i << endl;
	}
	void set(int ii)
	{
		i = ii;
	}
private:
	int i;
};
 
class B :public A
{
public:
    void f()
    {
        set(20);
        print();
    }
};
 
int main(int argc, const char* argv[])
{
	B b;
	b.set(10);
	b.print();
    b.f();
	return 0;
}
```

>   运行结果如下，说明类B的对象b生成了，而且其成员函数B::f();成功调用了其继承的类A的函数A::set();和A::print();

![image-20220206160654952](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\image-20220206160654952.png)

> 如果我们尝试利用类B的对象b直接修改其继承的类A的成员变量i，如下代码所示：
>
> ```cpp
> #include <iostream>
> using namespace std;
>  
> class A
> {
> public:
> 	A() : i(0)
> 	{
> 		cout << "A::A()" << endl;
> 	}
> 	~A()
> 	{
> 		cout << "A::~A()" << endl;
> 	}
> 	void print()
> 	{
> 		cout << i << endl;
> 	}
> 	void set(int ii)
> 	{
> 		i = ii;
> 	}
> private:
> 	int i;
> };
>  
> class B :public A
> {
> public:
> 	void f()
> 	{
> 		set(20);
> 		i = 30;
> 		print();
> 	}
> };
>  
> int main(int argc, const char* argv[])
> {
> 	B b;
> 	b.set(10);
> 	b.print();
> 	b.f();
> 	return 0;
> }
> ```

>   那么编译器就会报错，因为**成员变量i是private类型**，而类B是继承自类A，所以类B的实例化对象b不可直接去访问类A中的成员变量
>
>   如果我们将类A中的成员函数修改为protected时，局面就会发生变化：

```c++
#include <iostream>
using namespace std;
 
class A
{
public:
	A() : i(0)
	{
		cout << "A::A()" << endl;
	}
	~A()
	{
		cout << "A::~A()" << endl;
	}
	void print()
	{
		cout << i << endl;
	}
protected:
	void set(int ii)
	{
		i = ii;
	}
private:
	int i;
};
 
class B :public A
{
public:
	void f()
	{
		set(20);
		print();
	}
};
 
int main(int argc, const char* argv[])
{
	B b;
	b.print();
	b.f();
	return 0;
}
```



## 6.3 子类父类关系

> - 当构造一个子类时，其父类的构造函数会被调用
> - 父类的初始化/构造函数调用必须用Initializer list。其参数顺序是声明的顺序。

声明一个Employee class

```c++
#include<iostream>
using namespace std;
class Employee
{
public:
	Employee(const std::string& name, const std::string& ssn);
	const std::string& get_name() const;
	void print(std::ostream& out) const;
	void print(std::ostream& out, const std::string& msg) const;
protected:
	std::string m_name;
	std::string m_ssn;
};
```

Employee的构造函数

```C++
Employee::Employee(const string& name, const std::string& ssn)
	:m_name(name), m_ssn(ssn)
{
	//初始化列表设置值!
}
```

**Employee** 成员函数

```c++
inline const std::string& Employee::get_name() const
{
	return m_name;
}
 
inline void Employee::print(std::ostream& out) const
{
	out << m_name << endl;
	out << m_ssn << endl;
}
 
inline void Employee::print(std::ostream& out, const std::string& msg) const
{
	out << msg << endl;
	print(out);
}
```

现在添加一个Manager

```C++
class Manager :public Employee
{
public:
	Manager(const std::string& name, const std::string& ssn, const std::string& title);
	const std::string title_name() const;
	const std::string& get_title() const;
	void print(std::ostream& out) const;
private:
	std::string m_title;
};
```

继承和构造函数

> - 将继承的特征看作是嵌入的对象
> - 基类通过类名来提到

```C++
Manager::Manager(const std::string& name, const std::string& ssn, const std::string& title):Employee(name, ssn), m_title(title)
{
    //此处Manager的构造函数，需要使用到其父类的构造函数Employee()
}
```

 我们还可以再看一个更简单点的例子：

```C++
class A
{
public:
	A(int ii) :i(ii) { cout << "A::A()" << endl; }
	~A() { cout << "A::~A()" << endl; }
	void print() { cout << "A::f()" << endl; }
	void set(int ii) { i = ii; }
private:
	int i;
};
 
class B :public A
{
public:
	B() : A(15) { cout << "B::B()" << endl; }
	~B() { cout << "B::~B()" << endl; }
	void f()
	{
		set(20);
		print();
	}
};
 
int main(int argc, const char* argv[])
{
	B b;
}
```

-  **运行结果可以看出，在构建类B的一个对象b时，先调用了其父类A的构造函数，然后再调用了B的构造函数，在析构时是反过来的：先调用B的析构函数，再调用A的析构函数。**

![image-20220206195444266](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\image-20220206195444266.png)

> 在构造函数
>
> - 基类总是首先构造的
>
> - 如果没有明确的参数传递给基类
>
>   -默认构造函数将被调用
>
> - 析构函数的调用顺序正好与构造函数的调用顺序相反

Manager成员函数

```C++
Manager::Manager(const std::string& name, const std::string& ssn, const std::string& title):Employee(name, ssn), m_title(title)
{
 
}
 
inline void Manager::print(std::ostream& out) const
{
	Employee::print(out);                       //call the base class print
	out << m_title << endl;
}
 
inline const std::string& Manager::get_title() const
{
	return m_title;
}
 
inline const std::string Manager::title_name() const
{
	return string(m_title + ":" + m_name);      //access base m_name
}
```

 **Uses**

```C++
int main(int argc, const char* argv[])
{
	Employee bob("Bob Jones", "555-44-0000");
	Manager bill("Bill Smith", "666-55-1234", "Important Person");
	string name = bill.get_name();             //okay Manager inherits Employee
	//string title = bob.get_title();          //Error -- bob is an Employee!
	cout << bill.title_name() << '\n' << endl;
	bill.print(cout);
	bob.print(cout);
	bob.print(cout, "Employee:");
	//bill.print(cout, "Employee:");           //Error hidden!
}
```

  我们可以很惊奇的发现，main()中最后一行注释的函数是错误的，这涉及到C++的一个特殊特征：**名字隐藏**，我们再来举一个简单点的例子来运行说明：

```C++
class A
{
public:
	A();
	~A();
	void print();
	void print(int i);
};
 
A::A()
{
	cout << "A::A()" << endl;
}
 
A::~A()
{
	cout << "A::~A()" << endl;
}
 
void A::print(int i)
{
	cout << i << endl;
	A::print();
 }
 
void A::print()
{
	cout << "A::print()" << endl;
}
 
class B :public A
{
public:
	B();
	~B();
	void print();
};
 
B::B()
{
	cout << "B::B()" << endl;
}
 
B::~B()
{
	cout << "B::~B()" << endl;
}
 
void B::print()
{
	cout << "B::print()" << endl;
}
 
int main(int agrc, const char* argv[])
{
	B b;
	b.print();
}
```

运行结果可以看出，B类的B::print();和A类的两个A::print();A::print(int i);是没有关系的，如果有关系的话那就乱套了~只是碰巧同名而已

![image-20220206195738357](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\image-20220206195738357.png)

 如果对象b想要调用其父类A的A::print(int i);那么就要使用如下的代码：

```C++
b.A::print();
```



## 7-1 函数重载和默认参数

#### overload

- 相同的函数，不同的参数列表。
- 返回类型不能构成overload的条件

```C++
void print(char* str, int width);       //#1
void print(double d, int width);        //#2
void print(long l, int width);          //#3
void print(int i, int width);           //#4
void print(char* str);                  //#5
 
print("Pancakes", 15);
print("Syrup");
print(1999.0, 10);
print(1999, 12);
print(1999L, 15);
```

#### 默认参数

```c++
Stash(int size, int initQuantity = 0);
```

> 默认实参是在声明中给出的值，如果你在函数调用中不提供值，编译器会自动插入这个值。
>
> - 默认参数只能放到 **.h**文件中。
> - 要定义带有参数列表的函数，必须从右到左添加默认值。
> -  Default value是一种不安全的手段

```C++
int harpo(int n, int m = 4, int j = 5);
int chico(int n, int m = 6, int j);            //不合法
int groucho(int k = 1, int m = 2, int n = 3);
 
beeps = harpo(2);
beeps = harpo(1, 8);
beeps = harpo(8, 7, 6);
```



## 7.2 内联函数

```C++
inline int plusOne(int x);
inline int plusOne(int x) { return ++x; };
```

- 内联函数是在适当的位置展开的，就像预处理器宏一样，因此**消除了函数调用的开销**。
- 在**声明**（.h）和**定义**（.cpp）处**重复inline关键字**。
- 内联函数定义不能在.obj文件中生成任何代码。

如果我们将f()函数在前方加上inline来声明其为内联函数：

```C++
inline int f(int i)
{
    return i*2;
}
main()
{
    int a = 2;
    int b = f(a);
}
```

那么最终编译器生成的汇编代码会和如下段代码生成的汇编代码相同：

```C++
main()
{
    int a = 4;
    int b = a + a;
}
```



#### 头文件中的内联函数

- 所以你可以把内联函数的**主体**放在**头文件中**。然后在**需要函数**的地方**#include它**。
- 不要害怕内联函数的多重定义，因为它们根本没有函数体。
- 内联函数的定义**只是声明**



#### 内联函数的权衡

- 被调用函数的主体将被插入调用者中，
- 这可能会扩大代码大小，
- 但是减去了调用时间的开销。
- 所以它以空间为代价获得速度(时间)。
- 在大多数情况下，它是值得的。
- 它比C中的宏好得多。它检查参数的类型。

宏也可以做类似的事情，但是inline函数却比宏**更加安全**，因为内联函数在编译器中要做**类型检查**



#### 内联可能不内联

> 编译器不一定要满足你的请求才能使函数内联。它可能会认为函数太大，或者注意到它调用了自己(不允许递归，或者内联函数确实可能使用递归)，或者该特性可能没有为特定的编译器实现。

####   Inline inside classes

- 在类声明中定义的任何函数都自动成为内联函数。

  ——成员函数如果在class的声明时就给出函数的**body**，则此成员函数就是inline函数

- 例如：

  ```C++
  #include <string>
  using namespace std;
   
  class Point
  {
      int i, j, k;
  public:
      Point() { i = j = k = 0; }   // 内联函数
      Point(int ii, int jj, int kk) { i = ii, j = jj, k = kk; }   // 内联函数
  };
   
  int main()
  {
      Point p, q(1, 2, 3);
  }
  ```

  #### 存取函数

  > - 它们是一些小函数，允许您读取或更改对象的部分状态—即一个或多个内部变量。
  >
  >   ```C++
  >   class Cup
  >   {
  >       int color;
  >   public:
  >       int getColor()
  >       {
  >           return color;
  >       }
  >       void setColor(int color)
  >       {
  >           this->color = color;
  >       }
  >   };
  >   ```



#### inline的减少零乱方法

- 类内部定义的成员函数使用拉丁语原位(in situ)，并维护所有定义都应该放在类外部，以保持接口整洁。

  ```C++
  #include <string>
  using namespace std;
   
  class Rectangle
  {
  	int width, height;
  public:
  	Rectangle(int w = 0, int h = 0);
  	int getWidth() const;
  	void setWidth(int w);
  	int getHeight() const;
  	void setHeight(int h);
  };
   
  inline Rectangle::Rectangle(int w, int h): width(w),height(h)
  {
   // 把对应的函数的body放到了头文件的class的后面，本来应该放到对应的.cpp文件里。
  }
   
  inline int Rectangle::getWidth() const
  {
  	return width;
  }
  ```

  

####  Inline or not?

-  Inline:
  - 小函数，2到3行
  - 经常调用的函数，例如内部循环
-  Not inline?
  - 非常大的函数，超过20行
  - 递归函数



## 7.3 Const

- 声明一个变量具有一个常数值

  ```C++
  const int x = 123;
  x =27; // illegal!
  x++; // illegal!
  int y=x; // 0k, copy const to non-const 
  y=x; // 0k, same thing 
  const int z=y; // ok, const is safer
  ```

  

#### Constants 

- Constants 是变量
  - 遵守范围划分规则
  - 用“const”类型修饰符声明



## 编译时Constants(常量)

```C++
const int bufsize = 1024;  // 编译时刻知道值的const
```

- 值必须初始化
- 除非你显式地声明extern:
  - extern  全局变量的声明而不是定义。

```C++
extern const int bufsize;
```

- 编译器不会让你改变它
- 编译时常量是编译器符号表中的符号表，而不是变量。



#### 程序运行期 constants

- Const值可以被利用

  ```C++
  const int class_size =12; 
  int finalGrade[class_size]; // ok 
  ---------------------------
  int x; 
  cin >>x; 
  int size =x; 
  double classAverage [size]; // error! 不知道size是多少
  ```



#### Pointers and const 

- 指针所指的对象是const是说，**不能通过指针去修改那个所指的对象**，但并不意味着那个对象就变成了const.

![image-20220208232917029](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\image-20220208232917029.png)

```C++
char * const q="abc"; // q is const
*q='c'; // OK  指针所指向的那个内存不是const
q++;// ERROR ！ q is const， 不可修改！

const char *p = "ABCD"; // (*p) is a const char，即 p所指的那个内存是const
*p='b';  // ERROR! (*p) is the const
p++； // OK，但*p原来所指的下一个单元变成了const.
```

> 问： 下列那个是const？
>
> ```C++
> Person p1( "Fred", 200 );
> const Person* p= &p1;  // 对象是const
> Person const* p=&p1;   // 对象是const
> Person *const p =&p1;  // 指针是const
> const Person* const p = &p1 // 对象和指针都是const
> ```
>
> 区别的标记： 写在“ * ” 前**对象**是const, 写在“ * ”后面，指针是const.

例如：有

```c++
int i;  
const int ci = 3;
int *ip;
const int *cip;
```

作如下操作判断正误：

```C++
ip = &i; // 取非const变量i的地址交给非const的指针ip,没问题。
cip = &i;// 取非const变量i的地址交给指向const的int的指针，没问题。还可以继续改i的值，任何时候都可以做左值，但任何时候都不能说*cip等于某个值，cip都不能做左值，不能被修改。
ip = &ci; // 不合法！ci是个const,因为ip所指的那个对象可以做修改，但此时ci是个const。
cip = &ci; // 合法！ci是个const不可修改，cip也是个const，他所指的那个对象也不可修改。
```

Remember:

```C++
*ip = 54; //总是合法的，因为iP指向int
*cip = 54 //这是不合法的，因为cip指向const int  "但任何时候都不能说*cip等于某个值"
```



#### 字符串常量

例如：有如下代码

```C++
#include <iostream>
using namespace std;

int main(){
    char *s = "hello world"; //编译出现warning是因为系统不知道你后面会不会对s进行修改
    cout << s << endl;
    s[0] = 'B'; //编译这里是不知道s所指的地方是不是一个const，所以骗过了编译器
    cout << s << endl;
    return 0;
}
```

编译出现warning如下：

> ![image-20220212213114327](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\image-20220212213114327.png)

```C++
warning: deprecated conversion from string constant to 'char*' //警告:不赞成从字符串常量到'char*'的转换
```

如果运行，则会出现:

```C++
hello world

Bus error:10 // 异常终止
```

正确做法：

```C++
 const char *s = "hello world"; // 加个const，warning消失,运行到s[0] = 'B';时会出错
```

![image-20220212214314014](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\image-20220212214314014.png)

再假如，情况会如何?

```C++
#include <iostream>
using namespace std;

int main(){
    //char *s = "hello world"; 
    char s[] = "hello world"; 
    cout << s << endl;
    s[0] = 'B'; 
    cout << s << endl;
    return 0;
}
```

![image-20220212214557276](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\image-20220212214557276.png)

> 编译，运行都没有任何问题。

这两种写法的**区别**？

```C++
    char *s = "hello world";  // s在代码段里
    char s[] = "hello world"; // s是个数组，在堆栈里
```



#### 转换

是否可以始终将非const值视为const？

```c++
void f(const int* x); //给f任何int的变量都可，无论是不是const, 调用f："你传给我的是个指针，但我不会对你的那个东西做任何修改"
int a = 15;
f(&a); // ok
const int b = a;

f (&b); ok
b = a + 1; //error!
```

#### 传递const值

```C++
void f1(const int i){  
	i++; // 不合法！编译时错误，在f1里不能修改i
}
```

#### 返回const

- ```C++
  int f3() ( return 1; )
  const int f4() { return 1;}
  int main () {
  	const int j = f3(); //工作正常
      int k = f4 ();// 但这也很好!
  }
  ```

#### 传递和返回地址

- 传递整个对象可能会花费您很多。最好是传递一个指针。但是程序员可以获取它并修改原始值。
- 事实上，无论什么时候你把地址传递给函数，如果可能的话，你应该把它变成const。



## 不可修改对象

#### 常量对象

- 如果对象是const呢?

```C++
const Currency the_raise(42,38); // 对象里的值不可修改
```

- 哪些成员可以访问内部结构?
- 如何保护对象不受更改影响? 



#### const成员函数

![image-20220212221332003](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\image-20220212221332003.png)

#### Const成员函数用法

- 在定义和声明中重复const关键字

  ```C++
  int get_day() const;
  int get_day() const { return day};
  ```

- 不修改数据的函数成员应该声明为const

- Const成员函数对于Const对象是安全的

- **const放在函数后面**可以和**非const**的那个函数**构成重载**关系！

  例如：（const重载）

  ```C++
  #include <iostream>
  using namespace std;
  
  class A {
      int i;
  public:
      A() : i(0) {} //初始化i，因为main函数中创造了const对象a，a里面的值不可修改，就需要给i一个初始值。
      void f() { cout << "f()" << endl;}
      void f() const {cout << "f() const" <<endl;}
  };
  
  int main() {
      const A a;
      a.f();
      return
  }
  ```

  运行结果：

  ```
  f() const 
  ```

  原因：**f() 函数构成了重载**，上述f()函数的参数列表相当于

  ```C++
  void f(A* this) { cout << "f()" << endl;}
  void f(const A* this) const {cout << "f() const" <<endl;}
  ```

  函数名相同，参数列表不同，构成了重载！



#### 成员变量是const

- **必须在构造函数的初始化列表中初始化** (例1)

- **则不能用此成员变量做数组的size** （例2）

  - 解决办法 1. 成员变量前面加个staic;  2. 枚举

  例1：

  ```C++
  #include <iostream>
  using namespace std;
  
  class A {
      int i;
  public:
      A() {}
      void f() { cout << "f()" << endl;}
      void f() const {cout << "f() const" <<endl;}
  };
  
  int main() {
      A a;  //非const，不对i初始化也是可以的
      a.f();
      return
  }
  ```

  但如果，**成员变量是const**

  ```C++
  #include <iostream>
  using namespace std;
  
  class A {
      const int i; //成员变量是const
  public:
      A() {}
      void f() { cout << "f()" << endl;}
      void f() const {cout << "f() const" <<endl;}
  };
  
  int main() {
      A a;  
      a.f();
      return
  }
  ```

  则编译会出现：A的i没有被初始化

  ![image-20220213192202817](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\image-20220213192202817.png)

  

  **解决办法**：初始化i

  ```C++
  #include <iostream>
  using namespace std;
  
  class A {
      const int i; //成员变量是const
  public:
      A():i(0) {} // 初始化i
      void f() { cout << "f()" << endl;}
      void f() const {cout << "f() const" <<endl;}
  };
  
  int main() {
      A a;  
      a.f();
      return
  }
  ```

  例2：

  ```C++
  class HasArray {
      const int size;
      int array[size]; //错误！则不能用const成员变量做数组的size
      ......
  };
  ```

  解决方法1：将const值设为静态

  ```C++
  — staic const int size = 100; //将const值设为静态,Static表示每个类只有一个(而不是每个对象一个)
  ```

  解决方法2：使用“匿名枚举”hack

  ```C++
  class HasArray {
      enum { size = 100};
      int array[size]; // OK!
      ......
  };
  ```



## 引用（References）

#### 声明引用

- 引用是c++中的一种新数据类型

  ```C++
  -char C; // 一个字符 
  -char* p = &C; //指向字符的指针
  -char& r= C; // 对字符的引用， 此时r就相当于C，“一个东西两个名字”
  ```

- 局部或全局变量

  - `type& refname = name; `
  - 对于普通变量，需要初始值

- 在参数列表和成员变量中

  - `type& refname ` // 不需要初始值
  - 由调用者或构造函数定义的绑定

#### 引用的两层理解

- 为现有对象声明一个新名称

  ```C++
  int X= 47;
  int& Y= X; // Y是对X的引用
  // X和Y现在指向同一个变量
  cout << "Y="<< y; // prints Y= 47
  Y = 18; 
  cout << "X= " << x; //prints X = 18
  ```

  Y就是X的另一个名字，出现Y的地方都可以把它替换成X来理解。
  
- reference是一种const指针



#### 引用的规则

- 引用必须在**定义时初始化**

- 初始化建立绑定

  —在声明

  ```c++
  int x =3;
  int& y =x;
  const int& z = x; //z是对x的引用，不能通过z修改x，但x本身是可以改变。
  ```

  —作为函数参数

  ```C++
  void f(int& x); //意味着在f函数里对x做任何的修改，外面的y就变了。 
  f(y); // 函数调用时初始化
  ```

- 与指针不同，绑定在运行时不会更改

- 赋值会改变被引用的对象

  ```C++
  int& y= x; 
  y = 12; //改变x的值
  ```

- 引用的目标必须有一个位置!

  ```C++
  void func (int &); 
  func (i * 3); // Warning or error! "i*3"没有一个位置放。
  ```

例子

```C++
#include <iostream>

int* f(int* x){
    (*x)++;
    return x; //安全，x不在此范围内
}

int& g(int& x){ // 传入x的reference,返回一个int的reference
    x++; //和f()的效果一样,比较清爽
    return x;//安全，不在此范围内
}

// int g(int x){}  //不行！main函数中调用g函数时不知道调用哪个。reference不能overloaded

int x; // 全局变量x

int& h(){ // 一个函数的返回结果是reference，可以做左值。把x变量作为reference返回
    int q; //本地变量
  //! return q; //error! q是本地变量
    return x;  //安全，x在这个范围之外
}

int main(){
    int a = 0 ；
	f(&a); // Ugly（但是明确） x = 1
    g(a);  // Clean(但是不明确，不清楚g里面发生了什么 ) x = 2
    h() = 16; //h函数的返回结果是reference，可以做左值。相当于此时x = 16；直接把16赋值给x的reference
}
```

| Pointers vs. References |
| :---------------------: |

|                 References                 |             Pointers             |
| :----------------------------------------: | :------------------------------: |
|                   不能空                   |           可以设置为空           |
| 依赖于一个现有的变量，它们是一个变量的别名 |       指针独立于现有的对象       |
|      引用不能更改到一个新的“地址”位置      | 指针可以更改为指向不同地址的指针 |



#### 限制条件

- 没有references的references

- 没有指向references的指针

  - ```C++
    int& *p;    // 不合法！
    ```

  - references的指针是可以的

    ```C++
    void f(int* &p);  //可以！
    ```

- 没有引用数组

  - 因为references不是一个实体。



## 向上造型（Upcasting）

> - Upcasting是将派生引用或指针转换为基类引用或指针的行为。
>
> - 子类的对象可以被当作父类对象来看待

- 公共继承应该包含替换
  - If B isa A, 你可以在任何可以使用A的地方使用B。
  - if B isa A, 那么对A成立的一切对B也成立。
  - 如果替换无效，请小心!

![image-20220224133305976](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\image-20220224133305976.png)

例子:

```C++
Manager pete("Pete","444-55-6666","Bakery");
Employee* ep = &pete; //Upcast
Employee& er = pete;  //Upcast
```

- 丢失对象的类型信息:

  `ep -> print(cout); //打印基类版本`



## 多态性（Polymorphism）

![image-20220224142039630](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\image-20220224142039630.png)

![image-20220224142111369](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\image-20220224142111369.png)

代码:

- 定义shape的一般属性

```C++
class XYPos{...}; //x,y 坐标点
class Shape {
public:
	Shape(); //构造函数
    virtual ~Shape(); // 析构函数
    virtual void render();//virtual 让子类和父类同名的函数产生联系
    void move(const XYPos&);
    virtual void resize();
protected:
    XYPos center;
};
```

- 添加一个新shapes

```C++
class Ellipse : public Shape{
public:
    Ellipse(float mai, float minr);
    virtual void render(); //这里的virtual可加可不加，因为父类shape的函数前已经是virtual了，但最好加上，这样就不用回头看父类了。
    float major_axis, minor_axis;
};

class Circle : public Ellipse{
public:
    Circle(float radius) : Ellipse(radius, radius){}
    virtual void render();
};
```

```C++
void render(Shape* p){
    p->render(); //为给定的shape调用正确的render函数! 这里p是多态的
}
void func(){
    Ellipse ell(10, 20);
    ell.render();
    Circle circ(40);
    circ.render();
    render(&ell); //向上造型！把子类Ellipse的对象当做shape的对象看待，然后在render函数里让这个指针所指的那个对象去做render的事情，是谁render了？shape还是Ellipse?是Ellipse，因为这个函数是virtual，告诉编译器通过指针或者引用去调这个函数时不能直接在这里写进来掉哪个函数，要在运行时才能确定。
    render(&circ); //可知，这里调用Circle的render
}
```

#### 多态性的认识

- upcast:将派生类的对象作为基类的对象。

  —Ellipse可以被视为一个shape

- 动态绑定：

  —绑定：调用哪个函数 （当我调用一个函数的时候，该调用哪个函数？）

  - 静态绑定:调用函数作为代码 （我调用的函数是确定的，编译的时候就知道的。）
  - 动态绑定:调用对象的函数（调用时，运行的时候才知道到底要调用哪个函数，根据我那个指针所指向的对象来决定。）



## 多态性的实现

#### virtual在c++中是如何工作的

![image-20220224152505312](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\image-20220224152505312.png)

- 任何一个类如果有虚函数，这个类的对象都会比正常的要大一些。

  ```c++
  #include <iostream>
  using namespace std;
  
  class A {
  public:
      	A() : i(10){}
          virtual void f(){cout << "A::f()" << i << endl;}
          int i;
  };
  
  int main{
      A a ;
      a.f();
      cout << sizeof(a) << endl;
      int *p = (int*)&a;
      cout << *p <<endl;
      return 0;
  }
  ```

  ![image-20220224152140877](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\image-20220224152140877.png)

  

- 做一下 p++

  ```C++
  #include <iostream>
  using namespace std;
  
  class A {
  public:
      	A() : i(10){}
          virtual void f(){cout << "A::f()" << i << endl;}
          int i;
  };
  
  int main{
      A a ;
      a.f();
      cout << sizeof(a) << endl;
      int *p = (int*)&a;
      p++;
      cout << *p <<endl;
      return 0;
  }
  ```

  ![image-20220224152317846](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\image-20220224152317846.png)

- 再添加一个对象

  ```C++
  #include <iostream>
  using namespace std;
  
  class A {
  public:
      	A() : i(10){}
          virtual void f(){cout << "A::f()" << i << endl;}
          int i;
  };
  
  int main{
      A a，b;
      a.f();
      cout << sizeof(a) << endl;
      int *p = (int*)&a;
      int *q = (int*)&b;
      cout << *p <<endl << *q << endl;
      return 0;
  }
  ```

  ![image-20220224152733496](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\image-20220224152733496.png)

> - *p 和  *q是一样的

- 再添加一点

  ```C++
  #include <iostream>
  using namespace std;
  
  class A {
  public:
      	A() : i(10){}
          virtual void f(){cout << "A::f()" << i << endl;}
          int i;
  };
  
  int main{
      A a，b;
      a.f();
      cout << sizeof(a) << endl;
      int *p = (int*)&a;
      int *q = (int*)&b;
      int *x = (int*)*p;
      cout << x << endl;
      cout << *p <<endl << *q << endl;
      return 0;
  }
  ```

  ![image-20220224153102019](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\image-20220224153102019.png)

![image-20220224153157437](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\image-20220224153157437.png)

![image-20220224153434605](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\image-20220224153434605.png)

![image-20220224153536172](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\image-20220224153536172.png)

![image-20220224154428320](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\image-20220224154428320.png)

- 切出circ的面积

  - 只有符合elly的circ部分被复制

- 来自circ的Vtable被忽略;elly中的虚函数表是椭圆虚函数表

  `elly. render(); //Ellipse: : render ()`

![image-20220224154651225](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\image-20220224154651225.png)

  

#### 虚参数和引用参数(Virtuals and reference arguments)

```C++
void func(Ellipse& elly){
    elly.render();
}
Circle circ(60F);
func(circ);
```

- 引用的作用类似于指针
- Circle::render() is called



#### Virtual 构造函数

- 如果析构函数可能被继承，则将其设置为虚函数

  ```C++
  Shape *p = new Ellipse (100. OF, 200. OF); 
  ...
  delete p;
  ```

- 想要 Ellipse: :~Ellipse ()被调用

  - 必须声明Shape::~Shape()是virtual的
  - 它将自动调用Shape::~Shape ()

- 如果Shape::~Shape()不是virtual的，只有Shape::~Shape()将被调用!



#### Overriding（覆盖/改写）

- 重写将重新定义虚函数的函数体

  ![image-20220224155719567](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\image-20220224155719567.png)

#### 向上调用链

- 你仍然可以调用被重写的函数:

  ![image-20220224155845899](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\image-20220224155845899.png)

- 这是添加新功能的常用方法
- 没有必要复制旧的东西!



#### Return types relaxation (current)

- 假设D是由B派生出来的
- D::f()可以返回B::f()中定义的返回类型的子类
- 适用于指针和引用类型

![image-20220224160229177](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\image-20220224160229177.png)

#### Overloading and virtuals

- 重载添加多个signatures

  ![image-20220224160406169](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\image-20220224160406169.png)

- 如果你重写一个重载的函数，你必须重写所有的变量!
  - 不能重写一个
  - 如果不覆盖所有内容，则会隐藏一些内容





## 引用再研究

#### 引用作为类成员

- 无初始值声明

- 必须使用构造函数初始化列表进行初始化

  ![image-20220226102356166](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\image-20220226102356166.png)

#### 返回引用

- 函数可以返回引用类型

  - 但它们最好引用非局部变量!

    ![image-20220226102903380](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\image-20220226102903380.png)

    ![image-20220226103114115](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\image-20220226103114115.png)



#### 函数中的const参数

- 传递const value——不要这样做

- 传递const引用

  - `Person( const string& name, int weight ); `

  - 不要改变字符串对象
  - 通过引用(地址)传递比通过值(复制)传递更有效
  - Const限定符保护不受更改

#### Const 引用参数

- 如果你不想改变参数呢?
- 使用const修饰符
  - ![image-20220226104021157](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\image-20220226104021157.png)

#### 临时值是const

- What you type
  - ![image-20220226104419209](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\image-20220226104419209.png)

- 编译器生成什么
  - ![image-20220226104452632](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\image-20220226104452632.png)

#### 函数返回const

- 由const值返回
  - 对于用户定义的类型，它意味着“防止作为左值使用”。
  - 对于内置函数，它没有任何意义
- const指针或引用返回
  - 这取决于您希望客户端对返回值做什么



## 拷贝构造Ⅰ

- 现有对象创建一个新对象

  - 例如，当调用一个函数时

    ![image-20220226111850821](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\image-20220226111850821.png)

- 复制由拷贝构造函数实现
- 具有唯一的 signature 
  - ` T::T (const T&);`
  - 引用调用用于显式参数
- 如果你不提供拷贝器，c++会为你构建一个拷贝器!
  - 复制每个成员变量
    - 适用于数字，对象，数组
  - 复制每个指针
    - 数据可能会被共享!

