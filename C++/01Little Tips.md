#### 防止头文件重复编译：

```cpp
#pragma once //在头文件中加入此‘预处理指令’即可。
```

####  类内私有成员变量前面可以加前缀 m_ ，比如 m_LogLevel 

> 增加代码可读性，便于区分私有变量和局部变量

#### 在子类中，给被重写的函数用"override"关键字标记,增强代码可读性。

```cpp
//基类
class Entity
{
public:
	virtual std::string GetName() {return "Entity";} //声明为虚函数
};

//派生类
class Player : public Entity
{
    .....
    std::string GetName() override {return m_Name;}  //C++11新标准允许给被重写的函数用"override"关键字标记,增强代码可读性。
    .....
};
```

#### 查找字符串里是否包含某字符

```cpp
std::string name = std::string("Cherno") + "hello!";//OK
bool contains = name.find("no") != std::string::npos;//用find去判断是否包含字符“no”
```

#### 任何时候像这样传入一个只读字符串时，确保通过常量引用传递它

```cpp
void PrintString(const std::string& string)
{
	std::cout << string < std::endl;
}
```

#### 追加字符串

```cpp
std::string name = "Cherno" + "hello!";//ERROR!
//方法一:
std::string name = "Cherno"";
name += "hello!  //OK
//方法二 string_literals
#include <iostream>
#include <string>
int main()
{
	using namespace std::string_literals;

	std::string name0 = "hbh"s + " hello";

	std::cin.get();
}
```

#### 同时定义指针变量

```cpp
int* x, y; //x是指针，y不是
int* x, *y; //都是指针
```

#### 指针类型调用函数的两种方式

- 解引用
- 箭头运算符

```cpp
Entity* entity = new Entity("lk");
std::cout << entity.GetName() << std::endl; //error!
std::cout << (*entity).GetName() << std::endl; //ok
std::cout << entity->GetName() << std::endl; //ok
delete entity； //清除在堆上分配的对象内存
```

#### 指向指针的引用

- **引用**本身**不是**一个**对象**，因此**不能定义指向引用的指针**。但指针是对象，所以**存在对指针的引用**：

  ```cpp
  int i = 42；
  int *p； //p是一个int型指针
  int *&r = p; //r是一个对指针p的引用
  r = &i； //r引用了一个指针，因此给r赋值&i就是令p指向i
  *r = 0； //解引用r得到i，也就是p指向的对象，将i的值改为0
  ```

  > 要理解r的类型到底是什么，最简单的办法是**从右向左阅读**r的定义。**离变量名最近的符号**（此例中是&r的符号&）**对变量的类型有最直接的影响**，因此r是一个引用。**声明符的其余部分用以确定r引用的类型是什么**，此例中的符号*说明r引用的是一个指针。最后，声明的基本数据类型部分指出r引用的是一个int指针。

#### 局部作用域创建数组的经典错误

- 例如：返回一个在作用域内创建的数组

  > 如下代码，因为我们没有使用new关键字，所以他不是在堆上分配的，我们只是在栈上分配了这个数组，当我们返回一个指向他的指针时(`return array`)，也就是返回了一个指向栈内存的指针，旦离开这个作用域（CreateArray函数的作用域），这个栈内存就会被回收

  ```cpp
  int CreateArray()
  {
  	int array[50];  //在栈上创建的
  	return array;
  }
  int main()
  {
  	int* a = CreateArray(); //不能正常工作
  }
  ```

  > 如果你想要像这样写一个函数，那你一般有**两个选择**
  >
  > - 在堆上分配这个数组，这样他就会一直存在
  >
  >   ```cpp
  >   int CreateArray()
  >   {
  >   	int* array = new int[50];  //在堆上创建的
  >   	return array;
  >   }
  >   ```
  >
  > - 将创建的数组赋值给一个在这个作用域外的变量
  >
  >   > 比如说，我在这里创建一个大小为50的数组，然后把这个数组作为一个参数传给这个函数，当然在这个CreateArray函数里就不需要再创建数组了，但是我们可以对传入的数组进行操作，比如，填充数组，因为我们只是闯入了一个指针，所以不会做分配的操作。
  >
  >   ```cpp
  >   int CreateArray(int* array)
  >   {
  >    //填充数组
  >   }
  >   int main()
  >   {
  >       int array[50];
  >   	CreateArray(array); //不能正常工作
  >   }
  >   ```

  

#### 总是通过const引用去传递对象

> 因为你写的函数本身，你可以决定是否要复制，在函数的内部，但你没有理由到处复制，他们会拖慢你的程序



#### 一种调试在heap上分配内存的方法

```
//一种调试在heap上分配内存的方法，自己写一个new的方法，然后设置断点或者打出log，就可以知道每次分配了多少内存，以及分配了几次
static uint32_t s_AllocCount = 0;
void* operator new(size_t size) 
{
    s_AllocCount++;
    std::cout << "Allocating " << size << " bytes\n";
    return malloc(size);
}
```

