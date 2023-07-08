[TOC]

## 一、Jetson Agx Orin 刷机

Jetson Agx Orin 刷机

1.刷机软件sdkmanager下载:[https://developer.nvidia.com/drive/sdk-manager](https://link.zhihu.com/?target=https%3A//developer.nvidia.com/drive/sdk-manager) 需要注册账号。

2.orin进入recover模式

> Orin进入Recovery模式分两种状况，一是当Orin处于未开机状态，二是当Orin处于开机状态。
> 当处于**未开机状态**时，需要先长按住②键(Force Recovery键)，然后给Orin接上电源线通电，此时白色指示灯亮起，但进入Recovery模式后是黑屏的，所以此时连接Orin的显示屏不会有什么反应。
> 当处于**已开机状态**时，需要先长按住②键，然后按下③键(Reset键)，先松开③键，再松开②键。
> 参考：[NVIDIA Jetson AGX Orin开发套件刷机说明&镜像制作](https://link.zhihu.com/?target=https%3A//blog.csdn.net/m0_54792870/article/details/129426560)

![img](https://pic1.zhimg.com/80/v2-90e7cfe312651022af6c468e1e85aaec_720w.webp)

3.ubuntu pc终端输入sdkmanager 注册/登陆帐号，选择jetson型号（一定要选准自己的设备型号）

![img](https://pic4.zhimg.com/80/v2-c51fb3e7d00c489090367763a9d0a87b_720w.webp)

点击conitinue

勾选accept 然后conitinue

![img](https://pic2.zhimg.com/80/v2-c165cbb81ccbeecb1d123bc4884d48c5_720w.webp)



输入ubuntu pc密码

![img](https://pic1.zhimg.com/80/v2-369ccaae65681995cd843afaf9875f04_720w.webp)

选择**手动模式**，创建orin的用户名和密码

![img](https://pic2.zhimg.com/80/v2-9a7930482bcf5bfdbbde6de7789b263d_720w.webp)

等待安装完成，之后orin会开机，用户名和密码就是上一步创建的那一个

这时候ubuntu pc端不要动，orin连接网络，要与ubuntu pc在同一局域网下，这里建议使用手机热点。

wifi连接好之后，在ubuntu pc终端ping 192.168.55.1，确保ping通

![img](https://pic4.zhimg.com/80/v2-b452202acf3038205ea942d8ab98f67f_720w.webp)

等待cuda等组件安装完成

![img](https://pic2.zhimg.com/80/v2-fccbf8635c291d6ebee901cdb0a36459_720w.webp)

## 二、系统时间校准

终端输入命令：

```text
sudo apt install ntp
sudo ntpdate -u cn.pool.ntp.org
```

## 三、ubuntu系统挂载新硬盘及硬盘格式化

参考链接：[ubuntu添加新硬盘进行分区，并挂载到/home - sdlyxyf - 博客园](https://link.zhihu.com/?target=https%3A//www.cnblogs.com/sdlyxyf/p/15108302.html)

[Ubuntu挂载新的硬盘到/home下_ubuntu挂载硬盘到home目录_绿竹巷人的博客-CSDN博客](https://link.zhihu.com/?target=https%3A//blog.csdn.net/weixin_42156097/article/details/127359384)

### **（一）ubuntu添加新硬盘，进行分区，并挂载到/home目录。**

**1、查看已有的磁盘，可以看到**nvme0n1**还没有分区。**

```text
sudo fdisk -l 
```

可以看到各个硬盘的设备名，一般以sda、sdb、sdc命名，下面以/dev/nvme0n1为例，

**2、进入**nvme0n1**进行分区**

```text
sudo fdisk /dev/nvme0n1
```

输入m可以看到帮助信息。

我们依次这样做来创建分区：

1. 输入n新建分区；
2. 输入p，选择这个硬盘为主分区
3. 输入1，代表第一个分区号
4. 接下来输入2048（起始扇区位），代表这个分区的起始扇区位
5. 接下来输入提示的最大数，，代表这个分区的终止字节位就是磁盘的最大扇区位。
6. 完成以上步骤，实际上就是将2TB硬盘，分为了一个区。根据你的需要，你可以自定义进行你想要的调整
7. 最后输入w，保存以上的设置

可以再次执行 sudo fdisk -l 查看是否创建。

可以看到提示信息

```text
Disk /dev/nvme0n1：1.84 TiB，2000398934016 字节，3907029168 个扇区
Disk model: ST2000DM008-2UB1
单元：扇区 / 1 * 512 = 512 字节
扇区大小(逻辑/物理)：512 字节 / 4096 字节
I/O 大小(最小/最佳)：4096 字节 / 4096 字节
磁盘标签类型：dos
磁盘标识符：0x58a6a8ef

设备       启动  起点       末尾       扇区  大小 Id 类型
/dev/nvme0n1        2048 3907029167 3907027120  1.8T 83 Linux
```

**3、将新分区格式化为ext4**

```text
sudo mkfs -t ext4 /dev/nvme0n1
```

提示：

```text
mke2fs 1.45.5 (07-Jan-2020)
丢弃设备块： 完成                            
创建含有 488378390 个块（每块 4k）和 122101760 个inode的文件系统
文件系统UUID：7fbad918-d674-477f-a117-5e43120f9b74
超级块的备份存储于下列块： 
	32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632, 2654208, 
	4096000, 7962624, 11239424, 20480000, 23887872, 71663616, 78675968, 
	102400000, 214990848

正在分配组表： 完成                            
正在写入inode表： 完成                            
创建日志（262144 个块） 完成
写入超级块和文件系统账户统计信息： 已完成
```

**4、 创建临时目录，用来临时挂载新分区**

```text
sudo mkdir /mnt/newpart
```

**5、将新分区挂载到新文件夹**

```text
sudo mount /dev/nvme0n1 /mnt/newpart
```

至此，可以对/mnt/newpart目录进行读写操作。

**6、将/home目录下的文件拷贝到新分区**

```text
cd /home
sudo cp -ax * /mnt/newpart
```

拷贝时间也许较长，耐心等待。

**7、重命名原/home目录，并新建一个新的空/home目录，并将新分区挂载过来**

```text
cd /
sudo mv /home /home.old
sudo mkdir /home
sudo mount /dev/nvme0n1 /home
```

**8、查看uuid，找到新分区id**

```text
sudo blkid
```

**9、找到新分区的uuid，加入/etc/fstab**

```text
sudo vim /etc/fstab
加入UUID=20984cef-05e4-44c1-bc12-758fc1ecd2e3 /home ext4 defaults 0 2
```

**10、最后修改权限问题**

进入新挂载的/home 查看是否都是对应文件夹对应用户的权限，进行相应的更改。

```text
sudo chown user:user /user
```

至此，就把新硬盘的存储空间加到/home目录中。

### （二）格式化硬盘分区

下载磁盘分区工具

```text
sudo apt-get install gparted
```

运行

```text
sudo gparted
```

选择你要格式化的硬盘，可以对他进行分区、格式化、删除等操作。



## 四、配置ROS环境及VsCode安装

鱼香ROS：[小鱼的一键安装系列](https://link.zhihu.com/?target=https%3A//fishros.org.cn/forum/topic/20/%E5%B0%8F%E9%B1%BC%E7%9A%84%E4%B8%80%E9%94%AE%E5%AE%89%E8%A3%85%E7%B3%BB%E5%88%97%3Flang%3Dzh-CN)

```text
wget http://fishros.com/install -O fishros && . fishros
```

目前支持工具

- 一键安装:ROS(支持ROS和ROS2,树莓派Jetson)
- 一键安装:VsCode(支持amd64和arm64)
- 一键安装:github桌面版(小鱼常用的github客户端)
- 一键安装:nodejs开发环境(通过nodejs可以预览小鱼官网噢
- 一键配置:rosdep(小鱼的rosdepc,又快又好用)
- 一键配置:ROS环境(快速更新ROS环境设置,自动生成环境选择)
- 一键配置:系统源(更换系统源,支持全版本Ubuntu系统)
- 一键安装:Docker(支持amd64和arm64)
- 一键安装:cartographer
- 一键安装:微信客户端

## 五、在jetson上安装chromium

```text
sudo apt-get install chromium-browser -y
```

## 六、在jetson上安装qq

在[QQ Linux版-新不止步·乐不设限](https://link.zhihu.com/?target=https%3A//im.qq.com/linuxqq/index.shtml)中选择版本（arm64）

```text
sudo dpkg -i xxx.deb
```

## 七、安装jtop

```text
sudo apt-get update
sudo apt-get install python-pip
sudo apt-get install python3-pip
sudo pip3 install jetson-stats
sudo jtop   # 启动jtop
```

## 八、安装Anaconda、cuda、cudnn、pytorch、Tensorrt

参考：[Jetson AGX Orin安装Anaconda、Cuda、Cudnn、Pytorch、Tensorrt最全教程](https://link.zhihu.com/?target=https%3A//blog.csdn.net/weixin_43702653/article/details/129249585)

[[orin\] nvidia orin 上安装 pytorch 和 torchvision 实操](https://link.zhihu.com/?target=https%3A//blog.csdn.net/condom10010/article/details/128139401)

### （一）Anaconda安装

1、寻找[aarch64](https://link.zhihu.com/?target=https%3A//so.csdn.net/so/search%3Fq%3Daarch64%26spm%3D1001.2101.3001.7020)的shell安装包，下载地址[anaconda清华镜像源](https://link.zhihu.com/?target=https%3A//repo.anaconda.com/archive/)，我选择的是`Anaconda3-2021.11-Linux-aarch64.sh`。

2、进入到下载文件夹，按如下命令依次安装即可：

```text
chmod +x Anaconda3-2021.11-Linux-aarch64.sh 

./Anaconda3-2021.11-Linux-aarch64.sh
```

3、验证，输入如下代码查看anaconda版本号：

```text
conda init
conda --version
```

4、若还是显示找不到conda指令，尝试下方代码：

```text
# 将anaconda的bin目录加入PATH，根据版本不同，也可能是~/anaconda3/bin
echo 'export PATH="~/anaconda3/bin:$PATH"' >> ~/.bashrc
# 更新bashrc以立即生效
source ~/.bashrc
```

5、进行初始化

```text
conda init
```

### （二）CUDA、Cudnn安装及环境变量配置

一般来说，刷机后**Jetpack默认直接装上与jetson版本号适配的cuda、cudnn、TensorRT**

输入命令查看：

```text
sudo jetson_release
```

![img](https://pic3.zhimg.com/80/v2-e21f6f0ffb50a8fffad3453b5bdfb7fa_720w.webp)

运行`nvcc -V`查看版本号:

![img](https://pic1.zhimg.com/80/v2-2aee72bd15e0bf9a73d3b1589cefe07c_720w.webp)

注：**还没有结束，虽然安装了cuDNN，但没有将对应的头文件、库文件放到cuda目录。**

cuDNN的头文件在：/usr/include，库文件位于：/usr/lib/aarch64-linux-gnu。将头文件与库文件复制到cuda目录下：（这里我与amd64上的cudnn头文件进行了对比，发现amd64下的头文件都是源文件，而arm64下的头文件都是软链接，当我将软链接头文件复制到cuda头文件目录下，变为了源文件。。。之所以说这些，就是为了证明这里的操作和amd64的一样，不用担心）

> 参考：[Jetson AGX Orin安装Anaconda、Cuda、Cudnn、Pytorch、Tensorrt最全教程](https://link.zhihu.com/?target=https%3A//blog.csdn.net/weixin_43702653/article/details/129249585)

操作如下：

```text
#复制文件到cuda目录下
cd /usr/include && sudo cp cudnn* /usr/local/cuda/include
cd /usr/lib/aarch64-linux-gnu && sudo cp libcudnn* /usr/local/cuda/lib64

#修改文件权限，修改复制完的头文件与库文件的权限，所有用户都可读，可写，可执行：
sudo chmod 777 /usr/local/cuda/include/cudnn.h 
sudo chmod 777 /usr/local/cuda/lib64/libcudnn*

#重新软链接，这里的8.4.1和8对应安装的cudnn版本号和首数字
cd /usr/local/cuda/lib64

sudo ln -sf libcudnn.so.8.4.1 libcudnn.so.8

sudo ln -sf libcudnn_ops_train.so.8.4.1 libcudnn_ops_train.so.8
sudo ln -sf libcudnn_ops_infer.so.8.4.1 libcudnn_ops_infer.so.8

sudo ln -sf libcudnn_adv_train.so.8.4.1 libcudnn_adv_train.so.8
sudo ln -sf libcudnn_adv_infer.so.8.4.1 libcudnn_adv_infer.so.8

sudo ln -sf libcudnn_cnn_train.so.8.4.1 libcudnn_cnn_train.so.8
sudo ln -sf libcudnn_cnn_infer.so.8.4.1 libcudnn_cnn_infer.so.8

sudo ldconfig
```

测试Cudnn：

```text
sudo cp -r /usr/src/cudnn_samples_v8/ ~/
cd ~/cudnn_samples_v8/mnistCUDNN
sudo chmod 777 ~/cudnn_samples_v8
sudo make clean && sudo make
./mnistCUDNN
```

可能会报错

```text
test.c:1:10: fatal error: FreeImage.h: 没有那个文件或目录
#include “FreeImage.h”
^~~~~~~~~~~~~
compilation terminated.
```

输入如下代码：

```text
sudo apt-get install libfreeimage3 libfreeimage-dev
```

**如果配置成功 测试完成后会显示：“Test passed!”。**

![img](https://pic3.zhimg.com/80/v2-e711ed2d7bc3c9a532266d44086b5196_720w.webp)

### （三）pytorch及**torchvision**安装

1、首先新建一个文件夹，把下载好的pytorch及torchvision放进该文件夹

2、根据jetpack版本选择pytorch版本，官方下载地址：[PyTorch for Jetson](https://link.zhihu.com/?target=https%3A//forums.developer.nvidia.com/t/pytorch-for-jetson/72048)

![img](https://pic3.zhimg.com/80/v2-03db6bcaf2509f32d6cc416c5561395a_720w.webp)

我的jetpack是5.1.1，所以我下载的是[torch-1.12.0a0+2c916ef.nv22.3-cp38-cp38-linux_aarch64.whl](https://link.zhihu.com/?target=https%3A//developer.download.nvidia.com/compute/redist/jp/v50/pytorch/torch-1.12.0a0%2B2c916ef.nv22.3-cp38-cp38-linux_aarch64.whl)

查看jetpack版本：sudo jtop

![img](https://pic2.zhimg.com/80/v2-1408d98fa2f339b55c89a6aa206f29e9_720w.webp)

3、安装依赖

```text
sudo apt-get -y update; 
sudo apt-get -y install autoconf bc build-essential g++-8 gcc-8 clang-8 lld-8 gettext-base gfortran-8 iputils-ping libbz2-dev libc++-dev libcgal-dev libffi-dev libfreetype6-dev libhdf5-dev libjpeg-dev liblzma-dev libncurses5-dev libncursesw5-dev libpng-dev libreadline-dev libssl-dev libsqlite3-dev libxml2-dev libxslt-dev locales moreutils openssl python-openssl rsync scons python3-pip libopenblas-dev
sudo apt-get install  libopenblas-base libopenmpi-dev libomp-dev
```

4、下载**torchvision**

```text
sudo apt-get update
sudo apt-get upgrade
sudo apt-get install libjpeg-dev zlib1g-dev libpython3-dev libavcodec-dev libavformat-dev libswscale-dev 

git clone --branch <version> https://github.com/pytorch/vision torchvision #<version>看下表选择，我的是v0.13.0
cd torchvision
```

5、创建conda环境

```text
conda create -n py38 -y
```

6、安装Pytorch

```text
# 先进入虚拟环境
conda activate py38
# 安装pip依赖
pip install Cython numpy
# 安装Pytorch
pip install torch-1.12.0a0+2c916ef.nv22.3-cp38-cp38-linux_aarch64.whl
```

7、安装torchvision

```text
cd torchvision
export BUILD_VERSION=0.x.0  # where 0.x.0 is the torchvision version  
python3 setup.py install --user
```

这里0.x.0我的是0.13.0，版号可查看下图：

![img](https://pic2.zhimg.com/80/v2-7227453b0be57c5a7d356824e0e744f5_720w.webp)

8、验证

![img](https://pic2.zhimg.com/80/v2-5ff26ff2f2d660dd72e93d8da4381b7d_720w.webp)

### （四）Tensorrt安装

Jetpack已经给我们自动安装好了，但是安装位置在`/usr/lib/python3.8/dist-packages/`中，不能被虚拟环境中定位使用。因此我们需要软链接一下，运行如下命令：

```text
sudo ln -s /usr/lib/python3.8/dist-packages/tensorrt* /home/nvidia/anaconda3/envs/orin/lib/python3.8/site-packages/
```

测试一下，运行如下指令：

```text
python -c "import tensorrt;print(tensorrt.__version__)"
```

若出现版本号，则成功：

![img](https://pic1.zhimg.com/80/v2-5d2f5dc0ee93c4a56191eefb894dc674_720w.webp)

## 九、realsense SDK、realsense-ros、pyrealsense2安装

### （一）SDK 源碼安裝

```text
git clone https://github.com/IntelRealSense/librealsense.git
cd librealsense/
sudo apt install libudev-dev pkg-config libgtk-2-dev
sudo apt install libudev-dev pkg-config libgtk-3-dev
sudo apt install libusb-1.0-0-dev pkg-config
sudo apt install libglfw3-dev
sudo apt install libssl-dev
sudo apt-get install libglfw3-dev libgl1-mesa-dev libglu1-mesa
sudo apt install cmake
sudo cp config/99-realsense-libusb.rules /etc/udev/rules.d/.
sudo udevadm control --reload-rules && udevadm trigger
mkdir build
cd build/
cmake ../ -DBUILD_EXAMPLES=true
make
sudo make install
cd tools/realsense-viewer
./realsense-viewer  #直接終端輸入realsense-viewer也可以
```

如果出現：

![img](https://pic4.zhimg.com/80/v2-ba6ec65389a47d1cf91721069fd73de3_720w.webp)

則說明sdk成功安裝。

### （二）realsense-ros安裝

```text
sudo apt-get install ros-$ROS_DISTRO-realsense2-camera
sudo apt-get install ros-noetic-rgbd-launch
```

測試：

```text
source ~/.bashrc
roslaunch realsense2_camera rs_camera.launch #测试
```

打開rviz：

![img](https://pic3.zhimg.com/80/v2-2f6af816bee2880e53668d9b8c6c8fca_720w.webp)

add話題，正常。

### （三）脚本安装pyrealsense2以及RealSense SDK

> 原文连接：[https://github.com/35selim/RealSense-Jetson.git](https://link.zhihu.com/?target=https%3A//github.com/35selim/RealSense-Jetson.git)

**为 Jetson 模块安装和构建 RealSense 库。**

使用此存储库，可以将 librealsense 安装到 Jetson 模块并使用 RealSense 摄像头。我使用了“从源代码构建”选项并且不使用[此处](https://link.zhihu.com/?target=https%3A//github.com/IntelRealSense/librealsense/blob/master/doc/installation_jetson.md)描述的 RSUSB 实现，因为无法正确运行它并且无法安装 pyrealsense2。

**用法**

按照[用户指南](https://link.zhihu.com/?target=https%3A//developer.nvidia.com/embedded/learn/getting-started-jetson)安装相关镜像文件并将其写入SD卡后，将其插入Jetson模块并完成初始设置。

首次启动后，打开终端并将此存储库克隆到您的系统：

- `git clone https://github.com/35selim/RealSense-Jetson.git`
- `cd RealSense-Jetson`

现在，只需按以下顺序运行脚本：

1. 如果你**只想安装 RealSense SDK**

- `sh initialize_Jetson.sh`
- 重新启动后，再次打开终端并运行`cd RealSense-Jetson`
- 最后，运行`sh install_SDK_without_pyrealsense2.sh`

\2. 如果你**想构建 python 绑定以使用 pyrealsense2**

- `sh initialize_Jetson.sh`
- 重新启动后，再次打开终端并运行`cd RealSense-Jetson`
- 最后，运行`sh build_pyrealsense2_and_SDK.sh`

**注意：** “initialize_Jetson.sh”脚本将清除一些不必要的东西，升级系统并安装交换文件以进行比 Jetson 模块需要更多内存的进一步操作。最后，它会重新启动系统以确保更改生效。每当命令提示需要时，输入您的密码。

**注意：**由“sh build_pyrealsense2_and_SDK.sh”完成的第二个操作是从源构建。这意味着该操作将需要很长时间。

您可以根据需要配置脚本。请注意，pyrealsense2 将使用 CUDA 构建。

> **警告：**脚本仅在 Jetson Nano 模块上进行测试。更多信息将作为在其他模块上测试的脚本提供。

### （四）源码安装pyrealsense2

> [https://github.com/IntelRealSense/librealsense/issues/6964](https://link.zhihu.com/?target=https%3A//github.com/IntelRealSense/librealsense/issues/6964)

为了将要来参考，这里是我使用IntelRealsense Camara D455 在Jetson Nano 上使用python3 并获取的完整步骤列表。

1. 使用[此方法](https://link.zhihu.com/?target=https%3A//github.com/IntelRealSense/librealsense/issues/6980%23issuecomment-666858977)
   更新 CMake（您需要[安装](https://link.zhihu.com/?target=https%3A//stackoverflow.com/questions/56941778/cmake-use-system-curl-is-on-but-a-curl-is-not-found)curl 才能工作。）
2. [从https://github.com/IntelRealSense/librealsense/releases/](https://link.zhihu.com/?target=https%3A//github.com/IntelRealSense/librealsense/releases/)下载zip文件。我使用的是2.38.1版本
3. 解压文件，cd进入解压后的文件。
4. 创建一个名为 build 和 cd 的目录。
5. 运行CMake命令来测试结构是否有效。

```text
cmake ../ -DFORCE_RSUSB_BACKEND=ON -DBUILD_PYTHON_BINDINGS:bool=true -DPYTHON_EXECUTABLE=/usr/bin/python3.8 -DCMAKE_BUILD_TYPE=release -DBUILD_EXAMPLES=true -DBUILD_GRAPHICAL_EXAMPLES=true -DBUILD_WITH_CUDA:bool=true
```

如果您对上面描述的步骤有疑问，请查看[这个](https://link.zhihu.com/?target=https%3A//github.com/jetsonhacks/buildLibrealsense2TX/issues/13)、[这个](https://link.zhihu.com/?target=https%3A//github.com/IntelRealSense/librealsense/issues/6449%23issuecomment-650793097)和[这个](https://link.zhihu.com/?target=https%3A//askubuntu.com/questions/620601/cant-install-libsdl2-dev-or-cmake-glfw-libxinerama-dev-problem)

6.仍在构建目录中。运行` make -j4`然后`sudo make install`。
7.将这些添加到 .bashrc 文件的末尾

export PATH=$PATH:~/.local/bin export PYTHONPATH=$PYTHONPATH:/usr/local/lib export PYTHONPATH=$PYTHONPATH:/usr/local/lib/python3.6/pyrealsense2

1. 获取您的.bashrc文件
2. [使用这种方法](https://link.zhihu.com/?target=https%3A//github.com/IntelRealSense/meta-intel-realsense/issues/20%23issuecomment-687180484)处理python2和python3之间的包重组

您现在应该可以` pyrealsense2`使用python3导入

### （五)jetson上安装pyrealsense2终极解决方案

如果上述方法无法成功配置pyrealsense2，清进行如下操作：

1、进入 ～/librealsense-2.53.1/build/wrappers/python/

2、复制下列文件到你的项目程序目录中：

```text
pybackend2.cpython-38-aarch64-linux-gnu.so
pybackend2.cpython-38-aarch64-linux-gnu.so.2
pybackend2.cpython-38-aarch64-linux-gnu.so.2.53.1
pyrealsense2.cpython-38-aarch64-linux-gnu.so
pyrealsense2.cpython-38-aarch64-linux-gnu.so.2.53
pyrealsense2.cpython-38-aarch64-linux-gnu.so.2.53.1
```

3、测试

![img](https://pic2.zhimg.com/80/v2-bfd672837fb32b105c04feda5474840d_720w.webp)

导pyrealsense2包成功

这算是一个 下策吧，看了很多教程，尝试了很多方法，依旧无法把pyrealsense2成功配置到jetson agx orin上，最终只能将.so文件复制到项目文件中。

## 十、jetson中，安装所需的包

jetson agx orin 是arm64的，一般的安装命令可能不会编译通过，所以我在这里记录本人安装arm64所需的包的命令。

### （一）imagecodecs安装

```text
遇见报错：
ValueError: <COMPRESSION.LZW: 5> requires the 'imagecodecs' package
amd x86下可以：
pip3 install imagecodecs-lite
```

但在arm64，pip3 install imagecodecs-lite会报错：

```text
      imagecodecs/_blosc.c:756:10: fatal error: blosc.h: 没有那个文件或目录
        756 | #include "blosc.h"
            |          ^~~~~~~~~
      compilation terminated.
      error: command '/usr/bin/gcc' failed with exit code 1
      [end of output]
  
  note: This error originates from a subprocess, and is likely not a problem with pip.
  ERROR: Failed building wheel for imagecodecs
```

正确安装：

```text
conda install -c conda-forge imagecodecs
```



### （二）安装aruco_ros包

```text
cd ~/catkin_ws/src
git clone https://github.com/pal-robotics/aruco_ros.git 
cd ..
catkin_make
```

如果报错：

![img](https://pic3.zhimg.com/80/v2-3a24d31f76673874ad8a2f611909aebe_720w.webp)

使用：

```text
catkin_make -DPYTHON_EXECUTABLE=/usr/bin/python3
```

十一、推荐网站

[NVIDIA Jetson AGX Orin 开发环境配置 – Miraclefish](https://link.zhihu.com/?target=https%3A//orangafish.cn/archives/agxorinconfig)

[https://github.com/yqlbu/jetson](https://link.zhihu.com/?target=https%3A//github.com/yqlbu/jetson-packages-family)