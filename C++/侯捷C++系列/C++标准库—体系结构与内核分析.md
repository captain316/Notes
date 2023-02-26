前言

# 第一讲  认识各类容器

### 1.基本认识

（1）STL标准模板库是标准的子集。

（2）标准库以header files形式呈现

- C++标准的header files不带副档名（.h），例如#include <vector>
- 新式C header files不带副档名.h，例如#include <cstdio>
- 旧式C header files（帶有副档名.h）仍然可用，例如#include <stdio.h>

（3）旧式headers内的组件不被封装在namespace "std"中。

<img src="C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661230620152.png" alt="1661230620152" style="zoom:67%;" />



### 2.STL体系结构基础介绍

**（1）`STL`六大部件`Component`**

容器(`Containers`)、分配器(`Allocators`)、算法(`Alogorithms`)、迭代器(`Iterators`)、适配器(`Adapters`)、仿函数(`Functors`)。

<img src="C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661230794072.png" alt="1661230794072" style="zoom:67%;" />

有以下几点要注意：

- 分配器支持容器，容器是一个模板类，有一些模板函数——算法algorithm（注：在面向对象中，数据和一些算法函数都在一个类里头，但是这里很特别，数据在类里，算法在别的地方，和OO有所不同，是模板编程），算法要处理容器数据，算法和数据之间的桥梁就是迭代器（一种泛化的指针），除外还有仿函数Functor和适配器Adapter，适配器adapter用来做一些转换（像变压器）。
- 上图左边代码案例中，**可以选择不写分配器，因为容器会默认分配器**。分配器也是一个模板，告诉它每次分配的是什么东西。
- bind2nd()函数：绑定第二个参数。这里就是求出所有大于等于40的数的个数（用**了count_if，带一个条件，原来是小于40，然后再用not1变成是大于等于40的意思**）。 



**（2）复杂度**

<img src="C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661231044442.png" alt="1661231044442" style="zoom:67%;" />



**（3）“前闭后开”区间**

请注意：

- 所有的容器在设计上都要实现“**前闭后开**”区间（begin和end）
- **end解引用指向最后一个元素的下一个元素**。最后一个元素的下一个元素（即end）不属于容器本身。

<img src="C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661231130640.png" alt="1661231130640" style="zoom:67%;" />



**（4）遍历容器元素可用范围for循环**

面向对象课程详细讲过，请自行回顾。

但有一点要提醒：**对于关联式容器，我们不能改变其中的元素，**所以我们就不能够使用`for (auto& elem :vec){}`这种形式，不能**pass by reference**！

<img src="C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661231425952.png" alt="1661231425952" style="zoom:67%;" />



### 3.容器的分类与各种测试

#### （1）容器的分类：

**序列式容器**（Sequence Containers）：array、vector、deque、list、forward-list
**关联式容器**（Associative Containers）：有key和value，方便查找（用key来找东西就非常快）

- Set/Multiset：key就是value， value就是key。。Set的key必须唯一，Muitiset的key可以重复。
- Map/Multimap：一个key对应一个value。Map的key必须唯一，Multimap的key可以重复。

**不定序的容器**（Unordered Containers）：也是一种关联式容器，底部是hash table。

<img src="C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661231617890.png" alt="1661231617890" style="zoom:67%;" />

Set和Map是红黑树实现的。事实上，标准库并没有规定set和map应该用什么实现，但是由于红黑树实现很好所以各家编译器都用红黑树来实现。 

目前hash table做的最好的做法是**separate chain（链地址法）**，当然这里一条链子不能太长，所以还会有进一步的细节处理。 



#### （2）辅助函数

- 24行：一个把随机数转换成字符串的函数
- 31行：将target转换成字符串的函数。snprintf是C标准库中的函数。
- 35行、40行：两个比较函数，为后续的快排函数qsort准备。

<img src="C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661232092802.png" alt="1661232092802" style="zoom:67%;" />



#### （3）Array容器的测试

<img src="C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661232161384.png" alt="1661232161384" style="zoom:67%;" />



#### （4）Vector容器的测试

- 106行：tray catch函数，处理异常。
- 127行：find前面的 :: 指的是全局的函数find，加了显示的说明是全局的。其实不加也找得到，

<img src="C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661232523750.png" alt="1661232523750" style="zoom:67%;" />

<img src="C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661232541975.png" alt="1661232541975" style="zoom:67%;" />



#### （5）list容器的测试

- 197行： list内部**自己有一个sort**，区别于标准库的sort 

![1661232710972](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661232710972.png)



#### （6）forward_list容器的测试

- 249行：内部**自己有一个sort**，区别于标准库的sort 。
- 224行：**单向链表，只有push_front** 
- GNU C++还有非标准库的slist，与forward_list差不多：


![1661232760796](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661232760796.png)



#### （7）deque容器的测试

- 两边都可以扩充。由下图右边一段一段地构成，**实际是分段连续，但是让操作者使用上感觉是整个连续的**。比
- 通过重载了操作符++**每次扩充一个buffer** 
- 其实stack和queue内部都是用deque去实现的 

<img src="C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661232888091.png" alt="1661232888091" style="zoom:67%;" />

<img src="C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661232903056.png" alt="1661232903056" style="zoom:67%;" />



#### （8）stack容器的测试

- 先进后出

<img src="C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661233139953.png" alt="1661233139953" style="zoom:67%;" />



#### （9）queue容器的测试

- 先进先出
- 由于stack和queue是由deque实现的，所以从技术上来讲不算容器，叫adapter，不过也无所谓。
  因为queue有先进先出的性质，所以不会提供iterator的操作（不会提供函数让你得到iterator），否则就会破坏内部结构。stack同理。 

![1661233198093](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661233198093.png)



#### （10）multiset容器的测试

- 由于是multiset，所以**size仍然是100万** 
- 底层：红黑树
- 324行：安插元素：insert
- 有一个全局的find，标准库的；**有一个自己的find**，multiset的find。可以从下图图看到，**自己的find非常快**。因为是关联式容器。
  

![1661233235610](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661233235610.png)



#### （11）multimap容器的测试

- 红黑树实现，每一个元素有key和value。

<img src="C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661233389484.png" alt="1661233389484" style="zoom:67%;" />



#### （12）unordered_multiset容器的测试

- 有容器自带的find，也可以看出容器**自带的find较快**。 

![1661234534200](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661234534200.png)

![1661234645876](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661234645876.png)

#### （13）unordered_multimap容器的测试

![1661234718532](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661234718532.png)



#### （14）set容器的测试

- 这里rand的范围是0~32767，所以最终得到的set的size是32768，**区别于multiset的1000000** 

![1661234773950](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661234773950.png)



#### （15）map容器的测试

- 710行：`c[i] = string(buf);`：multimap的注释中说不可以用中括号的形式。但是这里的插入就可以：
- 第i个元素放右边的东西，i就是key，string(buf)就是value
- 因为这里key就是i不会重复，所以map的size仍然是1000000 

![1661234869961](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661234869961.png)



#### （16）unordered_set容器的测试

![1661235085358](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661235085358.png)

![1661235097896](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661235097896.png)



#### （17）unordered_map容器的测试

![1661235125567](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661235125567.png)





#### 4.分配器的测试

这部分简单了解一下即可。侯捷老师主要讲的是Gnu C++2.9版本的源代码。



# 第二讲  分配器 与 容器的深度探索

### 5. 源代码之分布

请找到你所用编译器的C++标准库所在位置。



### 6.OOP(面向对象编程) vs. GP(泛型编程)

**（一）OOP**

- OOP企图将datas和methods(操作数据的方法)关联起来。

- 为什么**list**要用OOP**单独放一个sort**操作而不用全局sort()呢？这是

> 这是因为链表不能通过iterator+3这样的操作到下一个迭代器去，**链表在内存里并不是一个连续空间**，迭代器不能跳来跳去，**只能一个一个前进或是后退**。
>
> 而在下图右侧**标准库的sort算法**可以看到**first + (last - first) / 2**(first与last都是**RandomAccessIterator**)，这样的操作是链表这样的不能支持的。所以需要自带sort。


![1661244264133](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661244264133.png)





**（二）GP**

- GP将datas与methods分离开来。这样Containers与Algorithms就可以各自“闭门造车”，然后通过迭代器沟通。
- vector、deque容器使用全局sort，这两个容器都提供**RandomAccessIterator**。
- 所有algorithms，其内最终**涉及元素本身**的操作，无非就是**比大小**。

![1661244740938](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661244740938.png)

![1661244922530](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661244922530.png)

上图中max函数有两种实现，一种是通过“字典”式比较字符串大小，一种是通过“字符串长度”比大小。



### 7.技术基础：操作符重载与模板

这部分主要讲了操作符重载、类模板、函数模板、特化、偏特化。这部分内容在面向对象课程中已经讲过，我这里也不再重复叙述，详情请看面向对象编程的课程笔记。



### 8.分配器

请注意以下几点：

（1）分配器很重要，但一般不会直接用它，也不推荐直接用它。

（2）所有的分配动作，最底层都会调用C语言层面的malloc函数中。这个函数再根据不同的操作系统去调用各自对应的API（system api）去拿到真正的内存。 （与之相反，所有的deallocate动作最终都会调用free函数）

（3）**malloc函数**有一个特点是： 对于**越小块**的内存，其**额外开销**比例就**越大**。如下图：size上下两端（红色部分）习惯上叫cookie，记录着整块内存的大小。因此free才知道回收多大内存。

![1661256159470](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661256159470.png)

（4）分配器最重要的函数就是allocate和deallocate，而allocate则会调用operator new，而operator new最终则会调用malloc。deallocate则是调用operator delete，而operator delete则最终调用free，与malloc配合。
（5）这里再次提醒：**`typename() `表示这是一个临时对象！**许多源代码中都会出现它，如临时对象 allocator() 。

（6）VC、BC、GNU C的分配器都一样，最终会使用malloc和free来实现分配动作，都会有malloc的额外开销。即：**如果区块小，这个开销所占比例大**。

（7）但在GNU2.9标准库分配器设计有一个 **alloc** 实现。这种分配器（alloc）是最好的。

![1661256568311](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661256568311.png)

> 上图中，第0号链表负责的是8个字节的大小，第7号就是负责8 * 8 = 64个字节的大小，依次类推，最后一个15号，负责的就是16 * 8个字节的大小。
>
> 所有的容器需要内存的时候都来往这个分配器要内存。而容器的元素大小因此就会调整到8的倍数，比如元素大小是50字节就会调整到56字节，那么此时就是第6号链表（7 * 8 = 56），然后就会看这号链表里面有没有内存块，如果没有就会调用malloc去向操作系统要一大块去切割，然后用单向链表去存储。**所以这样切出来的一大块就会不带cookie，就没有这样的额外开销。**（其实也有cookie，只不过一大块才有一个，所展开销很小。）
>
> 那么比如有一个容器，放一百万个元素，这样做，由于这一百万个元素都不带cookie，于是就可以省下800万个字节的开销。这可不是小数目。当然这是一个直观的想象，实际上每一次调malloc要一大块内存的时候都会带有一个cookie，那么按照我的理解，如果一次malloc想要分配100万个元素的空间，那么就只会带一个8字节的cookie，这当然可以忽略不计。
>
> 这是GNU C尤其是alloc的分配器所表现出来的好处。不过也**有缺陷**，需要在后面的内存管理章节去讲。
>
> 不过经过比较这一种分配器（alloc）是最好的。

（8）上面alloc是GNU2.9版的，但在新版本，至少说从**4.5**开始。这次以**G4.9**为例，**分配器却不再是原先的alloc**，又回到了最初的设计。至于为什么放弃好版本的分配器，侯老师也不清楚。



### 9.容器之间的关系与分类

- 早期，标准库很少有继承关系，更多的是复合。
- 如下图所示，**缩排**表示一种**复合**关系。如rb_tree红黑树缩排进去，表示接下来的set、map、multiset、multimap里头都有一个rb_tree。同理有heap（容器的heap）和priority_queue里头有一个vector，stack和queue里头有一个deque。 

![1661257434767](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661257434767.png)



### 10.深度探索list（上）

（1）G2.9版本一个list内部就一个node指针，指向一个节点，所以是4字节。

![1661265199956](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661265199956.png)

（2）链表是一个非连续空间，所以不希望一个iterator是单纯的一个指针，否则++就不会按链表去走(会指向未知)。因此希望iterator足够聪明，迭代器++的时候，会去看其指向的那个节点（data+2个泛化指针）中的next指针，该next指针指向list下一个节点。因此iterator应该是一个“聪明的指针”，它会设计成一个class。事实上除了vector、array容器外，其他容器的迭代器都是智能指针(即是一个类)。

（3）因为要模拟指针，所以要去实现++、-- 等操作，且**每个iterator的实现类至少要有这五个typedef** 。

（4）下图有两个++，其实就是**前置型的++和后置的++**。C++的语言规定：前置++没有参数，而后置++有参数（要把原来的东西记起来，然后++完再传回原来的东西），但是这个参数无实际意义，只是为了区分。 

![1661265824788](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661265824788.png)

![1661266013581](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661266013581.png)



（5）先看**前置++**。该重载函数body中有两步操作：第一步操作就是获取node指针指向的那个节点的next指针，然后将其赋值给node指针。这样node指针就指向下一个节点，完成了++操作。第二步return by reference。

![1661267194310](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661267194310.png)

（6）再看**后置++**。后置++重载函数body有三步操作。

第一步：记录原值。要注意这一步的赋值操作会**唤起拷贝构造函数**，然后`*this`作为参数传入该拷贝构造中，而不是唤起`operator*()`。

第二步：进行操作。**++*this不会唤起前置++重载函数**，原因见下图。

第三部：return by value。唤起拷贝构造函数。

![1661267118532](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661267118532.png)



（7）注意，上述前置++和后置++重载中，一个return by reference，一个return by value，这是为什么？这是因为，**重载操作符要向整数看齐**， 由于C++的整数不允许后置++两次，所以这里的后置++传回来的不是引用，而前置++是可以连加两次的，所以传回来的是引用。 

![1661267250671](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661267250671.png)

（8）请注意下图。

![1661267378480](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661267378480.png)



### 11.深度探索list（下）

（1）G2.9版标准库中list的设计有两个缺点：

- G2.9的迭代器传入了三个参数，其实传入一个更好。
- G2.9的节点指针类型都是void，这样不好，还得需要做一次转型，何不直接定义为节点类型呢？

这两个缺点在G4.9中得到了解决。但**G4.9**也有缺点，就是它把list类设计的太**过于复杂**！

![1661348174302](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661348174302.png)



（2）在第九节可以看到G4.9版的list大小为8，而G2.9为4，这是为什么？

![1661348512192](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661348512192.png)

这是因为，在G2.9中的list设计中，list类中只含有一个指针，该指针指向list节点，所以为4。但在G4.9中，list的设计中，含有两个指针（该指针就是节点中的那两个指针），所以为大小8。

![1661348903568](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661348903568.png)



（3）之前提过，每一个容器都有自己的迭代器，但这些迭代器中一定含有**五个typedef**，这是为什么呢？这牵扯到traits，具体看下一节讲解。



### 12.迭代器的设计原则和iterator Traits的作用与设计

参考1：https://www.cnblogs.com/mangoyuan/p/6446046.html

参考2：https://blog.csdn.net/weixin_47652005/article/details/119705116

**traits**，又被叫做特性萃取技术，说得简单点就是提取“被传进的对象”对应的返回类型，**让同一个接口实现对应的功能**。因为STL的算法和容器是分离的，两者通过迭代器链接。算法的实现并不知道自己被传进来什么。萃取器相当于在接口和实现之间加一层**封装**，来隐藏一些细节并协助调用合适的方法，这需要一些技巧（例如，偏特化）。

标准库有好几种traits，这里谈谈针对iterator的traits（还有type traits、character traits、pointer traits等等）。即萃取出iterator的特性，首先来看看iterator遵循的原则： 

![1661405336502](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661405336502.png)

上图①处的想要萃取处的**iterator_category分类**，所谓的iterator的分类就是它的移动性质，有的只能++，有的还能–，有的还可以跳着走（一次+很多、-很多）。
**②和3处**的difference_type和value_type，value_type就是容器的元素的type，difference_type就是两个iterator之间的距离应该用difference_type去表现。
所以算法（比如这里的1、2、3）问iterator，然后回答出这三个问题。而上图右下角所述，C++标准库一共设计出了五种：category、difference（距离）、value_type、reference、pointer，而最后这两种从未在标准库中被使用过。
这五种type被称为迭代器的associated_type，相关的类型。迭代器必须定义出来以便回答算法的提问

![1661405481529](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661405481529.png)

如上图，value_type就是链表的元素类型 T，category就是表现链表迭代器是双向类型bidirectional_iterator_tag
。**而指针也算一种iterator，是一种退化的iterator，而它不是class形式的，无法回答这五个问题**，就要**加一个中间层萃取机**，萃取机就需要进行区分。

![1661405549963](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661405549963.png)![1661405574972](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661405574972.png)

算法想知道`I`的五种相关类型，就来问traits，traits就转问 I （如上图）。这里通过了**模板的偏特化**来进行区分。如上图的1、2、3。
**而这里iterator若是const int* ，其萃取出来的value_type应该是int而非const int**，如上图的3与右下角的解释。

<img src="C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661405694670.png" alt="1661405694670" style="zoom:67%;" />

<img src="C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661405716231.png" alt="1661405716231" style="zoom:67%;" />



### 13.深度探索vector

- 事实上没有什么容器能原地扩充，因为不知道后面的空间是否使用。vector也是如此，每次会去找一个可以扩充的空间。最终没找到两倍大的空间，这个容器就失败了。
- vector扩充内存会先找一个比自身大两倍的空间，然后把内容copy过去，再清除原内容。所以效率很低。
- vector类自身就是三根指针（start、finish、end_of_storage），所以其本身大小是12个字节。

![1661409545044](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661409545044.png)


![1661409600049](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661409600049.png)

![1661409615405](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661409615405.png)



- vector内部是连续的，所以指针就能当作迭代器。同样用到了萃取机，原理细节与list差不多。

![1661409670419](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661409670419.png)

- G4.9版本的设计就相当复杂，可读性不高，这里不做说明。

<img src="C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661409770397.png" alt="1661409770397" style="zoom: 67%;" />

![1661409787414](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661409787414.png)

![1661409798196](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661409798196.png)



### 14.深度探索array、forward_list

- array就是C++的数组，但标准库又把它封装成了一个类，一个容器，就必须提供迭代器，然后迭代器就必须提供之前所述的五个信息，以便算法后续调用。如果没有这么包装的话，array就会在六大部件之外，就不能享受算法、仿函数等的功能。 
- array要使用时必须指定大小。
- array没有ctor和dtor（构造和析构）
- array是一个连续空间，**只要是连续空间就可以使用指针当迭代器**，不必那么复杂。 
- G4.9版又变得非常复杂了！

![1661410428521](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661410428521.png)

![1661410451557](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661410451557.png)

单向链表参考双向链表，其实现非常相似。

![1661410564919](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661410564919.png)



### 15.深度探索deque、queue、stack（上）

**（一）deque**

（1）deque的连续其实是一种“假象”，其底部实现是map，该map由一段一段连续的buffer实现。

（2）map其实是个vector，所以deque扩充的时候同vector。 一个vector（图中的map，源代码是用vector实现的，也被叫做控制中心）内放置指向各个缓冲区（buffer，也有人叫节点）的指针，需要扩充的时候就新分配一个缓冲区，然后把指针放入vector中。 

（3）deque的迭代器由四个指针构成：

- cur：指向现在的元素
- first：指向buffer头部
- last：指向buffer尾部
- node：指向“控制中心”，即控制该段buffer的那个。

这个迭代器的node就指向控制中心对应的位置，first和last指向缓冲区的边界位置，用作标志。所以当iterator每次++或者--的时候，就会**通过first和last去判断是否走到边界**，然后若已经到达边界要跳到下一个buffer的时候，就**通过node回到控制中心去找到对应的位置**。

（4）几乎所有的容器的迭代器都提供begin和end，begin就对应图中**start**，end就对应**finish**。 

![1661422264040](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661422264040.png)



（5）一个deque有**两个迭代器**、一个**map指针**（map 在这里定义是一个T**，4字节）、一个map_size。其中迭代器一个为16字节，map4字节，map_size 4字节，所以一共40字节。

（6）模板参数BufSiz就是每个buffer容纳的元素个数。G2.9版允许我们指定buffer的大小，但是新版是不允许的。
![1661422904831](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661422904831.png)

（7）从下图可以看到，一个迭代器内部四个指针，大小4 * 4 = 16字节

（8） 迭代器定义的五个typede。迭代器分类是**random_access_iterator_tag**，因此实现了deque是连续的这样一种假象。

![1661422917729](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661422917729.png)



**（9）deque的一个聪明的函数实现：**

 insert函数的实现有个考量。deque是可以两端扩充的，所以要是插入的时候前端元素比较少，那就应该往前推而不是往后推（效率高）。所以这里可以看到如果insert是头（第一个）就push_front，是尾端（最后一个）就是push_back，其他位置插入就用insert_aux函数实现。 

![1661423257225](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661423257225.png)

insert_aux函数实现：

![1661423271118](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661423271118.png)



**（10）deque是如何模拟连续空间的呢？** 这都是**迭代器的功劳**！

让调用者觉得deque连续，即做++、--、+=、-=等操作，那**迭代器**对这些**操作符**一定进行了**重载**！

![1661439247967](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661439247967.png)

如下图，*、—>、—操作符的重载，请**着重理解 — 操作符的重载**。

![1661439538660](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661439538660.png)



这有一个高明的操作：**后++重载中调用前++的重载，后--重载调用前--的重载。**

![1661439663261](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661439663261.png)



也要对+=、+操作符进行重载。实现如下：

![1661439894540](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661439894540.png)



同样，如下是`-+`、`-`操作符重载， 这里有一个很有意思的实现，可以看到下图的operator`-=`实际上用了`+=`去实现，即进行**取反**。

![1661440106811](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661440106811.png)



（11）G4.9中，deque的实现变得更为复杂。 

每个容器都设计成这样四个class。本身、base、impl、allocator，本身继承base，base内复合impl，impl继承分配器。而新版本把buffer_size这个参数拿掉了，取而代之的如上图右下角的注解，自动根据元素类型去判断buffer应该多大。 

这里还有一个聪明的考量，就是控制中心是一个vector，而这里每次扩充成两倍的时候，搬移元素不是搬移到新的控制中心vector的前面，而是搬移到中间（中段），这样便于两端扩充（非常聪明）。 

![1661440130472](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661440130472.png)



### 16. 深度探索deque、queue、stack（下）

（二）queue与stack

对于这两个容器来说就很简单了，因为他们俩内部实现就是一个deque。内含deque，然后封锁住一些功能。因为这样的实现，所以有时候也不会把queue叫做一个容器，转而叫做一个适配器。

![1661440372274](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661440372274.png)

![1661440387036](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661440387036.png)



**stack和queue还能选择list作为底部支撑**（如前面的stack和queue的实现，只要能提供那些如back、push_back之类的实现函数就能作为底部支撑），而这里默认的底部支撑是deque，应该deque实现起来更快。

还有一点需要注意，**queue与stack都不允许遍历**，不提供迭代器。因为一个先进先出一个先进后出是全世界公认的，所以要拿元素只能从头端拿或尾端拿。
![1661440496984](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661440496984.png)

![1661440509885](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661440509885.png)

![1661440526001](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661440526001.png)



### 17.RB-tree 深度探索

（1）红黑树的基本认识

- 红黑树是**平衡二分搜寻树**。
- 红黑树**提供“遍历”操作以及iterators**。按照正常的规则（++ite）遍历，就能得到所有元素的排序状态。
- 我们**不应该使用红黑树的iterators去改变元素的值**。但是**编程层面并未禁止**这件事。因为我们在红黑树里排序的是元素的key，而map允许元素的data被改变，只有元素的key才是不可被改变的。
- 红黑树提供**insert_unique和insert_equal**，前者表示放入的key一定是独一无二的，如红黑树中已经有了一key，为5，那么再放5进去的时候就会放不进去（什么也不发生，也不会报异常之类的）。而用insert_equal是可以放进去的。

![1661491386257](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661491386257.png)

- 红黑树内部实现有五个模板参数。前两个参数是key和value。这里有一个术语要弄清楚。这里元素本身可以放两个东西：key和data，而**这里的value是key和data合起来的东西**。而内部所存一个是key一个是data（区别于之前所述的key和value键值对）， 所以对应到源码实现的时候要告诉它key是啥value是什么。这里data本身也可能是其他几个东西的组合。
- 第三个模板参数意味着，key要怎么从value中拿出来；第四个模板参数就是告诉他应该怎么去比较大小；第五个模板参数就是分配器，有个默认值。
- 再接着看下图，红黑树内部的数据，图中有三个。分别代表着re_tree的大小、指向红黑树的节点的指针、key的大小比较准则（应该会是一个function object）。
- 再来思考一个红黑树的内部大小。一个node_count和header都是4字节，加起来8字节，而一个key_compare是一个函数对象，按理没有大小，但是一般编译器实现上，对于大小为0的class会默认给它大小为1，所以这里就是4+4+1为9字节。而要是按照内存对齐，这里就应该是4+4+4=12字节。
- 同样这里要考虑刻意的“前闭后开”，这里表现出来就是上图的header。

![1661492049386](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661492049386.png)

![1661491748212](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661491748212.png)



- 一般不会直接使用红黑树，会使用它的上层，即set或者map之类。
- 这里侯老师示范使用红黑树。这里老师第一和第二个参数都传入int，就表示key就是value，value就是key。第三个参数使用GNU C独有的identity，一个仿函数，就是直接返回它自己本身，如上图。第四个传标准库就有的less。这就是真正拿红黑树来用的做法。只是为了加深理解，实际中一般不会这样用。

![1661492147355](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661492147355.png)

![1661492158830](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661492158830.png)

![1661492171995](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661492171995.png)



- G4.9设计变得复杂化了，但是符合OO里面一个观念：OO里头为了某个目标会很乐意实现成，在一个class里头，有一个指针或一个单一的东西来表现它的实现手法**implementation。**这样一种手法叫做**handle and body**。所以从以前2.9版变成现在4.9版这样复杂，是为了符合handle and body这样的目标。
-  G4.9红黑树大小从原来的12变成了24字节。从这里可以看到里面还有一个_Rb_tree_color，是一个枚举类型，加起来是3 ptr + 1 color 是24字节。 

![1661492186803](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661492186803.png)



### 18.set、multiset深度探索

有了红黑树的基础，接下来的分析就简单了。

set/multiset的基本特点如下图， 这里set/multiset在设计上禁止通过iterators去改变数据（区分底层的红黑树，那是为了让map使用去改data） 。

![1661493684864](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661493684864.png)



- set内部有一个红黑树，这里set禁止通过迭代器改内容的关键就是下图的**const_iterator**。
- set的所有操作，都是转调用底层的t（红黑树）的操作。前面的stack和queue也是这样。那么从这层意义来看，set未尝不是一个containerdapter。

![1661493764148](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661493764148.png)



侯捷老师是用G2.9版进行讲解的，其他的平台其他的版本的实现都是类似的，下图是VC6的实现。 下图红黑树的第三个参数_Kfn就是GNU C的identity吗 

![1661493932306](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661493932306.png)



mutiset见下图。

![1661493998537](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661493998537.png)



### 19.map、multimap深度探索

在set中，key就是value、value就是key；而在map中value里头包括key和data两部分。这就是他们的唯一区别

我们无法使用iterators来改变元素的key，但可以用它来改变元素的data。 

![1661506920962](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661506920962.png)

map这里的实现中直接告诉了红黑树第三个参数（之前说了是从value中怎么拿key的方式）select1st，就是说value中的第一个就是key。

而同样从上图我们可以看到，这里把key和data组合成了一个pair，当作value，所以之前我们说set不能改变元素是借由const_iterator来做的，而map不能改key是借由value实现的pair中的模板参数const Key来实现的，区别在这里。

![1661506956956](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661506956956.png)



select1st是GNU C独有的，我们再来看看VC中的实现， 同样，在map中_Kfn这一块的写法就是GNU中的select1st 

![1661507017577](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661507017577.png)



379行: multimap<long, string>，心中要知道，红黑树实现是把他们包装成一个pair，然后当作节点放入红黑树中的 

![1661507032584](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661507032584.png)



请注意上图的378行：**mutimap不可使用[]**

这里中括号要传回来与这个key相关的data，如果这个key不存在，中括号就会创建这个元素带着这个key放入map中，所以**这是map独特的operator []**：

![1661507156794](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661507156794.png)

这里lower_bound是二分查找的一种版本，标准库提供的一个算法。而在上面实现中还分为了2011之前的版本和2011之后的版本实现。

同样提供的一个例子，通过中括号来放元素（通过之前分析我们知道，找不到key就会加入新的元素进去）。

而显然由于中括号里头先做了lower_bound再做了insert，所以当然是直接放元素比较快。 

![1661507215404](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661507215404.png)



### 20.hashtable深度探索（上）

（1）G2.9哈希表的实现：

哈希表是由一个vector实现的，可以把它看成一些“buckets”（篮子），每个bucket后跟着一个链表。
比如当我想向哈希表中传boject，则会**先把object映射称为编号**，然后（编号/篮子大小）的余数，放进哈希表中。如下图左上角，buckets大小为53，如果object的映射编号为55则（55/53）余2，就放进第二个bucket，同理2、108也都放进第二个笼子里。

有一个设计是：**当元素数(object)大于等于buckets数，则需要进行扩充**，因为以免篮子链表过长，毕竟链表查询效率很低。

G2.9扩充的方法是**寻找一个比原哈希表大两倍左右的质数（素数）空间**，比如53两倍附近的素数为97，就将原哈希表copy进新哈希表中，然后再对元素进行重新排序，比如此时（55/97）余55，（108/97）余11，放进新编号中。

![1661509114107](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661509114107.png)



（2）G2.9哈希表的源码

见下图，首先看其模板参数。

第一个参数value，第二个参数key，这没什么好说的。
第三个HashFcn（哈希函数，可以是一个仿函数函数对象），用来算出hash code，即将object对象映射为一个编号的函数。
第四个模板参数就是从这一包东西中取出key的方式（函数对象），第五个模板参数EqualKey，同样作为一个函数对象告诉它怎样比大小，最后一个参数为分配器。

同样我们观察它的内部数据，首先有三个函数对象，然后有一个篮子vector（图中的buckets），还有一个变量登记有多少元素。所以一个hashtable的大小就是：三个函数对象，之前提到了原本大小应该是0但是编译器会给1，共3个字节，buckets本身是vector三个指针12个字节，num_elements是一个size_type是四个字节，所以一共 1 + 1 + 1 + 12 + 4 = 19，字节对齐共20个字节。所以每个hashtable的大小是20个字节。

![1661510278579](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661510278579.png)

（3）G2.9哈希表迭代器的设计

见上图，对于node的设计，除了东西本身之外，由于单向链表的实现，所以会挂着一个指针指向下一个节点。 

同时迭代器要是走到尽头了应该能够回到“控制中心”以达到下一个节点（有点像之前STL上中分析的deque）。所以迭代器应该有能力回到篮子vector里头去走向下一个篮子。所以从上图观察设计可以看到其中有两个指针node* 和 hashtable* 



### 21.hashtable深度探索（下）

本节讲述的是一个直接使用哈希表的实例。

这里传入的对象是C风格字符串，在这里面，hash<const char*>、eqstr功能都需要自己实现。

G2.9标准库中也没有提供`hash<std::string>`，所以如果我们要传入C++风格字符串的话，hash-function函数也需要自己实现。但在G4.9中，提供了`hash<std::string>`。

![1661515449012](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661515449012.png)

![1661515494837](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661515494837.png)

![1661515513029](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661515513029.png)



所谓modulus（模数，mod）就是除后得余数，所以hash code算出来落在哪个篮子上，所有的hash table几乎都是这样直接取模去做的，公认的一件事。下图浅蓝色的部分其实也就是去计算最终落在哪个篮子里，最后可以看到最终通通会去取余数 。

![1661515644096](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661515644096.png)

![1661663924123](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661663924123.png)

![1661663936312](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661663936312.png)

![1661663946580](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661663946580.png)



### 22.unordered容器概念

C++11之后，hash_set、hash_multise、hash_map、hash_multimap全部**更名**为**unordered**_set、**unordered**_multise、**unordered**_map、**unordered**_multimap。但**实现原理没变**。

unordered容器与之前的set、map等容器区别就在于，底部支撑的是红黑树还是hash table。

![1661664491750](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661664491750.png)

第一讲中的测试，要记住，**“篮子”要比元素多**。

![1661664673488](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661664673488.png)

![1661664685248](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661664685248.png)





# 第三讲 算法、迭代器与适配器

### 23.算法的形式

- 从语言的层面讲，容器是一个类模板，算法是一个函数模板。
- 标准库里所有的算法类型都是这两个版本(下图右下角)。比如说sort算法可以传递第三个参数，即排序的准则。而这第三个参数其实是一个Functor。
- 算法其实是看不到容器，它只能看到自己的迭代器。所以算法会想要提问去问迭代器一些问题，然后迭代器进行回答来提供这些算法所需要的信息。如果算法发出问题而迭代器无法回答，那么编译就会报错。
  

![1661665339160](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661665339160.png)



### 24.迭代器的分类（category）

迭代器的**分类是一种对象**(类)，而不是1、2、3这样的分类表示。这样做的最主要的一个原因是：**类具有继承关系**，有时候对于五种迭代器的分类，不需要列出所有的分类，只需要由两个或三个即可，因为继承关系是**“is-a”**，没列出的分类，找它的父类即可。

这五种类型分别是
random_access_iterator_tag、bidirectional_iterator_tag、forward_iterator_tag、input_iterator_tag、output_tag。他们之间**存在继承**关系。

> Array、Vector、Deque：都是连续空间（这里包括deque的假象），所以都random_access_iterator_tag。
>
> List：不连续空间，但是是双向链表，所以是bidirectional_iterator_tag
>
> Forward-List：既然是单向链表，所以应该是forward_iterator_tag
>
> Set、Map、Multiset、Multimap：红黑树的底部支撑，通过我们之前的分析，我们知道红黑树都应该是双向的，所以是bidirectional_iterator_tag
>
> Unordered Set/Multiset、Unordered Map/Multimap：hashtable的底部支撑，通过之前的分析我们知道，要看每个篮子的链表是双向还是单向链表，所以应该是forward_iterator_tag（对应hashtable内部实现是单向的链表）或是bidirectional_iterator_tag（对应hashtable内部实现是双向的链表）。而按照之前分析的版本实现来看，G2.9是单向链表实现，所以G2.9版本就应该对应着forward_iterator_tag。

![1661666553586](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661666553586.png)



 测试打印出各种容器的迭代器类型 ：这里侯老师的做法就是把拿到的迭代器丢到萃取机去问它的iterator_category。然后继续往上丢，通过函数重载去实现打印。 

![1661666756101](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661666756101.png)

利用C++提供的功能打印迭代器分类：把放进来的iterator放到typeid去，typeid可以形容成C++提供的一个操作符，放入后得到一个对象object，然后使用其中的name。得到的结果如下图右侧。（使用前记得添加头文件）

![1661666846074](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661666846074.png)



迭代器有两种特殊的分类： **istream_iterator**和**ostream_iterator** 。至于为什么会是这两个类型，看一下源码实现就知道了，他只不过使用typename命名为这两种类型。

![1661667002358](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661667002358.png)

![1661667012747](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661667012747.png)





### 26.迭代器分类（category）对算法的影响

> 下面distance函数和advance函数，迭代器分类就没有列出5种，虽然只有两三种分类被列出，其实5种都出现了，因为迭代器的分类存在继承关系。这就是为什么迭代器的类型是**类对象**以及这样设计的好处。

（1） distance函数

如下图右下角的distance函数，先通过萃取机拿到iterator的category，然后根据category创建临时对象，通过重载根据第三参数从而调用相对应的函数，显而易见的是，distance函数的第二版本首尾一减就可以了，效率高；而第一个版本需要一步一步判断，效率很低。

distance函数返回值的返回类型同样是根据萃取机拿到迭代器difference_type。


![1661671426766](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661671426766.png) 



（2）advance函数

advance函数同样根据迭代器category分成了三个版本。

![1661671632872](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661671632872.png)



（3） copy函数

- copy函数需要三个参数，分别是：来源端的头和尾、目的端的头，以及copy过去的result。
- 一个简单的copy其设计实现相当复杂，因为有很多次对迭代器的检查，算法针对不同迭代器的类型选择不同的实现方式，效率很高。
- 下图右边的trivial表示重不重要。 

![1661672004909](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661672004909.png)



（3）destory函数

![1661672172938](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661672172938.png)



（4）__unique_copy函数

要注意有两个实现版本以应付不同的情况。

![1661672212702](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661672212702.png)



（5）算法对迭代器类型只有“暗示”没有强制，所以平时我们要规范使用算法迭代器容器，发挥最大的效率。

![1661672273285](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661672273285.png)



### 27.算法源代码剖析

首先要注意区别C函数与C++的算法

![1661677318298](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661677318298.png)

接下来，进行一些算法源代码分析。



（1）算法accumulate（累计）

算法的实现一般都有两个版本，如下图：

> 版本一：初值加上每个元素的值。 
> 版本二：初值与每个元素做了一个binary_op的操作。最后一个参数可以视作一个“准则”，这个“准则”可自定义。这个“准则“有一个要求，需要小括号（）能作用到其上即可。（）叫做function call operator，函数作用符。

![1661677629904](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661677629904.png)



（2）算法for_each

如下所示。C++11可以使用范围for循环。

![1661678410869](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661678410869.png)



（3）算法replace、replace_if、replace_copy

![1661678729918](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661678729918.png)



（4）算法count、count_if

这里要先提一句：**如果容器有自己的成员函数，就一定调用自己的，千万别调用全局的。**

关联式容器，都自带着一个count函数。因为他们是关联式容器，查找会比较快，不需要再像全局的count这样一个一个去遍历。 

![1661679369628](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661679369628.png)



（5）算法find、find_if

全局的find是一个循序查找，最坏的情况要全部走一遍，效率底。find_if就是找的时候要符合一个条件。

关联式容器自己带有一个find。 

![1661679426177](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661679426177.png)



（6）算法sort

1817行：rbegin和rend的r代表着reverse，即逆向的begin和end。

下图右边列出的八个关联式容器本身就已经形成sorted状态，所以不需要再调用sort函数。

list和forward_list需要调用自己的sort函数，不能调用全局的，否则报错。因为全局的sort要求迭代器是random_access_iterator（可以跳来跳去），而list和forward_list则不行。

![1661679582434](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661679582434.png)



关于上图提到的reserve iterator，现在现有一个简单的认识，他其实是一个适配器adapter，后续会详细的讲。

![1661680023431](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661680023431.png)



（7）算法binary_search

**二分查找的前提是：已经做了排序算法！**

二分查找到实现其实是一个lower_bound，意思是可插入的最低边界，与之相对的是upper_bound。lower_bound的意思是（下图右下角），可以把20安插进去的最低的那个边界点，而upper_bound就是可以把20安插进去的最高边界点。 

下图左下角是侯捷老师的一个心得。

![1661680389793](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661680389793.png)



### 28.仿函数和函数对象

- functor是最有可能自己写的六大部件之一，它只为算法服务。
- functo的表现形式就是在一个**类中重载（）**。
- 标准库提供三大类functor：**算术类、逻辑运算类、相对关系类** 。

![1661690302600](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661690302600.png)



GNU C++有一些独有的functor，标准库种不存在(现在不清楚有没有)，比如identity、select1st、select2nd。
要注意的是在G4.9版本，这些functor的名字发生了变化。 

![1661690318700](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661690318700.png)





还有一点要注意：**标准库提供的仿函数都继承了一个父类**，父类是谁呢？父类有什么特点？为什么要继承呢？如果自己写的functor没有继承这些父类会存在什么问题呢？

现在一次回答这三个问题：

- 父类只有两个，分别是：**unary_function、binary_function**。
- unary_function适用于单目操作符(只有一个操作数)、binary_function适用于双目操作符(两个操作数)，所以继承的时候你要分辨要继承哪一种。这两个父类仿函数还有一个特点是：内部只有一些typedef。没有其他东西继承它们，它们的大小就为1（实际为0），如果有东西继承它们，它们的大小就一定为0。
- 继承的原因是可以更好让functor融入STL库，这样**funtor就可以回答适配器adapter问题**，以适应算法（类似于迭代器必须定义5种typedef以便回答算法的提问）。而且继承之后并没有增加任何数据量，因为此时它们继承的父类大小为0。所以又能融入STL又不耗费内存，何乐而不为呢？
- 如果自己写的functor没有继承这两个父类的话，简单的操作能通过编译，但如果后面要深入使用，则可能会报错，毕竟没有融入STL，适配性就不高。

![1661691478187](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661691478187.png)

![1661691532526](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661691532526.png)

最后，侯老师做了个总结，也算是提醒：

> **functor就是一个class里头重载了小括号（）**，这样的一个class所创建出来的对象就叫做函数对象或仿函数。叫函数对象原因是因为这个对象是一个对象但是像一个函数。
>
> 很多地方为了搭配算法我们自己就会去写仿函数。但要注意，**如果自己写的functor的时候没有继承那两个父类，那么就放弃了未来可以被改造的机会**。所以如果想要自己写的functor融合进STL体系，就需要选择适合的仿函数（unary_function与binary_function）去继承。





### 29.存在多种Adapter

- **adapter的共性就是：把它所要改造的东西记下来，然后再考虑如何改造。**
- adapter往往都有一个**辅助函数**，方便user使用。

- adapter是把一个既有的东西稍微改造一下。比如：A改造了B，那么A就代表了B，那么之后就只需要使用A，而实际功能的实现则仍然是交由B去实现。
- 据我们所知，A要使用B的功能，有两种实现方式：继承和复合。但是**在adapter中，不用继承的方式，而都是用内含（复合）的方式。**
- 如下图所示，adapter出现在三个位置，由它想要改造的东西去决定叫什么。做法有个性也有共性。

![1661692462173](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661692462173.png)



### 30.容器适配器

如stack、queue中，都内含了一个deque。将deque的功能换一个“风貌”（即改个名称），让自己调用。

![1661692490838](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661692490838.png)



### 31.函数适配器

#### （1）Binder2nd

binder2nd是一个函数适配器。本节例子先不考虑not1。

大致实现：

> 如果我想要小于40的元素个数，就可以专门写一个小于40的function获知，而要是再要一个大于100，或小于200，就又需要写针对这样的特例的function，这样显得优点重复啰嗦，所以标准库就给了这样的适配器：bind2nd。
>
> 如下图右上角所调用的函数bind2nd（本节例子先**不考虑not1**），此时它有两个参数（less<int>()和40）。它其实就是一个函数适配器，它的作用就如同其名：**把第二个参数绑定**。
>
> 这里有两点要注意，一是第一个参数less实际上是一个object，还没有调用，所以此时并未传入参数；二是bind2nd内部就会创建binder2nd，其为真正的主角。有很多手法都是有一个class主体，然后再去给一个辅助函数来使用，所以这里**bind2nd就是一个辅助函数**，以方便user方便实用binder2nd。
>
> 关于主体binder2nd（下图右下角部分）：**作为一个函数适配器，其内部就要有东西像函数一样**，所以binder2nd内部重载了小括号（）。这里adapter修饰function那么它之后也要去形成function的样子，所以这里要去重载小括号（）。以下图右上角的调用为例，binder2nd内部的成员**op其实就是红色的less**，而**value实际上是40**，所以实际上实现中并不是什么绑定，只是先把40记起来，等到后面调用的时候直接传参（这里的op(x, value)，非常巧妙！
>

![1661774930289](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661774930289.png)

了解了大致实现，还有一些细节要注意。

第一个细节就是：上图中的实现出现的**Operation::first_arguement_type、Operation::second_arguement_type、Operation::result_type**（灰色字体），是什么作用？

这其实就是之前提到的“问和答”（28节）。

首先先看问题的原点：上图右上角`bind2nd(less<int>(),40)`，第一个参数说我要比较一个整数的大小，所以我要绑定第二个参数一定要是个整数，我希望编译器能分辨出是不是整数，而不是到了runtime error，而类似于Operation::second_arguement_type这样的细节操作就可以让编译器分辨出类型对不对。所以下图：adapter首先去问第二实参是什么类型，然后这里会看是否可以转换，比如右上角例子中的40去判断是不是less中模板的int型。如果不能转换就会编译出错。

![1661775789801](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661775789801.png)

所以同样，这里的value也要被询问，准备传入进去的40是不是我想要的或者是可以被转换为我想要的类型呢？可以看到这里的value的type不能随便定义，必须用问的方式来获得。

![1661775897739](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661775897739.png)

所以，从上图灰色的部分可以看到，很多地方的type都是靠问的，会问三个问题：第一个实参是什么type，第二个实参是什么type，这两个比完之后又是什么type？
所以一个函数对象必须能够回答这三个问题才能和这一个adapter：bind2nd搭配完美。这样上图这些灰色的部分才会有意义。如果能够回答这三个问题，我们就叫这个function叫做是adaptable的。
于是回到下图，我们瞬间明白了这三个typedef的作用，其实就是去回答那些问题的：
![1661776137848](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661776137848.png)

第二个细节是：**typename其实是为了让编译器通过的作用**。比如:typedef typename Operation::second_arg ument_type arg2_type;编译器编到这里的时候其实还不知道作为模板参数的Operation是什么，也就无法得知Operation::second_argument_type是否是正确的用法。所以正常来讲编译器编到这里会编不过。所以这里typename用以是这里，就是让编译器编到这里可以编译通过。

第三个细节：就是这个adapter作用完后还可能被别的adapter使用，于是这里的**binder2nd还继承了unary_function**。这样的写法就非常的严谨。



 下图是后续版本的一些变化，在新版本中bind1st、bind2nd已统统用bind来取代。

![1661777680578](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661777680578.png)



#### （2）not1

分析与binder2nd差不多。右上角意思时大于40的数。

![1661778244935](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661778244935.png)



#### （3）bind

C++11后binder2nd等都替换为bind了。

std::bind可以绑定：

- functions
- function objects
- member functions ,  _1必须是某个object的地址
- data members,  _1必须是某个object的地址

要注意的是，使用bind前要引入占位符命名空间：using namespace std::placeholders; 

其具体使用功能看下图实例基本就能理解了。

![1661780192653](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661780192653.png)



### 32.迭代器适配器

#### （1）reverse_iterator 

> adapter的共性就是：把它所要改造的东西记下来，然后再考虑如何改造。

reverse就是要逆序，重要的是表现出取值的动作，比如对逆向取值就是对正向退一位取值。

其次那5个typedef（迭代器的“问和答”），和原来的iterator一致。

具体实现看下图，关键步骤要清楚！

![1661781525426](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661781525426.png)

![1661781569853](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661781569853.png)



#### （2）inserter

不得不说，C++中操作符重载真的是太秒了！

我们知道，copy是直接拷贝赋值，所以要事先预留好足够的空间大小，如果超出此空间，就会出问题。
而inserter就不一样了！如下图的案例所示，（其中用了advance基础函数，因为链表是不能直接+3的）

从下图可知，要是硬插入这五个元素，就要用到inserter这样一种迭代器适配器（用copy的话就超空间了）。即把目的端迭代器it改为插入型的迭代器动作。而**实现的关键使用了操作符重载**。

> 我们来看它的实现：在copy中赋值是用赋值号=去操作的：*result = *first; 那么在inserter这个适配器中我们就重载了赋值号=，这样在进行copy的赋值操作的时候就会跑到inserter内的操作符重载中去调用。而在操作符重载中观看源码就可以发现关键是直接转调用了insert()函数。

![1661782574072](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661782574072.png)



### 33. X适配器

ostream iterator与istraem iterator都不属于容器、迭代器、函数适配器，于是这里侯老师叫做X适配器，或者未知适配器。 

这两种适配器让人拍案叫绝的地方在于操作符重载。

#### （1）ostream iterator  

- 该适配器的一个特点就在于，它把迭代器绑定到了一个装置上即：cout。在ostream_iterator中通过操作符重载，改变了copy动作中的赋值、*、++操作符的含义，赋予了新的意义，让其能够巧妙地将元素输出在控制台上。
- 此适配器的关键就是在赋值操作符重载的时候把value丢到了cout中去（ *out_stream << value)。那么丢出去后如果delim存在，就接着丢元素。以此类推把元素全部输出完。
- 因此，某种意义上，这里也可以叫做ostream的适配器，因为它是来用来改造ostream。

![1661826612743](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661826612743.png)



#### （2）istream iterator

istream_iterator也很奇妙，它绑定的是cin。下图的eos是没有参数的，代表一个标兵、一个符号。而iit带有参数cin，cin在istream_iterator实现中被记在in_stream中，然后构造函数的时候就会马上++，++则调用内部的操作符重载部分。也就是说，++就会去读内容。
![1661827898924](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661827898924.png)



接下来再看一个复杂的例子：

> 同样创建：一个eos作为标兵，一个绑定到cin上。
>
> copy之前出现很多次了，同一个copy，在这里的istream_iterator中重载了*、++等操作符，又实现了另外的功能。
>
> 同样一个copy，在不同的对象上有不同的使用，非常巧妙。 

![1661827959523](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661827959523.png)



# 第四讲：

第四讲开始讲述STL周边的一些东西。

### 34.一个万用的hash function

它有三种型式，这里先说两种。

型式1：作为成员函数

型式2：作为普通函数

![1661831420715](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661831420715.png)



关于其实现原理，重要的是要理解一点：**可变模板参数。**本节讲述的内容较繁杂，引用一下前人的笔记记录：

> 原文链接：https://blog.csdn.net/weixin_47652005/article/details/119843231
>
> 所谓hash function，希望产生的hash code越乱越好，避免重复。
> 从上图可以看到两个型式上的一些区别。
>
> 我们再往下看，如果有一个类内有好几个成员，且可能是不同的参数类型，一个“天真”的想法就是分别算出他们的hash code然后相加，但是这样做会造成较多的hash碰撞（冲突）。
>
> 如下图，简单地这样相加会造成碰撞较多。虽然可以运作，但是太天真了，不好。
> 接下来探讨上图1、2、3、4部分的实现。
> 首先可以看到1、2、3有三个同名的hash_val，1中为可变模板参数，而2、3的参数则与1不同。
> 可以观察上面的实现，每次拿到一包参数，先在1中声明一个种子seed，然后调用2，2再调用4combine，然后通过哈希函数去设定这个种子seed的值。这个改完之后的种子值就是hash code。也就是从…中一次一次去取出元素来设定种子，知道最后只剩一个参数的时候落到了3这个动作。
> 可以看到，可变模板参数variadic templates为我们很方便地做到了拆解的事情。
> 可以看到seed每次都是 ^= 操作，这样就把传入的那一包参数combine计算成了一个hash code。

这部分内容建议重复观看侯捷老师的视频。

![1661831473441](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661831473441.png)

 hash code的那个9e3779b9 其实是借用黄金比例。



接下来使用一下这个hash function

![1661831758257](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661831758257.png)

![1661831768973](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661831768973.png)



接下来看一下hash function 的第三种型式

![1661831812101](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661831812101.png)

![1661831823851](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661831823851.png)



### 35.tuple

- tuple：一堆东西的组合。这是tr1才加进来的。(注：C++ Technical Report 1 (TR1)是ISO/IEC TR 19768, C++ Library Extensions（函式库扩充）的一般名称。TR1是一份文件，内容提出了对C++标准函式库的追加项目。现在是到了C++2.0（C++11之后），涵盖了过去的TR1，变成了标准的一部分。)
- 如下图所示，首先测试了各个数据的大小。string里头大小就是一个指针，4字节。double8字节。而如果复数指定的是double的话，实部虚部加起来就是16个字节。

- **tuple赋初值**：`tuple<int, float, string> t1(41, 6.3, “nico”);`
- **取tuple元素**： `get<0>(t1) `拿出t1的第一个成员。
- 也可以通过**make_tuple**，通过编译器的实参推导得到一个tuple：auto t2 = make_tuple(22, 44, “stacy”);
- tuple对象：t1和t2可以比较大小、可以赋值、可以cout输出（因为tuple重载了<<）。
- **tie的用法**：tie绑定绑住的意思。下图右下角，t3要绑住这三个变量：tie(i1, f1, s1) = t3; 即把t3的这三个成分拿出来附着到这些变量去（assign values）。
- **tuple_size**：查看tuple元素个数
- **tuple_element**：查看tuple的指定元素的type。

![1661834889749](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661834889749.png)



tuple的原理实现：

关键是可变模板参数的使用（ variadic templates ），它可以实现**递归继承**！如下图右上角，当你创建一个tuple是，它的实际结构就是如图所示的继承结构！

 我们知道可变模板参数（variadic templates）的语法，一定会有一个主体和一个结束条件，毕竟递归要有结束条件。这里的结束条件就是一个空的tuple：`template<> class tuple<>{};`(下图左上角) 

> 模板参数一开始放入head和tail…，头head和尾tail都是任意类型。这里其实就是继承了tuple<Tail…>递归地去实现。 

![1661835262240](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661835262240.png)



### 36.type traits

#### （1）G2.9中的type traits:

> 做出了6个typedef。第一个typedef是实现上的关系，不用管；剩下五个问题要回答，问题分别是：你的默认构造函数是不重要的吗？（has_trivial_default_constructor，这里的trivial英文中就是微不足道的意思)，你的拷贝构造是不重要的吗？拷贝赋值？析构函数？可以看到这些默认的回答都是false。如：typedef false_type has_trivial_default_constructor;因此所有的这些东西都是重要的。
>
> 这里的POD就是“很平淡的旧格式”，那么什么是旧格式呢？其实就是C中的struct。就是里头没有function只有data。
>
> 在特化的版本中，例如type_traits< int >，这些都被设定为不重要的。毕竟一个int型不需要构造函数。
>
> 依葫芦画瓢，我们也可以自己去写出这样的一个特化版本。用真或假去回答这五个问题。因此一个设计者可以写出这五个问题的答案，然后算法再去询问这些问题使用萃取机得到答案。这就是type traits。但是这样实用性不高，毕竟谁知道一定要去定义这五个typedef呢！
>
> 文字引用：https://blog.csdn.net/weixin_47652005/article/details/119843231

![1661841820507](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661841820507.png)





#### （2）C++11之后的type traits

但是在C++11之后，**标准库内置了许多type traits**，它可以知道一个类、对象的实现细节！比如可以知道：有没有构造函数、拷贝构造、拷贝赋值、移动构造、移动赋值？这些构造函数重不重要？是不是pod？有没有虚函数？有没有析构函数？等等，可见type traits非常强大！

![1661842152730](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661842152730.png)

![1661842167794](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661842167794.png)



接下来，我们写一个函数，测试一下这些萃取机。

下图写了一个type_traits_ouput函数，内含许多萃取机，通过调用该函数，测试内部的type_traits。

![1661842267130](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661842267130.png)

如下图，测试一个string，可得如下结果。

这里要注意一点的是：

- 一个类要不要写**析构函数**？取决于该class**是否内含指针**。
- 一个类要不要写**虚析构函数**？取决于该class**是否被当作base class**。

字符串内含指针，所以应该存在析构函数（下图左下角绿框）。但字符串在设计的时候，考虑的是不会被拿来当作父类，所以destructor不是virtual的。而这些问题，萃取机都能够知道！非常的神奇！



![1661842619002](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661842619002.png)



再看一个例子，自己写了一个pod类（即：非常简单、平淡如水的类）

![1661843068098](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661843068098.png)



一个含有虚函数的类

![1661843167873](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661843167873.png)



一个具有拷贝构造、移动构造相关操作的类，依旧能够通过萃取机知道细节：

![1661843433926](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661843433926.png)

一个复数类的测试：

> 复数只有实部虚部，析构函数不需要定义，直接使用默认的就好。萃取出来的结果也是如此，__has_trivial_destructor确实是1，即代表着destructor是不重要的。 

![1661843511127](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661843511127.png)



同样，测试list

![1661843651903](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661843651903.png)



### 37.type traits实现

接下来看一下萃取机是怎么实现的。首先要明确一点，type traits的实现，其内部都有**一个模板泛化**和**一些模板特化**构成。

第一个例子 is_void：

首先将类型 _ Tp传入，然后通过调用remove_cv去掉其const、volatile属性，将返回值在传入_is_void_helper中。实现都是用一个泛化和一个偏特化去实现的，例如：

> 在remove_const的实现中用到了偏特化。比如这里的remove_const<_ Tp const>，它的typedef就仍然是_Tp。volatile同样。所以任何type放进去回应就是去掉那些关键字的版本。
>

![1661844380827](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661844380827.png)



第二个例子：is_integral 

此萃取机的实现原理也是一样的，先通过remove_cv去掉const、volatile属性，然后再调用helper进行实现。 

![1661844729343](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661844729343.png)



第三个例子： is_class，is_union，is_pod，is_move_assignable

要注意的是，下面蓝色部分标准库中都找不到源码，侯老师推测应该是编译器内部实现的。

![1661844855716](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661844855716.png)

![1661844867993](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661844867993.png)



### 38.cout

- 用到了那么多次的cout，现在来简单认识一下：
- cout是一个类还是一个对象？cout不能拿类来用，所以它一定是一个对象object。
- cout被extern修饰，意味着cout可以被外界使用，可以被其他文件使用。
- 基本类型可以直接被cout输出，是因为其内部早已进行了相对应的定义，对于自己写的类型，不能直接用cout输出，需要自己操作符重载<<

![1661845444248](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661845444248.png)

![1661845600312](C:\Users\刘坤\AppData\Roaming\Typora\typora-user-images\1661845600312.png)



### 39.movable元素对于deque速度效能的影响及测试函数

这部分内容就是浅显的讲了一下C++2.0移动构造带来的效能提升。具体实现在C++新标准课程中有详细的讲解。