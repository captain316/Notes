# 1. 关于 -1对256取模  问题（负值赋给unsigned 类型）

今天看c++primer遇到了这个-1对256取模，负数取模还真的不清楚，所以查了查资料，供大家参考。（P33）

原文：**C++中，把负值赋给unsigned 对象是完全合法的，其结果是初始值对无符号类型表示数值总数取模后的余数。所以，如果把-1赋给8位的unsigned char，那么结果是255，因为255是-1对256求模后的值。**

------

 

1、从数学角度“

取模运算时,对于负数,应该加上被除数的整数倍,使结果大于或等于0之后,再进行运算.

也就是：(-1)%256 = (-1+256)%256=255%256=255 

2.计算机存储角度：

计算机中负数是以补码形式存储的，-1的补码11111111，转换成无符号数即是255的二进制编码。

代码:

```C++
unsigned char uc;    //声明一个无符号的字符，8位的，无符号字符类型的取值个数为256。
uc=-1;               //将-1赋给无符号的字符型对象（变量），
                     //此过程会先将-1自动转换为无符号数，即 11111111 11111111，然后赋值给uc
                     //但是uc只有8位，所以只保存了 11111111 11111111 的低8位数据，其它的位
                     //就因为溢出而丢失了。-----因为溢出而丢失了其它位，就相当于取模运算了。
cout<<"uc as int is :"<<int(uc)<<endl;    //这一行将uc转换为整型输出，结果为255
//注意，11111111 11111111 是十六位的，但实际上也可能是32位的，因为我们现在的计算机都是32位的了。
```

​    再贴上摘自百度百科的取模和取余的区别：

　　取模运算（“Modulo Operation”）和取余运算（“Remainder Operation”）两个概念有重叠的部分但又不完全一致。主要的区别在于对负整数进行除法运算时操作不同。取模主要是用于计算机术语中。取余则更多是数学概念。

​    对于整型数a，b来说，取模运算或者求余运算的方法都是：

​    1.求整数商： c = a/b;

​    2.计算模或者余数： r = a - c*b.

​    求模运算和求余运算在第一步不同: 取余运算在取c的值时，向0 方向舍入(fix()函数)；而取模运算在计算c的值时，向负无穷方向舍入(floor()函数)。

​    例如：计算-7 Mod 4

​    那么：a = -7；b = 4；

​    第一步：求整数商c，如进行求模运算c = -2（向负无穷方向舍入），求余c = -1（向0方向舍入）；

​    第二步：计算模和余数的公式相同，但因c的值不同，求模时r = 1，求余时r = -3。

​    归纳：当a和b符号一致时，求模运算和求余运算所得的c的值一致，因此结果一致。

​    当符号不一致时，结果不一样。求模运算结果的符号和b一致，求余运算结果的符号和a一致。

​    另外各个环境下%运算符的含义不同，比如c/c++，java 为取余，而python则为取模。

 

​    自己理解：

​    通常，**取模运算也叫取余运算**，它们**返回结果都是余数**.rem（取余）和mod（取模）唯一的区别在于： 当x和y的正负号一样的时候，两个函数结果是等同的；当x和y的符号不同时，rem函数结果的符号和x的一样，而mod和y一样。



# 2. no matching function for call to ‘toupper(std::__cxx11::basic_string<char>&)’

正确代码：

```C++
#include <iostream>
#include <string>
#include <cctype>
#include <vector>

using std::cin;
using std::cout;
using std::endl;
using std::vector;
using std::string;

int main()
{
	vector<string> v;
	string s;

	while (cin >> s)
	{
		v.push_back(s);
	}

	for (auto &str : v)  //str 是字符串类型
	{
		for (auto &c : str)  //为了让c是字符 然后用toupper
		{
			c = toupper(c); // c 是字符类型
		}
	}

	for (auto i : v)
	{
		cout << i << endl;
	}
	return 0;
}
```

错误代码：

```C++
#include <iostream>
#include <string>
#include <cctype>
#include <vector>

using std::cin;
using std::cout;
using std::endl;
using std::vector;
using std::string;

int main()
{
	vector<string> v;
	string s;

	while (cin >> s)
	{
		v.push_back(s);
	}

	for (auto &str : v)
	{
		str = toupper(str)  //str 是字符串类型，而toupper只能对字符使用 或者说“toupper是对字符的操作，而str是字符串。”
		//for (auto &c : str)
		//{
		//	c = toupper(c); 
		//}
	}

	for (auto i : v)
	{
		cout << i << endl;
	}
	return 0;
}
```

![image-20220310162706633](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\image-20220310162706633.png)



# 3. 如何C++ 获取类型信息

头文件

```
#include <typeinfo>
```

**typeid(对象).name();**

```C++
const int a = 10, &b = a;
    auto e = a;
    auto d = b;
    MyClass c;
    MyStruct s;
    cout << typeid(a).name() << endl; // int
    cout << typeid(&b).name() << endl;// int const *
    cout << typeid(e).name() << endl; // int
    cout << typeid(d).name() << endl; // int
    cout << typeid(c).name() << endl; // class MyClass
    cout << typeid(s).name() << endl; // Struct MyStruct

```



# 4. C++Primer中for(auto it=s.cbegin(); iter!=s.cend() && !it->empty(); ++it){ cout<<*it<<endl; ...

在C++ Primer 中文版 第五版的 98页 ，有这么一段代码

```cpp
 for(auto it=text.cbegin(); it!=text.cend() && !it->empty(); ++it){
        cout<<*it<<endl;
 }
```

这段代码适用于输出text的每一行直至遇到第一个空白行为止

下面是我完整的代码：

```cpp
#include<iostream>
#include<string>
#include<vector>
using namespace std;
int main(){
    string text{"hello world"};
    for(auto it=text.cbegin(); it!=text.cend() && !it->empty(); ++it){
        cout<<*it<<endl;
    }

    return 0;
}
```

乍一看，好像没有错，但是，你却忽略了一点

在这个例子中，it 作为迭代器，每次指向的是text中的一个字符，然后用解引用*it，获得的也只是一个字符(char)，而非一个字符串(string)

所以一旦编译就会报错，错误信息如下

```cpp
C:\Users\Administrator\Documents\demo.cpp||In function 'int main()':|
C:\Users\Administrator\Documents\demo.cpp|7|error: request for member 'empty' in '* it.__gnu_cxx::__normal_iterator<_Iterator, _Container>::operator-><const char*, std::basic_string<char> >()', 
which is of non-class type 'const char'|
||=== Build failed: 1 error(s), 0 warning(s) (0 minute(s), 0 second(s)) ===|
```

错误信息的大概内容是 *it没有empty() 这个方法

这是为什么呢？

因为empty()是C++中的几种容器和string可以使用，而char类型的字符不能使用

修改方法:

```C++
#include<iostream>
#include<string>
#include<vector>
using namespace std;
int main(){
    vector<string> text{"hello world"};
    for(auto it=text.cbegin(); it!=text.cend() && !it->empty(); ++it){
        cout<<*it<<endl;
    }

    return 0;
}
```

现在我们再多做一步：修改上面那个输出text第一段的程序，首先把text的第一段全部改成大写形式，然后输出它。

```C++
#include<iostream>
#include<string>
#include<vector>
using namespace std;
int main(){
    
        vector<string> text;
        string word;
        while(cin>>word){
                text.push_back(word);
        }

        for(auto it1 = text.begin(); it1 !=text.end(); ++it1 )
				*it1 = toupper(*it);

        for(auto it = text.cbegin(); it != text.cend() && !it->empty(); ++it)
                cout << *it << " " ;
        cout << endl;

    return 0;
}
```

此时会报错：

```
iter.cpp:28:22: error: no matching function for call to ‘toupper(std::__cxx11::basic_string<char>&)’
   28 |   *it1 = toupper(*it1);
```

错误原因可以知道是因为

```
text是string的vector，*it1是text的元素类型，即string。
toupper是对字符的操作，而*it1是字符串。所以会出错
```

修改方法：

```c++
#include<iostream>
#include<string>
#include<vector>
using namespace std;
int main(){
    
        vector<string> text;
        string word;
        while(cin>>word){
                text.push_back(word);
        }

        for(auto it1 = text.begin(); it1 !=text.end(); ++it1 )
                for(auto &cha : (*it1))
                        cha  = toupper(cha);

        for(auto it = text.cbegin(); it != text.cend() && !it->empty(); ++it)
                cout << *it << " " ;
        cout << endl;

    return 0;
}
```

# 5. C++比较两个数组是否相等

> 不能使用 `==` 运算符与两个数组的名称来确定数组是否相等。以下代码似乎是在比较两个数组的内容，但实际上并不是。

```c++
int arrayA[] = { 5, 10, 15, 20, 25 };
int arrayB[] = { 5, 10, 15, 20, 25 };
if (arrayA == arrayB) // 语句错误
    cout << "The arrays are the same. \n";
else
    cout << "The arrays are not the same.\n";
```

> 在对数组名称使用 `==` 运算符时，运算符会比较数组的开始内存地址，而不是数组的内容。这个代码中的两个数组显然会有不同的内存地址。因此，表达式 arrayA == arrayB 的结果为 false，代码将报告数组不相同。
>
> 要比较两个数组的内容，则必须比较它们各自的元素。例如，请看以下代码：

```C++
const int SIZE = 5;
int arrayA[SIZE] = { 5, 10, 15, 20, 25 };
int arrayB[SIZE] = { 5, 10, 15, 20, 25 };
bool arraysEqual = true; // 标志变量
int count = 0; //循环控制变量

//确定元素是否包含相同的数据
while (arraysEqual && count < SIZE)
{
    if (arrayA[count] != arrayB[count])
        arraysEqual = false;
    count++;
}
//显示合适的消息
if (arraysEqual)
    cout << "The arrays are equal.\n";
else
    cout << "The arrays are not equal.\n";
```

例题：编写一段程序，比较两个数组是否相等。再写一段程序，比较两个vector对象是否相等。

```C++
#include <iostream>
#include <vector>
#include <iterator>

using std::begin; using std::end; using std::cout; using std::endl; using std::vector;

// pb point to begin of the array, pe point to end of the array.
bool compare(int* const pb1, int* const pe1, int* const pb2, int* const pe2)
{
    if ((pe1 - pb1) != (pe2 - pb2)) // have different size.
        return false;
    else
    {
        for (int* i = pb1, *j = pb2; (i != pe1) && (j != pe2); ++i, ++j)
            if (*i != *j) return false;
    }

    return true;
}

int main()
{
    int arr1[3] = { 0, 1, 2 };
    int arr2[3] = { 0, 2, 4 };

    if (compare(begin(arr1), end(arr1), begin(arr2), end(arr2)))
        cout << "The two arrays are equal." << endl;
    else
        cout << "The two arrays are not equal." << endl;

    cout << "==========" << endl;

    vector<int> vec1 = { 0, 1, 2 };
    vector<int> vec2 = { 0, 1, 2 };

    if (vec1 == vec2)
        cout << "The two vectors are equal." << endl;
    else
        cout << "The two vectors are not equal." << endl;

    return 0;
}
```



# 6. 输入连续的两个未知大小的vector

```C++
int main(){
        vector<int> v1,v2;
        cout << "please input number for v1: " << endl;
        int num1,num2;
        while(cin >> num1){
                v1.push_back(num1);
                if(getchar()=='\n')
                        break;
        }
//      cin.clear();
        cout << "please input number for v2: " << endl;
        while(cin >> num2){
                v2.push_back(num2);
                if(getchar()=='\n')
                        break;
        }
```

# 7.使用 `noskipws`可以保留默认跳过的空格。

```C++
#include <iostream>
using namespace std;

int main()
{
	unsigned spaceCnt = 0；
	char ch;
	while (cin >> noskipws >> ch)  //noskipws(no skip whitespce)
		switch (ch)
	{

		case ' ':
			++spaceCnt;
			break;
	}
	cout << "Number of space: \t" << spaceCnt << endl;

	return 0;
}
```

# 8. eof()函数判断输入是否结束,或者文件结束符,等同于 CTRL+Z

编写一段程序，从标准输入中读取`string`对象的序列直到连续出现两个相同的单词或者所有的单词都读完为止。
使用`while`循环一次读取一个单词，当一个单词连续出现两次时使用`break`语句终止循环。
输出连续重复出现的单词，或者输出一个消息说明没有任何单词是连续重复出现的。

```C++
#include <iostream>
#include <string>
using std::cout; using std::cin; using std::endl; using std::string;

int main()
{
    string read, tmp;
    while (cin >> read)
        if (read == tmp) 
            break; 
    	else 
            tmp = read;

    if (cin.eof())  
        cout << "no word was repeated." << endl; //eof(end of file)判断输入是否结束,或者文件结束符,等同于 CTRL+Z
    else            
        cout << read << " occurs twice in succession." << endl;

    return 0;
}
```



# 9. vector删除元素之pop_back(),erase(),remove()

---- 向量容器vector的成员函数pop_back()可以删除最后一个元素.

---- 而函数erase()可以删除由一个iterator指出的元素，也可以删除一个指定范围的元素。

---- 还可以采用通用算法remove()来删除vector容器中的元素，大家可以看到这里说的是算法，而不是方法；

     即vector没有remove()成员，这里的remove是algorithm中的remove函数。

---- 不同的是：采用remove()一般情况下不会改变容器的大小，而pop_back()与erase()等成员函数会改变容器的大小。

1、pop_back()

void pop_back();
Delete last element，Removes the last element in the vector, effectively reducing the container size by one.

删除容器内的最后一个元素，容器的size减1.

This destroys the removed element. 销毁删除的元素

```C++
#include <iostream>
#include <vector>
#include <stdio.h>
using namespace std;
int main()
{
	vector<int> vec;
	int sum = 0, i = 0;
	vec.push_back(10);
	vec.push_back(20);
	vec.push_back(30);
	cout << "init vec.size() =  "<< vec.size() << endl;
	while(!vec.empty())
	{
		i++;
		sum += vec.back();	//取最后一个元素	
		vec.pop_back();         //删除最后一个元素
		printf("after %d time, sum: %d size = %d\n", i, sum, vec.size());		
	}
	system("pause");
	return 0;
}
```

![img](https://img-blog.csdnimg.cn/20210330100046628.png)



其余详见：

原文链接：https://blog.csdn.net/dongyanxia1000/article/details/52838922



# 10 必须将类的 声明和**内联成员函数的定义都放在同一 个文件(或同一个头文件)中,否则编 译时无法进行代码置换

（1） 在一个文件中定义的内联函数不能在另一个文件中使用，否则会出现“无法解析的外部符号错误……”。它们通常放在头文件中共享。

（2） 内联函数应该简洁，只有几个语句，如果语句较多，不适合于定义为内联函数。

（3） 内联函数体中，不能有循环语句、if语句或switch语句，否则，函数定义时即使有inline关键字，编译器也会把该函数作为非内联函数处理。

（4） 内联函数要在函数被调用之前声明。

（5）内联函数的作用域仅本文件可见（static也是作用域仅本文件可见）。内联函数在编译阶段不能生成符号，所以只有本文件可见，功能类似与static函数，但是static修饰的函数会产生本地的符号。

（6）与宏替换作用一样，只是内联发生在编译阶段、宏替换发生在预处理阶段，而且内联函数会做类型检查，但宏替换只是做简单地字符替换，并不会做类型检查。

（7）inline函数仅仅是对编译器的建议,所以最后能否真正内联,看编译器的意思,它如果认为函数不复杂,能在调用点展开,就会真正内联,并不是说声明了内联就会内联,声明内联只是一个建议而已.



# 11 C++的拷贝与拷贝构造函数_cherno

- **问题**（b站评论区）:

  >  Cherno定义了拷贝构造函数，但未定义拷贝赋值运算符。但他用了＝，这时候是怎么工作的呢？我想的是调用编译器默认的拷贝运算符来进行[浅拷贝](https://search.bilibili.com/all?from_source=webcommentline_search&keyword=浅拷贝)，但视频中好像不是这样。
  >
  > -  懂了，混淆了”拷贝初始化“和”赋值“ 
  > -  String second = string调用的是拷贝构造函数。如果是拷贝赋值就是已有一个对象假设为String third = "Che"，这里由于没有无参构造函数所以需要带上参数；然后third = second，这样就是拷贝赋值了，也就是third清空，将second中的内容拷贝到third中。这里需要自己写拷贝赋值函数了，否则默认的拷贝赋值只是赋了内存地址（浅拷贝），这样会造成double free，退出作用域，second delete，third delete，两次释放同样地址的内存这样是错误的。自己写的话可以使用realloc + memcpy. 
  > -  这里确实容易混淆，因为在“=”这里编译器做了一次隐式类型转换，本质还是拷贝初始化，而不是赋值。  可以在拷贝构造函数前加个explicit，可以发现这时拷贝构造操作不能用“=”的形式，只能用“( )”的形式。 
  > -  String second = string 相当于 String second(string) 吧，就调用了构造函数  



# 12.‘strcpy‘: This function or variable may be unsafe. Consider using strcpy_s instead.

原文：https://blog.csdn.net/qq_38721302/article/details/82850292 

今天编写C++程序在使用头文件#include<cstring>中的strcpy()和strcat()函数时出现了一个错误：error C4996: 'strcpy': This function or variable may be unsafe. Consider using strcpy_s instead.在网上搜了一下大概知道怎么解决了，并且知道为什么出现这个错误——出现这个错误时，是因为strcpy()和strcat()函数不安全造成的溢出。

**解决方法是**：找到【项目属性】，点击【C++】里的【预处理器】，对【预处理器】进行编辑，在里面加入一段代码：_CRT_SECURE_NO_WARNINGS。



# 13.VS2022报错：E1696 命令行错误: 无法打开 元数据 文件 “platform.winmd”

 (1).点击功能栏中的工具(T),然后找到选项(O)。
(2).打开文本编辑器，选择c/c++选项。
(3).将IntelliSense选项条中的禁用IntelliSense选项从“False”改为"True"即可。
(4).回到代码，发现问题已经解决。 



# 14.报错未能找到程序集“platform.winmd”: 请使用 /AI 或通过设置 LIBPATH 环境变量指定程序集搜索路径，问题解决办法

https://blog.csdn.net/weixin_51425878/article/details/124889245

报错C1107 未能找到程序集“platform.winmd”和“Windows.winmd”
说在前面的话
文章供自己回顾学习使用（学生党踩坑总结）
做计算机图形学实验要用Visual studio，完成软件安装加MFC项目创建需要的配置（其他大佬都有相关文章）后，运行报错：未能找到程序集“platform.winmd”: 请使用 /AI 或通过设置 LIBPATH 环境变量指定程序集搜索路径。未能找到程序集“Windows.winmd”: 请使用 /AI 或通过设置 LIBPATH 环境变量指定程序集搜索路径。

重点直接看这里
先说下配置：Visual Studio2022 windows 版本 17.2
下面链接的文章大概率可以解决报错未能找到程序集“platform.winmd”的问题。
https://www.cnblogs.com/Lxk0825/p/10040560.html
之后就运行就遇见了报错未能找到程序集“Windows.winmd”的问题。
解决方法：
项目->属性->C/C++ ->常规->使用Windows运行时扩展->点击复选框选择 <从父级或项目默认设置继承>