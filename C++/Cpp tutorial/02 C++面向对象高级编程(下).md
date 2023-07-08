### 1.前言

侯捷老师讲的是真的很好，逻辑清晰，讲解清楚。一口气看完了，半天看完，半天整理笔记。

其实这个课程应该称为C++程序设计Ⅱ兼谈对象模型，因为他并没有过多的叙述面向对象编程，而是在上篇的基础上探讨一些没有讨论过的主题。在该课程中，侯捷老师从四个部分讲述：

第一是before C++。其实就是讲述了C++编程中常用的功能函数，我为了区分所以就称为before C++。

第二是Since C++。C++11部分讲述较少，仅讲述了variadic templates、auto、范围for循环这三个部分。

第三是Object Model。重点讲述了虚函数、虚指针、虚表、动态绑定。

最后一部分是侯捷老师进行的一些补充内容，讲的是const与动态分配new、delete。



# 一、before C++11

### 2.conversion function转换函数

作用：把一个class的类型转换成你想要的、自认为合理的类型。

格式：`operator double() const {...}`    (以转换成double类型为例)

特点：

- 一定要有关键字operator，且目标类型不能带参数
- 大多数情况下都要加const属性
- 只要你认为合理，你可以在类中写多个转换函数，将class类型转换成多个其他类型。

<img src="C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1660915484813.png" alt="1660915484813" style="zoom: 50%;" />



### 3.non-explicit-one-argument ctor与explicit-one-argument ctor

non-explicit-one-argument ctor(非显式的一个参实参)其实与转换函数的功能**相反**，它的作用是：**把其他类型转换成我这个class的类型。**

<img src="C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1660917106060.png" alt="1660917106060" style="zoom: 50%;" />



如果**转换函数和non-explicit-one-argument ctor同时出现**，则会**引起歧义**！

因为此时编译器再调用的时候发现：

- 可以通过non-explicit-one-argument ctor把4转换成Fraction类型，再与f相加。
- 也可以通过转换函数把Fraction类型的f转换成0.6，再与4相加，再通过non-explicit-one-argument ctor转换成Fraction类型。

编译器发现有多条路可以走通，则引起了二义性（歧义）！

<img src="C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1660917277038.png" alt="1660917277038" style="zoom: 50%;" />



解决二义性的方法就是把**non-explicit**-one-argument ctor声明为**explicit**-one-argument ctor，这样就禁止默认转换了。

<img src="C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1660917586661.png" alt="1660917586661" style="zoom: 50%;" />



### 4.pointer-like classes （仿指针）

**(1)智能指针**

智能指针就是一种经典的“像一个指针的类”。它的实现有如下特点：

- 智能指针中一定有一个一般的指针。
- 它一定有 * 、—>这两个操作符的重载，且实现手法都是固定的。
- 外界调用智能指针的重载操作符时，*操作符用一次就“消耗”掉了，但**—>操作符不会被“消耗**”，被重载的—>在使用过后，下次依然能继续使用。

<img src="C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1660978670377.png" alt="1660978670377" style="zoom: 50%;" />



**（2）迭代器**

迭代器是另一种pointer-like classes的指针，它与智能指针有些不一样。它有如下特点：

- 迭代器中一定有一个一般的指针。
- 他除了有 * 、—>这两个操作符的重载，还有++、--等等其他操作符的重载。且 * 、—>重载的实现手法与智能指针不一样。

<img src="C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1660978920956.png" alt="1660978920956" style="zoom:50%;" />

<img src="C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1660978940070.png" alt="1660978940070" style="zoom:50%;" />



### 5.function-like classes  (仿函数)

所谓仿函数就是：  一个类，**重载()操作符之后**，表现的像一个函数。它有如下特点：

- 仿函数内部一定有（）操作符的重载。
- 标准库中，有很多仿函数，它其实是一个很小的类，这些仿函数都继承了一些“奇怪”的父类。
- 这些“奇怪”父类的大小理论上为0，且没有函数，只有一些typedef定义。（详见标准库课程）

<img src="C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1660980142317.png" alt="1660980142317" style="zoom:50%;" />

<img src="C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1660980170497.png" alt="1660980170497" style="zoom: 67%;" />



### 6.namespace经验谈

namespace的主要用途就是为了避免命名冲突，在大型工程中尤为常见，自己在写一些测试代码时也可以使用命名空间封装起来。

<img src="C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1660980662306.png" alt="1660980662306" style="zoom:50%;" />



### 7.class template 类模板

如下形式，把类型"提取"出来，在用的时候在进行替换补充就好。

<img src="C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1660980904025.png" alt="1660980904025" style="zoom:50%;" />



### 8.Function template 函数模板

<img src="C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1660981082406.png" alt="1660981082406" style="zoom: 67%;" />



### 9.member template 成员模板

成员模板是指：在一个模板类里面的一个成员依旧是一个模板形式。

<img src="C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1660983448042.png" alt="1660983448042" style="zoom: 50%;" />

<img src="C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1660983477307.png" alt="1660983477307" style="zoom: 67%;" />



### 10.specialization（模板特化）

<img src="C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1660983932864.png" alt="1660983932864" style="zoom:50%;" />



### 11.partial specialization （模板偏特化）

（1）个数上的偏特化

即将模板中的某个/些参数提前进行”绑定“。

<img src="C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1660984300463.png" alt="1660984300463" style="zoom:50%;" />



（2）范围上的偏特化

如：将**什么类型都可以**传的模板，偏特化为**只有指针类型能**传的模板。（当然，指针可以指向任意类型，但指针也是一种类型，所以范围确实变小了）

<img src="C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1660984493189.png" alt="1660984493189" style="zoom:50%;" />



### 12.模板的模板参数

一个模板的参数是模板类型。如：

```cpp
template <typename T, typename Cont = std::vector<T>> 
class Stack {
private:
  Cont elems; // elements
  // ......
};
```

实例化：

```cpp
Stack<int, std::deque<int>> intStack;
```

可以看到上面这样实例化时，需要指定int类型两次，而且这个类型是一样的，能不能实例化直接写成？

```cpp
Stack<int, std::deque> intStack;
```

很显然是可以的，使用模板的模板参数，声明形式类似:

```cpp
template<typename T, template<typename Elem> class Cont = std::vector>
class Stack {
private:
  Cont<T> elems; // elements
  // ......
};
```

上面声明中的第二个模板参数Cont是一个类模板。注意**声明中要用到关键字class**（在**C++17之后，模板的模板参数中的class也可以替换成typename**）。只有类模板可以作为模板参数。这样就可以允许我们在声明Stack类模板的时候只指定容器的类型而不去指定容器中元素的类型。

 看下面的例子加深理解该功能： 

```cpp
#include <iostream>
#include <vector>
#include <deque>
#include <cassert>
#include <memory>

template<typename T,
    template<typename Elem,
             typename = std::allocator<Elem>>
    class Cont = std::deque>
class Stack {
private:
    Cont<T> elems; // elements
public:
    void push(T const&); // push element
    void pop();  // pop element
    T const& top() const;  // return top element
    bool empty() const // return whether the stack is empty
    {
        return elems.empty();
    }

    // assign stack of elements of type T2
    template<typename T2, 
        template<typename Elem2,
                 typename = std::allocator<Elem2>>
        class Cont2>
    Stack<T, Cont>& operator=(Stack<T2, Cont2> const&);

    // to get access to private members of any Stack with elements of type T2:
    template<typename, template<typename, typename> class>
    friend class Stack;
};

template<typename T, template<typename, typename> class Cont>
void Stack<T,Cont>::push(T const& elem) {
    elems.push_back(elem); // append copy of passed elem
}

template<typename T, template<typename, typename> class Cont>
void Stack<T,Cont>::pop() {
    assert(!elems.empty());
    elems.pop_back();  // remove last element
}

template<typename T, template<typename, typename> class Cont>
T const& Stack<T,Cont>::top() const {
    assert(!elems.empty()); 
    return elems.back();    // return last element
}

template<typename T, template<typename, typename> class Cont>
    template<typename T2, template<typename, typename> class Cont2>
Stack<T,Cont>& Stack<T,Cont>::operator=(Stack<T2,Cont2> const& op2) {
    elems.clear();   // remove existing elements
    elems.insert(elems.begin(), 
                 op2.elems.begin(),
                 op2.elems.end());
    return *this;
}

int main() {
    Stack<int> iStack;  // stacks of ints
    Stack<float> fStack; // stacks of floats

    // manipulate int stack
    iStack.push(1);
    iStack.push(2);
    std::cout << "iStack.top(): " << iStack.top() << '\n';

    // manipulate float stack
    fStack.push(3.3);
    std::cout << "fStack.top(): " << fStack.top() << '\n';
    
    // assign stack of different type and manipulate again
    fStack = iStack;
    fStack.push(4.4);
    std::cout << "fStack.top(): " << fStack.top() << '\n';

    // stack for doubles using a vector as an internal container
    Stack<double, std::vector> vStack;
    vStack.push(5.5);
    vStack.push(6.6);
    std::cout << "vStack.top(): " << vStack.top() << '\n';

    vStack = fStack;
    std::cout << "vStack: ";
    while(!vStack.empty()) {
        std::cout << vStack.top() << ' ';
        vStack.pop();
    }
    std::cout << '\n';
}

//输出
iStack.top(): 2
fStack.top(): 3.3
fStack.top(): 4.4
vStack.top(): 6.6
vStack: 4.4 2 1 
```



### 13.C++标准库

请一定要多多使用、了解、学习C++的标准库！（侯捷老师有一个系列课程专门讲了C++STL，可以去看看）



# 二、since C++11

### 14.三个主题——variadic templates、auto、ranged-based for

**（一）variadic templates （since C++11）**

variadic templates即：**数量不定的模板参数**。它有如下特点：

- 该语法是C++11的新特性，它可以传入数量不定的模板参数，它把传入的参数分为：**一个**和**一包**。
- variadic templates具有**递归**的特点，可以递归的将“一包”一个一个分解出来。
- variadic templates既然有递归的特点，那一定会有一个**结束条件**。下图的结束条件就是一个空的print函数。
- 如果你想确定这“一包”参数具体有多少个，可以用语法：`sizeof...(args)`。

举一个简单的例子：

<img src="C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1660997304605.png" alt="1660997304605" style="zoom: 67%;" />



**（二）auto  （since C++11）**

auto其实就是一个语法糖，面对复杂的返回类型可以用auto自动推导出来。

PS：关于auto的推到原理，可以参考我的Effective modern C++笔记，里面叙述的很清楚。

<img src="C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1660997760151.png" alt="1660997760151" style="zoom:67%;" />



**（三）ranged-based for （since C++11）**

基于范围的for循环，也是C++11的一个语法糖。它有如下特点：

- 它有两个参数，一个是自己创建的变量，另一个是一个**容器**。
- 范围for循环可以将一个容器(第二个参数)里的元素依次传第一个参数，并在该循环体中依次对每一个元素做操作。
- 如果你不想影响容器中的参数，请**pass by value**，否则请**pass by reference**。
- 但有一点要提醒：**对于关联式容器，我们不能改变其中的元素，**所以我们就不能够使用`for (auto& elem :vec){}`这种形式，不能**pass by reference**！

例子如下：

<img src="C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1660998462503.png" alt="1660998462503" style="zoom: 67%;" />



### 15.Reference

编译器其实把reference视作一种pointer。引用有如下特点：

- 引用是被引用对象的一个**别名**。
- 引用**一定要有初始化**。
- object和其reference的大小相同，地址也相同（**全都是假象**）

<img src="C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1660999892230.png" alt="1660999892230" style="zoom: 50%;" />

- reference通常不用于声明变量，而**用于参数类型（parameters type）和返回类型（return type）**的描述。
- 在函数调用的时候，pass by value和pass by reference传参形式一样，而且reference比较快，所以推荐一般pass by reference。（请回顾何时不可以pass by reference）

<img src="C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661000104005.png" alt="1661000104005" style="zoom:67%;" />

- 以下被视为"**same signature**”（所以二者**不能同时存在**）。但**const也被视作函数签名的一部份**，所以下面如果一个有const一个没有，则可以同时存在。

<img src="C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661000174867.png" alt="1661000174867" style="zoom: 67%;" />



# 三、Object Model （对象模型）

### 16.复合&继承关系下的构造和析构

该部分主要讲了三点：

（1）复合关系下的构造和析构

（2）继承关系下的构造和析构

（3）继承+复合关系下的构造和析构

其中（1）（2）在面向对象高级编程（上）已经讲过了，请自行回顾。

**（3）继承+复合关系下的构造和析构**

<img src="C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661001035445.png" alt="1661001035445" style="zoom:50%;" />





### 17.关于vptr和vtbl

在讲虚指针和虚表之前，先要知道：

- 当子类继承父类时，除了继承数据之外，同时会继承父类的虚函数。
- 继承父类的函数，继承的其实是它的**调用权**，而不是大小。

现在看如下的关系图：

![1661002686817](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661002686817.png)

观察关系图：

- 请注意：A B C三个类的非虚函数，他们虽然重名，但其实彼此之间毫无关系，这一点要注意，千万别以为B的非虚函数是继承A的非虚函数。

- B类的内存大小= 继承A类的数据  + B本身的数据，C类同理。（关系图最右边）
- A有两个虚函数vfunc1、vfunc2以及两个非虚函数func1、func2；B类继承A类的vfunc2，同时覆写A类的vfunc1，此时B有两个虚函数(vfunc1和vfunc2)；C类继承了B类的vfunc2（vfunc2其实是A的），同时覆写了vfunc1，也有两个虚函数。
- 所以A B C这三个类一共有八个函数，四个非虚函数，四个虚函数。（关系图中间偏右）。
- 只要一个类拥有虚函数，则就会有一个**虚指针vptr**，该vptr指向一个**虚表vtbl**，**虚表vtbl中放的都是函数指针，指向虚函数所在的位置**。（可以观察到，关系图中虚表中的函数指针都指向相应的虚函数的位置）这其实就是**动态绑定**的关键。
- 如果创建一个指向C类的指针p（如C* p= new C）,如果让该**指针p调用虚函数**C::vfunc1()，则编译器就知道这是动态绑定，故这时候就会通过p找到vptr，在找到vtbl，最终通过vtbl的函数指针找到相应的虚函数。该步骤如果要解析成C语言的话就如下所示，其中**n**指的是**要调用的虚函数在虚表中的第几个**。n在写虚函数代码的时候编译器看该虚函数第几个写的则n就是几。

<img src="C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661004184664.png" alt="1661004184664" style="zoom: 80%;" />

现在，应该很容易理解下面这个**多态**的例子了吧？一个容器，其元素是指针类型，它的功能是要画出不同的形状，所以要用虚函数，子类要进行覆写实现自己的形状绘制。

<img src="C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661005039124.png" alt="1661005039124" style="zoom: 50%;" />



现在总结一下，C++编译器看到一个函数调用，它有两个考量：

- 是静态绑定吗？（Call ×××）
- 还是动态绑定。

要想动态绑定要满足三个条件：

- 第一：必须是**通过指针来调用**
- 第二：该指针是**向上转型**(up-cast)的
- 第三：调用的是**虚函数**

到此为止，是不是觉得多态、虚函数、动态绑定是指的一回事了？没错，可以这么理解！



### 18.关于this

当你通过一个对象**调用**一个函数，该**对象的地址就是this指针**。

明白了上一节讲到的动态绑定、虚函数的底层实现，现在看如下这个例子应该就很清楚了吧？

<img src="C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661006344587.png" alt="1661006344587" style="zoom: 67%;" />

如果现在还不清晰图片中箭头线的步骤路线原理的话，建议再看一遍原视频。



### 19.关于Dynamic Binding

现在考虑一下，为什么动态绑定解析成C语言形式会是：

```C
(*(p->vptr)[n])(p)  //第二个p其实就是this指针（因为p是调用者）
//或
(* p->vptr[n])(p)
```

从汇编角度看一下：

下图中 a是一个**对象**，它调用函数是一个**静态绑定**，可以看到汇编呈现的就是：Call xxx一个地址

<img src="C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661007139147.png" alt="1661007139147" style="zoom: 67%;" />



下图中pa满足**动态绑定的三个条件**，所以它是一个动态绑定，而在汇编语言中，汇编所呈现出来的那部分命令就等价于C语言中的`(*(p->vptr)[n])(p)`

<img src="C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661007288820.png" alt="1661007288820" style="zoom:67%;" />





# 四、补充：const、动态分配new与delete

### 20.谈谈const

有以下重点要牢牢记住！

- **const也是函数签名的一部份**，即可构成函数重载。
- **常量对象**不可以调用**非常量成员函数**。
- 当成员函数的**const**和non-const版本**同时存在**，**const对象只能调用const版本的成员函数，non-const对象只能调用non-const版本的成员函数。**
- non-const成员函数可调用const成员函数，反之则不行。

![1661059830492](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661059830492.png)



### 21.关于new、delete

这部分内容其实在面向对象高级编程(上)讲述过了，可以自行回顾一下。这里要提醒的是：

- 使用**new**，其实会有三个动作，依次为：**分配内存、转型、构造函数**；**delete**有两个动作：**析构函数、释放内存**

- 当我们new一个对象或delete一块内存的时候，这个new、delete是一个**expression表达式**，不可以重载。但是他们的**内部new、delete**是operator**是操作符**，可以**重载**。
- array new 一定要搭配array delete。

![1661060320301](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661060320301.png)



### 22.重载Operator new，operator delete

**（1）全局重载 `::operator new, ::operator delete, :: operator new[], ::operator delete[] `**

着用重载要小心，它影响范围是全局。

<img src="C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661061430862.png" alt="1661061430862" style="zoom: 67%;" />



**（2）重载member operator new/delete**

如下所示，重载一个类中的成员，这里注意一下delete重载的第二个参数时可选的，可以不写。

<img src="C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661061686667.png" alt="1661061686667" style="zoom:67%;" />



**（3）重载member operator new[] / delete[]**

与上一个区别不大。

<img src="C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661061786411.png" alt="1661061786411" style="zoom:67%;" />



### 23.示例，接口

这一部分就是对上一节讲的内容进行了事例分析，这部分内容建议看一下视频，就10分钟，不长。

<img src="C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661062578537.png" alt="1661062578537" style="zoom: 67%;" />

<img src="C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661062615561.png" alt="1661062615561" style="zoom: 67%;" />

<img src="C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661062636685.png" alt="1661062636685" style="zoom:50%;" />



### 24.重载new()，delete()

**(1) placement new**

有如下特点：

- 使用形式：`Foo* pf = new(300,'c') Foo;`

- 可以重载多个class member operator new()版本，但每一个版本的**参数列表必须独一无二**。
- 且参数列表的第一个参数必须为size_t，其余参数以new所指定的placement arguments为初值。出现在new(......)小括号内的便是所谓的placement arguments。
- 所以上述的使用形式小括号内虽然看到有两个参(300，‘c’)，其实有三个。

![1661063906594](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661063906594.png)



**(2) placement delete**

有如下特点：

- **可以**（也**可以不**）重载多个class member operator delete()版本，但绝不会被**delete**调用（这个delete是指可以被分解为两步的那个delete）
- **唯一被调用的时机**：只有**当new所调用的构造函数**(new被分解的第一步)抛出异常，才会调用与new对应的那个重载operator delete()，主要用来归还未能**完全创建成功**的对象所占用的内存。

![1661064269797](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661064269797.png)



### 25.placement new的应用：Basic_String使用new(extra)扩充申请量 

标准库中对placement new的一个应用，用于**无声无息**的扩充申请一部份内存。

![1661064683894](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661064683894.png)