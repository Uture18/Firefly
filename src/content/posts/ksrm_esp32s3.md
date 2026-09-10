---
title: 【快速入门】ESP32基础
published: 2026-09-011
description: 自学习的Python记录并总结。为他人提供快速入门笔记
tags: [快速入门, 教学, ESP32]
category: 语言基础
---

20分钟快速入门Python (本文适合具有C语言基础的学习者)

## 一、数据的存储与运算
### 1.字面量
>在Python中，`字面量`同等为C语言的**常量**。是一种不会变化、被直接定义的量。
```python
#在Python中命令行输出为print()
print("Hello, World!")  #字符串
print(100)              #整型
print(2.14)             #浮点
print(True)             #布尔
```
### 2.变量
>在Python中可以变化的量被称为`变量`。定义变量的方式为 `变量名 = 变量值`。  
变量可以是`任意类型`且**不需定义类型**。在变量定义后仍可以存储不同类型的数据。  
常见数据类型有 `int`  `float`  `str`  `bool`  `NoneType `
```python
num = 10        #整数类型变量
num = 9.111     #浮点类型变量
num = "ok"      #字符串类型变量
num = True      #布尔类型变量
```
>同时一次可以同时定义多个变量`变量名1, 变量名2 = 变量值1, 变量值2`
```python
x, y = 1,2
```
>通过type()函数查看数据类型  
通过isinstance()查看数据是否属于某一类型 
```python
print(type(num))
print(isinstance(num,int))
```
### 3.标识符
1. 只能包含字母、数字、下划线(_)
2. 不能以数字开头
3. 不能使用关键字
4. 严格区分大小写
5. python中变量名全小写，多个单词用下划线连接（蛇形命名 snake_case）
### 4.字符串
1. 字符串有三种定义方法  `' '` `" "` `"""   """`其中`"""`定义的字符串**可以换行**
```python
c = 'AAA'
c = "AAA"
c = """
AAA:
    BBB
    CCC
"""
```
2. 字符串可以使用 `"+"` 加号连接。  
   '+'只能连接**字符串类型**数据，非字符串类型必须**强制转换**为字符串类型`str(int)`
```python
num = 1
print("AAA" + "BBB" + str(num))

```
3. 字符串的`格式化输出`  
- 方式一: `%s`占位符
```python
name, age, hobby = "li", 18, "软件"
print("大家好，我是%s，今年%d岁，爱好%s" % (name, age, hobby))  # %s=字符串占位 %d=整数占位
```
- 方式二: `f" ....{变量名、表达式}...."`
```python
name, age, hobby = "li", 18, "软件"
print(f"大家好，我是{name}，今年{age}岁，爱好是{hobby}")
```
### 5.输入输出
1. 输入 `input("提示信息")`。所有的输入都是**字符串类型**
```python
s = input("请输入")
```
2. 输出 `print()`
```python
print("Hello, World!")
```
### 6.运算符
1. 算数运算符  
- 算术运算符优先级 `**` **>** ` *`  `/`  `//`  `%` **>**  `+` `-`  

| 运算符 | 名称 | 示例 |
| --- | --- | --- |
| `+` | **加** | 3 + 5 = 8 |
| `-` | **减** | 10 - 4 = 6 |
| `*` | **乘** | 3 * 5 = 15 |
| `/` | **除** | 10 / 4 = 2.5 |
| `//` | **整除** | 10 // 4 = 2 |
| `%`| **取余** | 10 % 4 = 2 |
| `**` | **幂** | 2 ** 3 = 8 |
2. 赋值运算符  

| 运算符 | 名称 | 示例 | 等价写法 |
| --- | --- | --- | --- |
| `=` | 赋值 | a = 10 | — |
| `+=` | 加赋值 | a += 5 | a = a + 5 |
| `-=` | 减赋值 | a -= 5 | a = a - 5 |
| `*=` | 乘赋值 | a *= 5 | a = a * 5 |
| `/=` | 除赋值 | a /= 5 | a = a / 5 |
| `//=` | 整除赋值 | a //= 5 | a = a // 5 |
| `%=` | 取余赋值 | a %= 5 | a = a % 5 |
| `**=` | 幂赋值 | a **= 2 | a = a ** 2 |
3. 比较（关系）运算符  

| 运算符 | 名称 | 示例 | 结果 |
| --- | --- | --- | --- |
| `==` | 等于 | 3 == 3 | True |
| `!=` | 不等于 | 3 != 4 | True |
| `>` | 大于 | 3 > 4 | False |
| `<` | 小于 | 3 < 4 | True |
| `>=` | 大于等于 | 3 >= 3 | True |
| `<=` | 小于等于 | 3 <= 4 | True |
4. 逻辑运算符  

| 运算符 | 名称 | 说明 | 示例 | 结果 |
| --- | --- | --- | --- | --- |
| `and` | 与 | 两边都为真才为真 | True and False | False |
| `or` | 或 | 一边为真即为真 | True or False | True |
| `not` | 非 | 取反 | not True | False |
5. 成员运算符  

| 运算符 | 名称 | 说明 | 示例 | 结果 |
| --- | --- | --- | --- | --- |
| `in` | 属于 | 值在容器中（字符串/列表/元组/集合/字典键） | "a" in "cat" | True |
| `in` | 属于 | | 2 in [1, 2, 3] | True |
| `not in` | 不属于 | 值不在容器中 | "b" not in "cat" | True |
6. 身份运算符  
- **<span style="color: red;">重点区分:</span>** **"=="** 比的是`值相等`;**"is"** 比的是`是不是同一个对象`。例:a=[1,2,3]、b=[1,2,3] → a == b 是 True,但 a is b 是 False(内存里是两份)。判断 None 常用 x is None。

| 运算符 | 名称 | 说明 | 示例 | 结果 |
| --- | --- | --- | --- | --- |
| `is` | 是 | 两个变量指向**同一个对象** | a is b（当 b = a 时） | True |
| `is not` | 不是 | 两个变量指向**不同对象** | a is not c | True |


7. 位运算符(按二进制位运算)  

| 运算符 | 名称 | 说明 | 示例（二进制） | 结果 |
| --- | --- | --- | --- | --- |
| `&` | 按位与 | 两位都是1结果才为1 | 5 & 3 = 101 & 011 | 1 |
| `\|` | 按位或 | 有一位是1即为1 | 5 \| 3 = 101 \| 011 | 7 |
| `^` | 按位异或 | 两位不同才为1 | 5 ^ 3 = 101 ^ 011 | 6 |
| `~` | 按位取反 | 每一位取反（含符号位） | ~5 | -6 |
| `<<` | 左移 | 二进制位整体左移（相当于×2） | 5 << 1 | 10 |
| `>>` | 右移 | 二进制位整体右移（相当于÷2） | 5 >> 1 | 2 |

## 二、基础语法
在Python中，基础的语法有三种。分别是 `条件判断`**(if)** `模式匹配`**(match case)** `循环`**(while/for)**  
### 1.条件判断 - `if`
>if语句由 `if` 条件: `elif` 条件: `else`: 组成  
if语句从 `if`开始按照`if`与`elif`的判断条件**进行判断**。如果为`真`则执行对应的操作代码。如果所有条件都不满足，则实行`else:`中的操作代码  
在Python中 **<span style="color: red;">严格强调缩进:</span>** 。`缩进`是判断`if`的`工作范围`的`依据`
```python
if 条件:
   (tab)执行的操作  #一定要有缩进
elif 条件:
   (tab)执行的操作
else:
   (tab)if语句所有都不满足是执行
```
### 2.模式匹配 `match:` `case:`
```python
day = input("请输入星期(1-7)")
match day:
    case "1":
        print("周1")
    case "2":
        print("周2")
    case "3":
        print("周3")
    case "4":
        print("周4")
    case "5":
        print("周5")
    case "6" | "7":# XX | XX 匹配其中一种情况 ‘或’
        print("周末")
    case _:#不满足前面的所有情况
        print("输入错误")
```
### 3.循环
>在Python中循环有两种形式，分别是`while` 和 `for`
1. `while` 
```python
i = 0                    # 必须先给 i 初值，否则 NameError
while i < 10:
    i += 1
else:
    print("i = " + str(i))
```
2. `for`
```python
for i in "abc":
    print(i)
else:
    print("循环结束")
```
　　仿C语言的for循环使用 `range(开头，结尾+1，步伐)`长度为 **[开头，结尾)**
```python
for i in range(1,101,2):# 从1开始，步长2，输出 1,3,5,…,99
    print(i)
```
### 4.条件词  
1. continue跳出本次循环直接进入下次循环   
2. break结束
#随机数：先导入包（import 必须是真实代码，写在注释里无效）
import random
random_num = random.randint(1,100)
print(f"随机数的值为{random_num}")  
## 三、数据存储容器
在python中拥有5种**数据存储容器：**`列表-list`  `字符串str `  `元组tuple`  `集合set`  `字典dict`
### 1.列表-list  
>python列表的表达和功能类似于C语言的数组   
列表具有`可重复` `有序` `可以修改`的特点  
列表的定义表达式为：`列表名 = [数据1,数据2······]`
```python
num_list = [1,2,3,4]
```
1. `索引`: 索引是数据在列表中的位置，通过索引我们可以调用列表中该位置数据的值。  
在python中有两种索引：`正索引` `0` **->** `(x-1)`和`反索引` `-x` **<-** `-1`
```python
num_list = [1,2,3,4,5,6,7,8,9]
print(num_list[1])     #正索引
print(num_list[-1])    #反索引
```
2. `切片`: 指定一部分元素出来 `num_list`**[**`开始索引` **:** `结束索引`(输出不包含结束索引) **:** `步长` **]**
```python
for i in num_list[1,5,2]
    print(i)
```
3. 列表常见方法(函数)

| 方法 | 作用 | 语法 | 特点 / 返回值 | 示例 |
| --- | --- | --- | --- | --- |
| `append()` | 末尾追加一个元素 | `列表.append(元素)` | 不返回新列表 | `s.append(10086)` |
| `extend()` | 用另一个可迭代对象逐个追加 | `列表.extend([元素,...])` | 相当于循环 append；若想整体加一层用 append | `s.extend([4, 5])` |
| `insert()` | 在指定索引前插入 | `列表.insert(索引, 元素)` | 该位置及之后元素自动后移 | `s.insert(0, 92)` |
| `remove()` | 按值删除第一个匹配项 | `列表.remove(值)` | 值不存在会报 `ValueError` | `s.remove(2)` |
| `pop()` | 按索引删除并返回该元素 | `列表.pop(索引)` | 不写索引默认删最后一个 | `s.pop()` / `s.pop(2)` |
| `index()` | 查找某值首次出现的索引 | `列表.index(值)` || 找不到会报 `ValueError` | `s.index(2)` |
| `count()` | 统计某值出现的次数 | `列表.count(值)` | 没有则返回 0 | `s.count(2)` |
| `sort()` | 升序排序 | `列表.sort()` | 元素类型需一致；倒序用 `sort(reverse=True)` | `s.sort()` |
| `reverse()` | 反转元素顺序 | `列表.reverse()` | 就地反转，不返回新列表 | `s.reverse()` |

- `append()` - 追加元素   
在列表尾部添加一个元素  
语法：列表.append(元素)  
特点：直接修改原列表，不返回新列表  
```python
s.append(10086)  # 在末尾添加10086
```
- `extend()` - 扩展列表  
用另一个可迭代对象（列表、元组、字符串等）的所有元素扩展当前列表  
语法：列表.extend(可迭代对象)  
特点：等同于循环执行 append()，一次性添加多个元素  
对比：与 append() 的区别是 append() 会将整个对象作为一个元素添加  
```python
# 示例对比
s = [1, 2, 3]
s.extend([4, 5, 6])    # [1, 2, 3, 4, 5, 6]
s.append([4, 5, 6])    # [1, 2, 3, [4, 5, 6]]  # 作为整体添加

# 也可以扩展字符串
s = ['a', 'b']
s.extend('cd')         # ['a', 'b', 'c', 'd']
```
- `insert()` - 插入元素  
在指定索引位置前插入一个元素  
语法：列表.insert(索引, 元素)  
特点：该位置及之后的元素自动后移  
```python
s.insert(0, 92)  # 在索引0前插入92
```
- `remove()` - 移除元素  
移除列表中第一个匹配的指定值  
语法：列表.remove(值)  
⚠️ 注意：如果要删除的值不存在，会报错 ValueError  
安全做法：先判断元素是否存在  
```python
# 方式1：使用 if 判断
if 2 in s:
    s.remove(2)

# 方式2：使用 try-except 捕获异常
try:
    s.remove(75)
except ValueError:
    print("元素不存在")
```
- `pop()`- 弹出元素  
删除指定索引的元素，默认删除最后一个  
语法：列表.pop(索引) 或 列表.pop()  
特点：会返回被删除的元素  
```python
s.pop(2)    # 删除索引2的元素
s.pop()     # 删除最后一个元素（默认）
```
- `index()`- 查找索引  
返回指定值在列表中第一次出现的索引位置  
语法：列表.index(值, 起始索引, 结束索引)（后两个参数可选）  
⚠️ 注意：如果值不存在，会抛出 ValueError 异常  
安全做法：先使用 in 判断或使用 try-except  
```python
s = [10, 20, 30, 20, 40]
print(s.index(20))          # 1（第一次出现的位置）
print(s.index(20, 2))       # 3（从索引2开始查找）

# 安全使用方式
if 20 in s:
    index = s.index(20)
    
# 或者
try:
    index = s.index(50)
except ValueError:
    print("元素不存在")
```
- `count()`- 统计次数  
统计指定值在列表中出现的总次数  
语法：列表.count(值)  
特点：值不存在时返回 0，不会报错  
```python
s = [1, 2, 3, 2, 2, 4, 5]
print(s.count(2))    # 3（2出现了3次）
print(s.count(10))   # 0（不存在返回0）
```
- `sort()`- 排序  
对列表进行升序排序  
语法：列表.sort()  
⚠️ 要求：列表中的所有元素类型必须一致（可比较）  
```python 
s.sort()    # 升序排列
```
- `reverse()`- 反转  
将列表中的元素顺序反转  
语法：列表.reverse()  
```python
s.reverse()  # 列表元素倒序排列
```
>三大方法对比
append() vs extend()
```python
s = [1, 2, 3]
s.append([4, 5])    # [1, 2, 3, [4, 5]]   # 把[4,5]作为一个元素
s.extend([4, 5])    # [1, 2, 3, 4, 5]     # 把4和5分别加入
```
index() 使用建议
```python
# 推荐：使用 in 判断
if 值 in 列表:
    索引 = 列表.index(值)

# 或使用 try-except（如果你确定可能存在异常）
try:
    索引 = 列表.index(值)
except ValueError:
    print("值不存在")
```
count() 简单实用

```python
# 无需判断，直接使用
次数 = 列表.count(值)  # 不存在返回0，很安全

# 常见用途：判断元素是否存在
if 列表.count(值) > 0:
    print("存在")
```
### 2.字符串str  
Python中字符串是不可变的字符序列，可以用单引号、双引号或三引号定义。字符串也是容器，支持索引、切片等操作。  
- 索引与切片  
字符串的索引和切片规则与列表一致，支持正索引和反索引。  

```python
s = "Hello, World!"
print(s[0])           # H（正索引）
print(s[-1])          # !（反索引）
print(s[0:5])         # Hello（切片，不包含结束索引）
print(s[7:12])        # World
print(s[::-1])        # !dlroW ,olleH（反转字符串）
```
- 字符串拼接与重复
```python
# 拼接
s = "Hello" + " " + "World"   # "Hello World"
# 重复
s = "Hi" * 3                  # "HiHiHi"
# 拼接非字符串需转换
num = 100
s = "数字：" + str(num)        # "数字：100"
```
- 字符串常用方法  
所有方法都 **<span style="color: red;">不改变:</span>**  原字符串

| 类别 | 方法 | 作用 | 示例 |
| --- | --- | --- | --- |
| 大小写转换 | `upper()` | 全部转大写 | `"hello".upper()` → `"HELLO"` |
| 大小写转换 | `lower()` | 全部转小写 | `"HELLO".lower()` → `"hello"` |
| 去除空白 | `strip()` | 去除两端空白 | `" hello ".strip()` → `"hello"` |
| 查找与替换 | `replace()` | 替换子串 | `"hello".replace("l","x")` → `"hexxo"` |
| 查找与替换 | `find()` | 查找位置，找不到返回 -1 | `"hello".find("l")` → `2` |
| 查找与替换 | `count()` | 统计出现次数 | `"hello".count("l")` → `2` |
| 判断 | `isdigit()` | 是否全是数字 | `"123".isdigit()` → `True` |
| 判断 | `isalpha()` | 是否全是字母 | `"hello".isalpha()` → `True` |
| 判断 | `startswith()` | 是否以…开头 | `"hello".startswith("he")` → `True` |
| 分割与连接 | `split()` | 字符串 → 列表 | `"a,b,c".split(",")` → `['a', 'b', 'c']` |
| 分割与连接 | `join()` | 列表 → 字符串 | `",".join(['a', 'b', 'c'])` → `"a,b,c"` |

⚠️ 重点区分
```python
# find() vs index()
"hello".find("x")   # -1（找不到返回-1，安全）
"hello".index("x")  # 报错 ValueError（找不到报错）

# split() vs join()（互为逆操作）
s = "a,b,c"
lst = s.split(",")     # ['a', 'b', 'c']
s2 = ",".join(lst)     # "a,b,c"（还原）
```
💡 实用技巧
```python
# 1. 判断是否为数字/字母（常用于输入验证）
if user_input.isdigit():
    num = int(user_input)

# 2. 去除首尾空格（处理用户输入）
username = input("请输入用户名：").strip()

# 3. 字符串拼接列表（高效，比+快）
words = ["Hello", "World"]
s = " ".join(words)  # "Hello World"
```
- 字符串不可变性
字符串是不可变类型，所有方法都返回新字符串，不会修改原字符串。

```python
s = "hello"
# s[0] = "H"        # ❌ 报错！字符串不支持元素赋值

# 正确做法：创建新字符串
s = "H" + s[1:]     # "Hello"
s = s.replace("h", "H")  # "Hello"
s = s.upper()       # "HELLO"
```
- 字符串格式化
```python
name, age, hobby = "Li", 18, "软件"

# 方式一：% 占位符
print("我是%s，今年%d岁，爱好%s" % (name, age, hobby))

# 方式二：f-string（推荐）
print(f"我是{name}，今年{age}岁，爱好{hobby}")

# 方式三：format()
print("我是{}，今年{}岁，爱好{}".format(name, age, hobby))
```
- 字符串转义字符

| 转义字符 | 说明 | 示例 |
| --- | --- | --- |
| `\n` | 换行 | `"a\nb"` → 输出时 a、b 在两行 |
| `\t` | 制表符（Tab） | `"a\tb"` → `a` 与 `b` 之间空一个 Tab 位 |
| `\\` | 反斜杠 | `"C:\\Users"` → `C:\Users` |
| `\'` | 单引号 | `"I\'m"` → `I'm` |
| `\"` | 双引号 | `"He said \"Hi\""` → `He said "Hi"` |
| `\r` | 回车（光标回到行首） | 常与 `\n` 配合，如 `\r\n`（Windows 换行） |

- 原始字符串  
在字符串前加 r，可以忽略转义字符，常用于文件路径、正则表达式。

```python
path = r"C:\Users\name\Desktop"  # 不需要写双反斜杠
print(path)  # C:\Users\name\Desktop
```
- 字符串与列表互转
```python
# 字符串 → 列表
s = "hello,world,python"
lst = s.split(",")          # ['hello', 'world', 'python']
lst = list(s)               # ['h','e','l','l','o',',','w',...]

# 列表 → 字符串
lst = ['hello', 'world']
s = ' '.join(lst)           # "hello world"
s = ''.join(lst)            # "helloworld"
s = ','.join(lst)           # "hello,world"
```
### 3.元组tuple  
>元组是不可变的有序序列，定义后`不能修改`、添加或删除元素。元组比列表更节省内存，适合存储`不需要改变`的数据。  
其他与列表相同，可以**重复** **有序** **支持索引访问与切片**
- 定义方式
```python
# 基本定义
t1 = (1, 2, 3, 4, 5)        # 圆括号定义
t2 = 1, 2, 3, 4, 5           # 不加括号也可以（元组打包）
t3 = ()                      # 空元组
t4 = (1,)                    # ⚠️ 单元素元组必须加逗号

# 常见错误
t5 = (1)                     # ❌ 这是整数 1，不是元组！
t6 = (1,)                    # ✅ 这才是元组 (1,)

# 类型转换
t7 = tuple([1, 2, 3])        # (1, 2, 3) 从列表转换
t8 = tuple("hello")          # ('h', 'e', 'l', 'l', 'o') 从字符串转换
```
⚠️ 特殊情况：元组内可变对象
```python
# 元组本身不可变，但如果元素是可变对象（如列表），该对象内容可以改变
t = (1, 2, [3, 4])
t[2][0] = 99          # ✅ 可以修改列表内容
print(t)              # (1, 2, [99, 4])

# t[2] = [5, 6]       # ❌ 但不能替换整个列表元素
```
- 元组常用方法  

|方法|作用|语法|返回值|示例|
| --- | --- | --- | --- | --- |
|`count()`|统计某值出现次数|元组.count(值)|次数（整数）|(1,2,2,3).count(2) → 2|
|`index()`|查找某值`首次`出现的索引|元组.index(值)|索引值（找不到报错|(10,20,30).index(20) → 1|

- 元组的组包与解包
　　`组包: `将多个值合并到一个容器(元组、列表)中    
　　`解包: `将容器解开成独立的元素，分别赋值给多个变量。  
```python
#定义元组，组包
t1 = (5, 7, 9, 1)
t2 = 5, 7, 9, 1

#基础解包
```
### 4.集合set  
### 5.字典dict  
## 四、函数
函数是组织好的、可重复使用的、用来实现特定功能的代码片段
### 1.函数定义与调用
>定义函数使用关键字 `def` `函数名(参数列表):`
调用为 `函数名(参数列表)`
```python
#定义函数
def out_line():
    print("________________")
    return 0
#调用函数
out_line()
```
**<span style="color: red;">注意:</span>** 函数定义时参数列表与返回值可有可无，函数必须`先定义`在调用。
### 2.函数的`参数` 与 `返回值`
>在定义函数时,根据需要可以指定形参与返回值  
如果函数有`形参`则调用时需要填写对应的`实参 ` 。实参与形参**一一对应**
形参只能在`函数内`使用，形参`无法改变`实参  
```python
#计算长方形面积
def rectangle_area(l,w):
    area = l * w
    return area
#调用函数 
r_area = rectangle_area(20,10)
print(r_area)
```
>如果函数需要 **多个返回值** ，可以使用逗号隔开要输出的数据。将这些数据 `打包` 成一个 `元组 `输出。也可以通过 `解包` 分别将返回值赋值给不同变量。
round(数据，保留小数位数)
```python
#计算圆的周长和面积
def circle_area_len(r):
    return round(3.14 * r * r), round(2 * 3.14 * r,1)  #组包

al = circle_area_len(10)
print(al)
ptint(type(al))
#解包
area, len = circle_area_len(10)
print(area)
print(len)
```
```输出
(314.0, 62.8)
<class 'tuple'>
314.0
62.8
```
### 3.函数的说明
>函数的说明文档(Docstring)是写在函数开头，用三个引号包裹的字符串，用于解释函数的功能、参数、返回值等信息，方便调用者清楚函数的具体作用及细节。
```python
#定义一个函数，根据半径，计算圆的周长、面积
def circle_area_len(r):
    """
    该函数用于根据圆的半径，计算圆的面积和圆的周长
    :param r:圆的半径          #描述函数的参数
    :return:圆的面积，圆的周长  #描述函数的返回值
    """
return 3.14 * r * r, 2 * 3.14 * r

al = circle_area_len(10)
print(al)
```

### 4.函数的嵌套调用
>嵌套调用指的是在一个`函数中` ，又调用了`另外的函数`   
函数调用遵循`栈结构`，最后被调用的函数最先返回LIFO(Last InFirst Out，`后进先出`)
```python
def function_a
```
