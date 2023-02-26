#### CMakelists.txt的编写

> 方式一
>
> ```cmake
> cmake_minimum_required(VERSION 3.0)
> 
> project(SOLIDERFIRE)
> 
> set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall")
> 
> set(CMAKE_BUILD_TYPE Debug)
> 
> //设置为c++17标准
> set(CMAKE_CXX_STANDARD 17)
> set(CMAKE_CXX_STANDARD_REQUIRED ON)
> add_definitions(-D_GLIBCXX_USE_C99=1)
> 
> include_directories(${CMAKE_SOURCE_DIR}/include)
> 
> add_executable(my_cmake_exe main.cpp src/Gun.cpp src/Solider.cpp)
> ```
>
> 方式二
>
> ```cmake
> cmake_minimum_required (VERSION 3.5)
> 
> project (HelloWorld)
> 
> set (CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -Werror -std=c++14")
> //设置变量，指向当前目录中src文件夹下的文件（设置源代码路径）
> set (source_dir "${PROJECT_SOURCE_DIR}/src/")
> //设置需要编译的源文件
> file (GLOB source_files "${source_dir}/*.cpp")
> //设置编译的输出目标文件
> add_executable (HelloWorld ${source_files})
> ```



#### launch.json 与 tasks.json

> **launch.json** 
>
> ```json
> {
>     // 使用 IntelliSense 了解相关属性。 
>     // 悬停以查看现有属性的描述。
>     // 欲了解更多信息，请访问: https://go.microsoft.com/fwlink/?linkid=830387
>     "version": "0.2.0",
>     "configurations": [
>         {
>             "name": "(gdb) 启动",
>             "type": "cppdbg",
>             "request": "launch",
>             "program": "${workspaceFolder}/build/HelloWorld",
>             "args": [],
>             "stopAtEntry": false,
>             "cwd": "${workspaceFolder}",
>             "environment": [],
>             "externalConsole": false,
>             "MIMode": "gdb",
>             "setupCommands": [
>                 {
>                     "description": "为 gdb 启用整齐打印",
>                     "text": "-enable-pretty-printing",
>                     "ignoreFailures": true
>                 },
>                 // {
>                 //     "description":  "将反汇编风格设置为 Intel",
>                 //     "text": "-gdb-set disassembly-flavor intel",
>                 //     "ignoreFailures": true
>                 // }
>             ],
>         /*    "sourceFileMap": 
>             {
>                 "/build/glibc-SzIz7B": "/usr/src/glibc"
>             },
>         */
>             "preLaunchTask": "Build",
>             "miDebuggerPath": "/usr/bin/gdb"
>         }
> 
>     ]
> }
> ```
>
> **tasks.json**
>
> ```json
> {   
>  "version": "2.0.0",
>  "options": {
>      "cwd": "${workspaceFolder}/build"
>  },
>  "tasks": [
>      {
>          "type": "shell",
>          "label": "cmake",
>          "command": "cmake",
>          "args": [
>              ".."
>          ]
>      },
>      {
>          "label": "make",
>          "group": {
>              "kind": "build",
>              "isDefault": true
>          },
>          "command": "make",
>          "args": [
> 
>          ]
>      },
>      {
>          "label": "Build",
> 			"dependsOrder": "sequence", // 按列出的顺序执行任务依赖项
>          "dependsOn":[
>              "cmake",
>              "make"
>          ]
>      }
>  ]
> 
> }
> ```
>
> 



#### Linux下Vscode调试出现无法打开“libc-start.c“：无法读取文件解决方法

> 解决方法
>
> ```
> sudo apt install glibc-source
> cd /usr/src/glibc/
> sudo tar -xvf glibc-[VERSION].tar.xz
> ```
>
>  这里的[VERSION]为 版本号，比如现在是2.31
> 然后在launch.json中还需要加一行代码 
>
> ```json
> "sourceFileMap": {
>       "/build/glibc-xxxxx": "/usr/src/glibc"
> }
> ```
>
>  注意修改 `xxxxx` 为报错提示中出现的glibc文件名。 



#### Linux系统下C++静态库/动态库的使用（基于VScode)

- **以 GLFW 库为例**

  -  **源码安装GLFW 3.3.1** 

    ```cpp
    git clone https://ghproxy.com/https://github.com/glfw/glfw
    cd glfw
    mkdir build && cd build
    cmake ..
    make -j4
    sudo make install
    ```

  -  **直接命令二进制安装** 

    ```cpp
    sudo apt-get install libglfw3-dev
    ```

  - 在vscode中创建的源文件main.cpp中添加头文件

    ```cpp
    #include <GLFW/glfw3.h>
    ```

  - 在CMakeLists中添加链接库

    ```cmake
    target_link_libraries(${PROJECT_NAME}
        -lglfw
        )
    ```

  - 编译运行

    ```cpp
    #include <iostream>
    #include <GLFW/glfw3.h>
    
    int main(){
        int a = glfwInit();  //GLFW头文件中的一个函数
        std::cout << "a = " << a << std::endl;
    }
    ```

    成功输出：a = 1
    
  -   ldd命令查看可执行文件依赖的动态链接库 
  
     ```cpp
     ldd HelloWorld 
     输出：
     linux-vdso.so.1 (0x00007ffd7974a000)
     	libglfw.so.3 => /lib/x86_64-linux-gnu/libglfw.so.3 (0x00007fe75ac10000)
     	libstdc++.so.6 => /lib/x86_64-linux-gnu/libstdc++.so.6 (0x00007fe75aa2e000)
     	libc.so.6 => /lib/x86_64-linux-gnu/libc.so.6 (0x00007fe75a83c000)
     	libm.so.6 => /lib/x86_64-linux-gnu/libm.so.6 (0x00007fe75a6ed000)
     	libdl.so.2 => /lib/x86_64-linux-gnu/libdl.so.2 (0x00007fe75a6e7000)
     	libX11.so.6 => /lib/x86_64-linux-gnu/libX11.so.6 (0x00007fe75a5aa000)
     	libpthread.so.0 => /lib/x86_64-linux-gnu/libpthread.so.0 (0x00007fe75a585000)
     	/lib64/ld-linux-x86-64.so.2 (0x00007fe75acbe000)
     	libgcc_s.so.1 => /lib/x86_64-linux-gnu/libgcc_s.so.1 (0x00007fe75a56a000)
     	libxcb.so.1 => /lib/x86_64-linux-gnu/libxcb.so.1 (0x00007fe75a540000)
     	libXau.so.6 => /lib/x86_64-linux-gnu/libXau.so.6 (0x00007fe75a53a000)
     	libXdmcp.so.6 => /lib/x86_64-linux-gnu/libXdmcp.so.6 (0x00007fe75a532000)
     	libbsd.so.0 => /lib/x86_64-linux-gnu/libbsd.so.0 (0x00007fe75a516000)
     ```
  
     

- **存在的问题：**

  并没有配置相关的json文件就运行了，感觉缺少了点什么，有待后续进行学习。

- 、参考链接：

  **Ubuntu下vscode配置OpenGL(使用glfw+glad)**:http://t.csdn.cn/XFp9Q

  **Ubuntu系统下使用VS Code编译调试C++程序并添加外部库：**http://t.csdn.cn/cCFH2

  **Ubuntu下搭建OpenGL开发环境（GLFW_3.3.1 + GLM_0.9.9 + GLAD）**:http://t.csdn.cn/Y4hEZ

  

