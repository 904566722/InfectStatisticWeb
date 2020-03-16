# 代码规范

> 代码规范来源：[阿里巴巴JAVA开发手册](https://github.com/chjw8016/alibaba-java-style-guide)

## 缩进

> 缩进采用四个空格
>
> > 若使用tab进行缩进需将tab设置为4个空格

## 变量命名

> 1.**成员变量、局部变量**使用**小驼峰式命名法**
>
> > 正例：user**N**ame / user**E**mail
> >
> > 反例：UserName / user_Email
>
> 2.不能以下划线或美元符号开始，也不能以下划线或美元符号结束。
>
> > 反例： _name / __name / $Object / name_ / name$ / Object$
>
> 3.代码中的命名严禁使用拼音与英文混合的方式，更不允许直接使用中文的方式。
>
> > 说明：正确的英文拼写和语法可以让阅读者易于理解，避免歧义。
> > 注意，即使纯拼音命名方式也要避免采用。

## 每行最多字符数

> 1.每行最多字符数**120**
>
> 2.换行格式
>
> > * 第二行缩进：**4**个空格，其余行不继续缩进
> > * 运算符与下文一起换行
> > * 方法调用点符号与下文一起换行
> > * 参数个数过多，**逗号后**换行
>
> 示例：
>
> ```java
> 		String tooLongString = "sdfsdjfisdj" + "fdsfse" + ...
> 		    + "fdsfeifsdjfie";
> 		StringBuffer tooLongStringBuffer = new StringBuffer();
> 		tooLongStringBuffer.append("newdsfie").append("fdfes")....
> 			.append("dsfeij").append("dfvc")....
> 			.append("fdsjfejf");
> 		
> 		public void getName(int id, int grade, ... ,
>         	int classId) {
>        		//....
>    		}	
> ```

## 函数最大行数

> 函数最大行数不超过**150**行
> 
> > 不包括注释和空行。 

## 函数、类命名

> 1.**函数名、参数名、成员变量**使用**小驼峰式命名法**，第个单词以小写字母开始，其他单词的首字母大写
>
> > 正例：get**N**ame() / get**N**ame**B**y**I**d()
> >
> > 反例：GetName() 
>
> 2.**类名**使用**大驼峰式命名法**，每个单词的首字母均大写
>
> >正例：**U**ser**D**emo / **M**arco**P**olo
> >
> >反例：userDemo / MarcoPOLO
>
> 3.**抽象类名**使用**Abstract**或**Base**开头，**异常类名**使用**Exception**结尾，**测试类**以它要测试的类的名称开头，以**Test**结尾

## 常量

> 1.命名规范：全部大写，使用下划线隔开
>
> > 例：PI / MAX_NUMBER / MAX_STOCK_COUNT
>
> 2.不允许出现**神秘值**（未经定义的常量）
>
> 3.long、Long初始赋值时要使用大写L
>
> > 正例：Long a  = 2L;
> >
> > 反例：Long a = 2l;

## 空行规则

> 1.左大括号**{**前不换行，后换行
>
> 2.右大括号**}**前换行，后除了有else if/else语句，否则换行
>
> 3.每个函数之间隔一个空行

## 注释规则

> 1.类、类属性、类方法的注释使用**Javadoc规范**<http://ericfu.me/javadoc-coding-standards/>
>
> 2.方法内部单行注释，使用 **//** 注释，多行注释使用 **/\*\*/**
>
> 3.代码修改的同时要同步修改注释
>
> 4.注释掉的代码要说明
>
> 5.较简短的注释说明注释其后，如变量的简单意义说明

## 空格

> 1.运算符左右均加空格
>
> > 赋值运算符=、逻辑运算符&&、+-*/、三目运算符等
> >
> > 正例：int i = 0;  /  if (a && b) / for (int i = 0; i < 10; i++)
> >
> > 反例：int i=0; / if (a&&b) / for (int i=0; i<10; i++)
>
> 2.if/for/while/switch/do等保留字与左右括号之间必须加空格
>
> > 正例：if (flag == 0) {...}
> >
> > 反例：if(flag == 0){...}
>
> 3.左括号和后一个字符之间不出现空格；同样，右括号和前一个字符之间也不出现空格。
>
> 4.方法的参数间的逗号，逗号前不加空格，逗号后加空格
>
> 5.一元操作符如“ !”、“ ~”、“ ++”、“ --”、“ &”（ 地址运算符） 等前后不加空格。以及像“［ ］”、“ .”、“ ->” 这类操作符前后不加空格。

## 其他规则

> 1.if/else/for/while/do等语句都**必须**使用大括号包含，就算只有一行代码，也不能省略，避免使用下面的形式：if (condition) statements;
>
> 2.在一个switch块内，每个case要么通过break/return等来终止，要么注释说明程序将继续执行到哪一个case为止；在一个switch块内，都必须包含一个default语句并且放在最后，即使它什么代码也没有。
>
> 3.中括号是数组类型的一部分，数组定义如下：String[] args;
>
> > 反例：请勿使用String  args[]的方式来定义。