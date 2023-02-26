# 术语和惯例

> 作者与读者之间的一些约定，方便理解。

1.C++的版本

| 我使用的词 | 我意思中的语言版本 |
| ---------- | ------------------ |
| C++        | 所有版本           |
| C++98      | C++98和C++03       |
| C++11      | C++11和C++14       |
| C++14      | C++14              |

> 如： C++重视效率（对所有版本正确），C++98缺少并发的支持（只对C++98和C++03正确），C++11支持lambda表达式（对C++11和C++14正确），C++14提供了普遍的函数返回类型推导（只对C++14正确）。 

2.移动语义

移动语义的基础是区分右值和左值表达式 。**判断一个表达式是否是左值的一个有用的启发就是**，看看能否取得它的地址。如果能取地址，那么通常就是左值。如果不能，则通常是右值。 

> 这个启发的好处就是帮你记住，**一个表达式的类型与它是左值还是右值无关**。也就是说，有个类型`T`，你可以有类型`T`的左值和右值。当你碰到右值引用类型的形参时，记住这一点非常重要，因为**形参本身是个左值：** 

```cpp
class Widget {
public:
    Widget(Widget&& rhs);   //rhs是个左值，
    …                       //尽管它有个右值引用的类型
};
//在这里，在Widget移动构造函数里取rhs的地址非常合理，所以rhs是左值，尽管它的类型是右值引用。
```

3.作者在代码中遵循的惯用法 

- 类的名字是常用`Widget`。 
- 形参名`rhs`（“right-hand side”）。这是我喜欢的**移动操作**（即移动构造函数和移动赋值运算符）和**拷贝操作**（拷贝构造函数和拷贝赋值运算符）的形参名。 
- 使用“`…`”来表示“这里有一些别的代码”。这种窄省略号不同于C++11可变参数模板源代码中的宽省略号（“`...`”）。 

4.当使用另一个同类型的对象来初始化一个对象时，新的对象被称为是用来初始化的对象（initializing object，即源对象）的一个**副本**（*copy*），尽管这个副本是通过移动构造函数创建的。 

```cpp
void someFunc(Widget w);        //someFunc的形参w是传值过来

Widget wid;                     //wid是个Widget

someFunc(wid);                  //在这个someFunc调用中，w是通过拷贝构造函数
                                //创建的副本

someFunc(std::move(wid));       //在这个someFunc调用中，w是通过移动构造函数
                                //创建的副本
```

5.当我提到“**函数对象**”时，我通常指的是某个支持`operator()`成员函数的类型的对象。

6.通过*lambda*表达式创建的函数对象称为**闭包**（*closures*）。

7.声明与定义

> **声明**（*declarations*）引入名字和类型，并不给出比如存放在哪或者怎样实现等的细节： 

```cpp
extern int x;                       //对象声明
class Widget;                       //类声明
bool func(const Widget& w);         //函数声明
enum class Color;                   //限域enum声明（见条款10）
```

> **定义**（*definitions*）提供存储位置或者实现细节： 

```cpp
int x;                              //对象定义
class Widget {                      //类定义
    …
};

bool func(const Widget& w)
{ return w.size() < 10; }           //函数定义

enum class Color
{ Yellow, Red, Blue };              //限域enum定义
```

我定义一个函数的**签名**（*signature*）为它声明的一部分，这个声明指定了形参类型和返回类型。函数名和形参名不是签名的一部分。在上面的例子中，`func`的签名是`bool(const Widget&)`。函数声明中除了形参类型和返回类型之外的元素（比如`noexcept`或者`constexpr`，如果存在的话）都被排除在外。 

8.我将那些比如从`new`返回的内置指针（*build-in pointers*）称为**原始指针**（*raw pointers*）。原始指针的“反义词”是**智能指针**（*smart pointers*）。智能指针通常重载指针解引用运算符（`operator->`和`operator*`），但在Item20中解释看`std::weak_ptr`是个例外。 



# 第1章 类型推导

C++98有一套类型推导的规则：用于函数模板的规则。C++11修改了其中的一些规则并增加了两套规则，一套用于`auto`，一套用于`decltype`。C++14扩展了`auto`和`decltype`可能使用的范围。 

优点： 让C++程序更具适应性。 让你从拼写那些或明显或冗杂的类型名的暴行中脱离出来。

缺点： 类型推导也会让代码更复杂，因为由编译器进行的类型推导并不总是如我们期望的那样进行。 



### Item1:理解模板类型推导

> 真正理解`auto`基于的模板类型推导的方方面面非常重要。这项条款便包含了你需要知道的东西 

首先，看一个函数模板的例子

```cpp
template<typename T>
void f(ParamType param);

//调用
f(expr);                        //使用表达式调用f，从expr中推导T和ParamType
```

在编译期间，编译器使用`expr`进行两个类型推导：一个是针对`T`的，另一个是针对`ParamType`的。这两个类型通常是不同的，因为`ParamType`包含一些修饰，比如`const`和引用修饰符。举比如模板这样声明： 

```cpp
template<typename T>
void f(const T& param);         //ParamType是const T&

//然后这样进行调用
int x = 0;
f(x);                           //用一个int类型的变量调用f
```

`T`被推导为`int`，`ParamType`却被推导为`const int&` 。

我们可能很自然的期望`T`和传递进函数的实参是相同的类型（即`T`为`expr`的类型。在上面的例子中：`x`是`int`，`T`被推导为`int`）。

但需要注意的是，**`T`的类型推导不仅取决于`expr`的类型，也取决于`ParamType`的类型**。这里有三种情况： 

- `ParamType`是一个指针或引用，但不是通用引用（关于通用引用请参见Item24。在这里你只需要知道它存在，而且不同于左值引用和右值引用）
- `ParamType`一个通用引用
- `ParamType`既不是指针也不是引用。

> 我们下面将分成三个情景来讨论这三种情况，每个情景的都基于我们之前给出的模板。



**情景一：`ParamType`是一个指针或引用，但不是通用引用**

在这种情况下，类型推导会这样进行：

1. 如果`expr`的类型是一个引用，忽略引用部分
2. 然后`expr`的类型与`ParamType`进行模式匹配来决定`T`

例1：函数`f`的形参为`T&`

```cpp
//这是我们的模板，
template<typename T>
void f(T& param);               //param是一个引用

//声明这些变量
int x=27;                       //x是int
const int cx=x;                 //cx是const int
const int& rx=x;                //rx是指向作为const int的x的引用

//在不同的调用中，对param和T推导的类型会是这样：
f(x);                           //T是int，param的类型是int&
f(cx);                          //T是const int，param的类型是const int&
f(rx);                          //T是const int，param的类型是const int&
```

要点：

- 对象的常量性`const`ness会被保留为`T`的一部分【`f(cx) `、`f(rx)`表现出的性质】。 
- **实参**的引用性（reference-ness）在类型推导中会被忽略【`f(rx)`中 `rx`的类型是一个引用，`T`被推导为非引用 】。
- 这三个调用实力只展示了左值引用，但是类型推导会如左值引用一样对待右值引用。当然，右值只能传递给右值引用，但是在类型推导中这种限制将不复存在。 



例2： 函数`f`的形参类型改为`const T&` 

> 情况变化不大。`cx`和`rx`的`constness`依然被遵守，但是因为现在我们假设`param`是reference-to-`const`，`const`不再被推导为`T`的一部分：

```cpp
template<typename T>
void f(const T& param);         //param现在是reference-to-const

int x = 27;                     //如之前一样
const int cx = x;               //如之前一样
const int& rx = x;              //如之前一样

f(x);                           //T是int，param的类型是const int&
f(cx);                          //T是int，param的类型是const int&
f(rx);                          //T是int，param的类型是const int&
//同之前一样，rx的reference-ness在类型推导中被忽略了。
```



例3：`param`是一个指针（或者指向`const`的指针）而不是引用，情况本质上也一样

```cpp
template<typename T>
void f(T* param);               //param现在是指针

int x = 27;                     //同之前一样
const int *px = &x;             //px是指向作为const int的x的指针

f(&x);                          //T是int，param的类型是int*
f(px);                          //T是const int，param的类型是const int*
```



**情景二：`ParamType`是一个通用引用**

> 此时形参被声明为像右值引用一样（也就是，在函数模板中假设有一个类型形参`T`，那么通用引用声明形式就是`T&&`)，它们的行为在传入左值实参时大不相同。

推导规则：

- 如果`expr`是左值，`T`和`ParamType`都会被推导为左值引用。这非常不寻常，第一，这是模板类型推导中唯一一种`T`被推导为引用的情况。第二，虽然`ParamType`被声明为右值引用类型，但是最后推导的结果是左值引用。
- 如果`expr`是右值，就使用正常的（也就是**情景一**）推导规则

例如：

```cpp
template<typename T>
void f(T&& param);              //param现在是一个通用引用类型
        
int x=27;                       //如之前一样
const int cx=x;                 //如之前一样
const int & rx=cx;              //如之前一样

f(x);                           //x是左值，所以T是int&，
                                //param类型也是int&

f(cx);                          //cx是左值，所以T是const int&，
                                //param类型也是const int&

f(rx);                          //rx是左值，所以T是const int&，
                                //param类型也是const int&

f(27);                          //27是右值，所以T是int，
                                //param类型就是int&&
```



**情景三：ParamType既不是指针也不是引用**

此时，通过传值（pass-by-value）的方式处理：

```cpp
template<typename T>
void f(T param);                //以传值的方式处理param
```

这意味着无论传递什么`param`都会成为它的一份拷贝——一个完整的新对象。

推导规则：

1. 和之前一样，如果`expr`的类型是一个引用，忽略这个引用部分
2. 如果忽略`expr`的引用性（reference-ness）之后，`expr`是一个`const`，那就再忽略`const`。如果它是`volatile`，也忽略`volatile`（`volatile`对象不常见，它通常用于驱动程序的开发中。关于`volatile`的细节请参见Item40）

因此

```cpp
int x=27;                       //如之前一样
const int cx=x;                 //如之前一样
const int & rx=cx;              //如之前一样

f(x);                           //T和param的类型都是int
f(cx);                          //T和param的类型都是int
f(rx);                          //T和param的类型都是int
```

要点：

- 具有常量性的`cx`和`rx`不可修改并不代表`param`也是一样。（param是前两者独立的拷贝）

> 这就是为什么`expr`的常量性`const`ness（或易变性`volatile`ness)在推导`param`类型时会被忽略：因为`expr`不可修改并不意味着它的拷贝也不能被修改。 

- 只有在传值给形参时才会忽略`const` 。

认识到只有在传值给形参时才会忽略`const`（和`volatile`）这一点很重要。对于reference-to-`const`和pointer-to-`const`形参来说，`expr`的常量性`const`ness在推导时会被保留。

但是请考虑这样的情况：`expr`是一个`const`指针，指向`const`对象，`expr`通过传值传递给`param`

此时会发生什么?

```cpp
template<typename T>
void f(T param);                //仍然以传值的方式处理param

const char* const ptr =         //ptr是一个常量指针，指向常量对象 
    "Fun with pointers";

f(ptr);                         //传递const char * const类型的实参
```

> 当`ptr`作为实参传给`f`，组成这个指针的每一比特都被拷贝进`param`。像这种情况，`ptr`**自身的值会被传给形参**，根据类型推导的第三条规则，`ptr`自身的常量性`const`ness将会被省略，所以`param`是`const char*`，也就是一个可变指针指向`const`字符串。在类型推导中，这个指针指向的数据的常量性`const`ness将会被保留，但是当拷贝`ptr`来创造一个新指针`param`时，`ptr`自身的常量性`const`ness将会被忽略。 



**补充细节一：数组实参**

数组类型不同于指针类型，虽然它们两个有时候是可互换的。关于这个错觉最常见的例子是，在很多上下文中数组会退化为指向它的第一个元素的指针。这样的退化允许像这样的代码可以被编译：

```cpp
const char name[] = "J. P. Briggs";  //name的类型是const char[13]

const char * ptrToName = name;       //数组退化为指针。const char*指针ptrToName会由name初始化
```

但要是一个数组传值给一个模板会怎样？会发生什么？

> 因为数组形参会视作指针形参，所以传值给模板的一个数组类型会被推导为一个指针类型。这意味着在模板函数`f`的调用中，它的类型形参`T`会被推导为`const char*`：

```cpp
template<typename T>
void f(T param);                        //传值形参的模板

f(name);                                //name是一个数组，但是T被推导为const char*           
```

但是，虽然函数不能声明形参为真正的数组，但是**可以**接受指向数组的**引用**！所以我们修改`f`为传引用：

```cpp
template<typename T>
void f(T& param);                       //传引用形参的模板
//我们这样进行调用
f(name);                                //传数组给f
```

`T`被推导为了真正的数组！这个类型包括了数组的大小，在这个例子中`T`被推导为`const char[13]`，`f`的形参（对这个数组的引用）的类型则为`const char (&)[13]`。是的，这种语法看起来简直有毒....但可以装逼

有趣的是，可声明指向数组的引用的能力，使得我们可以创建一个模板函数来推导出数组的大小：

```cpp
//在编译期间返回一个数组大小的常量值（//数组形参没有名字，
//因为我们只关心数组的大小）
template<typename T, std::size_t N>                     
constexpr std::size_t arraySize(T (&)[N]) noexcept //arraySize被声明为noexcept     
{                                                  //会使得编译器生成更好的代码，
    return N;                                      //具体的细节请参见Item14。          
}                                                       
```

在Item15提到**将一个函数声明为`constexpr`使得结果在编译期间可用**。这使得我们可以用一个花括号声明一个数组，然后第二个数组可以使用第一个数组的大小作为它的大小，就像这样：

```cpp
int keyVals[] = { 1, 3, 7, 9, 11, 22, 35 };             //keyVals有七个元素

int mappedVals[arraySize(keyVals)];                     //mappedVals也有七个
```

当然作为一个现代C++程序员，你自然应该想到使用`std::array`而不是内置的数组：

```cpp
std::array<int, arraySize(keyVals)> mappedVals;         //mappedVals的大小为7
```



**补充细节二：函数实参**

> 在C++中不只是数组会退化为指针，函数类型也会退化为一个函数指针，我们对于数组类型推导的全部讨论都可以应用到函数类型推导和退化为函数指针上来。 

```cpp
void someFunc(int, double);         //someFunc是一个函数，
                                    //类型是void(int, double)

template<typename T>
void f1(T param);                   //传值给f1

template<typename T>
void f2(T & param);                 //传引用给f2

f1(someFunc);                       //param被推导为指向函数的指针，
                                    //类型是void(*)(int, double)
f2(someFunc);                       //param被推导为指向函数的引用，
                                    //类型是void(&)(int, double)
```

> 这里你需要知道：`auto`依赖于模板类型推导。正如我在开始谈论的，在大多数情况下它们的行为很直接。在通用引用中对于左值的特殊处理使得本来很直接的行为变得有些污点，然而，数组和函数退化为指针把这团水搅得更浑浊。有时你只需要编译器告诉你推导出的类型是什么。这种情况下，翻到[item4](https://github.com/kelthuzadx/EffectiveModernCppChinese/blob/master/1.DeducingTypes/item4.md),它会告诉你如何让编译器这么做。 



**请记住：**

- 在模板类型推导时，有引用的实参会被视为无引用，他们的引用会被忽略
- 对于通用引用的推导，左值实参会被特殊对待
- 对于传值类型推导，`const`和/或`volatile`实参会被认为是non-`const`的和non-`volatile`的
- 在模板类型推导时，数组名或者函数名实参会退化为指针，除非它们被用于初始化引用



### Item2：理解`auto`类型推导

该条款主要内容基本可概括为两点：

- `auto`类型推导通常和模板类型推导相同，仅有一个例外。

  > Item1描述的三个情景、 数组和函数名如何退化为指针，这些都适用于auto类型推导。

- 仅有的一个例外是指：`auto`类型推导假定花括号初始化代表`std::initializer_list`，而模板类型推导不这样做 

关于第一点这里不进行赘述，熟悉item1在快速浏览以下item2该部分内容即可知晓。这里主要讨论第二点“一个例外”。

为了方便理解，首先看一些伪代码：

```cpp
//如果你想声明一个带有初始值27的int，C++98提供两种语法选择：
int x1 = 27;
int x2(27);
//C++11由于也添加了用于支持统一初始化（uniform initialization）的语法：
int x3 = { 27 };
int x4{ 27 };
```

> 上述四种不同的语法只会产生一个相同的结果：变量类型为`int`值为27。

但Item5解释了使用`auto`说明符代替指定类型说明符的好处，所以现在把上面声明中的`int`替换为`auto`，并分析其类型：

```cpp
auto x1 = 27;                   //类型是int，值是27
auto x2(27);                    //同上

auto x3 = { 27 };               //类型是std::initializer_list<int>，值是{ 27 }
auto x4{ 27 };                  //同上
//可以发现，前面两个语句确实声明了一个类型为int值为27的变量，但是后面两个声明了一个存储一个元素27的 std::initializer_list<int>类型的变量。
```

这就造成了`auto`类型推导不同于模板类型推导的特殊情况：**当用`auto`声明的变量使用花括号进行初始化，`auto`类型推导推出的类型则为`std::initializer_list`。** 

如果这样的一个类型不能被成功推导（比如花括号里面包含的是不同类型的变量），编译器会拒绝这样的代码： 

```cpp
auto x5 = { 1, 2, 3.0 };        //错误！无法推导std::initializer_list<T>中的T
```

这里发生了两种类型推导：

- 首先是`auto`类型推导。(`x5`使用花括号的方式进行初始化，`x5`必须被推导为`std::initializer_list`。)
- 然后是模板类型推导。

> 模板类型推导的发生是由于auto类型推导出的 `std::initializer_list`是一个模板。`std::initializer_list`会被某种类型`T`实例化，所以这意味着`T`也会被推导(落入模板类型推导的范围)。 在这个例子中推导之所以失败，是因为在花括号中的值并不是同一种类型。 

还需要知道的一点是： 

**`auto`类型推导和模板类型推导的真正区别在于，`auto`类型推导假定花括号表示`std::initializer_list`而模板类型推导不会这样（确切的说是不知道怎么办）。** 

例如：

```cpp
auto x = { 11, 23, 9 };         //x的类型是std::initializer_list<int>
template<typename T>            //带有与x的声明等价的
void f(T param);                //形参声明的模板
f({ 11, 23, 9 });               //错误！不能推导出T

//如果在模板中指定T是std::initializer_list<T>而留下未知T,模板类型推导就能正常工作：
template<typename T>
void f(std::initializer_list<T> initList);

f({ 11, 23, 9 });               //T被推导为int，initList的类型为
                                //std::initializer_list<int>
```



最后再补充一下C++14中关于auto推导的内容：

- 在C++14中`auto`允许出现在函数返回值或者*lambda*函数形参中，但是它的工作机制是模板类型推导那一套方案，而不是`auto`类型推导

```cpp
auto createInitList()
{
    return { 1, 2, 3 };         //错误！不能推导{ 1, 2, 3 }的类型
}

//样在C++14的lambda函数中这样使用auto也不能通过编译：
std::vector<int> v;
…
auto resetV = 
    [&v](const auto& newValue){ v = newValue; };        //C++14
…
resetV({ 1, 2, 3 });            //错误！不能推导{ 1, 2, 3 }的类型
```



### Item3：理解`decltype` 

首先先放上该条款结论：

- `decltype`总是不加修改的产生变量或者表达式的类型。
- 对于`T`类型的不是单纯的变量名的左值表达式，`decltype`总是产出`T`的引用即`T&`。
- C++14支持`decltype(auto)`，就像`auto`一样，推导出类型，但是它使用`decltype`的规则进行推导。

总的来说，该条款讲了三件事

1. 一般来说 `decltype`只是简单的返回名字或者表达式的类型。（结论第一点）
2. `decltype`在C++11和C++14中的使用及区别。
3. `decltype`的非常规情况

接下来以此说明这三件事发生了什么。



**一、`decltype`只是简单的返回名字或者表达式的类型**

这部分很简单，看一下几个例子就好。

```cpp
const int i = 0;                //decltype(i)是const int

bool f(const Widget& w);        //decltype(w)是const Widget&
                                //decltype(f)是bool(const Widget&)

struct Point{
    int x,y;                    //decltype(Point::x)是int
};                              //decltype(Point::y)是int

Widget w;                       //decltype(w)是Widget

if (f(w))…                      //decltype(f(w))是bool

template<typename T>            //std::vector的简化版本
class vector{
public:
    …
    T& operator[](std::size_t index);
    …
};

vector<int> v;                  //decltype(v)是vector<int>
…
if (v[0] == 0)…                 //decltype(v[0])是int&
```



**二、`decltype`在C++11和C++14中的使用及区别。**

在开始叙述之前，首先要先知道：

>  对一个`T`类型的容器使用`operator[]` 通常会**返回一个`T&`对象**，比如`std::deque`就是这样。但是`std::vector`有一个例外，对于`std::vector`，`operator[]`不会返回`bool&`，它会返回一个全新的对象（译注：MSVC的STL实现中返回的是`std::_Vb_reference>>`对象）。关于这个问题的详细讨论请参见Item6，这里重要的是我们可以看到对一个容器进行`operator[]`操作返回的类型取决于容器本身。 



接下来先看**C++14中decltype的使用：**

```cpp
template<typename Container, typename Index>    //最终的C++14版本
decltype(auto)
authAndAccess(Container&& c, Index i)           //通用引用
{
    authenticateUser();
    return std::forward<Container>(c)[i];       //应用std::forward实现通用引用（Item25）
}
```

在该版本中，有以下几点需要特别注意：

- 使用`decltype(auto)`修饰`authAndAccess`而非单独的`auto`是因为：函数返回类型中使用`auto`，编译器实际上是使用的模板类型推导的那套规则（Item1），而 Item1解释了在模板类型推导期间，表达式的引用性会被忽略。如果没用使用`decltype(auto)`：

```cpp
std::deque<int> d;
…
authAndAccess(d, 5) = 10;               //认证用户，返回d[5]，然后把10赋值给它
                                        //但无法通过编译器！
//在这里d[5]本该返回一个int&，但是模板类型推导会剥去引用的部分，因此产生了int返回类型。函数返回的那个int是一个右值，上面的代码尝试把10赋值给右值int，C++11禁止这样做，所以代码无法编译。
```

-  `decltype(auto)`的含义：`auto`说明符表示这个类型将会被推导，`decltype`说明`decltype`的规则将会被用到这个推导过程中。 
-  `decltype(auto)`的使用不仅仅局限于函数返回类型，当你想对初始化表达式使用`decltype`推导的规则，你也可以使用：

```cpp
Widget w;
const Widget& cw = w;
auto myWidget1 = cw;                    //auto类型推导,myWidget1的类型为Widget
decltype(auto) myWidget2 = cw;          //decltype类型推导,myWidget2的类型是const Widget&
```

- `authAndAccess(Container&& c, Index i) `使用通用引用是为了适应一种**edge case**情况：**向`authAndAccess`传递一个右值**。（这一点请看书，很好理解）
-  `std::forward`实现通用引用 是听从了Item25的告诫。（这里先记住即可）



**C++11中decltype的使用：**

该版本看起来和C++14版本的极为相似，**除了你不得不指定函数返回类型**之外 

```cpp
template<typename Container, typename Index>    //最终的C++11版本
auto                                            //auto不会做任何的类型推导工作
authAndAccess(Container&& c, Index i)
->decltype(std::forward<Container>(c)[i])
{
    authenticateUser();
    return std::forward<Container>(c)[i];
}
```

在该版本中，有以下几点需要特别注意：

- 函数名称前面的`auto`不会做任何的类型推导工作。相反的，他只是暗示使用了C++11的**尾置返回类型**语法( ”`->`“ )。
- 尾置返回类型的好处是我们可以在函数返回类型中使用函数形参相关的信息。
- 在`authAndAccess`函数中，我们使用`c`和`i`指定返回类型。如果我们按照传统语法把函数返回类型放在函数名称之前，`c`和`i`就未被声明所以不能使用。 
- 在C++11中，`decltype`最主要的用途就是用于声明函数模板，而这个函数返回类型依赖于形参类型。



**三、`decltype`的非常规情况**

- 对于单纯的变量名，`decltype`只会返回变量的声明类型。
- 但是，对于比单纯的变量名更**复杂的左值表达式**，`decltype`可以**确保报告的类型始终是左值引用**。也就是说，如果一个不是单纯变量名的左值表达式的类型是`T`，那么`decltype`会把这个表达式的类型报告为`T&`。 

```cpp
int x = 0;      //decltype(x)是int
int (x) = 0;    //decltype((x))是int&

//C++14中
decltype(auto) f1()
{
    int x = 0;
    …
    return x;                            //decltype(x）是int，所以f1返回int
}

decltype(auto) f2()
{
    int x = 0;
    return (x);                          //decltype((x))是int&，所以f2返回int&
}
```

注意不仅`f2`的返回类型不同于`f1`，而且它还引用了一个局部变量！这样的代码将会把你送上未定义行为的特快列车。

所以，当使用`decltype(auto)`的时候一定要加倍的小心，在表达式中看起来无足轻重的细节将会影响到`decltype(auto)`的推导结果。为了确认类型推导是否产出了你想要的结果，请参见Item4描述的那些技术。 





### Item4：学会查看类型推导结果

该条款介绍了一些工具来帮助我们确定类型推导结果，但利用工具常常不尽人意，不是难读懂就是推到错误（Boost TypeIndex库相对好用），打铁还需自身硬，所以主要还是要**理解Item1-3中的C++类型推导规则**。

结论：

- 类型推断可以从IDE看出，从编译器报错看出，从Boost TypeIndex库的使用看出。
- 这些工具可能既不准确也无帮助，所以**理解C++类型推导规则才是最重要的**。