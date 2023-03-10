## git 使用指南

#### 一、创建本地仓库

> 首先在自己的Ubuntu上创建一个目录，具体建立在哪里随意。这里我在家目录下创建一个gittest目录,这个目录就是我们用来建立本地仓库的目录。

```c++
cd ~
mkdir local_repository
```



#### 二、本地仓库初始化

```cpp
cd local_repository
git init
```

 

#### 三、配置账户

```C++
 git config --global user.name "你的GitHub用户名"
 git config --global user.email "你的GitHub邮箱"
  
 
  git config  --list //此时 回车就会显示你的注册名字和注册邮箱
     
```

检查SSH

```cpp
ssh -T git@github.com
```

如果出现下列语句，则说明可以连接。

```
Permission denied (publickey).
```



#### 四、建立远程仓库

- 远程库就是你在github上便建立的属于自己的仓库，在创建远程仓库之前要先注册一个github账号。
- 目前我们已经有了自己的本地库，需要在github上建立一个远程仓库来进行本地库和远程库的交互。
- 远程仓库的HTTPS地址和SSH地址，这就是本地库和远程库进行通信的链接，虽然git可以通过这两种方式都可以访问远程库，但是HTTPS方式在每次链接是都需要进行填写密码，而SSH方式则只需要创建一个公匙，以后就可以免密码访问了。

```
 ssh-keygen -t rsa -C "你的GitHub邮箱"
```

- 执行之后会在用户目录~/.ssh/下建立相应的密钥文件。进入.ssh目录下，打开id_rsa.pub文件复制其内容。

```
cd ~/.ssh
gedit id_rsa.pub
```

- 进入github账户，选择设置，再选择添加公匙，将刚刚复制的内容进行粘贴即可。添加完成之后就可以进行随意的从本地库往远程库传递东西，或者从github上现在自己想要的开源项目了。



#### 五、从本地库向远程库发送文件

- 先将自己的文件放置自己创建的本地仓库目录中，然后

```C++
git add ./ (或者git add *)   //将文件添加到暂存区
git commit -m "文件" #//将暂存区的文件添加到本地库中
git remote add origin git@github.com:xxx/Notes.git(地址链接)  
//由于远程库地址教长我们将其用一个变量origin替代
git push origin master # 将文件从本地库推送到远程库
```



## TIPS:

一、关于git提交代码到main

如果github的仓库地址，是推送到了master分支，需要合并到main分支

1. `git fetch origin`
2. `git checkout main`
3. `git merge master --allow-unrelated-histories`（合并分支解决冲突）
4. `git add *`
5. `git commit -m '合并分支'`
6. `git push`

