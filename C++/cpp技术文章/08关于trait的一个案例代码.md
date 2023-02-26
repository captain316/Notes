## 网友完成的一个完整的代码

我们知道容器的许多操作都是通过迭代器展开的。其中容器类似于数组，迭代器类似于指针。我们用数组来写个例子：

```cpp
int arr[5] = {1,2,3,4,5}; 
int *p;
p = &arr[2];
```

假设，我将第1、2遮挡起来，问你p所指向的对象arr[2]是什么类型，你恐怕无法回答。因为它可以是int，char，float甚至你自己定义的类型。假设我们现在是个容器：

```cpp
list<int> lit(5,3);
list<int>::iterator it1，it2; 
it1 = lit.begin(); 
it2 = lit.end();
```

其中lit是个容器对象，it1和it2都是容器的迭代器。假设现在有个函数，他接受两个迭代器作为参数，并且返回类型是迭代器所指的类型：

```kotlin
template<class iterator>
返回类型 fun(iterator first,iterator last) 
{
    //函数体 
}
```

问题来了，现在我的返回类型假设是iterator所指向的类型。我们无法进行下去了……别怕，我们接着往下看：

如果我们将迭代器定义成一个类：

```cpp
template<class T>
class My_iterator
{ public:
    T* ptr;
    typedef T value_type;
    My_iterator(T* p = 0):ptr(p){} //... 
};
```

也就是说如果我们的list的迭代器的类型也是上面那种形式，那么我们的fun函数就可以这样写了：

```kotlin
template<class iterator> 
typename iterator::value_type　　//返回类型
fun(iterator first,iterator last)
{ 
    //函数体 
}
```

这样，迭代器所指的容器元素的类型就可以取出来了。怎么样，是不是很cool！但是不是所有的迭代器都是一个类啊，比如我们的原生指针也是迭代器的一种。vector的迭代器就是原生指针。那么用上面的那种方法似乎就不行了。但是STL的编写者创造了一个很好的方法---迭代器类型萃取模板，可以萃取原生指针所指向的元素的类型。对了，什么是原生指针？就是那种真正的是一个指针，我们的许多容器（list，deque）的迭代器是模拟指针但实际上它不是真正意义上的指针，他是一个类里面封装了原生指针。上面的My_iterator是迭代器，My_iterator里面的成员ptr就是原生指针。现在，是Traits编程技法发挥作用的时候了：

如果我们有个迭代器类型萃取模板，如下：

```cpp
template<clas iterator>    //专门用来萃取迭代器iterator指向的元素的类型
class My_iterator_traits
{
    typedef typename iterator::value_type value_type; //...
};
```

于是，我们的fun()函数就可以写成这样：

```kotlin
template<class iterator>
typename My_iterator_traits<iterator>::value_type　　//返回类新
fun(iterator first,iterator last)
{
    //函数体 
}
```

明眼人一眼就能看出这个代码跟原来的相比除了多一层包装，好像什么实质意义也没有，别急。我们这样写并不是做无用功，是为了应付上面说的原生指针而设计的。这时，我们的偏特化要派上用场了，针对原生指针的迭代器类型萃取偏特化模板如下：

```cpp
template<clas iterator>    //专门用来萃取迭代器iterator指向的类型的
class My_iterator_traits<iterator*> { //typedef typename iterator::value_type value_type;
    typedef T value_type;  //注意与上面的区别 //...
};
```

怎么样，这样一个迭代器类型萃取模板就这样诞生了。它可以萃取自定义的iterator类型和原生指针类型。

```cpp
#include <iostream>
using namespace std;

/*先定义一些tag*/
struct A {
};
struct B: A {
};

/*假设有一个未知类*/
template<class AorB>
struct unknown_class {
    typedef AorB return_type;
};

/*特性萃取器*/
template<class unknown_class>
struct unknown_class_traits {
    typedef typename unknown_class::return_type return_type;
};

/*特性萃取器 —— 针对原生指针*/
template<class T>
struct unknown_class_traits<T*> {
    typedef T return_type;
};

/*特性萃取器 —— 针对指向常数*/
template<class T>
struct unknown_class_traits<const T*> {
    typedef const T return_type;
};

template<class unknown_class>
inline typename unknown_class_traits<unknown_class>::return_type __func(unknown_class, A)
{
    cout << "use A flag" << endl;
    return A();
}

template<class unknown_class>
inline typename unknown_class_traits<unknown_class>::return_type __func(unknown_class, B)
{
    cout << "use B flag" << endl;
    return B();
}

template<class unknown_class, class T>
T __func(unknown_class, T) {
    cout << "use origin ptr" << endl;
    return T();
}

/*决定使用哪一个类型*/
template<class unknown_class>
inline typename unknown_class_traits<unknown_class>::return_type return_type(unknown_class)
{
    typedef typename unknown_class_traits<unknown_class>::return_type RT;
    return RT();
}

template<class unknown_class>
inline typename unknown_class_traits<unknown_class>::return_type func(unknown_class u)
{
    typedef typename unknown_class_traits<unknown_class>::return_type return_type;
    return __func(u, return_type());
}

int main() {
    unknown_class<B> b;
    unknown_class<A> a;
    //unknown_class<int> i;
    int value = 1;
    int *p = &value;

    A v1 = func(a);
    B v2 = func(b);
    int v3 = func(p);
}
```