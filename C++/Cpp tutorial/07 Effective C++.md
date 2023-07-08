# 二、构造、析构和赋值运算

### 条款05：了解C++默默编写并调用了哪些函数

当C++ 处理过empty class(空类)之后，如果你没有声明，则编译器会主动为**声明**一个**拷贝构造函数、拷贝复制操作符**和一个**析构函数**，同时如果你没有声明任何构造函数，编译器也会为你声明一个**default版本的拷贝构造函数**，这些函数都是`public`且`inline`的。

> 注意，上边说的是声明哦，只有当这些函数有调用需求的时候，编译器才会帮你去实现它们。但是编译器替你实现的函数可能在类内引用、类内指针、有`const`成员以及类型有虚属性的情形下会出问题。

- 对于拷贝构造函数，你要考虑到类内成员有没有深拷贝的需求，如果有的话就需要自己编写拷贝构造函数/操作符，而不是把这件事情交给编译器来做。
- 对于拷贝构造函数，如果类内有引用成员或`const`成员，你需要自己定义拷贝行为，因为编译器替你实现的拷贝行为在上述两个场景很有可能是有问题的。
- 对于析构函数，如果该类有多态需求，请主动将析构函数声明为`virtual`，具体请看条款07 。

除了这些特殊的场景以外，如果不是及其简单的类型，请自己编写好**构造、析构、拷贝构造和赋值操作符、移动构造和赋值操作符**（C++11、如有必要）这六个函数。 



### *条款06：若不想使用编译器自动生成的函数，就该明确拒绝。

承接上一条款，如果你的类型在语义或功能上需要明确禁止某些函数的调用行为，比如禁止拷贝行为，那么你就应该禁止编译器去自动生成它。作者在这里给出了两种方案来实现这一目标：

- 将被禁止生成的函数声明为`private`并省略实现，这样可以禁止来自类外的调用。但是如果类内不小心调用了（成员函数、友元），那么会得到一个链接错误。
- 将上述的可能的链接错误转移到编译期间。设计一不可拷贝的工具基类，将真正不可拷贝的基类私有继承该基类型即可，但是这样的做法过于复杂，对于已经有继承关系的类型会引入多继承，同时让代码晦涩难懂。

**新办法（推荐）:**C++11后，我们可以直接使用`= delete`来声明拷贝构造函数，显示禁止编译器生成该函数。



### 条款07：为多态基类声明virtual析构函数

该条款的核心内容为：**带有多态性质的基类必须将析构函数声明为虚函数，防止指向子类的基类指针在被释放时只局部销毁了该对象。**如果一个类有多态的内涵，那么几乎不可避免的会有基类的指针（或引用）指向子类对象，因为非虚函数没有动态类型，所以如果基类的析构函数不是虚函数，那么在基类指针析构时会直接调用基类的析构函数，造成子类对象仅仅析构了基类的那一部分，有内存泄漏的风险。除此之外，还需注意：

- 需要注意的是，普通的基类无需也不应该有虚析构函数，因为虚函数无论在时间还是空间上都会有代价，详情《More Effective C++》条款24。

- 如果一个类型没有被设计成基类，又有被误继承的风险，请在类中声明为`final`（C++ 11），这样禁止派生可以防止误继承造成上述问题。

  如：

  ```cpp
  class NoDerived final {/* */};   // NoDerived 不能作为基类
  class Base {/* */};
  class Last final : Base {/* */}; //Last 不能作为基类
  class Bad : NoDerived {/* */};   //Error! NoDerived是final的
  class Bad2 : Last {/* */};       //Error! Last是final的
  ```

- 编译器自动生成的析构函数是非虚的，所以多态基类必须将析构函数**显示声明**为`virtual`。



### 条款08：别让异常逃离析构函数

> 析构函数一般情况下不应抛出异常，因为很大可能发生各种未定义的问题，包括但不限于内存泄露、程序异常崩溃、所有权被锁死等。
>
> 一个直观的解释：析构函数是一个对象生存期的最后一刻，负责许多重要的工作，如线程，连接和内存等各种资源所有权的归还。如果析构函数执行期间某个时刻抛出了异常，就说明抛出异常后的代码无法再继续执行，这是一个非常危险的举动——因为析构函数往往是为类对象兜底的，甚至是在该对象其他地方出现任何异常的时候，析构函数也有可能会被调用来给程序擦屁股。在上述场景中，如果在一个异常环境中执行的析构函数又抛出了异常，很有可能会让程序直接崩溃，这是每一个程序员都不想看到的。
>
> 话说回来，如果某些操作真的很容易抛出异常，如资源的归还等，并且你又不想把异常吞掉，那么就请把这些操作移到析构函数之外，提供一个普通函数做类似的清理工作，在析构函数中只负责记录，我们需要时刻保证析构函数能够执行到底。

- 析构函数绝对不要吐出异常。如果一个被析构函数调用的函数可能抛出异常，析构函数应该捕捉任何异常，然后吞下它们（不传播）或结束程序。
- 如果客户需要对某个操作函数运行期间抛出的异常做出反应，那么 class 应该提供一个普通函数（而非在析构函数中）执行该操作。



### 条款09：绝不在构造和析构过程中调用virtual函数

在多态环境中，我们需要重新理解构造函数和析构函数的意义，这两个函数在执行过程中，涉及到了对象类型从基类到子类，再从子类到基类的转变。

一个子类对象开始创建时，首先调用的是基类的构造函数，在调用子类构造函数之前，该对象**将一直保持着“基类对象”的身份而存在**，自然在基类的构造函数中调用的虚函数——将会是基类的虚函数版本，在子类的构造函数中，**原先的基类对象变成了子类对象**，这时子类构造函数里调用的是子类的虚函数版本。这是一件有意思的事情，这说明在**构造函数中虚函数并不是虚函数**，在不同的构造函数中，调用的虚函数版本并不同，因为随着不同层级的构造函数调用时，对象的类型在实时变化。那么相似的，析构函数在调用的过程中，子类对象的类型从子类退化到基类。

因此，如果你指望在基类的构造函数中调用子类的虚函数，那就趁早打消这个想法好了。但很遗憾的是，你可能并没有意识到自己做出了这样的设计，例如将构造函数的主要工作抽象成一个`init()`函数以防止不同构造函数的代码重复是一个很常见的做法，但是在`init()`函数中是否调用了虚函数，就要好好注意一下了，同样的情况在析构函数中也是一样。



### 条款10：令operator =返回一个reference to *this

简单来说：这样做可以让你的赋值操作符实现“连等”的效果：

```C++
x = y = z = 10;
```

如：

```cpp
class Widget
{
public:
    ...
    Widget& operator=(const Widget& rhs) //返回类型是个 reference，
    {    								 //指向当前对象。
        ...
        return *this；					//返回左侧对象
    }
    ...
}
```

这个协议不仅适用千以上的标准赋值形式，也适用千所有**赋值**相关运算，例如：

```cpp
class Widget
{
public:
    ...
    Widget& operator+=(const Widget& rhs)  //这个协议适用于
    {    								   //+=、-+、*=等等。
        ...
        return *this；					  
    }
    
    Widget& operator=(int rhs)  		   //／此函数也适用，即使
    {    								   //此一操作符的参数类型
        ...								   //不符协定。
        return *this；					
    }
    ...
}
```

注意 **bool操作符**重载的**返回值**有所不同，请留心，以免无限调用自身。

```cpp
struct Vector2
{
	....
	bool operator==(const Vector2& other) const  //定义操作符的重载,如果！=，这里做相应修改即可
	{
		return x == other.x && y == other.y;  //不能return *this 否则无限调用自己
	}
    
    bool operator！=(const Vector2& other) const  
	{
		return ！(*this == other);
	}
};
```

在设计接口时一个重要的原则是，**让自己的接口和内置类型相同功能的接口尽可能相似**，所以如果没有特殊情况，就请让你的赋值操作符的返回类型为`ObjectClass&`类型并在代码中返回`*this`吧。



### 条款11：在operator=中处理“自我赋值”

- 确保当对象自我赋值时operator=有良好行为。其中技术包括比较“来源对象”和“目标对象”的地址、精心周到的语句顺序、以及copy-and-swap。
- 确定任何函数如果操作一个以上的对象，而其中多个对象是同一个对象时，其行为仍然正确。

自我赋值指的是将自己赋给自己。这是一种看似愚蠢无用但却在代码中出现次数比任何人想象的多得多的操作，这种操作常常需要假借指针来实现：

```C++
*pa = *pb;		 	    //pa和pb指向同一对象，便是自我赋值。
arr[i] = arr[j];		//i和j相等，便是自我赋值
```

那么对于管理一定资源的对象重载的operator = 中，一定要对是不是自我赋值格外小心并且增加预判，因为无论是深拷贝还是资源所有权的转移，原先的内存或所有权一定会被清空才能被赋值，如果不加处理，这套逻辑被用在自我赋值上会发生——先把自己的资源给释放掉了，然后又把以释放掉的资源赋给了自己——出错了。

第一种做法是在赋值前增加预判，但是这种做法没有异常安全性，试想如果在删除掉原指针指向的内存后，在赋值之前任何一处跑出了异常，那么原指针就指向了一块已经被删除的内存。

```C++
//假设你建立一个class 用来保存一个指针指向一块动态分配的位图(DataBlock) :
class DataBlock{...};
SomeClass& SomeClass::operator=(const SomeClass& rhs) {
  if (this == &rhs) return *this;
  
  delete ptr;	
  ptr = new DataBlock(*rhs.ptr);				//如果此处抛出异常，ptr将指向一块已经被删除的内存。
  return *this;
}
```

如果我们把异常安全性也考虑在内，那么我们就会得到如下方法，令人欣慰的是这个方法也解决了自我赋值的问题。

```C++
SomeClass& SomeClass::operator=(const SomeClass& rhs) {
  DataBlock* pOrg = ptr;
  ptr = new DataBlock(*rhs.ptr);				//如果此处抛出异常，ptr仍然指向之前的内存。
  delete pOrg;
  return *this;
}
```

另一个使用copy and swap技术的替代方案将在条款29中作出详细解释。



### 条款12：复制对象时勿忘其每一个成分

所谓“每一个成分”，作者在这里其实想要提醒大家两点：

- 当你给类多加了成员变量时，请不要忘记在拷贝构造函数和赋值操作符中对新加的成员变量进行处理。如果你忘记处理，编译器也不会报错。

- 如果你的类有继承，那么在你为子类编写拷贝构造函数时一定要格外小心复制基类的每一个成分，这些成分往往是private的，所以你无法访问它们，你应该让子类使用子类的拷贝构造函数去调用相应基类的拷贝构造函数：

  ```C++
  //在成员初始化列表显示调用基类的拷贝构造函数
  ChildClass::ChildClass(const ChildClass& rhs) : BaseClass(rhs) {		
    	// ...
  }
  ```

除此之外，拷贝构造函数和拷贝赋值操作符，他们两个中任意一个不要去调用另一个，这虽然看上去是一个避免代码重复好方法，但是是荒谬的。其根本原因在于拷贝构造函数在构造一个对象——这个对象在调用之前并不存在；而赋值操作符在改变一个对象——这个对象是已经构造好了的。因此前者调用后者是在给一个还未构造好的对象赋值；而后者调用前者就像是在构造一个已经存在了的对象。不要这么做！



# 三、资源管理

### *条款13：以对象管理资源

本条款的核心观点在于：以面向流程的方式管理资源（的获取和释放），总是会在各种意外出现时，丢失对资源的控制权并造成资源泄露。以面向过程的方式管理资源意味着，资源的获取和释放都分别被封装在函数中。这种管理方式意味着资源的索取者肩负着释放它的责任，但此时我们就要考虑一下以下几个问题：调用者是否总是会记得释放呢？调用者是否有能力保证合理地释放资源呢？不给调用者过多义务的设计才是一个良好的设计。

首先我们看一下哪些问题会让调用者释放资源的计划付诸东流：

- 一句简单的`delete`语句并不会一定执行，例如一个过早的`return`语句或是在`delete`语句之前某个语句抛出了异常。
- 谨慎的编码可能能在这一时刻保证程序不犯错误，但无法保证软件接受维护时，其他人在delete语句之前加入的return语句或异常重复第一条错误。

为了保证资源的获取和释放一定会合理执行，我们把获取资源和释放资源的任务封装在一个对象中。当我们构造这个对象时资源自动获取，当我们不需要资源时，我们让对象析构。这便是“Resource Acquisition Is Initialization; RAII”的想法，因为我们总是在获得一笔资源后于同一语句内初始化某个管理对象。无论控制流如何离开区块，一旦对象被销毁（比如离开对象的作用域）其析构函数会自动被调用。

具体实践请参考C++11的`shared_ptr`。



### 条款14：在资源管理类中小心copying行为

- 复制 RAII 对象必须一并复制它所管理的资源，所以资源的 copying 行为决定RAII对象的copying行为。

- 如果对想要自行管理delete（或其他类似行为如上锁/解锁）的类处理复制问题，有以下方案，先创建自己的资源管理类，然后可选择：

- - 禁止复制，使用**条款6**的方法
  - 对复制的资源做引用计数（声明为shared_ptr），shared_ptr支持初始化时自定义删除函数（auto_ptr不支持，总是执行delete）
  - 做真正的深复制
  - 转移资源的拥有权，类似auto_ptr，只保持新对象拥有。



### 条款15：在资源管理类中提供对原始资源的访问

- 许多 APIs 需要直接引用资源，而不是通过资源管理类。虽然它们不合规范，但很难避免使用它们。所以资源管理类应该提供访问原始资源的能力。
- tr1::shared_ptr 和auto_ptr 都提供一个 get 成员函数，用来执行显式转换，也就是它会返回：智能指针内部的原始指针的副本。
- tr1::shared_ptr 和auto_ptr 也重载了 operator-> 和 operator*，允许隐式转换至原始指针。
- 对于非智能指针管理类，可以编写 get() 函数，提供显式转换，重载operator xxx()，提供隐式转换。
- 记住隐式转换可能存在问题，虽然它比较直观。

总结

1. **APIs往往要求访问原始资源（raw resources），所以每一个RAII class应该提供一个取得其所管理资源的方法。**
2. **对原始资源的访问可能经由显式转换或隐式转换。一般而言显式转换比较安全，但隐式转换对客户比较方便。**

### 条款16：成对使用new和delete时要采取相同形式

- 当你使用 new（也就是通过new动态生成一个对象），有两件事发生。

- - 第一，内存被分配出来（通过名为operator new的函数，见条款49和条款51）。
  - 第二，针对此内存会有一个（或更多）构造函数被调用。

- 当你使用 delete，也有两件事发生：针对此内存会有一个（或更多）析构函数被调用，然后内存才被释放（通过名为operator delete的函数，见条款51）。
- 如果你调用new时使用[]，你必须在对应调用delete时也使用[]。如果你调用new时没有使用[]，那么也不该在对应调用delete时使用[]。
- 对于数组，不建议使用typedef行为，这会让使用者不记得去delete []。对于这种情况，建议使用string或者vector。



### 条款17：以独立语句将newed对象放入智能指针

1. **背景阐述**

假设有两个函数`priority`和`processWight`，其中`priority`函数返回处理程序的优先级，`processWidget`函数按照`priority`返回的优先级处理动态分配的`Widget`对象，函数原型如下：

```cpp
int priority();
void processWidget(std::shared_ptr<Widget> pw, int priority);
```

如果按照如下方法调用`processWidget`函数，则有可能造成资源泄漏：

```cpp
processWidget(std::shared_ptr<Widget>(new Widget()), priority());
```

2. **具体分析**

编译器在生成`processWidget`函数调用码之前会核算即将被传递的各个实参，第二个实参是对`priority`函数的简单调用，而第一个实参包含两个部分：

1. 执行`new Widget()`表达式动态创建`Widget`对象。
2. 调用`shared_ptr`类的构造函数并使用`Widget`对象的指针作为构造参数。

所以，在调用`processWidget`函数之前编译器会做以下三件事情：

1. 执行`new Widget()`表达式动态创建`Widget`对象。
2. 调用`shared_ptr`类的构造函数并使用`Widget`对象的指针作为构造参数。
3. 调用`priority`函数生成优先级。

以何种顺序执行以上三个步骤，C++语句并没有给出严格规定（Java和C#中必须按规定的顺序完成参数的核算），具体由编译器来决定。

能够明确知道的是执行`new Widget`表达式肯定是在调用`shared_ptr`构造函数之前，但调用`priority`函数则有可能是在第1、2、3中任意一步执行。假设调用`priority`函数在第2步执行，将获得如下执行顺序：

1. 执行`new Widget()`表达式动态创建`Widget`对象。
2. 调用`priority`函数生成优先级。
3. 调用`shared_ptr`类的构造函数并使用`Widget`对象的指针作为构造参数。

如果在调用`priority`函数的过程中发生了异常，那么`new Widget()`表达式返回的指针会被遗失，就有可能造成资源泄漏。原因是在【资源被创建】和【资源被管理对象接管】之间造成了异常干扰。

3. **解决办法**

分离构造`Widget`对象的语句，在单独的语句中执行`new Widget()`表达式并调用`shared_ptr`类的构造函数，最后将智能指针传给`processWidget`函数。代码如下：

```cpp
std::shared_ptr<Widget> pw(new Widget());
processWidget(pw, priority());
```

编译器对于**跨越语句的各项操作**没有重新排列的自由，只有在语句内才拥有某种自由度。

因此在上述代码中【（1）执行`new Widget()`表达式和（2）调用`shared_ptr`类的构造函数】与【对`priority`函数的调用】是在不同的语句中，被分隔开来了，所以编译器不得在它们之间任意选择执行次序。

4. **最终结论**

1. 以独立语句将newed对象存储于智能指针中，这样能够保证动态获取的资源一定能被资源管理对象接管，不会造成内存泄漏。
2. 如果不这样做，一旦在【资源申请成功】和【资源管理对象接管资源】之间抛出了异常，就有可能产生难以察觉的资源泄漏。因为异常本身就在意料之外的错误，不容易复现，从而导致资源泄漏无法轻易定位。



# 四、设计与声明

### 条款18：让接口容易被正确使用，不易误使用

本条款告教你如何**帮助你的客户在使用你的接口时避免他们犯错误**。

在设计接口时，我们常常会错误地假设，接口的调用者**拥有某些必要的知识来规避一些常识性的错误**。但事实上，接口的调用者并不总是像正在设计接口的我们一样“聪明”或者知道接口实现的”内幕信息“，结果就是，我们错误的假设使接口表现得不稳定。这些不稳定因素可能是由于调用者缺乏某些先验知识，也有可能仅仅是代码上的粗心错误。接口的调用者可能是别人，也可能是未来的你。所以一个合理的接口，应该尽可能的从**语法层面**并在**编译之时运行之前**，帮助接口的调用者规避可能的风险。

如下， 设计一个日期类 

```cpp
//参考原文：https://blog.csdn.net/hualicuan/article/details/27526033
class Date
{
public:
	Date(const int month, const int day, int const year) 
		: m_month(month)
		, m_day(day)
		, m_year(year)
	{
 
	}
private:
	int m_day;
	int m_month;
	int m_year;
};
```

 错误调用 

```cpp
	Date d1(29, 5, 2014);  //调用顺序错乱，应该是 5, 29, 2014
	Date d2(2, 30, 2014);  //传入参数有误，2月没有30号
```

- 使用**外覆类型（wrapper）**提醒调用者传参错误检查，将参数的附加条件限制在**类型本身**

当调用者试图传入数字“13”来表达一个“月份”的时候，你可以在函数内部做运行期的检查，然后提出报警或一个异常，但这样的做法更像是一种责任转嫁——调用者只有在尝试过后才发现自己手残把“12”写成了“13”。如果在设计参数类型时就把“月份”这一类型抽象出来，比如使用enum class（强枚举类型），就能帮助客户在编译时期就发现问题，把参数的附加条件限制在类型本身，可以让接口更易用。

```cpp
struct Day
{
	explicit Day(const int day) : m_day(day) {}
private:
	int m_day;
};
 
struct Month
{
	explicit Month(const int month) : m_month(month) {}
private:
	int m_month;
};
 
struct Year
{
	explicit Year(const int year) : m_year(year) {}
private:
	int m_year;
};
 
class Date
{
public:
	Date(const Month &month, const Day &day,  const Year &year) 
		: m_month(month)
		, m_day(day)
		, m_year(year)
	{
 
	}
private:
	Day m_day;
	Month m_month;
	Year m_year;
};
```

 类型错误得到预防，但值还是没有得到保障 

```cpp
	Date d2(2, 30, 2014);  //error,类型错误
	Date d3(Day(30), Month(2), Year(2014)); //error,类型错误
	Date d4(Month(2), Day(30), Year(2014)); //ok
```

 可通过设计对应的类型的值限制来达到 

```cpp
struct Month
{
	enum E_MON{JAN = 1, FEC, MAR, APR, MAY, JUN, JUL, AGU, SEP, OCT, NOV, DEC};
	explicit Month(const E_MON month) : m_month(month) {}
private:
	int m_month;
};
```

 调用 

```cpp
Date d4(Month(Month::E_MON::DEC), Day(30), Year(2014)); //ok
```

- 从**语法层面**限制调用者**不能做的事**

接口的调用者往往无意甚至没有意识到自己犯了个错误，所以接口的设计者必须在语法层面做出限制。一个比较常见的限制是加上`const`，比如在`operate*`的返回类型上加上`const`修饰，可以防止无意错误的赋值`if (a * b = c)`。

- 接口应表现出与内置类型的一致性

让自己的类型和内置类型的一致性，比如自定义容器的接口在命名上和STL应具备一致性，可以有效防止调用者犯错误。或者你有两个对象相乘的需求，那么你最好重载`operator*`而并非设计名为”multiply”的成员函数。

- 从语法层面限制调用者**必须做的事**

**别让接口的调用者总是记得做某些事情**，接口的设计者应在假定他们**总是忘记**这些条条框框的前提下设计接口。比如用智能指针代替原生指针就是为调用者着想的好例子。如果一个核心方法需要在使用前后设置和恢复环境（比如获取锁和归还锁），更好的做法是将设置和恢复环境设置成纯虚函数并要求调用者继承该抽象类，强制他们去实现。在核心方法前后对设置和恢复环境的调用，则应由接口设计者操心。

当方法的调用者（我们的客户）责任越少，他们可能犯的错误也就越少。

请记住：

①好的接口易于正确使用，而难以错误使用。你应该在你的所有接口中为这个特性努力。
②使易于正确使用的方法包括在接口和行为兼容性上与内建类型保持一致。
③预防错误的方法包括创建新的类型，限定类型的操作，约束对象的值，以及消除客户的资源管理职责。
④tr1::shared_ptr 支持自定义 deleter。这可以防止 cross-DLL 问题，能用于自动解锁互斥体（参见 Item 14）

### 条款19：设计class犹如设计type

如何设计class：

- 对象该如何创建销毁：包括构造函数、析构函数以及new和delete操作符的重构需求。
- 对象的构造函数与赋值行为应有何区别：构造函数和赋值操作符的区别，重点在资源管理上。
- 对象被拷贝时应考虑的行为：拷贝构造函数。
- 对象的合法值是什么？最好在语法层面、至少在编译前应对用户做出监督。
- 新的类型是否应该复合某个继承体系，这就包含虚函数的覆盖问题。
- 新类型和已有类型之间的隐式转换问题，这意味着类型转换函数和非explicit函数之间的取舍。
- 新类型是否需要重载操作符。
- 什么样的接口应当暴露在外，而什么样的技术应当封装在内（public和private）
- 新类型的效率、资源获取归还、线程安全性和异常安全性如何保证。
- 这个类是否具备template的潜质，如果有的话，就应改为模板类。



### 条款20：宁以pass-by-reference-to-const替换pass-by-value

函数接口应该以`const`引用的形式传参，而不应该是按值传参，否则可能会有以下问题：

- 按值传参涉及大量参数的复制，这些副本大多是没有必要的。
- 如果拷贝构造函数设计的是深拷贝而非浅拷贝，那么拷贝的成本将远远大于拷贝某几个指针。
- 对于多态而言，将父类设计成按值传参，如果传入的是子类对象，仅会对子类对象的父类部分进行拷贝，即部分拷贝，而所有属于子类的特性将被丢弃，造成不可预知的错误，同时虚函数也不会被调用。（对象切割）
- 小的类型并不意味着按值传参的成本就会小。首先，类型的大小与编译器的类型和版本有很大关系，某些类型在特定编译器上编译结果会比其他编译器大得多。小的类型也无法保证在日后代码复用和重构之后，其类型始终很小。

请记住：

- **尽量以pass-by-reference-to-const 替换pass-by-value**。前者通常比较高效，并可避免切割问题（slicing problem）。
- 以上规则**并不适用于内置类型，以及STL的选代器和函数对象**。对它们而言，pass-by-value 往往比较适当。



### *条款21：必须返回对象时，别妄想返回其reference

这个条款的核心观点在于，不要把总返回值写成引用类型，作者在条款内部详细分析了各种可能发生的错误，无论是返回一个stack对象还是heap对象，在这里不再赘述。作者最后的结论是，如果必须按值返回，那就让他去吧，多一次拷贝也是没办法的事，最多就是指望着编译器来优化。

但是对于C++11以上的编译器，我们可以采用给类型编写“转移构造函数”以及使用`std::move()`函数更加优雅地**消除由于拷贝造成的时间和空间的浪费。**

请记住

- 绝不要返回pointer或reference指向一个local stack对象，或返回reference指向一个heap-allocated对象，或返回 pointer或 reference指向一个local static对象而有可能同时需要多个这样的对象。条款4已经为“在单线程环境中合理返回reference指向一个local static对象”提供了一份设计实例。



### 条款22：将成员变量声明为private

先说结论——**请对class内所有成员变量声明为`private`，`private`意味着对变量的封装。**但本条款提供的更有价值的信息在于不同的属性控制——`public`,` private`和`protected`——**代表的设计思想**。

简单的来说，把所有成员变量声明为private的好处有两点。首先，所有的变量都是private了，那么所有的public和protected成员都是函数了，用户在使用的时候也就无需区分，这就是语法一致性；其次，对变量的封装意味着，**可以尽量减小因类型内部改变造成的类外外代码的必要改动。**

一旦所有变量都被封装了起来，外部无法直接获取，那么所有类的使用者（我们称为客户，客户也可能是未来的自己，也可能是别人）想利用私有变量实现自己的业务功能时，就**必须通过我们留出的接口**，这样的接口便充当了一层缓冲，将类型内部的升级和改动尽可能的对客户不可见——**不可见就是不会产生影响**，不会产生影响就不会要求客户更改类外的代码。因此，一个设计良好的类在内部产生改动后，对整个项目的影响只应是**需要重新编辑而无需改动类外部的代码**。

我们接着说明，**`public`和`protected`属性在一定程度上是等价的**。一个自定义类型被设计出来就是供客户使用的，那么客户的使用方法无非是两种——**用这个类创建对象**或者**继承这个类以设计新的类**——以下简称为第一类客户和第二类客户。那么从封装的角度来说，一个`public`的成员说明了**类的作者决定对类的第一种客户不封装此成员**，而一个`protected`的成员说明了**类的作者对类的第二种客户不封装此成员**。也就是说，当我们把类的两种客户一视同仁了以后，`public`、`protected`和`private`三者反应的即类设计者对类成员封装特性的不同思路——对成员封装还是不封装，如果不封装是对第一类客户不封装还是对第二类客户不封装。

请记住：

- 切记将成员变量声明为private。这可赋予客户访问数据的一致性、可细微划分访问控制、允诺约束条件获得保证，并提供class作者以充分的实现弹性。
- protected 并不比public更具封装性。



### 条款23：宁以non-member, non-friend替换member函数

我宁愿多花一些口舌在这个条款上，一方面因为它真的很重要，另一方面是因为作者并没有把这个条款说的很清楚。

在一个类里，我愿把**需要直接访问private成员的public和protected成员函数**称为**功能颗粒度较低的函数**，原因很简单，他们涉及到对private成员的直接访问，说明他们处于封装表面的第一道防线。由若干其他public（或protected）函数集成而来的public成员函数，我愿称之为**颗粒度高的函数**，因为他们集成了若干颗粒度较低的任务，这就是本条款所针对的对象——那些**无需直接访问private成员**，而只是**若干public函数集成而来的member函数**。本条款告诉我们：这些函数应该尽可能放到类外。

```C++
class WebBrowser {			//	一个浏览器类
public:
  	void clearCache();		// 清理缓存，直接接触私有成员
  	void clearHistory();	// 清理历史记录，直接接触私有成员
  	void clearCookies();    // 清理cookies，直接接触私有成员
  
  	void clear();		    // 颗粒度较高的函数，在内部调用上边三个函数，不直接接触私有成员，本条款告诉我们这样的函数应该移至类外
}
```

如果高颗粒度函数设置为类内的成员函数，那么一方面他会破坏类的封装性，另一方面降低了函数的包裹弹性。

1. 类的封装性

封装的作用是尽可能减小被封装成员的改变对类外代码的影响——我们希望类内的改变只影响有限的客户。一个量化某成员封装性好坏的简单方法是：看类内有多少（public或protected）函数直接访问到了这个成员，这样的函数越多，该成员的封装性就越差——该成员的改动对类外代码的影响就可能越大。回到我们的问题，高颗粒度函数在设计之时，设计者的本意就是**它不应直接访问任何私有成员**，而只是公有成员的简单集成，这样会最大程度维护封装性，但很可惜，**这样的愿望并没有在代码层面体现出来**。这个类未来的维护者（有可能是未来的你或别人）很可能忘记了这样的原始设定，而在此本应成为“高颗粒度”函数上大肆添加对私有成员的直接访问，这也就是为什么封装性可能会被间接损坏了。但设计为非成员函数就从语法上避免了这种可能性。

1. 函数的包裹弹性与设计方法

将高颗粒度函数提取至类外部可以允许我们从**更多维度组织代码结构**，并**优化编译依赖关系**。我们用上边的例子说明什么是“更多维度”。`clear（）`函数是代码的设计者最初从浏览器的角度对低颗粒度函数做出的集成，但是如果从“cache”、“history”、和“cookies”的角度，我们又能够做出其他的集成。比如将“搜索历史记录”和“清理历史记录”集成为“定向清理历史记录”函数，将“导出缓存”和“清理缓存”集成为“导出并清理缓存”函数，这时，我们在浏览器类外做这样的集成会有更大的自由度。通常利用一些工具类如`class CacheUtils`、`class HistoryUtils`中的static函数来实现；又或者采用不同namespace来明确责任，将不同的高颗粒度函数和浏览器类纳入不同namespace和头文件，当我们使用不同功能时就可以include不同的头文件，而不用在面对cache的需求时不可避免的将cookies的工具函数包含进来，降低编译依存性。这也是`namespace`可以跨文件带来的好处。

> -  **命名空间可以跨越多个源码文件而类则不可以。** 
>
>   ```cpp
>   //在C++中，比较自然的做法是让clearBrowser()函数成为一个non-member函数并且位于WebBrowser类所在的同一个命名空间(namespace)中。
>   namespace WebBrowserStuff {	
>       class WebBrowser {   //核心机能
>           public :
>               void clearCache();
>               void clearHistory();
>               void clearCookies();
>           };
>   
>           // non-member函数，提供几乎所有客户都需要的核心机能
>           void CoreFunc(WebBrowser& wb) {
>               wb.clearCache();
>               wb.clearHistory();
>               wb.clearCookies();
>           }
>   }
>   ```
>
> -  一个像WebBrowser这样的类中可能有大量的便利函数，如书签便利函数、打印便利函数、cookies管理有关的便利函数。通常，大多数客户只对其中某些感兴趣。为了防止多个便利函数之间发生编译相互依赖性，分离它们的最直接方法是将书签便利函数声明在一个头文件中，将cookies管理有关的便利函数声明在另一个头文件中，再将打印便利函数声明于第三个头文件中。如下所示： 
>
>   ```cpp
>   // 头文件webbrowser.h，这个头文件针对WebBrowser类
>   namespace WebBrowserStuff{
>       class WebBrowser{
>           // ...
>       };
>       // ...   non-member函数
>   }
>   // 头文件webbrowserbookmarks.h
>   namespace WebBrowserStuff{
>       // ...   与书签相关的便利函数
>   }
>   // 头文件webbrowsercookies.h
>   namespace WebBrowserStuff{
>       // ...   与cookies管理相关的便利函数
>   }
>   ```
>
>   

最后要说的是，本条款讨论的是那些**不直接接触私有成员的函数**，如果你的public(或protected)函数必须直接访问私有成员，那请忘掉这个条款，因为把那个函数移到类外所需做的工作就比上述情况远大得多了。



### 条款24：若所有参数皆需类型转换，请为此采用non-member函数

这个条款告诉了我们**操作符重载被重载为成员函数和非成员函数的区别**。作者想给我们提个醒，如果我们在使用操作符时**希望操作符的任意操作数都可能发生隐式类型转换**，**那么应该把该操作符重载成非成员函数。**

我们首先说明：如果一个操作符是成员函数，那么它的**第一个操作数（即调用对象）不会发生隐式类型转换**。

首先简单讲解一下当操作符被重载成员函数时，第一个操作数特殊的身份。操作符一旦被设计为成员函数，它在被使用时的特殊性就显现出来了——单从表达式你无法直接看出**是类的哪个对象在调用这个操作符函数**，不是吗？例如下方的有理数类重载的操作符”*”，当我们在调用`Rational z = x * y;`时，调用操作符函数的对象并没有直接显示在代码中——这个操作符的`this`指针指向`x`还是`y`呢？

```C++
class Rational {
public:
  //...
  Rational operator*(const Rational rhs) const; 
pricate:
  //...
}
```

作为成员函数的操作符的第一个隐形参数”`this`指针”总是指向第一个操作数，所以上边的调用也可以写成`Rational z = x.operator*(y);`，这就是操作符的**更像函数的调用方法**。那么，做为成员函数的操作符默认操作符的第一个操作数应当是正确的类对象——**编译器正式根据第一个操作数的类型来确定被调用的操作符到底属于哪一个类的**。因而第一个操作数是不会发生隐式类型转换的，第一个操作数是什么类型，它就调用那个类型对应的操作符。

我们举例说明：当`Ratinoal`类的构造函数允许`int`类型隐式转换为`Rational`类型时，`Rational z = x * 2;`是可以通过编译的，因为操作符是被`Rational`类型的`x`调用，同时将`2`隐式转换为`Ratinoal`类型，完成乘法。但是`Rational z = 2 * x;`却会引发编译器报错，因为由于操作符的第一个操作数不会发生隐式类型转换，所以加号“*”实际上调用的是`2`——一个`int`类型的操作符，因此编译器会试图将`Rational`类型的`x`转为`int`，这样是行不通的。

因此在你编写诸如加减乘除之类的（但不限于这些）操作符、并假定允许每一个操作数都发生隐式类型转换时，**请不要把操作符函数重载为成员函数**。因为当第一个操作数不是正确类型时，可能会引发调用的失败。解决方案是，**请将操作符声明为类外的非成员函数**，你可以选择友元让操作符内的运算更便于进行，也可以为私有成员封装更多接口来保证操作符的实现，这都取决于你的选择。

```cpp
class Rational {
public:
  Rational (int numerator = 0, int denminator = 1);
  // 下面的重载会导致错误(1)
  const Rational operator* (const Rational& rhs) {
    return Rational(n * rhs.n, d * rhs.d);
  }
  int numerator() const { return n; }
  int denminator() const { return d; }
private:
  int n, d; // 分子、分母
}
Rational A(1,8);
Rational result =  A * 2; // ok
result = 2 * a; // wrong (1)

const Rational operator* (const Rational& rhs, const Ratioanal& lhs) {
  // return Rational(rhs.n * lhs.n, rhs.d * lhs.d); // 私有成员不能访问
  return Rational(rhs.numerator() * lhs.numerator(), // ok
                  rhs.denminator() * lhs.denminator());
}

Rational result =  A * 2;  // ok
result = 2 * a; // wrong (1) // ok 
```

希望这一条款能解释清楚操作符在作为成员函数与非成员函数时的区别。此条款并没有明确说明该法则只适用于操作符，但是除了操作符外，我实在想不到更合理的用途了。

题外话：如果你想禁止隐式类型转换的发生，请把你每一个单参数构造函数后加上关键字`explicit`。



### 条款25: 考虑写出—个不抛异常的swap 函数

##### 参考原文1：https://www.cnblogs.com/wuchanming/p/3735189.html

std::swap（）是个很有用的函数，它可以用来交换两个变量的值，包括用户自定义的类型，只要类型支持copying操作，尤其是在STL中使用的很多，例如：

```cpp
int main(int argc, _TCHAR* argv[])  
{  
    int a[10] = {1,2,3,4,5,6,7,8,9,10};  
    vector<int> vec1(a, a + 4);  
    vector<int> vec2(a + 5, a + 10);  
  
    swap(vec1, vec2);  
  
    for (int i = 0; i < vec1.size(); i++)  
    {  
        cout<<vec1[i]<<" ";  
    }  
    return 0;  
}  
```

 上面这个例子实现的是两个vector的内容的交换，有了swap函数，省去了很多的麻烦！What a fucking convenient!

**一、swap的原理**

​    缺省的swap的原理其实很简单，就是将两对象的值彼此赋予对方，其实现过程大致如下：

​    swap的实现是通过被交换类型的copy构造函数和赋值操作符重载实现的，会涉及到三个对象的复制。所以说，要对自定义的类型调用swap实现交换，必须首先保证自定义类型的copy构造函数和赋值操作符重载函数。

**二、swap的缺陷**

​    缺省的swap最主要的问题就是：当对象内部包含指针成员时，它不仅要复制3三次被交换的对象，还要复制3次对象成员，而且复制的是指针对象所指向的内容！例如：

​    一旦要置换两个Line对象值，swap需要复制三个Line，还要复制六个Point对象，详细可以看赋值运算符重载函数，这样是非常低效的，尤其是当Line的数据成员非常庞大的时候，实际上我们只需要交换各自成员的指针就可以了！

**三、swap的改进方案**

​    我们希望告诉std::swap：当Line被置换时，真正该做的是置换骑内部的px和py指针。实现这个过程有几个方案，我们先看最简单的方案：

​												**方案一：将std::swap针对Line特化**

​    C++规定：通常不允许改变std命名空间内的任何东西，但是可以为标准template（如swap）制造特化版本，使他专属于我们自己的class（例如Line）。

​    根据这个性质，我们可以对std:swap针对Line进行特化。我们可以这样特化swap：

​    在这个代码中，“template<>”表示它是std::swap的一个全特化版本，函数名之后的“<Line>"表示这一特化版本针对”T是Line”而设计。

​    完整的方案如下：

```cpp
// SwapTest.cpp : 定义控制台应用程序的入口点。  
  
#include "stdafx.h"  
#include <iostream>  
#include <vector>  
  
using namespace std;  
  
class Point{  
private:  
    int x,y;  
public:  
    Point():x(0),y(0){};  
    Point(int a, int b):x(a),y(b){};  
    void Print(){  
        cout<< x << " "<< y <<endl;  
    }  
    int GetX(){  
        return x;  
    }  
    int GetY(){  
        return y;  
    }  
};  
  
class Line{  
private:  
    Point *px, *py;  
public:  
    Line():px(),py(){};  
    Line(int a,int b,int c,int d):px(new Point(a,b)), py(new Point(c, d)){};  
    void swap(Line& l){  //Line成员函数，用以实现指针成员交换  
        cout<<"swap of Line is called......"<<endl;  
        using std::swap;  
        swap(px, l.px);  // 交换指针  
        swap(py, l.py);  
    }  
  
    void Print(){  
        cout<<"( "<<px->GetX()<<" "<<px->GetY()<<" "<<py->GetX()<<" "<<py->GetY()<<" )"<<endl;  
    }  
};  
  
namespace std{  
    template<>  
    void swap<Line>(Line& l1, Line& l2){      // std::swap()的特化版本，std::swap()只可以特化，不可以重载  
        cout<<"swap of std is called......"<<endl;  
        l1.swap(l2);  
    }  
}  
  
int main(int argc, _TCHAR* argv[])  
{  
    Line l1(1,1,2,2), l2(3,3,4,4);  
    swap(l1, l2);  
    l1.Print();  
    return 0;  
}  
```

​    在这个例子中，一共出现了5次swap这个函数：

 

​    第一次是main中调用的swap，这个调用的是我们自定义的std::swap()的特化版本

​    第二次是我们自己定义的std::swap()对Line类型的特化，在函数名前面有“template<>”

​    第三次是对Line特化的swap中调用的swap，也就是l1.swap(l2)，这个很明显是调用Line类型的swap()成员函数

​    第四次是Line类型中的成员函数，void swap(Line& l)，这个public函数的目的是供给非Line成员函数调用的，也就是特化版本的swap，因为只有类的成员函数才可以调用类的private成员变量

​    第五次是Line成员函数swap调用的swap，这个swap调用前面有个using std::swap的声明，表示后面调用的是std中的原始swap，当然不是特化版本的swap
​    其中可以被调用的swap有3个，std中原始的swap、std::swap的特化版本、Line中的成员函数swap，这3个函数中，真正给用户调用的只有第一个swap，也就是std::swap的Line特化版。通过这一系列函数就可以实现Line对象中指针成员的指针的交换，而不是Line对象整个的交换。

​    这种方式和STL容器有一致性，因为所有的STL容器也都提供有public swap成员函数和std::swap特化版本（用以调用前者）

​													**方案二、重载特化的std::swap** 

​    上面这种方式是针对Line和Point都是非template class，现在假设Line和Point都是template class，那么这种方式还可不可以了？

​    假设Line类和Point类都是template class，如下定义：

```cpp
#include <iostream>  
#include <string.h>  
  
template<typename T>  
class Point{  
private:  
     T x,y;  
public:  
     Point():x(0),y(0){};  
     Point(T a, T b):x(a),y(b){};  
     void Print(){  
          std::cout<< x << " "<< y <<endl;  
     }  
     T GetX(){  
          return x;  
     }  
     T GetY(){  
          return y;  
     }  
};  
  
template<typename T1, typename T2>  
class Line{  
private:  
     T1 px,py;  
public:  
     Line():px(),py(){};  
     Line(T2 a,T2 b,T2 c,T2 d):px(T1(a, b)), py(T1(c, d)){};  
     void Print(){  
          std::cout<<"( "<<px.GetX()<<" "<<px.GetY()<<" "<<py.GetX()<<" "<<py.GetY()<<" )"<<std::endl;  
     }  
     void swap(Line<T1, T2>& l){  
          std::cout<<"swap of Line is called......"<<std::endl;  
          using std::swap;  
          swap(px, l.px);  
          swap(py, l.py);  
     }  
};  
  
namespace std {  
    template<typename t1="" typename="" t2="">  
    void swap(Line<t1 t2="">& l1, Line<t1 t2="">& l2){  
        cout<<"swap of std is called......"<<std::endl;  
        l1.swap(l2);  
    }  
}  
  
int main()  
{  
    Line<Point<double>, double> l1(1, 1, 2, 2), l2(3, 3, 4, 4);  
    std::swap(l1, l2);  
    l1.Print();  
  
    return 0;  
  
}  
```

其中std里面的swap函数就是对std::swap的一个重载版本，然而，这个方式并不是特别的推荐，按照《effective c++》中的说法，这是一种非法的方式，是被C++标准禁止的，虽然能够编译和运行通过。

​												**方案三、非特化非重载的non-member swap**

​    我们可以声明一个非Line类成员函数swap，让其调用Line的成员函数swap，这个非成员swap也非特化的std::swap，如下所示：

```cpp
 #include <iostream>  
#include <string.h>  

template<typename T>
class Point {
private:
    T x, y;
public:
    Point() :x(0), y(0) {};
    Point(T a, T b) :x(a), y(b) {};
    void Print() {
        std::cout << x << " " << y << std::endl;
    }
    T GetX() {
        return x;
    }
    T GetY() {
        return y;
    }
};

template<typename T1, typename T2>
class Line {
private:
    T1 px, py;
public:
    Line() :px(), py() {};
    Line(T2 a, T2 b, T2 c, T2 d) :px(T1(a, b)), py(T1(c, d)) {};
    void Print() {
        std::cout << "( " << px.GetX() << " " << px.GetY() << " " << py.GetX() << " " << py.GetY() << " )" << std::endl;
    }
    void swap(Line<T1, T2>& l) {
        std::cout << "swap of Line is called......" << std::endl;
        using std::swap;
        swap(px, l.px);
        swap(py, l.py);
    }
};

template<typename T1, typename T2>
void swap(Line<T1, T2>& a, Line<T1, T2>& b) {
    std::cout << "swap of non-member is called......" << std::endl;
    a.swap(b);
}

int main()
{
    Line<Point<double>, double> l1(1, 1, 2, 2), l2(3, 3, 4, 4);
    std::swap(l1, l2);
    l1.Print();

    return 0;

}
```

 其实就是将方案二的std::swap重载改成了自定义的非成员函数，原理依然一样！

**请记住：**

​    1.当std::swap对你的类型效率不高时，提供一个swap成员函数，并确定这个函数不抛出异常。
​    2.如果你提供一个member swap，也该提供一个non-member swap用来调用前者。对于class（而非template），也请特化std::swap。
​    3.调用swap时应针对std::swap使用using声明式，然后调用swap并且不带任何“命名空间资格修饰符”。
​    4.为“用户定义类型”进行std template全特化是好的，但千万不要尝试在std内加入某些对std而言全新的东西。

##### 参考原文2：https://www.cnblogs.com/wuchanming/p/3735410.html

我也不知道为什么作者给这个条款起这样的名字，因为这样看上去重点是在“不抛出异常”，但事实上作者只是在全文最后一段说了一下不抛异常的原因，大部分段落是在介绍怎样写一个节省资源的swap函数。

你可以试一下，只要包含了头文件iostream，就可以使用swap函数，比如：

```cpp
1 #include <iostream>
2 
3 int main()
4 {
5     int a = 3;
6     int b = 4;
7     std::swap(a, b);
8 }
```

结果就是a为4，b为3了，也就是说，在std的命名空间内，已经有现成的swap的函数了，这个swap函数很简单，它看起来像这样：

```cpp
1 template<class T>
2 void swap(T& a, T& b)
3 {
4     T c = a;
5     a = b;
6     b = c;
7 }
```

这是最常见形式的两数交换了（特别地，当T是整数的时候，还可以使用异或的操作，这不是本条款讨论的重点，所以略过了，但面试题里面很喜欢问这个）。

假设存在一个类Element，类中的元素比较占空间：

```cpp
1 class Element
2 {
3 private:
4     int a;
5     int b;
6     vector<double> c;
7 };
```

Sample类中的私有成员是Element的指针，有原生指针，大多数情况下都需要自定义析构函数、拷贝构造函数和赋值运算符，像下面一样。

```cpp
1 class Sample
2 {
3 private:
4     Element* p;
5 public:
6     ~Sample();
7     Sample(const Sample&);
8     Sample& operator= (const Sample&);
9 };
```

在实现operator=的时候，有一个很好的实现方法，参见条款十一。大概像这样：

```cpp
1 Sample& operator= (const Sample& s)
2 {
3     if(this != &s)
4     {
5         Sample temp(s);
6         swap(*this, temp);
7     }
8     return *this;
9 }
```

当判断不是自我赋值后，是通过调用拷贝构造函数来创建一个临时的对象（这里可能会有异常，比如不能分配空间等等），如果这个对象因异常没有创建成功，那么下面的swap就不执行，这样不会破坏this的原始值，如果这个对象创建成功了，那么swap一下之后，把临时对象的值换成*this的值，达到了赋值的效果。

上面的解释是条款九的内容，如果不记得了，可以回头翻翻看，本条款的重点在这个swap函数上。这里调用的是默认的std里面的swap函数，它会创建一个临时的Sample对象（拷贝构造函数），然后调用两次赋值运算，这就会调回来了，即在swap函数里面调用operator=，而之前又是在operator=中调用swap函数，这可不行，会造成无穷递归，堆栈会溢出。

因此，我们要写一份自己的swap函数，这个函数是将Sample里面的成员进行交换。

问题又来了，Sample里面存放的是指向Element的指针，那是交换指针好呢，还是逐一交换指针所指向的对象里面的内容好呢？Element里面的东西挺多的，所以显然还是直接交换指针比较好（本质是交换了Element对象存放的地址）。

因此，可以定义一个swap的成员函数。像这样：

```cpp
 1 void swap(Sample& s)
 2 {
 3     std::swap(p, s.p);
 4 }
 5 Sample& operator= (const Sample& s)
 6 {
 7     if(this != &s)
 8     {
 9         Sample temp(s);
10         this->swap(s);
11     }
12     return this;
13 }
```

但这样看上去有点别扭，我们习惯的是像swap(a, b)这种形式的swap，如果交给其他程序员使用，他们也希望在类外能够像swap(SampleObj1, SampleObj2)那样使用，而不是SampleObj1.swap(SampleObj2)。为此我们可以在std空间里面定义一个全特化的版本（std namespace是不能随便添加东西的，只允许添加类似于swap这样的全特化版本），像这样：

```cpp
1 namespace std
2 {
3 template<>
4 void swap<Sample>(Sample &s1, Sample &s2)
5 {
6     s1.swap(s2); // 在这里调用类的成员函数
7 }
8 }
```

重写operator=，像下面这样：

```cpp
1 Sample& operator= (const Sample& s)
2 {
3     if(this != &s)
4     {
5         Sample temp(s);
6         swap(*this, s); // 顺眼多了，会先去调用特化版本的swap
7     }
8     return *this;
9 }
```

这样，就可以在使用namespace std的地方用swap()函数交换两个Sample对象了。

下面书上的内容就变难了，因为假设Sample现在是一个模板类，Element也是模板类，即：

```cpp
1 template <class T>
2 class Element
3 {…};
4 
5 template <class T>
6 class Sample
7 {…};
```

那应该怎么做呢？

在模板下特化std的swap是不合法的（这叫做偏特化，编译器不允许在std里面偏特化），只能将之定义在自定义的空间中，比如：

```cpp
 1 namespace mysample
 2 {
 3     template <class T>
 4 class Element
 5 {…};
 6 
 7 template <class T>
 8 class Sample
 9 {…};
10 
11 template <class T>
12 void swap(Sample<T> &s1, Sample<T> &s2)
13 {
14     s1.swap(s2);
15 }
16 }
```



总结一下，当是普通类时，可以将swap的特化版本放在std的namespace中，swap指定函数时会优先调用这个特化版本；当是模板类时，只能将swap的偏特化版本放在自定义的namespace中。好了，问题来了，这时候用swap(SampleObj1, SampleObj2)时，调用的是std版本的swap，还是自定义namespace的swap？

事实上，编译器还是会优先考虑用户定义的特化版本，只有当这个版本不符合调用类型时，才会去调用std的swap。但注意此时：

```cpp
1 Sample& operator= (const Sample& s)
2 {
3     if(this != &s)
4     {
5         Sample temp(s);
6         swap(*this, s); // 前面的swap不要加std::
7     }
8     return *this;
9 }
```

里面的swap不要用std::swap，因为这样做，编译器就会认为你故意不去调用位于samplespace里面的偏特化版本了，而去强制调用std命名空间里的。

为了防止出这个错，书上还是建议当Sample是普通类时，在std命名空间里定义一个全特化版本。

这个条款有些难度，我们总结一下：

\1. 在类中提供了一个public swap成员函数，这个函数直接交换指针本身（因为指针本身是int类型的，所以会调用std的普通swap函数），像下面这样：

```cpp
1 void Sample::swap(Sample &s)
2 {
3     swap(p, s.p); // 也可以写成std::swap(this->p, s.p);
4 }
```

\2. 在与Sample在同一个namespace的空间里提供一个non-member swap，并令他调用成员函数里的swap，像下面这样：

```cpp
1 template <>
2 void swap<Sample>(Sample& s1, Sample& s2){s1.swap(s2);} // 如果Sample是普通类，则定义swap位于mysample空间中，同时多定义一个位于std空间中（这个多定义不是必须的，只是防御式编程）
```

或者

```cpp
1 template <class T>
2 void swap(Sample<T>& s1, Sample<T>& s2){s1.swap(s2);} // 如果Sample是模板类时，只能定义在mysample空间中
```

好了，最后一段终于说到了不抛异常的问题，书上提到的是不要在成员函数的那个swap里抛出异常，因为成员函数的swap往往都是简单私有成员（包括指针）的置换，比如交换两个int值之类，都是交换基本类型的，不需要抛出异常，把抛出异常的任务交给non-member的swap吧。

 

# 五、实现

### 条款27: 尽量少敝转型动作

​													**1. C和C++的三种形式的转型语法**

(1)形式一：C语言风格的转型语法：

```cpp
 (T)expression     //将expression转换为T类型
```

(2)形式二:函数风格的转型：

```cpp
T(expression)     ////将expression转换为T类型
```

(3)形式三：C++风格的转型语法

- `const_cast(expression);//const->non const`
  const_cast 用来将对象的const属性去掉,功能单一,使用方便,呵呵.
- `dynamic_cast(expression);`
  dynamic_cast 用于继承体系下的"向下安全转换",通常用于将基类对象指针转换为其子类对象指针,它也是唯一一种无法用旧式转换进行替换的转型,也是唯一可能耗费重大运行成本的转型动作.
- `reinterpret_cast(expression);`
  低级转型,结果依赖与编译器,这因为着它不可移植,我们平常很少遇到它,通常用于函数指针的
  转型操作.
- `static_cast(expression);`
  static_cast 用来进行强制隐式转换,我们平时遇到的大部分的转型功能都通过它来实现.例如将int转换为double,将void*转换为typed指针,将non-const对象转换为const对象,反之则只有const_cast能够完成.

注意：形式一、二并无差别，统称旧式转型，形式三称为新式转型。

​                                                                           **新式转型的优点**

- 在代码这种容易被识别出来(无论是人工识别还是使用工具如grep)，因而简化“找出类型系统在哪个点被破坏”的过程(简化找错的过程)。

- 各种转型动作的目标越窄化，编译器越能判断出出错的运用。例如：如果你打算将常量性去掉，除非使用新式转型的const_cast否则无法通过编译

  ​																**旧式转型的唯一适用场景**

我唯一使用旧式转型的时机是，当我调用一个explicit构造函数将一个对象传递给一个函数时。例如：

```cpp
  class Widget{
    public:
        explicit Widget(int size);
        ...
    };
    void doSomething(Widget& w);
    doSomething(Widget(15)); //"旧式转型"中的函数转型
    doSomething(static_cast<Widget>(15));//"新式转型"
```



消除一个误解：转型动作其实什么也没做

> ##### (1)误解
>
> 请不要认为转型什么都没做，其实就是告诉编译器把某种类型视为另一种类型。实际上，任何一种转型动作往往真的令编译器额外地编译出运行期间执行的代码。
> 例如将int转型为double就会发生这种情况,因为在大部分的计算器体系结构中,int的底层表述不同于double的底层表述。
>
> ##### (2) 转型动作导致编译器在执行期间编译出不同的码的另外一个例子
>
> **单一的对象可能拥有一个以上的地址**(例如:"以base*指向它"时的地址和"以Derived*指向它"时的地址这时会有一个偏移量在运行期间施加在Derived*身上，用以取得正确的base*的指针值）。实际上一旦使用多重继承,这事几乎一直发生。即使在单一继承中也可能发生。
>
> ##### (3)我们应该避免作做出“对象在C++中如何布局”的假设
>
> 有了偏移量这个经验后，我们也不能做出“对象在C++中如何布局”的假设。因为对象的布局方式和它们的地址计算发式随着编译器的不同而不同,这就以为着写出"根据对象如何布局"而写出的转型代码在某一平台上行得通,在其它平台上则不一定。很多程序员历经千辛万苦才学到这堂课。



​												**2、转型动作容易写出似是而非的代码**

有些场景下，需要在派生类的virtual函数中调用基类的版本的次函数：

```cpp
    class Window{
    public:
        virtual void onResize(){...}
        ...
    };
    class SpecialWindow:public Window{
    public:
        virtual void onResize(){
            static_cast<Window>(*this).onResize();//调用基类的实现代码
            ... //这里进行SpecialWindow的专属行为.
        }
        ...
    };
```

上述代码看着似乎合情合理，但是实际却是错误的。错在转型语句。为什么错呢？首先它确实执行了多态，调用的函数版本是正确的，但是由于做了转型，它并没有真正作用在派生类对象身上，而是作用在了派生类对象的基类部分的副本身上，改动的是副本。但是如果改动当前对象的派生类部分的话，不做转型动作就真的改变了当前对象的派生类部分。但是导致的最终结果就是：当前对象的基类部分没有被改动，但是派生类部分缺被改动了。

上述代码的正确写法：

```cpp
    void SpecialWindow::onResize(){
        Window::onResize(); //此时才是真正的调用基类部分的onResize实现.
        ...     //同上
    }
```

​								

​								**3、何时需要dynamic_cast，以及避dynamic_cast的方法**

(1)何时需要dynamic_cast?

通常当你想在一个你认定为derived class对象上执行derived class操作函数时，但是你的手上只有一个指向base 的指针或引用时，你会想到使用dynamic_cast进行转型

(2)如何不做转型，实现上述需求？

通常有两种做法可以解决上述问题：

- 方法一：使用容器，并在其中存储直接指向derived class对象的指针(通常是智能指针)，这样就避免了上述需求。

- 方法二：在base class内提供virtual函数做你想对各个派生类想做的事情。这样可以使得你通过base class
  接口处理“所有可能之各种派生类”。

  ​													**绝对避免一连串的dynamic_cast**

一连串dynamic_cast的代码又大又慢，而且基础不稳，因为每次继承体系一有改变，所有这种代码必须再次进行检查看看是否需要修改。例如假如新的派生类，就要加新的分支。这样的代码应该使用“基于virtual函数调用”的东西取而代之。



**请记住**

- 如果可以，尽量避免转型，特别是在注重效率的代码中避免dynamic_casts。如果有个设计需要转型动作，试着发展无需转型的替代设计。
- 如果转型是必要的，试着将它隐藏于某个函数背后。客户随后可以调用该函数，而不需将转型放进他们自己的代码内。
- 宁可使用C++-style（新式）转型，不要使用旧式转型。前者很容易辨识出来，而且也比较有着分门别类的职掌。



### 条款28：避免返回handles 指向对象内部成分

- reference、指针、迭代器系统都是所谓的handles(号码牌，用来获得某个对象)。函数返回一个handle，随之而来的便是“减低对象封装性”的风险。它也可能导致：虽调用const成员函数却造成对象状态被更改的风险。 

- 返回handles 指向对象内部成分 

  - 可能带来的问题一：自相矛盾

  ```cpp
  class Point{
  public:
         Point(intx,inty);
         voidsetX(intnewVal);
         voidsetY(intnewVal);
  };
  
  struct RectData{
         Pointulhc;
         Pointlrhc;
  };
  
  class Rectangle{
  public:
         Point&upperLeft()const{returnpData->ulhc;}
         Point&lowerRight()const{returnpData->lrhc;}
         ...
  private:
         std::tr1::shared_ptr<RectData>pData;
  };
  
  ```

  > point 类是一个代表点的类，RectData代表一个矩形的结构，Rectangle类则代表一个矩形，该类能够返回表示矩阵的左上和右下的两个点。由于这两个函数为const的，因此所要表达的意思就是，返回矩阵的两个点，但是不能修改他们。但是又由于返回的是点的reference形式，因此通过reference，实际是可以改变返回的点的数据的。因此，造成了自相矛盾。问题的原因就是，函数返回了handle。 
  >
  > 由此可知：
  >
  > - **成员变量的封装性最多等于“返回其reference”的函数的访问级别。**即使数据本身被声明为private的，但是如果返回他们的reference是public的，那么数据的访问权限就编程public了。
  > - 如果const成员函数传出一个reference，后者所指数据又不在自身对象内，那么这个函数的调用者可以修改此数据。(这是 bitwise constness 带来的后果。)

  - 改进：返回**const handles** 指向对象内部成分 可能带来的问题：解决了自相矛盾，却可能形成**虚吊问题**

    ```cpp
    class Rectangle{
    public:
           //加const。这便解决了自相矛盾问题
           const Point&upperLeft()const{returnpData->ulhc;} 
           const Point&lowerRight()const{returnpData->lrhc;}
           ...
    private:
           std::tr1::shared_ptr<RectData>pData;
    };
    ```

- 无论返回的handle是指针、reference、或者迭代器，也无论他是否为const。只要一个handle被传出去了，都是比较危险的。 



请记住

- 避免返回handles（包括references、指针、选代器）指向对象内部。遵守这个条款可增加封装性，帮助const成员函数的行为像个const，并将发生“虚吊号码牌”（dangling handles）的可能性降至最低。



### 条款29: 为“异常安全”而努力是值得的

1. 异常安全的两个条件：当异常抛出时，①不泄漏任何资源；②不允许数据败坏；
2. 解决资源泄漏：使用“资源管理类”；
3. 异常安全函数提供以下三个保证之一：①基本承诺：保证对象和数据结构，不保证程序状态；②强烈保证：程序状态不改变；③不抛掷承诺：总能完成功能（作用于内置类型上的所有操作都可做到）；
4. 为做到强烈保证：①见第2条；②重新排列对象内语句次序的策略：不要为了表示某件事情发生而改变对象状态，除非那件事情真的发生了；
5. copy and swap 策略往往可以实现强烈保证：在对象的副本上完成修改后，再与原对象在一个不抛出异常的操作中置换（pimpl idiom通过指针实现此策略）；
6. “强烈保证”并非对所有函数都可实现或具备现实意义；
7. 异常安全保证具有木桶效应；

总结

1. 资源管理类不仅防止了资源泄漏，同时缩短原函数的语句，减少了数据败坏的复杂度；
2. 尽量实现更高的异常安全保证等级。



### 条款30：透彻了解inlining的里里外外

- inlining函数可以免除函数调用成本的开销，且编译器可对其执行语境相关的最优化，但需考虑object code 的大小；

- inline的隐喻方式：将函数定义于class定义式内；明确声明方式：在其定义式前加上关键字 inline；

- inline函数通常一定被置于头文件内，因为inlining大部分情况下都是编译期行为；template通常也被置于头文件内，因为大部分建置环境都是在编译期完成具现化动作；

- 如果一个template具现出来的函数都应该inlined，则将此template声明为inline，否则应避免此声明；

- inline**只是对编译器**的一个**申请**，不是强制命令。大多数编译器如无法将要求的函数inline化，会给出一个警告信息；

- 慎重决定inlining施行范围：将大多数inlining限制在小型、被频繁调用的函数身上，以便于日后的调试和二进制升级。

  > - 编译器通常不对“通过函数指针而进行的调用”实施inlining，且需考虑后续代码维护用到函数指针的可能；
  > - 构造函数和析构函数并不适合用于inlining，往往会引起代码的膨胀（所不要随便地将构造函数和析构函数的定义体放在类声明中）；
  > - inline函数代码如发生改变，所有用到该inline函数的程序都必须重新编译；
  > - 大部分调试器都不能对inline函数进行调试；



总结：

1. 如果inline函数不能增强性能，就避免使用它；
2. inline修饰符用于解决一些频繁调用的小函数大量消耗栈空间（栈内存）的问题；
3. inline函数本身不能是直接递归函数；
4. 将成员函数的定义体放在类声明之中（隐喻方式）虽然能带来书写上的方便，但不是一种良好的编程风格；
5. 关键字inline 必须与函数定义体放在一起才能使函数成为内联，仅将inline 放在函数声明前面不起任何作用，即inline 是一种“用于实现的关键字”；声明前可以加inline关键字，但不符合高质量C++/C 程序设计风格的一个基本原则：声明与定义不可混为一谈，用户没有必要、也不应该知道函数是否需要内联。



### 条款31：将文件间的编译依存关系降至最低

- 一个简洁明了的解答： https://www.zhihu.com/question/52832178/answer/192499529 

-  一个 pimpl 手法的例子 ：http://t.csdn.cn/qzlzt

   **student.h** 

  ```cpp
  #pragma once
  #include <memory>
  
  
  class StudentImpl;
  
  class Student {
  public:
      Student(int Id);
      
      /** 因为此处智能指针使用的是 unique_ptr ，它为了保证高效性，
       * 其删除器是自身的一部分，它必须保证 raw pointer 为 complete 对象。
       * 由于编译器默认生成的析构函数是 inline ，
       * 此时 Impl 所指之物仅仅是前置声明，是一个 non-complete 对象，所以会报错。
       * 因此如果使用 unique_ptr 而不是 shared_ptr 实现 Impl时，
       * 不要使用默认的析构行为，请自行额外实现。
       * 因为shared_ptr不使用自身的 deleter，无需这种保证。
       */
      ~Student();
      
      Student(const Student&) = delete;
      Student& operator=(const Student&) = delete;
      Student(Student&&) = delete;
      Student& operator=(Student&&) = delete;
      void SetId(int Id) const;
      int GetId() const;
  private:
      std::unique_ptr<StudentImpl> Impl;
  };
  ```

   **student.cpp** 

  ```cpp
  #include "Student.h"
  
  
  class StudentImpl {
  public:
      StudentImpl(int mId) {
          Id = mId;
      }
  
      ~StudentImpl() = default;
      StudentImpl(const StudentImpl&) = default;
      StudentImpl& operator=(const StudentImpl&) = default;
      StudentImpl(StudentImpl&&) = default;
      StudentImpl& operator=(StudentImpl&&) = default;
  
      void SetId(int mId) {
          Id = mId;
      }
  
      int GetId() const {
          return Id;
      }
  
  private:
      int Id;
  };
  
  Student::Student(int Id): Impl(std::make_unique<StudentImpl>(Id)) {}
  Student::~Student() = default;
  
  void Student::SetId(int Id) const {
      Impl->SetId(Id);
  }
  
  int Student::GetId() const {
      return Impl->GetId();
  }
  ```

   **main.cpp** 

  ```cpp
  #include <iostream>  
  #include "student.h"
  
  int main()
  {
      const Student Moota(233);
      std::cout << Moota.GetId() << "\n";
  
      Moota.SetId(666);
      std::cout << Moota.GetId() << "\n";
  
      return 0;
  
  }
  ```

请记住

- 支持编译依存性最小化的一般构想是：相依于声明式，不要相依于定义式。基于此构想的两个手段是 Handle classes 和 Interface classes。
- 程序库头文件应该以完全且仅声明式（full and declaration-only forms）的形式存在。这种做法不论是否涉及 templates 都适用。



# 六、继承与面向对象设计

### 条款32：确定你的public继承保证了is-a关系

-  public继承的意思是：**子类是一种特殊的父类**，这就是所谓的“is-a”关系。 

-  在使用public继承时，**子类必须涵盖父类的所有特点，必须无条件继承父类的所有特性和接口**。 

  > 如果你令 class D 以 public 的方式继承 class B，你便是告诉 C++ 编译器和你的客户：**每一个类型为 D 的对象，同时也是一个类型为 B 的对象**，反之则不成立。类型 B 比 类型 D 表现出更一般的概念，而类型 D 比类型 B 表现出更特殊化的概念。B 对象可使用到的地方，D 对象都可以派上用场。反之，如果你需要对象 D ，B 对象并不能效劳，因为 **B 对象并不具备 D 对象所含有的特殊化信息。**

-  虽然 public 继承意味着 is-a 的关系看似简单，但有时候如果单纯偏信生活经验，会犯错误。 例如：

  -  鸵鸟是不是鸟 

    >  如果我们考虑飞行这一特性（或接口），那么鸵鸟类在继承中就绝对不能用public继承鸟类，因为鸵鸟不会飞，我们要在**编译阶段消除调用飞行接口的可能性**；但如果我们关心的接口是下蛋的话，按照我们的法则，鸵鸟类就可以public继承鸟类。 

    ```cpp
    class Bird {  //没有声明 fly 函数
    public:
        virtual ~Bird();
    };
    	
    class Penguin : public Bird { 	   //没有声明 fly 函数
    public:
        //...
    };
    
    inline void Try(){
    	Penguin P;
    	P.fly();  //编译阶段就会报错！
    }
    ```

  -  矩形和正方形 

    > 生活经验告诉我们正方形是特殊的矩形，但这并不意味着在代码中二者可以存在public的继承关系，矩形具有长和宽两个变量，但正方形无法拥有这两个变量——没有语法层面可以保证二者永远相等，那就不要用public继承。 

- 总结

  - **public 继承意味 is-a。**适用于 base classes 身上的每一件事情一定也适用于 derived classes 身上，因为每一个 derived class 对象也都是一个 base class 对象。
  - 在确定是否需要public继承的时候，我们首先要搞清楚**子类是否必须拥有父类每一个特性**，如果不是，则无论生活经验是什么，都不能视作”is-a”的关系。**public继承关系不会使父类的特性或接口在子类中退化，只会使其扩充。** 



### 条款33：避免遮掩继承而来的名称

-  遮掩名称：

  > 当编译器在 func 的作用域并使用 x 时，它会先在 local 作用域查找是否存在该变量，如果找不到在扩大作用域。显然，编译器会在 local 找到 double x，然后停止查找，这意味着在 local 中使用 x，将总是找到 double x，而非 global 作用域的 int x。这便是我们所说的：遮掩名称。

  ```cpp
  int x=1;   //全局变量
  void func() {
     double x=1.1;  //局部变量
     std::cout<<x<<"\n";
  }
  ```

- 该条款研究的是继承中多次重载的虚函数的**名称遮盖问题**，如果在你设计的类中没有涉及到对同名虚函数做多次重载，请忽略本条款。 

  > 在父类中，虚函数`foo()`被重载了两次，可能是由于参数类型重载（`foo(int)`），也可能是由于`const`属性重载(`foo() const`)。如果子类仅对父类中的`foo()`进行了覆写，那么在子类中父类的另外两个实现(`foo(int)` ,`foo() const`)也无法被调用，这就是名称遮盖问题——名称在**作用域级别的遮盖是和参数类型以及是否虚函数无关的**，即使子类重载了父类的一个同名，父类的所有同名函数在子类中都被遮盖 

-  继承中的遮掩

  ```cpp
  class Base {
  public:
     virtual void mf1()=0;
     virtual void mf1(int);
     virtual void mf2();
     void mf3();
     void mf3(double);
  private:
  };
  
  class Derived : public Base {
  public:
     virtual void mf1();
     void mf3();
  };
  
  inline void Try() {
     Derived d;
     int x;
     d.mf1();   //没问题，调用Derived::mf1
     d.mf1(x);  //报错，因为 derived::mf1 遮掩了 base:: mf1 (int) 
     d.mf2();	  //没问题，调用Base::mf2
     d.mf3();	  //没问题，调用Derived::mf3
     d.mf3(4);  //报错，因为 derived::mf3 遮掩了 base::mf3 （double）
  }
  ```

- 避免遮掩名称的方式 

  -  使用 using 声明式 

    > 让 base class 内的某些事物可以在 derived class 作用域中可见。
    >
    > 注意使用 using 声明式的权限符为 public，注意不要违反继承时的继承权限。对于 public 继承，并不是所有的函数都被继承，因而不是所有的函数都可以进行声明访问。**尝试声明无法访问的函数，编译器会自动报错**。 

    ```cpp
    class Derived : public Base {
    public:
       using Base::mf1;
       using Base::mf3;
       virtual void mf1();
       void mf3();
    };
    ```

  - 使用转交函数（forwarding function） 

    > 例如假设Derived以private形式继承Base，而Derived唯一想继承的mf1是那个无参数版本。using声明式在这里派不上用场，因为using声明式会令继承而来的某给定名称之所有同名函数在derived class中都可见。不，我们需要不同的技术，即一个简单的转交函数(forwarding function)

    ```cpp
    class Base {
    public:
       virtual void mf1()=0;
       virtual void mf1(int);
       virtual void mf2();
       void mf3();
       void mf3(double);
    private:
       int x;
    };
    
    class Derived : private Base {
    public:
       virtual void mf1() { //转交函数（forwarding function）
          Base::mf1();      //暗自成为inline
       }
       ...
    };
    
    inline void Try() {
       Derived d;
       int x;
       d.mf1();   //没问题，调用Derived::mf1
       d.mf1(x);  //报错，  Base::mf1()被遮掩了 
    }
    ```

总结：

1. derived classes 内的名称会遮掩 base classes 内的名称。在 public 继承下从来没有人希望如此。
2. 为了让被遮掩的名称再见天日，可使用 using 声明式或转交函数（forwarding functions）。



### 条款34：区分接口继承和实现继承

- public 继承其实可以分成：`函数接口（function interfaces）`继承和`函数实现（function implemention）`继承。这意味着 derived class 不仅可以有 base class 函数的声明，还可以有 base class 函数的实现。 

- 成员函数的`接口总是会被继承`。因为条款32曾说：public 继承是 is-a 的关系，任何可以作用于 base class 的函数也一定可以作用于 derived class。 

-  不同类型的函数代表了**父类对子类实现过程中不同的期望**。 

  - 在父类中声明纯虚函数，是为了**强制子类拥有一个接口**，并**强制子类提供一份实现**。
  - 在父类中声明虚函数，是为了**强制子类拥有一个接口**，并**为其提供一份缺省实现**。
  - 在父类中声明非虚函数，是为了**强制子类拥有一个接口以及规定好的实现**，并不允许子类对其做任何更改（条款36要求我们不得覆写父类的非虚函数）。

  > 在这其中，有可能出现问题的是普通虚函数，这是因为父类的缺省实现并不能保证对所有子类都适用(具体请看Cherno的CppSeriesP28、29)，因而当子类忘记实现某个本应有定制版本的虚函数时，父类应**从代码层面提醒子类的设计者做相应的检查**，很可惜，普通虚函数无法实现这个功能。一种解决方案是，在父类中**为纯虚函数提供一份实现**，作为需要主动获取的缺省实现，当子类在实现纯虚函数时，检查后明确缺省实现可以复用，则只需调用该缺省实现即可，这个主动调用过程就是在代码层面提醒子类设计者去检查缺省实现的适用性。 

  ```cpp
  class Airplane {
  public:
      virtual ~Airplane() = default;
  
      //pure-virtual  子类继承函数接口，强制覆写
      virtual void ToString() const =0;
      //impure-virtual/virtual  子类继承函数接口和默认函数实现，可覆写
      virtual void Fly();
      //non-virtual   子类继承函数接口和默认函数实现，不可覆写
      void DefaultFly();
  };
  
  class ModelA : public Airplane { //public 子类继承函数接口
  public:
      void ToString() const override;
      void Fly() override;
  };
  ```

- 将纯虚函数、虚函数区分开的并不是在父类有没有实现——纯虚函数也可以有实现，其二者本质区别在于父类对子类的要求不同，前者在于**从编译层面提醒子类主动实现接口**，后者则侧重于**给予子类自由度对接口做个性化适配**。非虚函数则没有给予子类任何自由度，而是要求子类坚定的遵循父类的意志，**保证所有继承体系内能有其一份实现**。 

- 两个常见错误：

  -  将**所有**函数都声明为 **non-virtual**。 

    > 这会使得 derived class 没有余裕空间进行特化工作。non-virtual 函数还会带来析构问题，见条款7。实际上任何 class 如果打算使用多态性质，都会有若干 virtual 函数。如果你关心 virtual 函数的成本，请参考 80-20 法则：一个典型的程序有80%的执行时间花费在20%的代码身上。这个法则十分重要，这意味着平均而言你的函数调用中可以有80%是virtual，而不冲击程序的大体效率。所以当你担心是否有能力负担 virtual 函数的运行成本时，先关注那举足轻重的20%代码身上。

  - 另一个常见错误是将**所有**函数都声明为 **virtual**。

    > 有时候是正确的，比如 interfaces class。然而这也可能是 class 设计者缺乏坚定立场的表现，某些函数就是不该在 derived class 中被重新实现，你就应该把它声明为 non-virtual。



总结：

1. 接口继承和实现继承不同。在 public 继承之下，derived class 总是继承 base class 的接口。
2. pure virtual 函数只具体指定接口继承。
3. 简朴的（非纯）impure virtual 函数具体指定接口继承及缺省实现继承。
4. non-virtual 函数具体指定接口继承以及强制性实现继承。



### 条款35：考虑 virtual 函数以外的其他选择

C++的virtual函数让我们能方便地实现接口继承与实现继承，但同时也会让我们忽略可能的其他方案。本条款针对于virtual函数的功能设计了具有不同优缺点的替代方案。 

> 假如你在设计一款游戏，涉及到各式角色的健康情况，但不同角色的健康度是不同的，这时候将计算健康度的函数**声明为 virtual** 似乎是再明白不过的做法： 

```cpp
class Character {
public:
    virtual ~Character()=default;
    virtual int CalculateHealthValue() const;
};

class NpcEvil:public Character {
public:
    virtual int CalculateHealthValue() const override;
};
```

这的确是再**明白不过的设计**，但是从某个角度说却**反而成了它的弱点**。由千这个设计如此明显，你可能因此没有认真考虑其他替代方案。为了帮助你跳脱面向对象设计路上的常轨，让我们考虑其他一些解法。

- #### 藉由 `Non-Virtual Interface` 手法 （NVI） 实现 Template Method 模式 

  > 有一个有趣的思想流派**主张 virtual 函数应该几乎总是 private**。这个流派建议：`保留 CalculateHealthValue 为 public 成员函数，但让它成为 non-virtual，并调用一个 private virtual 函数（例如 OnCalculateHealthValue）进行实际工作`

  ```cpp
  class Character {
  public:
      virtual ~Character()=default;
      int CalculateHealthValue() const {
          const int Result= OnCalculateHealthValue();
          //...
          return Result;
      }
  private:
      virtual int OnCalculateHealthValue()const=0;
  };
  
  class NpcEvil:public Character {
  private:
      int OnCalculateHealthValue() const override {
          return 100;
      }
  };
  //这种设计方式：令客户通过 public non-virtual 成员函数间接调用 private virtual 函数，称为 non-virtual interface （NVI）手法。
  ```

  值得注意的一点，**C++ 允许 derived class 覆写 base class 的 private virtual 方法**。看起来诡异，但这是真的。

  - 优点

  - 

    > NVI 手法的一个优点是可以在调用 private virtual 函数前后做一些额外的事情，其实这也是封装带来的好处。调用之前可以做的工作：锁定互斥器，制造运转日志记录项，验证 class 约束条件，验证函数先决条件等等。调用之后可以做的工作：互斥器解除锁定，验证函数的事后条件，再次验证 class 约束条件等等。但假如没有这一层封装，直接调用 virtual 函数，就没有任何好办法可以做这些事。

  - 缺点

    > 在某些class继承体系中，virtual函数必须调用其base class的版本，这就导致virtual函数必须是protected而不能是private，有些时候virtual函数甚至一定得是public。在这种情况下，non-virtual成员函数和virtual成员函数都是public的，NVI的wrapper手法显然就不成立了 

- #### 藉由 `Function Pointers` 实现 Strategy 模式 

  > NVI 手法对于 public virtual 函数而言是一个有趣的设计，但从某种设计角度来看，这仅仅多了一层装饰而已，毕竟我们还是使用 virtual 函数计算每一个角色的健康指数。另一种更具戏剧性的做法主张：人物健康指数的计算与人物类型无关，这样的计算完全不需要人物这个成分。
  >
  > 例如我们可能要求每个人物的构造函数接受一个指针，指向一个健康计算函数，我们可以调用该函数进行实际计算：

  ```cpp
  class Character {
  public:
      virtual ~Character() = default;
  	// 函数指针类型定义
      typedef int (*FCalculateHealthValueFunc)(const Character&);
  
      explicit Character(FCalculateHealthValueFunc InCalculateHealthValueFunc) : CalculateHealthValueFunc(
          InCalculateHealthValueFunc) { }
  
      int CalculateHealthValue() const {
          const int Result = CalculateHealthValueFunc(*this);
          //...
          return Result;
      }
  
      void SetCalculateHealthValueFunc(FCalculateHealthValueFunc InCalculateHealthValueFunc) {
          CalculateHealthValueFunc = InCalculateHealthValueFunc;
      }
  
  private:
      FCalculateHealthValueFunc CalculateHealthValueFunc;
  };
  
  class NpcEvil : public Character {
  public:
      explicit NpcEvil(FCalculateHealthValueFunc InCalculateHealthValueFunc)
          : Character(InCalculateHealthValueFunc) {}
  };
  
  int main()
  {
      //NpcEvil Moota([](const Character&) {
      //    return 100;
      //    });
      auto lam = [](const Character&) {
          return 1000;
      };
      NpcEvil Moota(lam);
      NpcEvil Vicky([](const Character&) {
          return 10000;
          });
      std::cout << Moota.CalculateHealthValue() << "\n";
      std::cout << Vicky.CalculateHealthValue() << "\n";
  
      //小宇宙爆发
      Moota.SetCalculateHealthValueFunc([](const Character&) {
          return 99999;
          });
      std::cout << Moota.CalculateHealthValue() << "\n";
  }
  ```

  - 优点：

    - 同一人物类型的不同实例`可以有不同的健康计算函数`。只需提供不同的函数指针进行初始化。
    - 某已知人物的健康计算函数`可在运行期变更`。只需提供类似 Setter 函数即可替换用于计算健康度的函数。

  - 缺点：

    - 这种指针函数只能访问 class 的 public 成分 

      > 如果人物的健康可纯粹根据人物 public 接口得来的，这种设计没有问题，但如果需要 non-public 信息进行精确计算，就有问题了。 实际上任何时候当你将 class 内的某个机能由 non-member 函数实现，都会存在这样的额外难题。 
      >
      > 唯一能解决该问题的办法就是弱化class的封装，比如声明外部函数为friend，或者为函数的实现提供一些public访问函数。所以到底是要良好的封装性，还是要上面的两个优点，则需要根据具体情况仔细分析一下。 
      >
      > 另一种思路：
      >
      > 把外部函数指针改成类成员函数指针可以同时享有这两个优点，并且不用弱化class的封装性。但这会导致class内部的函数冗杂，并且该健康计算函数不能再不同class中复用

- ####  藉由 `tr1::function` 完成 Strategy 模式 

  > 一旦习惯了 templates 以及它们对隐式接口的使用，见条款41的使用，基于函数指针的做法看起来就苛刻死板了。为什么要求计算健康指数必须是个函数，而不是**某些看起来像函数的东西**，例如函数对象？如果是函数，为什么不能是个成员函数，为什么一定返回 int 而不是任何可被转换为 int 的类型呢？
  >
  > 实际上如果我们不再使用函数指针，而是改用一个类型为 **tr1::function** 的对象，这些约束就全不见了。就像条款54所说，这样的对象可持有任何可调用之物，只要其签名式满足于需求：

  ```cpp
  #include <functional>
  class Character {
  public:
      virtual ~Character() = default;
      //接受一个reference 指向const Character, 并返回int
      typedef std::function<int(const Character&)> FCalculateHealthValueFunc; //注意 const & 不能隐式转化
  
      explicit Character(FCalculateHealthValueFunc InCalculateHealthValueFunc) : CalculateHealthValueFunc(
          InCalculateHealthValueFunc) { }
  
      int CalculateHealthValue() const {
          const int Result = CalculateHealthValueFunc(*this);
          //...
          return Result;
      }
  
      void SetCalculateHealthValueFunc(FCalculateHealthValueFunc InCalculateHealthValueFunc) {
          CalculateHealthValueFunc = InCalculateHealthValueFunc;
      }
  
  private:
      FCalculateHealthValueFunc CalculateHealthValueFunc;
  };
  
  class NpcEvil : public Character {
  public:
      explicit NpcEvil(FCalculateHealthValueFunc InCalculateHealthValueFunc)
          : Character(InCalculateHealthValueFunc) {}
  };
  
  class FCalculator {
  public:
      static double CalculateHealthGM(const Character& InNpcEvil) {
          return 2147483647;
      }
  
      int CalculateHealthNormal(const Character& InNpcEvil) {
          return 5;
      }
  
  };
  
  int main() {
      //函数指针仍然适用
      NpcEvil Moota([](const Character&) {
          return 100;
          });
      std::cout << Moota.CalculateHealthValue() << "\n";
  
      //使用返回值为 double 的 static member函数
      Moota.SetCalculateHealthValueFunc(&FCalculator::CalculateHealthGM);
      std::cout << Moota.CalculateHealthValue() << "\n";
  
      FCalculator Calculator;
  
      //使用某对象的 member函数
      Moota.SetCalculateHealthValueFunc(std::bind(&FCalculator::CalculateHealthNormal, Calculator,
          std::placeholders::_1));
      std::cout << Moota.CalculateHealthValue() << "\n";
  }
  ```

总结：

- virtual 函数的替换方案包括 NVI 手法以及 Strategy 设计模式的多种形式。NVI 手法自身是一个特殊形式的 Template Method 设计模式。
- 将机能从成员函数移到 class 外部函数，带来的一个缺点是，非成员函数无法访问 class 的 non-public 成员。
- tr1::function 对象的行为就像一般函数指针。这样的对象可接纳与给定之目标签名式（target signature）兼容的所有可调用物（callable entites）。



### 条款36：绝不重新定义继承而来的 non-virtual 函数

- 如果你的函数**有多态调用的需求**，一定记得把它**设为虚函数**，否则在动态调用（基类指针指向子类对象）的时候是不会调用到子类重载过的函数的，很可能会出错。 
- 反之同理，如果一个函数父类没有设置为虚函数，一定不要在子类重载它。 
- 原因：多态的动态调用中，只有虚函数是**动态绑定**，非虚函数是**静态绑定**的——指针（或引用）的静态类型是什么，就调用那个类型的函数，和动态类型无关。 

> 条款7解释为什么**多态性质的 base classes 应该声明 virtual 析构函数**。如果你在多态性质下的 base class 声明了 non-virtual 函数，那么derived class 便绝不应该重新定义一个继承而来的 non-virtual 析构函数。但即使你没有定义，条款5曾说，**编译器会默认为你生成它**，所以多态性质的 base classes 都需要 virtual 析构函数。因此就本质而言，条款7只不过是本条款的一个特殊案例，尽管它足够重要到单独成为一个条款。



### 条款37：绝不重新定义继承而来的缺省参数值

-  静态绑定和动态绑定的差异 

  > 对象的所谓静态类型（static type），就是它在程序中被声明时采用的类型。对象的所谓动态类型（dynamic type），就是指目前所指对象的类型，可以决定一个对象将会有什么样的动态行为。virtual 函数是动态绑定的，所以调用一个 virtual 函数时，究竟调用那一份函数实现代码，取决于该对象的动态类型。

- 在继承中：

  1. 不要更改父类非虚函数的缺省参数值，其实**不要重载父类非虚函数的任何东西**，不要做任何改变！(见条款36)

  2. 虚函数不要写缺省参数值，子类自然也不要改，**虚函数要从始至终保持没有缺省参数值**。

     > 缺省参数值是属于__静态绑定__的，而**虚函数属于动态绑定**。虚函数在大多数情况是供动态调用，而在动态调用中，子类做出的缺省参数改变其实并没有生效，反而会引起误会，让调用者误以为生效了。

     ```cpp
     class B {
     public:
         virtual std::string ToString(std::string Text="BBB") const{
             return Text;
         }
     };
     
     class D : public B {
     public:
         virtual std::string ToString(std::string Text="DDD") const{
             return Text;
         }
     };
     
     inline void BTry() {
         D Derived;
         B* BasePointer = &Derived;
         std::cout << BasePointer->ToString() << "\n"; //BBB
     }
     //BasePointer 静态类型是 B，动态类型是 D。意味着 ToString 的定义取决于 D，而 ToString 的缺省参数值却取决于 B。
     ```

- 缺省参数值属于**静态绑定**的原因是为了提高**运行时效率**。 

  > 假设缺省参数值为动态绑定，编译器就必须要支持某种方式在运行期为 virtual 函数选择适当的缺省参数值，这意味着更慢更复杂。 

- 假如你需要重新定义缺省参数值的需求 

  -  `替换 virtual 函数`。条款35列出了不少 virtual 函数的替换设计。 
  - 如果你真的想让某一个虚函数在这个类中拥有缺省参数，那么就把这个虚函数设置成private，在public接口中重制非虚函数，让非虚函数这个“外壳”拥有缺省参数值，当然，这个外壳也是一次性的——在被继承后不要被重载。 

总结：

- 绝对不要重新定义一个继承而来的缺省参数值，因为缺省参数值都是静态绑定，而virtual函数——你唯一应该覆写的东西——却是动态绑定。



### 条款38：通过复合塑膜出has-a关系，或“根据某物实现出”

- 两个类的关系除了继承之外，还有“一个类的对象可以作为另一个类的成员”，我们称这种关系为“类的复合”

- public 继承是一种 is-a 的意义，复合也有它们的意义。复合意味着 has-a（有一个）或 is-implemented-in-terms-of （根据某物实现出）。 

-  `is-a`（是一种 和 `is-implemented-in-terms-of` （根据某物实现出） 的区分

  - 这两种关系其实是在不同领域的表现，如果对象只是你所塑造的世界中的某个物品，某些人物等，那这样的对象就属于应用域部分，如果对象需要负责你所塑造世界的细节部分，是规则的制定者和执行者，那这样的对象就属于实现域部分。当对象处于应用域，它就是 has-a 的关系，当对象处于实现域，它就是 is-implemented-in-terms-of 的关系。
  -  请牢记“is-a”关系的唯一判断法则，一个类的全部属性和接口是否必须**全部**继承到另一个类当中？另一方面，“用一个工具类去实现另一个类”这种情况，是需要对工具类进行**隐藏**的，比如人们并不关心你使用stack实现的queue，所以就藏好所有stack的接口，只把queue的接口提供给人们用就好了，而红芯浏览器的开发者自然也不希望人们发现Google Chrome的内核作为底层实现工具，也需要“藏起来”的行为。 

- 什么情况下我们应该用类的复合

  - 某一个类“拥有”另一个类对象作为一个属性（has-a），比如学生拥有铅笔、市民拥有身份证，一个人可以有名字，有地址，有手机号码等。

    ```cpp
    class Address;
    class PhoneNumber;
    class Person {
    public:
        //...
    private:
        std::string name;  //复合对象
        Address& Address;
        PhoneNumber& VoiceNumber;
        PhoneNumber& FaxNumber;
    };
    ```

    

  -  “一个类根据另一个类实现”(is-implemented-in-terms-of )。比如“用stack实现一个queue”，更复杂一点的情况可能是“用一个老版本的Google Chrome内核去实现一个红芯浏览器”。 再比如用list对象实现一个sets

    这里以list对象实现一个sets为例， **set 成员函数可大量倚赖 list 及标准程序库其他部分提供的机能来完成：** 

    ```cpp
    template <typename T>
    class Set {
    public:
        bool Contains(const T& Item) const;
        void Insert(const T& Item);
        void Remove(const T& Item);
        size_t Size() const;
    private:
        std::list<T> Rep;
    };
    
    template <typename T>
    bool Set<T>::Contains(const T& Item) const {
        bool Result=std::find(Rep.begin(),Rep.end(),Item)!=Rep.end();
        return Result;
    }
    
    template <typename T>
    void Set<T>::Insert(const T& Item) {
        if(!Contains(Item)) {
            Rep.push_back(Item);
        }
    }
    
    template <typename T>
    void Set<T>::Remove(const T& Item) {
        typename std::list<T>::iterator It=std::find(Rep.begin(),Rep.end(),Item);
        if (It!=Rep.end()) {
            Rep.erase(Item);
        }
    }
    
    template <typename T>
    size_t Set<T>::Size() const {
        return Rep.size();
    }
    //显然，set 和 list 的关系是 is-implemented-in-terms-of，而不单单是 has-a 的关系。
    ```



总结

- 复合（composition）的意义和 public 继承完全不同。
- 在应用域（application domain），复合意味 has-a （有一个）。在实现域（implementation domain），复合意味 is-implemented-in-terms-of（根据某物实现出）。



### 条款39：明智而审慎地使用private继承

- 条款32中说到**public继承是一种is-a**关系。在这种继承体系下，编译器在必要时刻（为了让函数调用成功）会将derived class转换为base class 。

  ```cpp
  class Person {...};
  class Student : public Person {...};
  void eat(const Person& p);
  
  Person p;
  Student s;
  
  eat(p); // 没问题
  eat(s); // 没问题，这里编译器将Student暗自转换为Person类型。
  ```

- ####  private 继承的两个行为

  - 如果 derived class 和 base class 是 **private 继承**，那么从 derived class 到 base class 的**转换将失败**
  -  在**private继承**下，base class的成员无论是private、protected还是public，继承后**都会变为private**。 

  ```cpp
  class Person {...};
  class Student : private Person {...};
  void eat(const Person& p);
  
  Person p;
  Student s;
  
  eat(p); // 没问题
  eat(s); // 错误！！！s是private继承，编译器无法转换。
  ```

- #### Private继承的意义

  - private 继承意味着：is-implemented-in-terms-of （根据某物实现出）。private 继承可以看作纯粹是`为了实现细节`，它需要的不是类似 public 继承可以向外提供接口，仅仅是为了让derived class采用base class中已经具备的某种特性。derived和base之间并没有什么直接意义上的联系。 

- #### 那么当我们拥有“用一个类去实现另一个类”的需求的时候，如何在类的复合与private继承中做选择呢？

  - 尽可能用复合，**除非必要，不要采用private继承**。
  - 当我们需要对工具类的某些方法（虚函数）做重载时，我们应选择private继承，这些方法一般都是工具类内专门为继承而设计的调用或回调接口，需要用户自行定制实现。

  ##### 案例一：能用复合，就不要用private

  > 假设我们需要写一个Widget（控件）。这个控件需要按某一频率定时检查Widget的某些信息，换句话说需要定时地调用某个函数。为了少写新的代码，我们在其他程序中翻到了一个Timer class。 

  ```cpp
  class Timer 
  {
  public:
      explicit Timer(int tickFrequency);
      virtual void onTick() const;
  };
  ```

  > 这个定时器的功能是每隔一段时间就调用一次onTick函数。
  >
  > 为了让Widget重新定义virtual内的virtual函数，Widget必须继承自Timer。但此时不能使用public继承，**因为Widget并不是个Timer**，所以我们必须以private形式继承Timer。

  ```cpp
  class Widget : private Timer 
  {
  private:
      virtual void onTick() const override;
  }
  ```

  > 但**private继承并不是唯一的选择方案**，我们可以**使用复合**来替代这个方案。 
  >
  > 只要在Widget 内声明一个**嵌套式private class**, 后者以public 形式继承Timer 并重新定义onTick, 然后放一个这种类型的对象千Widget 内

  ```cpp
  class Widget 
  {
  private:  //private的
      class WidgetTimer : public Timer 
      {
      public:
          virtual void onTick() const override;  //本应被目标类覆写的方法在嵌套类中实现，这样TargetClass的子类就无法覆写该方法。
      };
      WidgetTimer timer;
  };
  ```

   **该复合设计相比于private继承有两个优点：** 

  - **当Widget拥有derived class时，你可能同时想阻止derived class重新定义onTick。**如果是private继承（Widget 继承了Timer），那这个想法就不可能实现。（条款35曾说过：**derived class可以重新定义private virtual函数**，即使它们不能调用它）。但如果WidgetTimer是widget内部的一个private成员并继承Timer，Widget的derived classes将无法取用WidgetTimer，因此无法继承它或重新定义它的virtual函数。
  - **降低widget的编译依存性。**如果继承Timer，当Widget被编译时Timer的定义必须可见，所以定义widget的文件必须#include Timer.h。如果WidgetTimer移出Widget之外，而widget内含指针指向一个widgetTimer，widget可以只带一个简单的WidgetTimer前置声明。（对大型系统而言非常重要）关于编译依存性的最小化，详见条款31 。 

  ##### 案例二：一个使用private的极端案例

  > 这种情况真是够激进的，只适用于你所处理的 class 不带任何数据时。这样的 `class 不存在任何成员函数或变量`。示例： 

  ```cpp
  class Empty {};
  
  class DemoWithEmpty {
  private:
      int x;
      FEmpty Empty;
  };
  
  inline void Try(){
  	DemoWithEmpty DemoWithEmpty;
      Empty Empty;
      std::cout<<sizeof(Empty)<<"\n";  //1
      std::cout<<sizeof(DemoWithEmpty)<<"\n"; //8
  }
  ```

  > 可以看到，一个不含任何成员的 class 的大小居然为 1。因为C++规定凡是独立对象都必须有非零大小。所以你可以发现 sizeof（Empty）的大小为 1，而且几乎所有的编译器都这样做。至于为什么含一个 int 大小的 class 是 8，这涉及到内存对齐的问题，不必详细讨论。

  >  或许你注意到了，独立对象才需要有非零大小，这意味着继承而来的 Empty class 大小可以不受约束:
  
  ```cpp
  class FEmpty {};
  
  class DemoWithEmpty :private FEmpty{
  private:
      int x;
  };
  	
  inline void Try(){
  	DemoWithEmpty DemoWithEmpty;
      Empty Empty;
      std::cout<<sizeof(Empty)<<"\n";  //1
      std::cout<<sizeof(DemoWithEmpty)<<"\n"; //4
  }
  ```
  
  > DemoWithEmpty 所用大小正好等于一个 int 的大小，而这种表现就是所谓的 **`EBO（empty base optimization）空白基类最优化`。**值得注意的是，EBO一般在单一继承下才可行。 
  
- 尽管有这些例外情况，让我们回到根本。大部分 class 并非 empty，这很少成为你使用 private 继承的理由。只有当你面对需要访问 base class 的 protected 成员或者覆写 virtual 函数时，private 继承才被纳入考虑。当你审视完所有方案，仍然认为 private 继承是最佳方法，才使用它。

总结：

- Private 继承意味 is-implemented-in-terms-of（根据某物实现出）。它通常比复合（composition）的级别低。但是当 derived class 需要访问 protected base class 的成员，或需要重新定义继承而来的 virtual 函数时，这么设计是合理的。
- 和复合（composition）不同，private 继承可以造成 empty base 最优化。这对致力于对象尺寸最小化的程序库开发者而言，可能很重要。



### 条款40：明智而审慎地使用多继承

- C++社群对多重继承（multiple inheritance MI）持有两类观点。

  - 单一继承是好的，但多重继承不值得使用。
  - 单一继承（single inheritance SI）是好的，多重继承更好。

- 两种观点的比较与选择

  - #### 观点一：**多重继承不值得使用**

    **原因一**：**多重继承可能会引发歧义（ambiguity）行为。** **解决办法：指明调用**

    ```cpp
    // 图书馆可借内容的基类。
    class BorrowableItem
    {
    public:
        void checkOut(); // 检查函数
    };
    
    // 一个电子小工具类。
    class ElectronicGadget
    {
    private:
        bool checkOut() const; // 检查函数
    };
    
    // Mp3播放器类。
    class MP3Player :
    public : BorrowableItem, 
    public : ElectronicGadget 
    {...};
    
    MP3Player mp;
    // 这里会引发歧义，mp对象到底调用的是哪个checkout函数？
    mp.checkout();
    ```

    > 疑问:：B~class的checkOut函数是public的，E~class的checkOut函数是private的，理应只有B~class的函数是可以调用，那为什么会引发歧义行为？
    >
    > 原因：这与**C++的解析机制**有关（与解析（resolving）重载函数调用的规则相符）。在看到是否有个函数可取用之前，C++会首先确认这个函数是不是此调用的最佳匹配，**找出最佳匹配函数后才检验其可取用性**。在该例中，两个checkOuts有相同的匹配程度（因此才造成歧义），没有所谓最佳匹配。因此**ElectronicGadget::checkOut的可取用性也就从未被编译器审查**(是不是public对该问题也就没有影响,还没到这一步就错了)。

    **解决方法**：如下调用即可

    ```cpp
    // 指定调用BorrowableItem的checkOut函数。
    mp.BorrowableItem::checkOut();
    // 错误行为！！！通过最佳匹配检查后发现，这个函数是个private函数。
    mp.ElectronicGadget::checkOut();
    ```

    

    **原因二：要命的“钻石型多重继承” **    **解决办法：virtual继承**

    ![1659966606569](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1659966606569.png)

    ```cpp
    class File {...};
    class InputFile: public File {...};
    class OutputFile: public File {...};
    class IOFile: public InputFile, public OutputFile {...};
    ```

    > 这种继承体系必须面对的一个问题是：**是不是打算让File class内的成员变量经过每一条路径被复制？**
    >
    > 假设File中有一个名为fileName的成员变量。从某个角度说，IOFile从其每一个base class继承一份，所以其对象内应该有两份fileName成员变量。但实际上，文件名只有一个就可以了。
    >
    > 对复制还是不复制的问题，C++两个方案都支持。上面是复制方案。不让数据重复复制的方法是令带有数据的class成为一个virtual base class。具体做法是**virtual继承**。

    ```cpp
    class File {...};
    class InputFile: virtual public File {...};
    class OutputFile: virtual public File {...};
    class IOFile: public InputFile, public OutputFile {...};
    ```

    **virtual继承需要付出代价**

    > - 从合理行为的观点来看， public 继承应该总是使用 virtual。这样总是可以保证 derived class 总是不会重复获得成员。但是合理并不是唯一观点，virtual 继承需要付出代价，**使用 virtual 继承的那些 class 产生的对象往往比 non-virtual 继承的对象体积大，访问速度慢**。
    > - virtual 继承的成本还包括其他方面。比如 virtual class 的初始化责任是由继承体系中最底层的（most derived）class 负责，这暗示 class 若派生自 virtual classes 而需要初始化，必须认识其 virtual class，不论继承体系有多少，且必须负责其所有 virtual class 的初始化责任。

    **作者对virtual base classes 的看法** 

    > 第一，**非必要不使用virtual bases**。平常请使用non-virtual继承。
    >
    > 第二，如果你必须使用virtual base classes，**尽可能避免在其中放置数据**。这么一来你就不需担心这些classes身上的初始化（和赋值）所带来的诡异事情了。 

    

  - #### 观点二：多重继承是值得使用的

    对于**接口和实现分开的设计**，多重继承显然就可以发挥其作用。

    ```cpp
    class IPerson {
    public:
        virtual ~IPerson() = default;
        virtual std::string GetName() const =0;
    };
    
    class IPersonImpl {
    public:
        virtual ~IPersonImpl() = default;
        explicit IPersonImpl(std::string InName): Name(std::move(InName)) {}
    
        virtual std::string GetNameImpl() const {
            return Name;
        }
    
    private:
        std::string Name;
    };
    
    class APerson : public IPerson, private IPersonImpl {
    public:
        explicit APerson(const std::string& InName)
            : IPersonImpl(InName) {}
    
        std::string GetName() const override {
            return IPersonImpl::GetNameImpl();
        }
    };
    ```

    使用 public 继承其接口，private 继承其实现，似乎是再完美不过的一件事。这个例子告诉我们，多重继承也有它的合理用途。 

- 最后：

  > **多重继承只是面向对象工具箱的一个工具**而已。和单一继承相比，它通常比较复杂，使用上也难以理解。所以如果你有个单一继承的方案，也有一个多重继承的方案，那么单一继承的设计方案一定比较受欢迎。然而有时候多重继承确实是完成任务之最简洁，最易维护，最合理的方案，那就别害怕使用它们，只要确定，你的确是在明智而审慎的情况下使用它。



总结：

- 多重继承比单一继承复杂。它可能导致新的歧义性，以及对 virtual 继承的需要。
- virtual 继承会增加大小，速度，初始化（赋值）复杂度等等成本。如果 virtual base classes 不带任何数据，将是最具有实用价值的情况。
- 多重继承的确有正当用途。其中一个情节涉及**“public 继承某个 Interface class”** 和**"private 继承某个协助实现的 class"**的两相组合。



# 七、模板与泛型编程

### 条款41：了解隐式接口和编译器多态

-  **显式接口**和**运行期多态**

  > 面向对象的世界总是以显式接口和运行期多态解决问题。

  - 显式接口的构成： 函数名称，参数类型，返回类型，常量性也包括编译器产生的copy
    构造函数和copy assignment 操作符。( 函数的签名式 )

  ```cpp
  class Widget {
  public:
      virtual ~Widget()=default;
      virtual void Normalize()=0;
  };
  class SpecialWidget:public Widget {
  public:
      virtual void Normalize() override {
          std::cout<<"Special"<<"\n";
      }
  };
  class NormalWidget:public Widget {
  public:
      virtual void Normalize() override {
          std::cout<<"Normal"<<"\n";
      }
  };
  inline void BeginPlayWithWidget(Widget& InWidget) {
      InWidget.Normalize();
  }
  inline void Try() {
      SpecialWidget SpecialWidget;
      NormalWidget NormalWidget;
      BeginPlayWithWidget(SpecialWidget); //Special
      BeginPlayWithWidget(NormalWidget);	//Normal
  }
  ```

  可以这样说 BeingPlayWithWidget 函数中的 InWidget

  - 由于 InWidget 类型被声明为 Widget，所以 InWidget 必须支持 Widget 接口。我们可以在源码中找到这个接口，看看它们是什么样子，所以我们称之为一个**显式接口**（explicit interface），也就是它在源码中的确可见。
  - 由于 Widget 的BeingPlayWithWidget(或者说某些成员函数)函数是virtual ，InWidget 将对此函数的调用表现出**运行期多态**（runtime polymorphism），也就是说将**在运行期根据 InWidget 的动态类型决定究竟调用哪个函数。**

-  **隐式接口**和**编译期多态**

  > templates及泛型编程的世界，与面向对象的世界有根本的不同。在此世界显式接口和运行期多态仍然存在，但重要性降低。 

  -  隐式接口的构成： 有效表达式（valid expression） 

  ```cpp
  template <typename T>
  inline void BeginPlayWithWidgetTemplate(T& InT) {
      if (InT.Size() > 0 && InT != EClassType::None) {
          InT.Normalize();
          std::cout << InT.Size() << "\n";
          //...
      }
  }
  ```

  对InT来说

  - InT 必须支持哪一种接口，是由函数体中对 InT 的操作决定的。从本例来看，InT 的类型 T 必须要支持 Normalize 、Size、不等比较等操作。看表面可能并非完全正确，但这组操作对于 T 类型的参数来说，是一定要支持的**隐式接口**（implicit interface）。
  - 凡是涉及 InT 的任何函数调用，例如 operator> 和 operator != 有可能造成 template 的具现化，使得这些调用得以成功，这样的行为发生在编译器。以**不同的 template 参数具现化 function templates** 会导致调用不同的函数，这便是所谓的**编译期多态**（compile-time polymorphism）。

  > 纵使你从未用过templates，应该不陌生“运行期多态”和“编译期多态”之间的差异，因为它类似于“哪一个重载函数该被调用”（发生在编译期）和“哪一个virtual函数该被绑定”（发生在运行期）之间的差异。

  

   隐式接口与显示接口不同，它不基于函数签名式，而是由**有效表达式（valid expression）**构成 

  ```cpp
  template <typename T>
  inline void BeginPlayWithWidgetTemplate(T& InT) {
      if (InT.Size() > 0 && InT != EClassType::None) {
          //...
      }
  }
  ```

  在该例子中， T 类型的隐式接口有这些约束：

  > - T 必须提供名叫 Size 的成员函数，该函数返回一个整数值；
  >
  > - T 必须支持 operator!= 函数，用来与两个T对象，这里假设 EClassType 为T类型 
  >
  > 得益于操作符重载（operator overloading）带来的可能性，这两个约束都不需要满足。是的，T必须支持size成员函数，然而这个函数也可能从base class继承而得。这个成员函数不需返回一个整数值，甚至不需返回一个数值类型。就此而言，它甚至不需要返回一个定义有operator>的类型！它唯一需要做的是返回一个类型为x的对象，而x对象加上一个int（10的类型）必须能够调用一个operator>。这个operator>不需要非得取得一个类型为x的参数不可，因为它也可以取得类型Y的参数，只要存在一个隐式转换能够将类型x的对象转换为类型y的对象！
  >
  > 同样道理，T并不需要支持operator!=，因为以下这样也是可以的：operator！=接受一个类型为x的对象和一个类型为Y的对象，T可被转换为x而 EClassType 的类型可被转换为Y，这样就可以有效调用operator !=。

总结：

1. classes 和 templates 都支持接口（interfaces）和多态（polymorphism）。
2. 对 classes 而言接口是显式的（explicit），**以函数签名为中心**。多态则是通过 virtual 函数发生于**运行期**。
3. 对 template 参数而言，接口是隐式的（implicit），**奠基于有效表达式**。多态则是通过 template 具现化和函数重载解析（function overloading resolution）发生于**编译期**。



### 条款42：了解 typename 的双重意义

本条款首先提出一个问题：以下 template 声明式中，class 和 typename 有什么不同 

```cpp
template<class T>
class Widget;

template<typename T>
class Widgt;
```

答案：没有不同。

> **当我们声明 template 类型参数时， class 和 typename 的意义完全相同。**
>
> 某些程序员喜欢 class，因为可以少打几个字,有些人(比如作者本人)比较喜欢 typename ，因为它**暗示参数并非一定是个 class 类型**。



**然而C++并不总是把class和typename视为等价**。有时候你一定得使用typename。为了解其时机，我们必须先谈谈你可以在template内指涉（refer to）的两种名称： (嵌套)从属名称和非从属名称 。

```cpp
template<typename T>
void PrintContainer(const T& Container)
{ 											//注意这不是有效的C++代码
    if (Container.Size()>0) {
        T::const_iterator iter(Container.begin()); //取得第一元素的迭代器  注意 iter
        ++iter;							
        int value=*iter; 					//将该元素复制到某个int，注意 value
        std::cout<<value<<"\n";
    }
}
```

> 在上述代码中强调两个 local 变量：**iter** 和 **value**。
>
> iter 的类型是`T::const_iterator`，实际是什么取决于 template 参数 T。template 内出现的名称如果依赖于某个 template 参数，我们就称之为**从属名称**（dependent names）。如果从属名称在 class 内呈嵌套状，我们就称之为**嵌套从属名称**（nested dependent names）。T::const_iterator就是这样的名称，实际上它还是一个**嵌套从属类型名称**（nested dependent type name），也就是个**嵌套从属名称**并且**指涉是什么类型**。
>
> value 的类型是 int 。它不依赖于任何 template 参数。我们便称之为非从属名称（non-dependent names）。



**嵌套从属名称可能导致解析（parsing）困难** 

> 在我们知道T是什么之前，没有任何办法可以知道T::const_iterator是否为一个类型。而当编译器开始解析template PrintContainer时，尚未确知T是什么东西。
> C++有个规则可以解析（resolve）此一歧义状态：**如果解析器在template中遭遇一个嵌套从属名称，它便假设这名称不是个类型，除非你告诉它是**。所以缺省情况下嵌套从属名称不是类型。此规则有个例外，稍后我会提到。

再次回顾上述代码:

```cpp
template<typename T>
void PrintContainer(const T& Container)
{ 											
    if (Container.Size()>0) {
        T::const_iterator iter(Container.begin());  //这个名称被假设为非类型
		......
    }
}
```

> 现在应该很清楚为什么这不是有效的C++代码了吧。iter声明式只有在T::const_iterator是个类型时才合理，但我们并没有告诉C++说它是，于是C++假设它不是。若要矫正这个形势，我们必须告诉C++说T::const iterator是个类型。**只要紧临它之前放置关键字typename即可：**

```cpp
template<typename T>
void PrintContainer(const T& Container)      //这是合法的C++代码
{ 											
    if (Container.Size()>0) {
        typename T::const_iterator iter(Container.begin());  //ok
		......
    }
}
```

一般性规则很简单：**任何时候当你想要在template中指涉一个嵌套从属类型名称，就必须在紧临它的前一个位置放上关键字typename。**（再提醒一次，很快我会谈到一个例外。）

**typename只被用来验明嵌套从属类型名称**；其他名称不该有它存在。例如下面这个function template，接受一个容器和一个“指向该容器”的选代器：

```cpp
template<typename C> 				 //允许使用"typename"（或"class"）
void f(const C&container，			//不允许使用"typename"
typename C::iterator iter)；		   //一定要使用"typename"
```

> 上述的C并不是嵌套从属类型名称（它并非嵌套于任何“取决于template参数”的东西内），所以声明container时并不需要以typename为前导，但C::iterator是个嵌套从属类型名称，所以必须以typename为前导。



“typename必须作为嵌套从属类型名称的前缀词”这一规则的例外是：**typename不可以出现在base classes list内的嵌套从属类型名称之前，也不可在member initialization list（成员初值列）中作为base class修饰符。**

```cpp
class Message {
public:
    Message() = default;
    explicit Message(std::string InText): Text(std::move(InText)) {}

    void SetText(std::string InText) {
        Text = std::move(InText);
    }

    std::string GetText() {
        return Text;
    }

private:
    std::string Text;
};

template <typename T>
class MessageContainer {
public:
    typedef T ElementType;
};

template <typename T>
class Printer : private MessageContainer<T>::ElementType {//base classes list不使用typename
public:
    //使用 typename 表明是一个类型，而不是变量
    //使用 typedef 给过长的类型起别名，方便。
    typedef typename MessageContainer<T>::ElementType ElementType; 

    explicit Printer(): MessageContainer<T>::ElementType() { //mem.init.list中不使用typename
        
        std::cout << typeid(ElementType).name() << "\n"; //class Message
        
    }

    void Log(std::string Text) {
        ElementType::SetText(Text);
        std::cout << ElementType::GetText() << "\n";
    }
};

inline void TryWithPrinter() {
    Printer<Message> Printer;
    Printer.Log("HelloWorld");
}
```



总结：

- 声明 template 参数时，前缀关键字 class 和 typename 可互换。
- 请使用关键字 typename 标识**嵌套从属类型名称**；但**不得在 base class lists（基类列）**或 **member initialization lists（成员初值列）**内以它作为 base class 修饰符。



### 条款43：学习处理模板化基类内的名称

从一个例子入手，假设我们要设计游戏中人物的相关列表，比如 buff 列表，物品列表等等，一个显而易见的设计是： 

```cpp
#include <iostream>
#include <set>

class Buff {
public:
    virtual ~Buff() = default;
    virtual void Start() = 0;
    virtual void End() = 0;
    virtual void OnTick() = 0;
};

class RedBuff : public Buff {
public:
    virtual void Start() override {}
    virtual void End() override {}
    virtual void OnTick() override {}
};

class BlueBuff : public Buff {
public:
    virtual void Start() override {}
    virtual void End() override {}
    virtual void OnTick() override {}
};

template <typename T>
class Container {
public:
    void Add(T Item) {
        std::cout << "Add" << "\n";
        Data.insert(Item);
    }

    void Clear() {
        std::cout << "Clear" << "\n";
        Data.clear();
    }

    size_t Size() {
        return Data.size();
    }

private:
    std::set<T> Data;
};

template <typename T>
class PlayerContainer : public Container<T> {
public:
    void RemoveAll() {
      Clear();   //在此无法访问 Clear 函数,找不到标识符
    }

    void ShowAll() {
        //...
    }
};

int main() {
    PlayerContainer<Buff*> PlayerBuffContainer;
    PlayerBuffContainer.Clear();

    RedBuff* RedBuffOne = new RedBuff;
    BlueBuff* BlueBuffOne = new BlueBuff;
    PlayerBuffContainer.Add(RedBuffOne);
    PlayerBuffContainer.Add(BlueBuffOne);

    std::cout << PlayerBuffContainer.Size() << "\n";
}
```

运行此代码，出现错误

```cpp
Clear:找不到标识符!
```

而出错的原因在于：

> 当编辑器遭遇 class template PlayerContainer 时，其实并不知道它究竟继承哪个 class。当然它继承的是 Container<T> ，但其中的 T 是一个 template 参数，**不到后来的具现化，是无法确切知道它是什么**。而如果不知道 T 是什么，就不清楚class Container<T>看起来像什么——更确切地说是没办法知道它是否有个 Clear 函数。
>
> 例如，如果有以下特化版 class Container （模板全特化）
>
> ```cpp
> template<>                 //一个全特化的Container
> class Container<Buff*> {   //它和一般的template相同，区别只在于它删掉了void Clear() 函数
> public:
>     void Add(T Item) {
>         std::cout << "Add" << "\n";
>         Data.insert(Item);
>     }
>     
>     size_t Size() {
>         return Data.size();
>     }
> };
> 
> //等价于
> template<typename T=Buff*>
> class Container<T> {
> public:
>      .....
> };
> ```
>
> 现在，再让我们考虑derived class PlayerContainer:
>
> ```cpp
> template <typename T>
> class PlayerContainer : public Container<T> {
> public:
>     void RemoveAll() {
>         Clear();   //如果T==Buff,这个函数不存在
>     }
> 
>     void ShowAll() {
>         //...
>     }
> };
> ```
>
> 正如注释所言，**当base class被指定为 Container<Buff> 时，这段代码将不合法！**因为该版本的 Container template 类**被特化**，其中并**不存在Clear函数**，且由于编译器会**优先考虑特化版本**，意味着 Container 使用 Buff 具现化时类中只存在Add、Size 函数，并未提供 Clear 函数。
>
> 这正是前面所说，为什么 C++ 拒绝在 PlayerContainer 访问 Clear 函数的原因：它知道 base classes templates 有可能被特化，而那个**特化版本可能不提供和一般性 template 相同的接口。因此它往往拒绝在 base classes templates 寻找继承而来的名称**。因此它往往拒绝在templatized base classes（模板化基类，本例的Container<T>）内寻找继承而来的名称（本例的Clear）。



所以，**我们必须有某种办法令C++"不进入templatized base classes观察”的行为失效**。幸运的是，我们有三个解决办法：

> 1. 在 base class template 函数调用动作之前**加上 this->**。this 指针可以访问所有成员函数。 
>
>    ```cpp
>    template <typename T>
>    class PlayerContainer : public Container<T> {
>    public:
>        void RemoveAll() {
>          this -> Clear();   //成立，假设Clear将被继承
>        }
>    	...
>    };
>    ```
>
> 2.  **使用 using 声明式**。可以告诉编译器进入 base class 作用域寻找函数。 
>
>    ```cpp
>    template <typename T>
>    class PlayerContainer : public Container<T> {
>    public:
>        using Container<T>::Clear; //告诉编译器，请他假设Clear位于base class内
>        void RemoveAll() {
>           Clear();   
>        }
>    	...
>    };
>    ```
>
>    （虽然using声明式在这里或在条款33都可有效运作，但两处解决的问题其实不相同。这里的情况并不是base class名称被derived class名称遮掩，而是编译器不进入base class作用域内查找，于是我们通过using告诉它，请它那么做。）
>
> 3.  明确指出被调用函数位于 base class 内。 (不推荐)
>
>    ```cpp
>    template <typename T>
>    class PlayerContainer : public Container<T> {
>    public:
>        void RemoveAll() {
>          Container<T>::Clear();   //成立，假设Clear将被继承
>        }
>    	...
>    };
>    ```
>
>    但这往往是最不让人满意的一个解法，因为**如果被调用的是virtual函数**，上述的明确资格修饰（explicit qualification）会**关闭"virtual绑定行为”**
>
> 从名称可视点的角度来看，上述每一个解法做的事情都相同：**对编译器承诺 base class template 的任何特化版本都支持其泛化版本所提供的接口。如果承诺未被保证，编译器仍然会报错。** 



总结：

1. **可在 derived class templates 内通过 this-> 指涉 base class templates 内的成员名称，或藉由一个明白写出的 base class 资格修饰符完成。**



### 条款44：将与参数无关的代码抽离 templates

- **templates 是节省时间和避免代码重复的奇方妙法。**

  > 你不再需要键入 20 个类似的 classes 并且每一个都带有 20 个 成员函数，你只需要键入一个 class template，留给编译器去具现化那 20 个你需要的相关 classes 即可，而且对于 20 个函数中未被调用的，编译器不会自动生成。这样的技术是不是很伟大，呵呵。

- 但这也很容易使得**代码膨胀**（code bloat），templates 产出码带着重复，或者几乎重复的代码，数据，或者两者。你可以通过：**共性与变形分析**（commonality and variability analysis）来避免代码膨胀。

  > 这个概念其实你早在使用，即使你从未写过一个 templates。当你编写某个函数时，你明白其中某些部分的实现码和另一个函数的实现码实质相同，你会很单纯的重复它们吗？当然不，你会抽出这两个函数相同的部分，放进第三个函数中，然后令原先两个函数调用这个新函数。也就是说：你分析了两个函数的共性和变形，把公共的部分搬到一个新的函数中去，变化的部分保留在原来的函数不动。对于 class 也是这个道理，如果你明白某些 class 和另一个 class 具有相同的部分，你也会把共性搬到一个新的 class。
  >

- templates 的优化思路也是如此，以相同的方式避免重复，但其中有个窍门。在 non-template 代码中，重复很明确。然而**在 template 代码中，重复是隐晦的，**毕竟只存在一份 template 代码，所以你必须自己去感受 template 具现化时可能发生的重复。



造成代码膨胀的一个典型的例子： **template class 成员依赖 template 参数值**

```cpp
// 典型例子
template <typename T, std::size_t n>
class SquareMatrix {
  public:
    void invert();
};

SquareMatrix<double, 5> m1;
SquareMatrix<double, 10> m2;
```

> 会具现两份非常相似的代码，因为除了一个参数5，一个参数10，其他都完全一样

**改进**一**使用带参数值的函数** 

```cpp
template <typename T>
class SquareMatrixBase {
  protected:            // protected 保证只有本类/子类本身可以调用
    void invert(std::size_t n);
}

template<typename T, std::size_t n>
class SquareMatrix  : private SquareMatrixBase<T> { // private继承，derived 和base不是is-a关系，base只是帮助实现derived 
  private:
    using SquareMatrixBase<T>::invert;  // derived class 会掩盖template base class的函数
                    
  public:
    inline void invert() { this->invert(n);}
}
```

> 如上，SquareMatrixBase只对“矩阵元素对象的类型”参数化，不对矩阵的尺寸参数化。因此对于某给定元素类型，所有矩阵共享同一个SquareMatrixBase类
>
> SquareMatrixBase::invert只是企图成为“避免派生类代码重复”的一种方法，所以它**用protected替换public**。调用它而造成的额外成本应该是0(因此派生类的invert调用基类版本的invert时是inline调用)。这里函数使用`this->`，否则**模板化基类的函数名称会被派生类掩盖**。注意这里是**private继承**，说明了这里的基类只是为了帮助派生类的实现，不是为了表现SquareMatrixBase和SquareMatrix 的is-a关系。

目前为止一切都好，但还有一些问题没有解决：

> - SquareMatrixBase::invert如何知道该操作什么数据？
> - 虽然它从参数中知道矩阵尺寸，但它如何知道哪个矩阵的数据在哪儿？想必只有派生类知道。
> - 派生类如何联络其基类做逆运算动作？

解决办法： **令SquareMatrixBase存储一个指针，指向矩阵数值所在的内存** 

```cpp
template <typename T>
class SquareMatrixBase {
public:
    SquareMatrixBase(std::size_t InN, T* InData): N(InN), Data(InData) {}

    void Invert() const {
        std::cout << N << "\n";
    }

private:
    std::size_t N;  // 矩阵的大小
    T* Data;  		// 指向矩阵内容
};

template <typename T, size_t N>
class SquareMatrix : private SquareMatrixBase<T> {
public:
    SquareMatrix()
        : SquareMatrixBase<T>(N, Data) {
        Data = new T[N * N];
    }

    void Invert() {
        SquareMatrixBase<T>::Invert();
    }

private:
    T* Data;
};


inline void TryWithMatrix() {
    SquareMatrix<int, 5> SquareMatrixFive;
    SquareMatrixFive.Invert();
}
```

这类类型的对象不需要动态分配内存，但对象自身可能非常大。另一种做法是把每一个矩阵的数据放进heap 

```cpp
template<typename T, std::size_t n>
class SquareMatrix : private SquareMatrixBase<T>{
public:
	SquareMatrix () :  
	 SquareMatrixBase<T>(n, 0),             //将基类的数据指针设为null
	 pData(new T[n * n])   // 为矩阵内容分配内存, 将指向该内存的指出存储起来
	 {this->setDataPtr(pData.get();)}
		
private:
	boost::scoped_array<T>pData;
}
```



这个条款只讨论由non-type template parameters(非类型模板参数)带来的膨胀，其实type parameters (类型参数)也会导致膨胀。

> - 比如在很多平台上，int和long有相同的二进制表述，所以vector< int>和vector< long>的成员函数可能完全相同。
> - 同样的，大多数平台上，所有指针类型都有相同的二进制表述，因此凡模板持有指针者(比如list< int*>、list< const int *>等)往往应该对每一个成员使用唯一一份底层实现。
> - 也就是说，如果你实现成员函数而它们操作强类型指针（T*），你应该令它们调用另一个无类型指针(void *)的函数，由后者完成实际工作。



总结:

1. Templates 生成多个 classes 和多个 functions，所以任何 template 代码都不该与某个造成膨胀的 template 参数产生相依关系。
2. 因非类型模板参数（non-type template parameters）而造成的代码膨胀，往往可以消除，做法是以函数参数或 class 成员变量替换 template 参数。
3. 因类型参数（type parameters）而造成的代码膨胀，往往可以降低，做法是让带有完全相同二进制表述（binary representations）的具现类型（instantiation types）共享实现码。



### 条款45：运用成员函数模板接受所有兼容类型

所谓智能指针（smart pointer），是行为像指针的对象，并提供指针没有的机能：自动管理资源。但原始指针（raw pointer）做的很好的一件事是：支持隐式转换（implicit conversions）。比如 derived class 指针可以隐式转换为 base class 指针，指向 non-const 的指针可以转换为 指向 const 的指针

```cpp
class Top {...}
class Middle: public Top {...}
class Bottom:public Middle {...}
Top* pt1 = new Middle;    //将Middle*转换为Top*
Top* pt2 = new Bottom;    //将Bottom*转换为Top*
const Top* pct2 = pt1;      //将Top*转换为const Top*
```

而对于 template 具现的类，并不能很好的进行像原始指针一样的隐式转换，比如想把一个具现类转换为另一个具现类，这是不可以的，它们不存在像 derived-base 一样的关系，它们是完全不同的类。**唯一的方式就是我们明确的编写构造函数。** 

也许我们可以对于某个具现类，编写特定的构造函数去变成另一个具现类，但这存在一个问题。因为一个 template 可以被无限的具现，意味着我们要提供无限的构造函数。因此，更好的解决方法是：**为它编写一个模板构造函数：** 

```cpp
template<typename T>
class SmartPtr {
public:
    template<typename U>
    SmartPtr(const SmartPtr<U>& Other) {
        //...
    }
};
```

但并不是所有的构造行为都是我们期望的，**我们必须有能力对模板构造函数进行筛选和剔除**。条款41提及的隐式接口是值得注意的，我们可以结合这点去进行约束。良好的接口设计可以避免不必要的构造，比如 shared_ptr的实现： 

```cpp
template <typename T>
class AutoPtr{};
template <typename T>
class WeakPtr{};

template <typename T>
class SharedPtr {
public:
    template <typename Y>
    explicit SharedPtr(Y* InPointer);
    
    template <typename Y>
    explicit SharedPtr(SharedPtr<Y> const& InR);
    
    template <typename Y>
    explicit SharedPtr(WeakPtr<Y> const& InR);
    
    template <typename Y>
    explicit SharedPtr(AutoPtr<Y>& InR);

    template <typename Y>
    SharedPtr& operator=(SharedPtr<Y> const& InR);

    template <typename Y>
    SharedPtr& operator=(AutoPtr<Y>& InR);
};
```

> 明确指出了可以进行转换的类型，要比上个版本的转换函数安全且容易甄别错误。此外，还可以看出，模板函数还可以被用于赋值操作。 
>
> ```cpp
> template<typename T>
> class shared_ptr {
>   public:
>     shared_ptr(T* ptr);  // 构造
>     shared_ptr(const shared_ptr& ptr); // 拷贝构造
>     // 下面的泛化拷贝构造函数没有使用explicit，因为derived->base支持隐式转换
>     // 成员初始化列表使用U* ptr 赋值给T* ptr_,只有U->T存在隐式类型转换，此处才能编译成功，
>     // 正好满足Dervied可以转化为Base,反向却不行的约束
>     template<U>   // 泛化拷贝构造
>     shared_ptr(const shared_ptr<U>& ptr) : ptr_(ptr.get()); 
>     shared_ptr& operator=(shared_ptr const& ptr); // 拷贝赋值
>     template<U>  // 泛化拷贝赋值
>     shared_ptr& operator=(shared_ptr<U> const& ptr);
>     T* get() {return ptr_};
>   private:
>     T* ptr_;
> };
> ```

提及构造函数，其实模板构造函数并不会影响语言规则，如果你的程序需要一个拷贝构造函数，而你却没有声明它。编译器依旧会为你生成一个。尽管你已经声明了模板构造函数，但那是只对泛化类型而言的，如果你对一个非泛化类型机型拷贝构造，模板函数就失去了作用。所以最好的方式是：**同时提供模板构造函数和正常构造函数。**



总结：

1. **请使用 member function templates（成员函数模板）生成可接受所有兼容类型的函数。**
2. **如果你声明 member templates 用于泛化 copy 构造 或 泛化 assignment 操作，你还是需要声明正常的 copy 构造函数和 copy assignment 操作符。**



### 条款46：需要类型转换时请为模板定义非成员函数

学习本条款前建议先熟悉一下条款24。

条款24讨论了为什么只有 non-member 函数才有能力在所有实参身上实施隐式类型转换。那么，如果是class template情况下又会发生什么呢？

```cpp
template <typename T>
class TRational {
public:
    TRational(const T& mNumerator, const T& mDenominator):
        Numerator(mNumerator), Denominator(mDenominator) {}

public:
    T GetNumerator() const {
        return Numerator;
    }

    T GetDenominator() const {
        return Denominator;
    }

private:
    T Numerator;
    T Denominator;
};

template <typename T>
inline TRational<T> operator*(const TRational<T>& RationalOne, const TRational<T>& RationalTwo) {
    return TRational<T>(RationalOne.GetNumerator() * RationalTwo.GetNumerator(),
                     RationalOne.GetDenominator() * RationalTwo.GetDenominator());
}

inline void TryWithTRational() {
    const TRational<int> TempOne(1, 8);
    const TRational<int> TempTwo(1, 2);
    TRational<int> Result = TempOne * TempTwo; //很好
    Result = Result * TempOne; //很好
    Result = Result * 2; //错误
    Result = 2 * Result; //错误
}
```

> 就像条款24所期望的那样，我们希望支持混合式算术运算。所以我们希望这段代码也能通过编译并正确运行，毕竟这段代码相比于条款24的代码，唯一不同的是Rational和operator*如今都成了templates。
>
> 但事与愿违， 由于模板化带来了一些不同，导致编译器无法找到相应的函数进行调用，致使编译失败。
>
> 实际上编译器试图想出什么函数被名为 operator* 的 template 具现化。它知道它们应该可以**“具现化某个名为 operator* 并接受两个 TRational<T> 的参数”**的函数，但为了完成这一具现化的任务，它必须先算出 T 是什么。问题就在于它没有这个能力。 
>
> 以 Result * 2 为例，Result 是一个类型为 TRational<int> 的参数，所以编译器可以得知 T 为 int 。其他的参数就没这样顺利，2 是一个 int ，编译器如何从 int 推算出 TRational<T> 的 T 是什么类型呢？你也许期待编译器用 TRational<int> 进行构造，但这是不行的，因为在 template 实参推导过程中：**从不将隐式类型转换函数纳入考虑。因为相应的隐式转换函数也需要知道 T 是什么类型才能被具现化。**



解决方法：**template class 内的friend声明式可以指涉某个特定函数**。

> 这意味class Rational<T>可以声明 operator*是它的一个friend函数。Class templates并不倚赖template实参推导（后者只施行于function templates身上），所以**编译器总是能够在class Rational<T>具现化时得知T**。

```cpp
template <typename T>
class TRational {
public:
    friend TRational<T> operator*(const TRational<T>& RationalOne, const TRational<T>& RationalTwo);
	//...
};

template <typename T>
inline TRational<T> operator*(const TRational<T>& RationalOne, const TRational<T>& RationalTwo) {
    return TRational<T>(RationalOne.GetNumerator() * RationalTwo.GetNumerator(),
                     RationalOne.GetDenominator() * RationalTwo.GetDenominator());
}

inline void TryWithTRational() {
    const TRational<int> TempOne(1, 8);
    const TRational<int> TempTwo(1, 2);
    TRational<int> Result = TempOne * TempTwo; //很好
    Result = Result * TempOne; //很好
    Result = Result * 2;//OK
    Result = 2 * Result; //Ok
}
```

> 注意： 这段代码虽然可以通过编译，但是仍会有**链接错误**（稍后再说）

> 现在对`operator*`的混合式调用可以通过编译了，因为当对象 Result  被声明为一个TRational<int>，class TRational<int>于是被具现化出来，而作为过程的一部分，friend函数`operator*`（接受TRational<int>参数）也就被自动声明出来。
> 后者身为一个函数而非函数模板（function template），因此编译器可在调用它时使用隐式转换函数（例如TRational的non-explicit构造函数），而这便是混合式调中之所以成功的原因。

> 小技巧：当一个 class template 内，template 名称可以作为 template声明 的简略表达形式，所以在 TRational<T> 我们可以只写 Rational 而不必写 TRational<T>，对于有很多参数的 template，这样可以节省一些时间，并让代码看起来干净，当然为了一致性，意义也并不大：
>
> ```cpp
> template <typename T>
> class TRational {
> public:
>     friend TRational operator*(const TRational& RationalOne, const TRational& RationalTwo);
>     //...
> };
> ```

**那为什么会有链接错误呢？**

> 这是因为编译器虽然知道要调用这个函数，但该函数只被用 **friend 声明于 template 内，并没有实际定义**。可惜的是虽然声明式知道了 T 是 int，但是类外的函数模板仍不知道，因为它们并无实际关系。 

解决办法就是：**将 operator* 的函数体从类外合并到 template 声明式中** 。

```cpp
template <typename T>
class TRational {
public:
    TRational(const T& mNumerator =0, const T& mDenominator=1):
        Numerator(mNumerator), Denominator(mDenominator) {}

public:
    T GetNumerator() const {
        return Numerator;
    }

    T GetDenominator() const {
        return Denominator;
    }
    friend TRational operator*(const TRational& RationalOne, const TRational& RationalTwo) {
        return TRational<T>(RationalOne.GetNumerator() * RationalTwo.GetNumerator(),
                 RationalOne.GetDenominator() * RationalTwo.GetDenominator());
    }
private:
    T Numerator;
    T Denominator;
};


inline void TryWithTRational() {
    const TRational<int> TempOne(1, 8);
    const TRational<int> TempTwo(1, 2);
    TRational<int> Result = TempOne * TempTwo; //很好
    Result = Result * TempOne; //很好
    Result = Result * 2;//编译ok，运行ok too
    Result = 2 * Result; //编译ok，运行ok too
}
//终于，混合式运算的问题得到了解决！
```

该解决方法的有趣之处在于：

> 虽然我们使用 friend 关键字，却和其传统用途：访问 class 的 non-public 成分不同。我们是**为了让类型转换发生在所有可能的实参上，我们需要一个 non-member 函数**，而**为了使这个函数自动具现化，我们需要将它声明在 class 内部**，而在 class 内部声明 non-member 函数的唯一有效方法就是：**令它成为一个 friend。**

优化： **令该 friend 函数调用另一个辅助函数** 

> 一如条款30所说，**定义于class内的函数都暗自成为inline**，包括像`operator*`这样的friend函数。你可以将这样的inline声明所带来的冲击最小化，做法是令`operator*`不做任何事情，**只调用一个定义于class外部的辅助函数**。在本条款的例子中，这样做并没有太大意义，因为`operator*`已经是个单行函数，但对更复杂的函数而言，那么做也许就有价值。“令friend函数调用辅助函数”的做法的确值得细究一番。

```cpp
template <typename T>
class TRational {
public:
    friend TRational operator*(const TRational& RationalOne, const TRational& RationalTwo) {
        return OnMultiply(RationalOne,RationalTwo);
    }
    //...
};
template <typename T>
TRational<T> OnMultiply(const TRational<T>& RationalOne, const TRational<T>& RationalTwo){
    return TRational<T>(RationalOne.GetNumerator() * RationalTwo.GetNumerator(),
                     RationalOne.GetDenominator() * RationalTwo.GetDenominator());
}
```



总结：

1. **当我们编写一个 class template，而它所提供之与此 template 相关的函数支持所有参数隐式类型转换时，请将那些函数定义为 class template 内部的 friend 函数。**



### 条款47：请使用 traits classes 表现类型信息

第一次看该条款时，觉得云里雾里模模糊糊的，于是查了很多资料，其中觉得这一篇文章讲的最为清晰，由浅入深，结合书本一起看效果极佳。

> 原文链接：http://t.csdn.cn/eAPtl
>
> 除此之外还强烈建议阅读：http://t.csdn.cn/X2Hug 以及Cpp技术文章08

注意：看本条款时请先熟悉**模板特化**、**偏特化**以及**typename关键字**。

我们知道，在 STL 中，**容器与算法是分开的**，彼此独立设计，容器与算法之间通过迭代器联系在一起。那么，算法是如何从迭代器类中萃取出容器元素的类型的？没错，这正是我们要说的 traits classes 的功能。
**迭代器所指对象的类型，称为该迭代器的 value_type**。我们来简单模拟一个迭代器 traits classes 的实现。

```cpp
template<class IterT>
struct my_iterator_traits {
    typedef typename IterT::value_type value_type;
};
```

my_iterator_traits 其实就是个类模板，其中包含一个类型的声明。有`typename`的基础，相信大家不难理解 `typedef typename IterT::value_type value_type;` 的含义：将迭代器的`value_type` 通过`typedef` 为 `value_type`。

对于`my_iterator_traits`，我们再声明一个偏特化版本。

```cpp
template<class IterT>
struct my_iterator_traits<IterT*> {
    typedef IterT value_type;
};
```

即如果 `my_iterator_traits` 的实参为指针类型时，直接使用指针所指元素类型作为 `value_type`。

为了测试 `my_iterator_traits` 能否正确萃取迭代器元素的类型，我们先编写以下的测试函数。

```cpp
void fun(int a) {
    cout << "fun(int) is called" << endl;
}

void fun(double a) {
    cout << "fun(double) is called" << endl;
}

void fun(char a) {
    cout << "fun(char) is called" << endl;
}
```

我们通过函数重载的方式，来测试元素的类型。

测试代码如下：

```cpp
my_iterator_traits<vector<int>::iterator>::value_type a;
fun(a);  // 输出 fun(int) is called
my_iterator_traits<vector<double>::iterator>::value_type b;
fun(b);  // 输出 fun(double) is called
my_iterator_traits<char*>::value_type c;
fun(c);  // 输出 fun(char) is called
```

 为了便于理解，我们这里贴出 vector 迭代器声明代码的简化版本： 

```cpp
template <class T, ...>
class vector {
public:
    class iterator {
    public:
        typedef T value_type;
        ...
    };
...
};
```

 我们来解释 `my_iterator_traits::iterator>::value_type a;` 语句的含义。

`vector::iterator` 为`vector` 的迭代器，该迭代器包含了 `value_type` 的声明，由 vector 的代码可以知道该迭代器的`value_type` 即为 int 类型。

 接着，`my_iterator_traits::iterator>` 会采用 `my_iterator_traits` 的通用版本，即  `my_iterator_traits::iterator>::value_type` 使用 `typename IterT::value_type` 这一类型声明，这里 `IterT` 为  `vector::iterator`，故整个语句萃取出来的类型为 int 类型。 

对 double 类型的 vector 迭代器的萃取也是类似的过程。

而`my_iterator_traits<char*>::value_type`则使用`my_iterator_traits`的偏特化版本，直接返回 char 类型。

由此看来，通过`my_iterator_traits`，我们正确萃取出了迭代器所指元素的类型。



总结一下我们设计并实现一个 traits class 的过程：
1）确认若干我们希望将来可取得的类型相关信息，例如，对于上面的迭代器，我们希望取得迭代器所指元素的类型；
2）为该信息选择一个名称，例如，上面我们起名为 value_type；
3）提供一个 template 和一组特化版本（例如，我们上面的 my_iterator_traits），内容包含我们希望支持的类型相关信息。



### 条款48：认识 template 元编程

**template metaprogramming（TMP，模板元编程）**：编写 template C++ 程序并执行于编译期的过程。

> 所谓模板元程序就是：**以 C++ 写成，执行于 C++ 编译器内的程序**。该程序执行后产生具现的代码，和正常代码一并加入编译。即元编程可以做到**用代码去生成代码**。

由于 template metaprograms **执行于 C++ 编译期**，因此可以将很多工作从运行期转移到编译期。如：

> - 某些错误原本通常在运行期才能检测到，现在可在编译器找出来。
> - 使用 TMP 的 C++ 程序可能在每一方面都更加高效：比如较小的可执行文件，较短的运行期，较少的内存需求。
>
> 注意：将工作移至编译期，会导致编译时间变长



条款 47 实现一个 Move函数的伪代码 ,可能存在编译问题 

```cpp
	template <typename IteratorType>
	void Move(IteratorType& Iterator, int Distance) {
		// 使用类型信息
	    if (typeid(IteratorTraits<IteratorType>::IteratorTag) == typeid(RandomAccessIteratorTag)) {   
	        Iterator += Distance; //针对random access 迭代器使用迭代器算术运算
	    }
	    else {
	        if (Distance >= 0) {  //针对其他迭代器类型,反复调用＋＋或－－
	            while (Distance--)++Iterator;
	        }
	        else {
	            while (Distance++)--Iterator;
	        }
	    }
	}
```

> 虽然我们这里根据迭代器类型进行不同的操作，或 +=，或 ++，–，我们知道只有 Random Access Iterator 可以有 += 运算，但是 C++ 要求：**编译器必须确保所有源码都有效，即使是不会执行的源码。**也就是说编译器会拿着其他不支持 += 的迭代器，进入 if 语句先测试是否支持 += 运算，无效则会报错。
>
> 所以相比于要支持所有操作，Traits class 针对不同类型进行函数重载的做法显然更好。



TMP 已被证明是一个图灵完备（Turing-complete）机器

> 这意味着它可以计算任何事物，使用 TMP 你可以声明变量，执行循环，编写及调用函数…但这些相对于正常的 C++ 的实现会有很大的不同。比如：TMP 并没有循环部件，所有的循环效果都由递归完成。

一个经典的初级案例—— 利用TMP在编译期计算阶乘 

```cpp
template <unsigned N>
struct Factorial {
    static const int Value = N * Factorial<N - 1>::Value;
};

template <>
struct Factorial<0> {
    static const int Value = 1;
};

inline void TryWithFactorial() {
    std::cout << Factorial<10>::Value << "\n";
}
```

> 和所有递归行为一样，我们**需要一个特殊情况来结束递归**。对于 TMP 而言就是**使用 tmeplate的特化版本**Factorial<0> 。
> 正如 TryWithFactorial 函数所使用的，只要你声明 Factorial<N>::Value 就可以得到 N 阶乘值。当然这里存在值溢出的问题。 

总结：

1. Template metaprogramming（TMP，模板元编程）可将工作由运行期移往编译期，因而得以实现早期错误侦测和更高的执行效率。
2. TMP 可被用来生成基于政策选择组合（based on combination of policy choices）的客户定制代码，也可用来避免生成对某些特殊类型并不合适的代码。



# 八、定制new 和delete

### 条款49：了解 new-handler 行为

当你调用 operator new 函数，程序无法满足某一内存需求时，它会抛出异常。老旧的编译器会返回 null 指针。而抛出异常之前，程序会先调用一个 operator new 错误处理函数，名叫 `new-handler`。 

> **new-handler 是一个 typedef**，指向一个无参数值无返回值的函数。我们可以通过 set_new_handler 函数去指定客户想要的 new-handler。
>
> set_new_handler 函数接受一个新的 new-handler 参数，返回被替换掉的 new-handler 函数。

一个设计良好的 new-handler 函数必须考虑以下几点： 

> 1.**提供更多的可被使用的内存。**这可以保证下次在operator new内部尝试分配内存时能够成功。实现这个策略的一种方法是在程序的开始阶段分配一大块内存，然后在第一次调用new-handler的时候释放它。
>
> 2.安装一个不同的new-handler。如果当前的new-handler不能够为你提供更多的内存，可能另外一个new-handler可以。如果是这样，可以在当前的new-handler的位置上安装另外一个new-handler（通过调用set_new_handler）。下次operator new调用new-handler函数的时候，它会调用最近安装的。（这个主题的一个变种是一个使用new_handler来修改它自己的行为，所以在下次触发这个函数的时候，它就会做一些不同的事情。达到这个目的的一个方法是让new_handler修改影响new-handler行为的static数据,命名空间数据或者全局数据。）
>
> 3.卸载new-handler，也就是为set_new_handler传递null指针。如果没有安装new-handler，operator  new在内存分配失败的时候会抛出异常。
>
> 4.抛出 bad-alloc，或派生自 bad-alloc 的异常。
>
> 5.没有返回值，**调用abort或者exit**。

有时候你或许希望以不同的方式处理内存分配的情况，比如按不同的 class 进行处理，但是 C++ 并不支持为每一个 class 提供专属版本的 new_handler，好在我们可以模仿这一行为，只要我们为 class 实现自己的 set_new_handler 函数 和 operator new 函数即可。

- 对于 set_new_handler ，我们根据参照默认实现即可 

```cpp
    static std::new_handler SetNewHandler(std::new_handler NewHandler) throw() {
        const std::new_handler OldHandler=std::set_new_handler(NewHandler);
        CurrentHandler=OldHandler;
        return OldHandler;
    }
```

- 对于 operator new，我们要做以下事情。 

> 调用标准版 set_new_handler 安装我们自定义的 new-handler，将返回的标准版 new-handler 保存起来。
> 调用标准版 operator new。如果标准版 operator new 异常，那么会调用我们自定义的 new-handler 处理函数。
> 调用标准版 set_new_handler 重新安装标准版的 new-handler。

为了确保可以重新安装标准版 new-handler，我们可以采用条款13所说`以对象管理资源`的方法： 

```cpp
class NewController {
public:
    explicit NewController(std::new_handler InHandler): Handler(InHandler) {}

    ~NewController() {
        std::set_new_handler(Handler);
    }

private:
    std::new_handler Handler;
};
```

 所以operator new 实现如下： 

```cpp
void* operator new(std::size_t Size) throw(std::bad_alloc) {
	NewController(std::set_new_handler(CurrentHandler));
	return ::operator new(Size);
}
```



但是上述代码还是不够简洁，每一个 class 都要自己实现一个 set_new_handler 和 operator new 版本。一个更好的方式是`使用 template 进行模板编程，然后根据不同 class 进行特化和具现化`。完整实现如下： 

```cpp
template <typename T>
class NewHandlerSupport {
public:
    static std::new_handler SetNewHandler(std::new_handler NewHandler) throw() {
        const std::new_handler OldHandler = std::set_new_handler(NewHandler);
        CurrentHandler = OldHandler;
        return OldHandler;
    }

    void* operator new(std::size_t Size) throw(std::bad_alloc) {
        NewController(std::set_new_handler(CurrentHandler));
        return ::operator new(Size);
    }
private:
    static std::new_handler CurrentHandler;
};
template <typename T>
std::new_handler  NewHandlerSupport<T>::CurrentHandler = nullptr;

class FDemo:public  NewHandlerSupport<FDemo> {
    
};

inline void TryWithNew() {
    FDemo::SetNewHandler([]() {
        std::cout<<"内存不够啦"<<"\n";
    });
    FDemo *Demos=new FDemo[1000123123100000]();
}
```

> 注意，**当 operator new 无法满足内存申请时，它会不断调用 new-handler 函数，直到找到足够内存或异常退出。**
> 当然，你想说为什么我们需要 template？我们似乎并没有使用到模板参数，是的，T 的确不被需要，我们只是希望，继承自 NewHandlerSupport 的 class 拥有各自的 CurrentHandler 成员。类型参数只是用来区分不同的派生类，**然后 template 机制会自动为每一个 T 具现化一份 CurrentHandler 成员，即使它是 static 的。**
> 也许你的焦虑还来自于 template class 导致的多重继承，可以先看看条款40。



总结：

1. **set_new_handler 允许客户指定一个函数，在内存分配无法获得满足时被调用。**
2. **Nothrow new 是一个颇为局限的工具，因为它只适用于内存分配；后继的构造函数调用还是可能抛出异常。**



### 条款50：了解new和delete的合理替换时机

替换缺省new/delete的三个常见原因：

> 1.用来检测运行上的错误。自定义new分配超额内存，在额外空间放置特定签名/byte pattern。在delete时检查是否不变；反之，肯定存在“overruns”（写入点在分配区块尾部之后）或“unferruns”（写入点在分配区块头部之前），delete也可log那个指针。
> 2.为了强化效能。缺省版new/delete必然比定制版new/delete效率低。
> 3.为了收集使用上的统计数据。自定义new/delete可以收集内存使用习惯与使用寿命。

当一定要写相关new/delete代码时，参考成熟的开源代码十分必要（条款54/55：TR1及Boost的Pool库）。

本条款的主题是，了**解何时可在"全局性的"或"class专属的"基础上合理替换缺省的new和delete**。在这之前，先对答案做一些摘要：

- 为了检测运用错误（如前所述）。
- 为了收集动态分配内存的使用统计信息（如前所述）。
- 为了增加分配和归还的速度。
- 为了降低缺省内存管理s器带来的空间额外开销。
- 为了弥补缺省分配器中的非最佳齐位。
- 为了将相关对象成簇集中。降低“内存页错误”（page fault）的频率，new/delete的“placement版本”（条款52）有可能完成。
- 为了获得非传统的行为。

总结：

1. **有许多理由需要写个自定的 new 和 delete，包括改善性能，对 heap 运用错误进行调用，收集 heap 使用信息。**



### 条款52：写了 placement new 也要写 placement delete

1.`placement new` 和 `placement delete` 在 C++ 中并不常见，如果不熟悉也不用太焦虑。 请回忆一下条款16和17，当你写一个 new 表达式时：

```cpp
String* Str = new String("Hello")；
```

> 共有两个函数被调用：一个是用以分配内存的 **operator new**，一个是 **String 的default构造函数**。
>
> 假如第一个函数调用成功，第二个函数却抛出异常。那么运行期系统必须回收第一个函数分配的内存，否则就会发生资源泄漏。在这个时候，客户没有能力归还内存，因为如果String构造函数抛出异常，str尚未被赋值，客户手上也就没有指针指向该被归还的内存。取消步骤一并恢复旧观的责任因此落到C++运行期系统身上。
> 运行期系统就会调用步骤一所调用的operator new的相应operator delete版本，前提是，**系统必须知道哪一个 operator delete 该被调用**，因为可能存在多个operator delete函数（可能接受不同的参数列表）。



2.对于`placement new/delete` ，它们接受额外的参数 。当人们谈及 placement new 时，大多数是指具有唯一额外实参 void* 的 operator new，少数时候才是指具有任意额外实参的 operator new。

> **当抛出异常时，运行期系统会寻找参数个数和类型都与 operator new 相同的某个 operator delete**。比如 operator new 额外接受一个 string 参数，那么 operator delete 也需要提供一个额外的 string 参数。如果并没有这样的 operator delete 函数，那么系统什么也不会做，内存就会泄漏掉。



3.值得注意的是，**placement delete 只有在 placement new 的调用构造函数异常时才会被系统调用**(即使我们可以显式调用 placement new，)。即使你对一个用 placement new 申请出的指针使用 delete，也绝不会调用 placement delete。这意味着额外的参数并不提供实际的作用。

> 所以，如果要处理 placement new 相关的内存泄漏问题，我们**必须同时提供一个正常版本的 delete 和 placement 版本的 delete**。前者用于构造期间无异常抛出，后者用于构造期间有异常抛出。 

除此之外，还要注意**同名函数遮掩调用的问题**

> 当你为 class 声明了 placement new 时，客户是无法使用标准版的 operator new 的，因为 derived class 声明的 operator new 会遮掩标准版本和 base class 版本。
> 所以如果你需要的客户在使用标准版本不受影响，也**需要同时提供标准版的定义**。



满足以上注意事项的一个简单做法是，`建立一个 base class`，内含所有标准版本的 new/delete，凡是想以写 placement 版本的 class 都可以继承自它，并使用 `using 声明式`使得标准版本在类中可见： 

```cpp
class FNewDeleteSupport {
public:
    // normal new/delete
    static void* operator new (std::size_t Size) throw(std::bad_alloc) {
        return ::operator new(Size);
    }
    static void operator delete (void* RawMemory) throw() {
        ::operator delete(RawMemory);
    }
    //placement new/delete
    static void* operator new (std::size_t Size,void *Ptr) throw() {
        return ::operator new(Size,Ptr);
    }
    static void operator delete (void* RawMemory,void *Ptr) throw() {
        ::operator delete(RawMemory,Ptr);
    }
    //nothrow new/delete
    static void* operator new (std::size_t Size,const std::nothrow_t& Nothrow) throw() {
        return ::operator new(Size,Nothrow);
    }
    static void operator delete (void* RawMemory,const std::nothrow_t& Nothrow) throw() {
        ::operator delete(RawMemory);
    }
};
class FDemo:public FNewDeleteSupport {
public:
    using FNewDeleteSupport::operator new;
    using FNewDeleteSupport::operator delete;

    //custom new/delete
    static void* operator new (std::size_t Size,std::string User) throw(std::bad_alloc) {
        std::cout<<User<<"使用了内存";
        return ::operator new(Size);
    }
    static void operator delete (void* RawMemory,std::string User) throw() {
        ::operator delete(RawMemory);
    }
};
```

总结:

1. 当你写一个 placement operator new，请确定也写出了对应的 placement operator delete。如果没有这样做，你的程序可能会发生隐微而时断时续的内存泄漏。
2. 当你声明 placement new 和 placement delete，请确定不要无意识（非故意）地遮掩了它们的正常版本。



# 九、杂项讨论

### 条款53：不要轻忽编译器的警告

许多程序员习惯性的忽略编辑器警告，这并不是一个好习惯。如：

```cpp
class B{
public:
    virtual void f() const;
};

class D{
public:
    virtual void f()''
};
```

> 这里希望以D::f重新定义virtual函数B::f，但其中有个错误：B中的f是个const成员函数，而在D中它未被声明为const。我手上的一个编译器于是这样说话了：`warning: D::f() hides virtual B::f()`
>
> 如果你认为：“当然，D::f遮掩了B::f，那正是想象中该有的事！”
>
> 那就大错特错了，该编译器试图告诉你声明于B中的f并未在D中被重新声明，而是被整个遮掩了（条款33描述为什么会这样）。如果忽略这个编译器警告，几乎肯定导致错误的程序行为，然后是许多调试行为，只为了找出编译器其实早就侦测出来并告诉你的事情。

因此，需要牢牢记住， **面对警告信息时，你一定要清楚的了解它的真实含义**，然后才可以选择性的处理或者忽略。 

总结：

1. **严肃对待编译器发出的警告信息。努力在你的编译器的最高（最严苛）警告级别下争取无任何警告的荣誉。**
2. **不要过度倚赖编译器的报警能力，因为不同的编译器对待事情的态度并不相同。一旦移植到另一个编译器上，你原来倚赖的警告信息有可能消失。**



### 条款54：让自己熟悉包括TR1在内的标准程序库

- 这部分建议学习`C++`新标准(`C++11`、`14`等)。



### 条款55：让自己熟悉 Boost

`boost`库是一个优秀的，可移植的，开源的 `C++` 库，它是由 `C++` 标准委员会发起的，其中一些内容已经成为了下一代 `C++` 标准库的内容，在 `C++` 社区中影响甚大，是一个不折不扣的准标准库，它的功能十分强大，弥补了 `C++` 很多功能函数处理上的不足。

很多`boost`中的库功能堪称对语言功能的扩展，其构造用尽精巧的手法，不要贸然的花费时间研读。`boost`另外一面，比如`Graph`这样的库则是具有工业强度，结构良好，非常值得研读的精品代码，并且也可以放心的在产品代码中多多利用。

有如下分类：

- **字符串和文本处理库**
  - Conversion库：对C++类型转换的增强，提供更强的类型安全转换、更高效的类型安全保护、进行范围检查的数值转换和词法转换。
  - Format库：实现类似printf的格式化对象，可以把参数格式化到一个字符串，而且是完全类型安全的。
  - IOStream库 ：扩展C++标准库流处理，建立一个流处理框架。
  - Lexical Cast库：用于字符串、整数、浮点数的字面转换。
  - Regex库：正则表达式，已经被TR1所接受。
  - Spirit库：基于EBNF范式的LL解析器框架
  - String Algo库：一组与字符串相关的算法
  - Tokenizer库：把字符串拆成一组记号的方法
  - Wave库：使用spirit库开发的一个完全符合C/C++标准的预处理器
  - Xpressive 库：无需编译即可使用的正则表达式库
- **容器库**
  - Array 库：对C语言风格的数组进行包装
  - Bimap 库：双向映射结构库
  - Circular Buffer 库：实现循环缓冲区的数据结构
  - Disjoint Sets库 ：实现不相交集的库
  - Dynamic Bitset 库：支持运行时调整容器大小的位集合
  - GIL 库：通用图像库
  - Graph 库：处理图结构的库
  - ICL 库：区间容器库，处理区间集合和映射
  - Intrusive 库：侵入式容器和算法
  - Multi-Array 库：多维容器
  - Multi-Index 库：实现具有多个STL兼容索引的容器
  - Pointer Container 库：容纳指针的容器
  - Property Map 库：提供键/值映射的属性概念定义
  - Property Tree 库：保存了多个属性值的树形数据结构
  - Unordered 库：散列容器，相当于hash_xxx
  - Variant 库：简单地说，就是持有string, vector等复杂类型的联合体
- **迭代器库**
  - GIL 库：通用图像库
  - Graph 库：处理图结构的库
  - Iterators 库：为创建新的迭代器提供框架
  - Operators 库：允许用户在自己的类里仅定义少量的操作符，就可方便地自动生成其他操作符重载，而且保证正确的语义实现
  - Tokenizer 库：把字符串拆成一组记号的方法
- **算法库**
  - Foreach库：容器遍历算法
  - GIL库：通用图像库
  - Graph库：处理图结构的库
  - Min-Max库：可在同一次操作中同时得到最大值和最小值
  - Range库：一组关于范围的概念和实用程序
  - String Algo库：可在不使用正则表达式的情况下处理大多数字符串相关算法操作
  - Utility库：小工具的集合
- **函数对象和高阶编程库**
  - Bind库：绑定器的泛化，已被收入TR1
  - Function库：实现一个通用的回调机制，已被收入TR1
  - Functional库：适配器的增强版本
  - Functional/Factory库：用于实现静态和动态的工厂模式
  - Functional/Forward库：用于接受任何类型的参数
  - Functional/Hash库：实现了TR1中的散列函数
  - Lambda库：Lambda表达式，即未命名函数
  - Member Function库：是STL中mem_fun和mem_fun_ref的扩展
  - Ref库：包装了对一个对象的引用，已被收入TR1
  - Result Of库：用于确定一个调用表达式的返回类型，已被收入TR1
  - **Signals库**：实现线程安全的观察者模式
  - Signals2库：基于Signal的另一种实现
  - Utility库：小工具的集合
  - Phoenix库：实现在C++中的函数式编程。
- **泛型编程库**
  - Call Traits库：封装可能是最好的函数传参方式
  - Concept Check库：用来检查是否符合某个概念
  - Enable If库:允许模板函数或模板类在偏特化时仅针对某些特定类型有效
  - Function Types库：提供对函数、函数指针、函数引用和成员指针等类型进行分类分解和合成的功能
  - GIL库：通用图像库
  - In Place Factory, Typed In Place Factory库：工厂模式的一种实现
  - Operators库：允许用户在自己的类里仅定义少量的操作符，就可方便地自动生成其他操作符重载，而且保证正确的语义实现
  - Property Map库：提供键值映射的属性概念定义
  - Static Assert库：把断言的诊断时刻由运行期提前到编译期，让编译器检查可能发生的错误
  - Type Traits库：在编译时确定类型是否具有某些特征
  - TTI库：实现类型萃取的反射功能。
- **模板元编程**
  - Fusion库：提供基于tuple的编译期容器和算法
  - MPL库：模板元编程框架
  - Proto库：构建专用领域嵌入式语言
  - Static Assert库：把断言的诊断时刻由运行期提前到编译期，让编译器检查可能发生的错误
  - Type Traits库：在编译时确定类型是否具有某些特征预处理元编程库
  - Preprocessors库：提供预处理元编程工具
- **并发编程库**
  - **Asio库**：基于操作系统提供的异步机制，采用前摄设计模式实现了可移植的异步IO操作
  - **Interprocess库**：实现了可移植的进程间通信功能，包括共享内存、内存映射文件、信号量、文件锁、消息队列等
  - **MPI库**：用于高性能的分布式并行开发
  - Thread库：为C++增加线程处理能力，支持Windows和POSIX线程
  - Context库：提供了在单个线程上的协同式多任务处理的支持。该库可以用于实现用户级的多任务处理的机制，比如说协程coroutines，用户级协作线程或者类似于C#语言中yield关键字的实现。
  - Atomic库：实现C++11样式的atomic<>，提供原子数据类型的支持和对这些原子类型的原子操作的支持。
  - **Coroutine库**：实现对协程的支持。协程与线程的不同之处在于，协程是基于合作式多任务的，而多线程是基于抢先式多任务的。
  - Lockfree库：提供对无锁数据结构的支持。
- **数学和数字库**
  - Accumulators库：用于增量计算的累加器的框架
  - Integer库：提供一组有关整数处理的类
  - Interval库：处理区间概念的数学问题
  - Math库：数学领域的模板类和算法
  - Math Common Factor库：用于支持最大公约数和最小公倍数
  - Math Octonion库 ：用于支持八元数
  - Math Quaternion库：用于支持四元数
  - Math/Special Functions库：数学上一些常用的函数
  - Math/Statistical Distributions库：用于单变量统计分布操作
  - Multi-Array库：多维容器
  - Numeric Conversion库：用于安全数字转换的一组函数
  - Operators库：允许用户在自己的类里仅定义少量的操作符，就可方便地自动生成其他操作符重载，而且保证正确的语义实现
  - Random库：专注于伪随机数的实现，有多种算法可以产生高质量的伪随机数
  - Rational库：实现了没有精度损失的有理数
  - uBLAS库：用于线性代数领域的数学库
  - Geometry库：用于解决几何问题的概念、原语和算法。
  - Ratio库：根据C++ 0x标准N2661号建议，实现编译期的分数操作。
  - Multiprecision库：提供比C++内置的整数、分数和浮点数精度更高的多精度数值运算功能。
  - Odeint库：用于求解常微分方程的初值问题。
- **排错和测试库**
  - Concept Check库 ：用来检查是否符合某个概念
  - Static Assert库 ：把断言的诊断时刻由运行期提前到编译期，让编译器检查可能发生的错误
  - Test库：提供了一个用于单元测试的基于命令行界面的测试套件
- **数据结构库**
  - Any库：支持对任意类型的值进行类型安全的存取
  - Bimap库：双向映射结构库
  - Compressed Pair库：优化的对pair对象的存储
  - Fusion库：提供基于tuple的编译期容器和算法
  - ICL库：区间容器库，处理区间集合和映射
  - Multi-Index库：为底层的容器提供多个索引
  - Pointer Container库：容纳指针的容器
  - Property Tree库：保存了多个属性值的树形数据结构
  - Tuple库：元组，已被TR1接受
  - Uuid库：用于表示和生成UUID
  - Variant库：有类别的泛型联合类
  - Heap库：对std::priority_queue扩展，实现优先级队列。
  - Type Erasure: 实现运行时的多态。
- **图像处理库**
  - GIL库：通用图像库
- **输入输出库**
  - Assign库：用简洁的语法实现对STL容器赋值或者初始化
  - Format库：实现类似printf的格式化对象，可以把参数格式化到一个字符串，而且是完全类型安全的
  - IO State Savers库：用来保存流的当前状态，自动恢复流的状态等
  - IOStreams库：扩展C++标准库流处理，建立一个流处理框架
  - Program Options库：提供强大的命令行参数处理功能
  - Serialization库：实现C++数据结构的持久化
- **跨语言混合编程库**
  - **Python库**：用于实现Python和C++对象的无缝接口和混合编程
- **内存管理库**
  - **Pool库**：基于简单分隔存储思想实现了一个快速、紧凑的内存池库
  - Smart Ptr库：智能指针
  - Utility库：小工具的集合
- **解析库**
  - Spirit库：基于EBNF范式的LL解析器框架
- **编程接口库**
  - Function库：实现一个通用的回调机制，已被收入TR1
  - Parameter库：提供使用参数名来指定函数参数的机制
- **综合类库**
  - Compressed Pair库：优化的对pair对象的存储
  - CRC库：实现了循环冗余校验码功能
  - Date Time 库：一个非常全面灵活的日期时间库
  - Exception库：针对标准库中异常类的缺陷进行强化，提供<<操作符重载，可以向异常传入任意数据
  - Filesystem库：可移植的文件系统操作库，可以跨平台操作目录、文件，已被TR2接受
  - Flyweight 库：实现享元模式，享元对象不可修改，只能赋值
  - Lexical Cast 库：用于字符串、整数、浮点数的字面转换
  - Meta State Machine库：用于表示UML2有限状态机的库
  - Numeric Conversion 库：用于安全数字转换的一组函数
  - Optional 库：使用容器的语义，包装了可能产生无效值的对象，实现了未初始化的概念
  - Polygon 库：处理平面多边形的一些算法
  - Program Options库：提供强大的命令行参数处理功能
  - Scope Exit库：使用preprocessor库的预处理技术实现在退出作用域时资源自动释放
  - Statechart库：提供有限自动状态机框架
  - Swap库：为交换两个变量的值提供便捷方法
  - System库：使用轻量级的对象封装操作系统底层的错误代码和错误信息，已被TR2接受
  - Timer库：提供简易的度量时间和进度显示功能，可以用于性能测试等需要计时的任务
  - Tribool库：三态布尔逻辑值，在true和false之外引入indeterminate不确定状态
  - ypeof库：模拟C++0x新增加的typeof和auto关键字，以减轻变量类型声明的工作，简化代码
  - Units库：实现了物理学的量纲处理
  - Utility库：小工具集合
  - Value Initialized库：用于保证变量在声明时被正确初始化
  - Chrono库：实现了C++ 0x标准中N2661号建议所支持的时间功能。
  - Log库：实现日志功能。
  - Predef库：提供一批统一兼容探测其他宏的预定义宏。
- 编译器问题的变通方案库
  - Compatibility库：为不符合标准库要求的环境提供帮助
  - Config库：将程序的编译配置分解为三个部分：平台、编译器和标准库，帮助库开发者解决特定平台特定编译器的兼容问题

