## 1. 在构造函数中使用auto关键字得到警告：warning: variable ‘start’ set but not used [-Wunused-but-set-variable]

问题描述：写一个计时器类时，用到了chrono类，由于类型太长，故考虑在构造、析构函数中使用auto关键字自动推荐类型。结果出现了警告，需要说明的是，在计时器类外使用auto关键字没有任何警告。代码如下：

不自定义计时器类使用auto关键字无警告。

```cpp
#include <iostream>
#include <chrono>
#include <thread>

int main() {
    //literals：文字
    using namespace std::literals::chrono_literals;	//有了这个，才能用下面1s中的's'
    auto start = std::chrono::high_resolution_clock::now();	//记录当前时间
    std::this_thread::sleep_for(1s);	//休眠1s，实际会比1s大。函数本身有开销。
    auto end = std::chrono::high_resolution_clock::now();	//记录当前时间
    std::chrono::duration<float> duration = end - start;	//也可以写成 auto duration = end - start; 
   	std::cout << duration.count() << "s" << std::endl;
    return 0;
}
```

在自定义计时器类内使用auto关键字出现警告：

```cpp
struct Timer
{
    std::chrono::time_point<std::chrono::steady_clock> start; //定义局部变量，否则析构函数中出现未定义的start。
    // std::chrono::duration<float> duration;

    Timer()
    {
       auto start = std::chrono::steady_clock::now();
    }

    ~Timer()
    {
        auto end = std::chrono::steady_clock::now();
        auto duration = end - start;

        float ms = duration.count() * 1000;
        std::cout << "Timer took " << ms << " ms" << std::endl;
    }
};
```

警告内容：

```cpp
warning: variable ‘start’ set but not used [-Wunused-but-set-variable]
   12 |         auto start = std::chrono::steady_clock::now();
```

将构造函数中的auto删去，则警告消失：

```cpp
    Timer()
    {
        start = std::chrono::steady_clock::now(); //ok
    }
```

结合警告提示：**variable ‘start’ set but not used**   变量定义了却没有使用。

改构造函数中变量start的名字，析构函数中也不报错。

**可以推测，构造函数中用auto定义的变量start没有使用！**

**原因**：



推荐书写：

```cpp
struct Timer   //写一个计时器类。
{
    std::chrono::time_point<std::chrono::steady_clock> start, end;
    std::chrono::duration<float> duration;

    Timer()
    {
        start = std::chrono::steady_clock::now();
    }

    ~Timer()
    {
        end = std::chrono::steady_clock::now();
        duration = end - start;

        float ms = duration.count() * 1000;
        std::cout << "Timer took " << ms << " ms" << std::endl;
    }
};
```

