---
layout: post
title: 用 Emacs 编辑 markdown
category: 工具技巧
tags: 
- emacs
- markdown
status: publish
type: post
published: true
toc: true
---
后面不用读了：VS code 真香！

陆陆续续尝试使用 Emacs 已经该有7、8回了，每次都受不了它繁琐的 Ctrl 和 Meta 组合键，但最近不知道哪根筋出了问题，不但编辑器迅速的切换到了Emacs，甚至操作系统也从Win 7平滑到了Ubuntu。以下记录一些关于Emacs、markdown、Ubuntu、ssh乱七八糟的东东。

开源体系下，我的软件之路差不多是下面这样的：

> R->LaTeX->imagemagic->Emacs->Ubuntu->github(git,svn)->markdown->pandoc->putty

当走到 putty 这一步，基本上也能称之为半个合格的码农了，囧。

Emacs 是非常好用的文本编辑器，是著名黑客 stallman 的作品，同vi并称为 linux 体系同两大神器。用它来编辑任意文本有大量的定制扩展，试用起来非常方便，而最近老板也在推行用 markdown 来记录技术文档，并且在内网构建了基于 markdown 的 git wiki 系统。刚好自己也一直在用md，比如现在的这个搭建在 github 上的静态页面博客。

<!-- more -->

# 1. Emacs 的安装

在 ubuntu 下安装 Emacs 非常简单，甚至可以一起装好ess：

```
sudo apt-get install emacs ess
```

在 Emacs 里运行R还是很爽的事情。

## 1.1. Emacs 的设置文档

主要支持语法高亮，以及一些人性化的配置，不多说直接贴 .emacs [文件](/upload/emacs)（改名为`.emacs`，在/home/user目录，可能需要Ctrl+h显示隐藏文件）

这里面有个 emacs 的颜色主题，用于代码高亮，需要下载 color-theme.el，请自行搜索之，并拷贝至emacs可以找到的目录下。如果不许要注释掉相关行即可。

## 1.2. 安装markdown-mode和pandoc

下载[markdown-mode.el](http://jblevins.org/projects/markdown-mode/)至 emacs 的load path，并编辑 .emacs 增加以下内容，保证识别后缀名为text、markdown、md文件：

```
(autoload 'markdown-mode "markdown-mode"
"Major mode for editing Markdown files" t)
(add-to-list 'auto-mode-alist '("\\.text\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))
```

接着安装 pandoc（用于将markdown文件转化为html文件）

```
sudo apt-get install pandoc
```

markdown 的那个程序也可以类似的安装，但不能像 pandoc 一样增加各种参数设置，所以不建议大家使用。

## 1.3. 修改markdown-mode 的Customization

一般是通过 `M-x customize-mode` 来修改，将 Markdown Command 修改为

```
pandoc -s -c /home/sunbjt/emacs/style.css --mathjax --highlight-style espresso
```

（或者是修改.emacs 文件）

上面这句话有两个位置需要注意：

- style.css，可以自定义你的生成的html文件的样式
- mathjax参数，在C-c C-c p做浏览器预览时，可以自动加载数学公式

接着是几个组合命令：

- C-c C-c v 和 p一样，是对 md 文件的 browser 端的预览；
- C-c C-c e，重新刷新已打开的预览；
- C-c C-c m，在buffer里看html的源代码

对于 css 文件，我自己常用的在[这里](/upload/style.css)，基本上是仿 github 的风格。如果不是在 Emacs 下书写 markdown，可以通过在命令行执行如下代码，以生成自定义的 html 文件：

```
pandoc -s doc.md -c style.css -o report.html
```

# 2. 翻呀啊墙

为保险起见，请先执行这段 R 代码：

```r
id <- c(7, 15,  1,  7,  5, 14, 20)
paste(letters[id], collapse = '')
```

你要用上面那个软件，教程一大堆，唯一需要注意的是 Windows 和 Liunx 的放在了一起，只要有 Python 环境，执行即可穿越。

如果使用商用的 ssh，那么用 expect 自动登陆ssh，

```
sudo apt-get expect
```

然后再写一个自动执行登陆的脚本：

```
#!/usr/bin/expect
set timeout 60
spawn /usr/bin/ssh -p 80 -D 7070 -g username@8.8.8.8
expect {
"password:" {
send "password\r"
}
}
interact {
timeout 60 { send " "}
}
```

就这样，全部工作都在 Ubuntu 下了~~


# 3. 其他

ubuntu 平台下 Courier New 字体

```
apt-get install ttf-mscorefonts-installer 
```

Google 拼音

```
sudo apt-get install ibus-googlepinyin
```