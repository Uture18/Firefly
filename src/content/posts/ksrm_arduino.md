---
title: 【快速入门】Arduino基础
published: 2026-09-08
description: 自学习的Arduino记录并总结。为他人提供快速入门笔记
tags: [快速入门, 教学, Arduino]
category: 语言基础
---

20分钟快速入门Arduino (本文适合具有C语言基础的学习者)

>本文以 **Arduino UNO R3 + Arduino IDE 2.x** 为例，所有代码均可直接烧录运行。

## 一、软件操作认识
### 1.Arduino 是什么
>Arduino 是一套**开源的软硬件平台**。它把单片机里最麻烦的寄存器配置、时钟树、位操作全部封装成了简单的函数，让你不必翻几百页芯片手册就能点亮一盏灯。

| 组成 | 说明 |
| --- | --- |
| 硬件 | UNO / Nano / Mega 等开发板，以及各种传感器模块 |
| 软件 | Arduino IDE，或 VS Code + PlatformIO |
| 语言 | 基于 C/C++ 的简化封装（Wiring 框架） |
| 库 | 别人写好的驱动代码，`#include` 进来即可调用 |

- 常见型号怎么选

| 型号 | 主控 | 数字IO | 模拟输入 | PWM | 特点 |
| --- | --- | --- | --- | --- | --- |
| **UNO R3** | ATmega328P | 14 | 6 | 6 | 最经典，教程最多，**入门首选** |
| Nano | ATmega328P | 14 | 8 | 6 | 体积小，直接插面包板 |
| Mega2560 | ATmega2560 | 54 | 16 | 15 | IO 和内存多，适合复杂项目 |
| ESP32 | 双核 Xtensa | 34 | 18 | 全部 | 自带 WiFi / 蓝牙，性能强 |

### 2.安装 Arduino IDE
1. 打开官网 `https://www.arduino.cc/en/software`，下载 **Arduino IDE 2.x** 的 Windows 安装包（.exe）。
2. 双击安装，一路默认即可。
3. 用数据线把板子插到电脑上。

**<span style="color: red;">注意:</span>** 如果「设备管理器 → 端口」里出现带黄色感叹号的未知设备，说明缺少 **CH340 驱动**。国产兼容板大多使用 CH340 或 CP2102 芯片，需要单独下载安装对应驱动。

### 3.IDE 界面认识
打开 IDE 后主要分 5 个区域：

| 区域 | 位置 | 作用 |
| --- | --- | --- |
| 菜单栏 | 顶部 | 文件、编辑、**工具**、帮助 |
| 工具栏 | 菜单栏下方 | ✅验证（编译）、➡️上传、串口绘图器 |
| 代码编辑区 | 中间 | 写代码，支持自动补全 |
| 侧边栏 | 左侧 | 新建 / 打开、库管理器、开发板管理器 |
| 输出区 | 底部 | 编译信息、报错提示、上传进度 |

>**<span style="color: red;">上传前必须做的两件事:</span>** 选对「开发板」和「端口」，90% 的上传失败都是这两项没选对。

| 操作 | 路径 |
| --- | --- |
| 选择开发板 | 工具 → 开发板 → Arduino AVR Boards → **Arduino Uno** |
| 选择端口 | 工具 → 端口 → **COMx**（拔插一次板子，看哪个端口是新出现的） |
| 打开串口监视器 | 工具 → 串口监视器（快捷键 `Ctrl + Shift + M`） |
| 打开库管理器 | 左侧「书架」图标，或 `Ctrl + Shift + I` |

### 4.第一个程序 —— Blink 点灯
>「点灯」就是嵌入式界的 Hello World。UNO 板上 13 号引脚自带一颗贴片 LED（板子上标着 `L`），不用接线就能看到效果。

```cpp
void setup() {
  pinMode(13, OUTPUT);       // 把 13 脚配置为输出模式
}

void loop() {
  digitalWrite(13, HIGH);    // 输出高电平 → LED 亮
  delay(1000);               // 保持 1000ms（1 秒）
  digitalWrite(13, LOW);     // 输出低电平 → LED 灭
  delay(1000);               // 再保持 1 秒
}
```

**上传四步走：**

| 步骤 | 操作 | 判断成功的标志 |
| --- | --- | --- |
| 1 | 点 ✅（验证） | 底部输出「编译完成」，无红色报错 |
| 2 | 工具 → 开发板 → Arduino Uno | — |
| 3 | 工具 → 端口 → COMx | — |
| 4 | 点 ➡️（上传） | 板子 TX/RX 灯闪烁，13 脚 LED 开始 1 秒一闪 |

### 5.串口监视器 —— 你的「显示器」
>没有屏幕的时候，`Serial` 就是唯一的调试手段。**先让程序开口说话，再让它干活。**

```cpp
void setup() {
  Serial.begin(9600);             // 打开串口，波特率 9600
}

void loop() {
  Serial.println("Hello Arduino");
  delay(1000);
}
```

上传后按 `Ctrl + Shift + M` 打开串口监视器，**右下角波特率必须选 9600**。

**<span style="color: red;">⚠️ 波特率不匹配 = 全是乱码</span>**，这是新手第一大坑。

### 6.常用快捷键与常见报错

| 快捷键 | 作用 |
| --- | --- |
| `Ctrl + R` | 验证 / 编译 |
| `Ctrl + U` | 上传 |
| `Ctrl + Shift + M` | 打开串口监视器 |
| `Ctrl + T` | 自动格式化代码（对齐缩进） |
| `Ctrl + /` | 注释 / 取消注释选中行 |

| 报错信息 | 原因 | 解决办法 |
| --- | --- | --- |
| `avrdude: ser_open(): can't open device` | 串口被占用 | 关掉串口监视器再上传 |
| `programmer is not responding` | 开发板或端口选错 | 重新检查「工具」菜单 |
| `expected ';' before ...` | 少了分号或括号 | 看报错行的**上一行** |
| `'xxx' was not declared` | 变量 / 函数拼错或未定义 | 检查拼写与作用域 |
| 上传成功但板子没反应 | 引脚接错 / 没供电 | 看板上电源灯（PWR）是否亮 |
| 编译提示内存不足 | 全局变量或 String 太多 | 改用 `F()` 宏，减少 String 使用 |

## 二、基础语法
### 1.程序结构 —— `setup()` 与 `loop()`
>Arduino 程序（叫 **Sketch**，文件后缀 `.ino`）**没有 main 函数**，框架已经帮你写好了，你只需要填两个函数：

```cpp
void setup() {
  // 上电或复位后【只执行一次】
  // 用来做初始化：引脚模式、串口波特率、传感器配置
}

void loop() {
  // setup() 执行完后【无限循环执行】
  // 主逻辑写在这里
}
```

>它背后隐藏的 `main()` 大概长这样，理解它就理解了 Arduino 的运行方式：

```cpp
int main() {
  init();              // 硬件初始化
  setup();             // 你的初始化
  for (;;) {           // 死循环
    loop();            // 你的主逻辑
  }
}
```

**<span style="color: red;">注意:</span>** `loop()` 里**不要写死循环或超长 `delay()`**，否则按键、串口等响应会全部卡住。

### 2.注释与代码规范
```cpp
// 单行注释

/*
  多行注释
  可以写很多行
*/

#define LED_PIN 13   // 常量的常见写法
```

命名习惯（和 C 语言一致）：

| 对象 | 风格 | 示例 |
| --- | --- | --- |
| 变量 | 小驼峰 | `int sensorValue;` |
| 常量 / 宏 | 全大写下划线 | `#define LED_PIN 13` |
| 函数 | 小驼峰 | `void readSensor()` |
| 类 | 大驼峰 | `class Motor` |

### 3.变量与数据类型
>Arduino 的数据类型和 C 语言基本一致，但有几个**和电脑上不一样**的地方，踩坑率极高。

| 类型 | 字节 | 范围 | 说明 |
| --- | --- | --- | --- |
| `bool` | 1 | true / false | 布尔 |
| `byte` | 1 | 0 ~ 255 | 无符号 8 位 |
| `char` | 1 | -128 ~ 127 | 单个字符 |
| `int` | **2** | -32768 ~ 32767 | **UNO 上只有 16 位！** |
| `unsigned int` | 2 | 0 ~ 65535 | 无符号整型 |
| `long` | 4 | ±21 亿 | 需要大数时用 |
| `unsigned long` | 4 | 0 ~ 42.9 亿 | `millis()` 的返回类型 |
| `float` | 4 | ±3.4×10³⁸ | 小数，精度 6~7 位 |
| `double` | **4** | 同 float | **UNO 上 `double` 和 `float` 一模一样** |
| `String` | — | — | 字符串对象，方便但费内存 |

**<span style="color: red;">重点:</span>** UNO 的 `int` 最大只能存 **32767**。`analogRead()` 返回的 0~1023 没问题，但如果做累加（比如统计脉冲数）很容易溢出，这时必须改用 `unsigned long`。

```cpp
int  a = 10;
float v = 3.14;
char c = 'A';
bool flag = true;
unsigned long t = 0;

const int LED_PIN = 13;   // const 常量，推荐
```

### 4.常量与宏定义
>Arduino 已经内置了一批常用常量，直接用即可，不需要自己定义。

| 常量 | 含义 | 常用于 |
| --- | --- | --- |
| `HIGH` / `LOW` | 高电平 / 低电平 | `digitalWrite()`、`digitalRead()` |
| `INPUT` / `OUTPUT` | 输入 / 输出模式 | `pinMode()` |
| `INPUT_PULLUP` | 输入并启用内部上拉 | 接按键 |
| `true` / `false` | 真 / 假 | 逻辑判断 |
| `LED_BUILTIN` | 板载 LED 的引脚号 | 免去硬编码 13 |

| 定义方式 | 写法 | 特点 |
| --- | --- | --- |
| `#define` | `#define LED_PIN 13` | 预处理替换，**不占内存**，无类型检查 |
| `const` | `const int LED_PIN = 13;` | 有类型检查，可调试，**推荐** |

### 5.运算符
1. 算术运算符

| 运算符 | 名称 | 示例 |
| --- | --- | --- |
| `+` | 加 | 3 + 5 = 8 |
| `-` | 减 | 10 - 4 = 6 |
| `*` | 乘 | 3 * 5 = 15 |
| `/` | 除 | 10 / 4 = 2（整数除法！） |
| `%` | 取余 | 10 % 4 = 2 |

**<span style="color: red;">重点:</span>** `10 / 4` 在 C 语言里结果是 **2** 而不是 2.5，因为两边都是整数。要得到小数必须写成 `10.0 / 4`。

2. 比较与逻辑运算符

| 运算符 | 名称 | 说明 |
| --- | --- | --- |
| `==` | 等于 | 注意别写成赋值 `=` |
| `!=` | 不等于 | |
| `>` `<` `>=` `<=` | 大小比较 | |
| `&&` | 逻辑与 | 两边都为真才为真 |
| `\|\|` | 逻辑或 | 一边为真即为真 |
| `!` | 逻辑非 | 取反 |

3. 位运算符（嵌入式必备）
>位运算在 Arduino 里非常重要：控制寄存器、做标志位、驱动 74HC595 移位芯片都要用。

| 运算符 | 名称 | 说明 | 示例 |
| --- | --- | --- | --- |
| `&` | 按位与 | 用来**读某一位**或**清零** | `val & 0x01` |
| `\|` | 按位或 | 用来**置 1 某一位** | `val \| 0x80` |
| `^` | 按位异或 | 两位不同才为 1，可用来**翻转** | `val ^ 0xFF` |
| `~` | 按位取反 | 每一位取反 | `~0x0F` |
| `<<` | 左移 | 相当于 ×2 | `1 << 3` = 8 |
| `>>` | 右移 | 相当于 ÷2 | `16 >> 2` = 4 |

>常用套路，建议背下来：

```cpp
val |= (1 << 3);      // 把第 3 位置 1
val &= ~(1 << 3);     // 把第 3 位清 0
val ^= (1 << 3);      // 把第 3 位翻转
if (val & (1 << 3)) { /* 判断第 3 位是否为 1 */ }
```

4. 复合赋值：`+=` `-=` `*=` `/=` `%=` `&=` `\|=` `^=` `<<=` `>>=`，含义都是「先运算再赋值」，例如 `a += 5` 等价于 `a = a + 5`。

### 6.条件判断
1. `if` / `else if` / `else`
```cpp
int value = analogRead(A0);

if (value > 800) {
  digitalWrite(13, HIGH);
} else if (value > 400) {
  digitalWrite(13, LOW);
} else {
  digitalWrite(13, HIGH);
}
```

2. `switch case`
```cpp
char cmd = Serial.read();

switch (cmd) {
  case 'a':
    Serial.println("向左");
    break;
  case 'd':
    Serial.println("向右");
    break;
  case 'w':
  case 's':                 // 多个 case 共用一段代码
    Serial.println("前后");
    break;
  default:                  // 都不匹配时执行
    Serial.println("无效指令");
}
```

**<span style="color: red;">注意:</span>** `switch` 的每个 `case` 后面记得写 `break`，否则会「贯穿」执行下一个分支。

3. 三目运算符 `条件 ? 值1 : 值2`
```cpp
digitalWrite(13, value > 500 ? HIGH : LOW);
```

### 7.循环
1. `for` —— 最常用
```cpp
for (int i = 0; i < 10; i++) {
  Serial.println(i);
}

// 倒序
for (int i = 9; i >= 0; i--) {
  Serial.println(i);
}
```
>`for` 的三段分别是：`初始化` ; `循环条件` ; `每次循环后的操作`。循环变量 `i` 在循环内定义，出了循环就失效。

2. `while`
```cpp
int i = 0;
while (i < 10) {
  i++;
}
```

3. `do...while` —— 至少执行一次
```cpp
int i = 0;
do {
  i++;
} while (i < 10);
```

4. 循环控制

| 关键字 | 作用 |
| --- | --- |
| `break` | 立刻结束整个循环 |
| `continue` | 跳过本次，进入下一次循环 |
| `return` | 直接从函数返回 |

### 8.函数
>把重复的代码封装成函数，是让代码变短的第一步。

```cpp
// 无返回值
void ledOn() {
  digitalWrite(13, HIGH);
}

// 有返回值 + 有形参
int add(int a, int b) {
  return a + b;
}

// 带默认参数
void blink(int times, int ms = 200) {
  for (int i = 0; i < times; i++) {
    digitalWrite(13, HIGH);
    delay(ms);
    digitalWrite(13, LOW);
    delay(ms);
  }
}

void setup() {
  pinMode(13, OUTPUT);
  blink(3);          // 用默认 200ms
  blink(2, 500);     // 指定 500ms
}
```

| 返回类型 | 含义 |
| --- | --- |
| `void` | 不返回任何值 |
| `int` `float` `char` … | 返回对应类型的数据 |
| `bool` | 返回真 / 假，适合做判断函数 |

### 9.数组与字符串
1. 数组
```cpp
int leds[3] = {9, 10, 11};       // 一维数组

void setup() {
  for (int i = 0; i < 3; i++) {
    pinMode(leds[i], OUTPUT);
  }
}
```
>数组下标从 **0** 开始，`leds[3]` 是**越界**的（只有 `leds[0]` ~ `leds[2]`）。C 语言不会检查越界，写错会读到垃圾数据甚至死机。

2. 字符串的两种写法

| 写法 | 示例 | 优点 | 缺点 |
| --- | --- | --- | --- |
| 字符数组 | `char s[] = "hello";` | 省内存、快 | 操作麻烦 |
| `String` 对象 | `String s = "hello";` | 拼接方便 | 费内存，容易产生碎片 |

```cpp
char s1[] = "hello";             // C 风格字符串（推荐）
String s2 = "hello";             // Arduino String 对象（方便）

Serial.println(s1);
Serial.println(s2 + " world");   // String 可以直接用 + 拼接
Serial.println(s2.length());     // 长度
```

**<span style="color: red;">建议:</span>** UNO 只有 **2KB RAM**，长期运行的程序尽量用 `char[]` 和 `F()` 宏，少用 `String`。

## 三、引脚操作
### 1.引脚分类与编号
>UNO 的引脚不是随便用的，每类引脚功能不同，插错线是新手最常见的错误。

| 类别 | UNO 引脚 | 说明 |
| --- | --- | --- |
| 数字 IO | D0 ~ D13 | `digitalWrite()` / `digitalRead()` |
| 模拟输入 | A0 ~ A5 | `analogRead()`，**也可以当普通数字 IO 用** |
| PWM 输出 | D3, D5, D6, D9, D10, D11 | 引脚号旁有 `~` 标记 |
| 串口 | D0(RX), D1(TX) | 下载和串口通信用，**平时别占用** |
| 外部中断 | D2, D3 | 只有这两个能 `attachInterrupt()` |
| I2C | A4(SDA), A5(SCL) | 接 OLED、传感器 |
| SPI | D10(SS) D11(MOSI) D12(MISO) D13(SCK) | 接 SD 卡、TFT 屏 |
| 电源 | 5V, 3.3V, VIN, GND, AREF, RESET | 供电与参考电压 |

### 2.数字输出 `digitalWrite()`
>控制 LED、继电器、蜂鸣器这类「开 / 关」器件。

```cpp
void setup() {
  pinMode(13, OUTPUT);      // 必须先设为 OUTPUT
}

void loop() {
  digitalWrite(13, HIGH);   // 输出 5V
  delay(500);
  digitalWrite(13, LOW);    // 输出 0V
  delay(500);
}
```

| 函数 | 说明 |
| --- | --- |
| `pinMode(pin, OUTPUT)` | 配置为输出；不配置也能写，但驱动能力不足 |
| `digitalWrite(pin, HIGH/LOW)` | 输出高 / 低电平 |
| `digitalWrite(pin, !digitalRead(pin))` | 翻转电平的常用写法 |

### 3.数字输入 `digitalRead()`
>读取按键、限位开关、红外传感器的「高 / 低」状态。

```cpp
const int BUTTON = 2;
const int LED = 13;

void setup() {
  pinMode(LED, OUTPUT);
  pinMode(BUTTON, INPUT_PULLUP);   // 启用内部上拉电阻
}

void loop() {
  if (digitalRead(BUTTON) == LOW) {   // 按下时读到 LOW
    digitalWrite(LED, HIGH);
  } else {
    digitalWrite(LED, LOW);
  }
}
```

**<span style="color: red;">重点:</span>** 输入引脚**绝对不能悬空**，否则读到的是随机值（乱跳）。两种处理方式：

| 方式 | 接线 | 代码 | 按下时读到 |
| --- | --- | --- | --- |
| 外部下拉电阻 | 按键一端接 5V，另一端接引脚并串 10kΩ 到 GND | `pinMode(pin, INPUT)` | **HIGH** |
| 内部上拉（推荐） | 按键一端接引脚，另一端直接接 GND | `pinMode(pin, INPUT_PULLUP)` | **LOW** |

>⚠️ 按键有**机械抖动**，按下瞬间会跳变多次。简单处理是加 `delay(20)`，规范做法是用 `millis()` 做软件消抖：

```cpp
const int BUTTON = 2;
int lastState = HIGH;
unsigned long lastTime = 0;

void loop() {
  int state = digitalRead(BUTTON);
  if (state != lastState && millis() - lastTime > 30) {   // 30ms 消抖
    lastTime = millis();
    if (state == LOW) Serial.println("按下");
  }
  lastState = state;
}
```

### 4.模拟输入 `analogRead()`
>读取电位器、光敏电阻、热敏电阻这类**连续变化**的电压。

```cpp
void setup() {
  Serial.begin(9600);
}

void loop() {
  int value = analogRead(A0);              // 返回 0 ~ 1023
  float voltage = value * 5.0 / 1023.0;    // 换算成电压（V）
  Serial.print("原始值: ");
  Serial.print(value);
  Serial.print("  电压: ");
  Serial.println(voltage);
  delay(200);
}
```

| 特性 | 说明 |
| --- | --- |
| 分辨率 | **10 位**，返回 0 ~ 1023 |
| 参考电压 | 默认 5V，可用 `analogReference()` 修改 |
| 换算公式 | `电压 = 读数 × 参考电压 / 1024` |
| 提高精度 | 改用 `analogReference(INTERNAL)` 可获得 1.1V 参考 |

**<span style="color: red;">注意:</span>** 模拟引脚输入电压**不能超过 5V**，否则可能烧坏芯片。测量更高电压必须用电阻分压。

### 5.PWM 模拟输出 `analogWrite()`
>Arduino 没有真正的 DAC，是用 **PWM（脉冲宽度调制）** 模拟出「平均电压」，用来调 LED 亮度、调电机速度、控制舵机。

```cpp
const int LED = 9;        // 必须是带 ~ 的 PWM 引脚

void setup() {
  pinMode(LED, OUTPUT);
}

void loop() {
  // 呼吸灯：亮度从暗到亮，再从亮到暗
  for (int duty = 0; duty <= 255; duty += 5) {
    analogWrite(LED, duty);
    delay(20);
  }
  for (int duty = 255; duty >= 0; duty -= 5) {
    analogWrite(LED, duty);
    delay(20);
  }
}
```

| 特性 | 说明 |
| --- | --- |
| 取值范围 | **0 ~ 255**（8 位） |
| 0 | 一直低电平（灭） |
| 255 | 一直高电平（全亮） |
| 127 | 约 50% 占空比（半亮） |
| PWM 频率 | 约 **490Hz**（D5、D6 约 980Hz） |

**<span style="color: red;">两个大坑:</span>**
1. **D5、D6 的 PWM 占空比会偏高**，因为这两个引脚和 `millis()` / `delay()` 共用定时器 Timer0。
2. 用了 `Servo` 库之后，**D9、D10 的 PWM 会失效**，因为它们被舵机库占用了（Timer1）。

### 6.时间控制 `delay()` 与 `millis()`
>`delay()` 简单粗暴，但它会让**整个程序停下来**。想让多个任务同时跑，必须用 `millis()`。

| 函数 | 说明 | 缺点 |
| --- | --- | --- |
| `delay(ms)` | 阻塞等待 ms 毫秒 | 期间什么都干不了 |
| `delayMicroseconds(us)` | 阻塞等待微秒 | 同样阻塞 |
| `millis()` | 返回开机至今的毫秒数 | **不阻塞，推荐** |
| `micros()` | 返回开机至今的微秒数 | 约 70 分钟溢出 |

```cpp
// 用 millis() 实现「非阻塞闪烁」，同时程序还能干别的事
const int LED = 13;
unsigned long previousMillis = 0;
const unsigned long interval = 1000;

void setup() {
  pinMode(LED, OUTPUT);
}

void loop() {
  unsigned long currentMillis = millis();

  if (currentMillis - previousMillis >= interval) {
    previousMillis = currentMillis;              // 记录本次时间
    digitalWrite(LED, !digitalRead(LED));        // 翻转 LED
  }

  // 这里可以继续写别的任务，互不影响
}
```

**<span style="color: red;">注意:</span>** 时间变量一定要用 `unsigned long`，并且用 `当前 - 上次 >= 间隔` 这种**减法写法**，这样即使 `millis()` 溢出（约 49.7 天）也不会出错。

### 7.外部中断 `attachInterrupt()`
>需要「立刻响应」的场合（编码器计数、急停按钮），用中断比轮询可靠得多。

```cpp
volatile unsigned long count = 0;    // 中断里改的变量必须加 volatile

void setup() {
  Serial.begin(9600);
  pinMode(2, INPUT_PULLUP);
  attachInterrupt(digitalPinToInterrupt(2), onPulse, FALLING);
}

void onPulse() {
  count++;                           // 中断服务函数：越短越好
}

void loop() {
  Serial.print("脉冲数: ");
  Serial.println(count);
  delay(500);
}
```

| 参数 | 可选值 | 说明 |
| --- | --- | --- |
| 中断引脚 | UNO 只有 **D2、D3** | 其它型号见官方文档 |
| 触发方式 | `RISING` | 上升沿触发 |
| | `FALLING` | 下降沿触发 |
| | `CHANGE` | 电平变化就触发 |
| | `LOW` | 低电平持续触发 |

**<span style="color: red;">注意:</span>** 中断服务函数里**不要用 `delay()`、`Serial.print()`**，要短、要快，只做标志位和计数。

### 8.引脚安全与速查
**<span style="color: red;">电流红线（超过就烧芯片）:</span>**

| 项目 | 限制 |
| --- | --- |
| 单个 IO 引脚电流 | 绝对最大 **40mA**，建议 ≤ **20mA** |
| 所有 IO 总电流 | ≤ **200mA** |
| 3.3V 引脚输出 | ≤ **50mA** |
| 5V 引脚输出 | 取决于 USB 供电，一般 ≤ 500mA |

- 驱动**电机、继电器、大功率 LED、电磁阀**时，**绝对不能直接接 IO 口**，必须用三极管 / MOS 管 / 专用驱动模块。
- 驱动**继电器、电机等感性负载**要加**续流二极管**，否则反向电动势会击穿 IO。
- 不确定电流时，串一个电阻再测。

**引脚操作函数速查表：**

| 函数 | 作用 | 取值范围 |
| --- | --- | --- |
| `pinMode(pin, mode)` | 设置引脚模式 | INPUT / OUTPUT / INPUT_PULLUP |
| `digitalWrite(pin, val)` | 数字输出 | HIGH / LOW |
| `digitalRead(pin)` | 数字输入 | 返回 HIGH / LOW |
| `analogRead(pin)` | 模拟输入 | 返回 0 ~ 1023 |
| `analogWrite(pin, val)` | PWM 输出 | 0 ~ 255 |
| `analogReference(type)` | 设置参考电压 | DEFAULT / INTERNAL / EXTERNAL |
| `delay(ms)` | 阻塞延时 | 毫秒 |
| `delayMicroseconds(us)` | 阻塞延时 | 微秒 |
| `millis()` | 开机毫秒数 | unsigned long |
| `micros()` | 开机微秒数 | unsigned long |
| `attachInterrupt(pin, func, mode)` | 开启外部中断 | — |
| `detachInterrupt(pin)` | 关闭外部中断 | — |
| `tone(pin, freq)` | 蜂鸣器发声 | 频率 Hz |
| `noTone(pin)` | 停止发声 | — |
| `pulseIn(pin, state)` | 读取脉冲宽度 | 微秒（超声波测距用） |

## 四、通讯协议
>单片机之间、单片机与模块之间交换数据，就靠通讯协议。Arduino 最常用的是 **串口 UART**、**I2C**、**SPI** 三种。

### 1.串口通讯 UART
>**<span style="color: red;">最常用、最简单</span>**，两根线就能通。调试打印靠它，接蓝牙 / WiFi 模块也靠它。

| 特性 | 说明 |
| --- | --- |
| 线数 | 2 根：**TX（发送）、RX（接收）**，外加共地 GND |
| UNO 引脚 | D0(RX)、D1(TX) —— 和下载口复用 |
| 电平 | **5V TTL**，不是电脑的 RS-232，不能直接插电脑串口 |
| 速率 | 常用 9600、115200 |
| 方式 | **异步**，没有时钟线，双方波特率必须一致 |
| 拓扑 | **点对点**，只能连两个设备 |

**接线口诀：A 的 TX 接 B 的 RX，A 的 RX 接 B 的 TX，GND 必须共地。**

```cpp
void setup() {
  Serial.begin(9600);          // 波特率必须和串口监视器一致
}

void loop() {
  if (Serial.available() > 0) {          // 有数据可读
    char c = Serial.read();              // 读 1 个字节
    Serial.print("收到: ");
    Serial.println(c);
  }
}
```

**常用串口函数：**

| 函数 | 作用 |
| --- | --- |
| `Serial.begin(baud)` | 初始化串口 |
| `Serial.print(x)` | 输出，**不换行** |
| `Serial.println(x)` | 输出并**换行** |
| `Serial.write(x)` | 发送**原始字节**（不是文本） |
| `Serial.available()` | 返回缓冲区里可读的字节数 |
| `Serial.read()` | 读 1 个字节，无数据返回 **-1** |
| `Serial.readStringUntil(c)` | 读到指定字符为止 |
| `Serial.parseInt()` | 读取一个整数 |
| `Serial.flush()` | 等待发送完成 |

**<span style="color: red;">重点区分:</span>** `print()` 和 `write()` 完全不一样。

```cpp
Serial.print(65);    // 先转成文本，串口收到字符 '6' '5'（两个字节）
Serial.write(65);    // 直接发送 0x41（一个字节），串口监视器显示 'A'
```

**接收字符串指令的完整例子（用串口控制 LED）：**

```cpp
void setup() {
  Serial.begin(9600);
  pinMode(13, OUTPUT);
}

void loop() {
  if (Serial.available() > 0) {
    String cmd = Serial.readStringUntil('\n');   // 读到换行为止
    cmd.trim();                                  // 去掉首尾空白和 \r

    if (cmd == "on") {
      digitalWrite(13, HIGH);
      Serial.println("LED 已打开");
    } else if (cmd == "off") {
      digitalWrite(13, LOW);
      Serial.println("LED 已关闭");
    } else {
      Serial.println("未知指令");
    }
  }
}
```

>串口监视器里记得把行尾设置为**「换行符」**，否则 `readStringUntil('\n')` 会一直等。

**软串口（SoftwareSerial）：** UNO 只有一组硬件串口，被下载口占了。如果需要额外的串口接模块，可以用任意两个数字引脚模拟：

```cpp
#include <SoftwareSerial.h>
SoftwareSerial mySerial(10, 11);   // RX, TX

void setup() {
  Serial.begin(9600);
  mySerial.begin(9600);
  mySerial.print("AT");            // 发给模块
  if (mySerial.available()) Serial.write(mySerial.read());
}
```

>⚠️ 软串口**最高只能到 115200，实际建议不超过 38400**，高波特率会丢数据。

### 2.I2C 通讯
>只用两根线就能挂**多个**设备，接线最省事，是传感器和 OLED 屏的首选。

| 特性 | 说明 |
| --- | --- |
| 线数 | 2 根：**SDA（数据）、SCL（时钟）**，外加 GND |
| UNO 引脚 | **A4 = SDA，A5 = SCL** |
| 拓扑 | **一主多从**，每个从机有唯一的 **7 位地址** |
| 速率 | 标准 100kHz，快速 400kHz |
| 上拉电阻 | 需要！SDA、SCL 各接一个 4.7kΩ 到 5V（**大多数模块已内置**） |
| 距离 | 短，一般不超过 1 米 |

>不同板子的 I2C 引脚不一样，别记混：

| 板子 | SDA | SCL |
| --- | --- | --- |
| UNO / Nano | A4 | A5 |
| Mega2560 | D20 | D21 |
| ESP32 | GPIO21 | GPIO22 |

**I2C 扫描器 —— 不知道模块地址时的必备工具：**

```cpp
#include <Wire.h>

void setup() {
  Serial.begin(9600);
  Wire.begin();                    // 作为主机，不用填地址
  Serial.println("开始扫描 I2C 设备...");
}

void loop() {
  int found = 0;

  for (byte addr = 1; addr < 127; addr++) {
    Wire.beginTransmission(addr);          // 向该地址发起通讯
    if (Wire.endTransmission() == 0) {     // 返回 0 = 从机应答
      Serial.print("发现设备，地址: 0x");
      Serial.println(addr, HEX);
      found++;
    }
  }

  Serial.print("共发现 ");
  Serial.print(found);
  Serial.println(" 个设备");
  delay(5000);
}
```

**向 I2C 设备写数据（以 0x3C 的 OLED 为例）：**

```cpp
#include <Wire.h>

#define ADDR 0x3C

void setup() {
  Wire.begin();
  Wire.beginTransmission(ADDR);   // 开始与从机通讯
  Wire.write(0x00);               // 写一个字节
  Wire.write(0xAE);               // 具体指令看模块手册
  Wire.endTransmission();         // 结束并发送
}

void loop() { }
```

**从 I2C 设备读数据：**

```cpp
Wire.requestFrom(ADDR, 2);              // 请求读 2 个字节
while (Wire.available()) {              // 等数据到达
  int data = Wire.read();               // 读 1 个字节
  Serial.println(data);
}
```

| 函数 | 作用 |
| --- | --- |
| `Wire.begin()` | 作为主机初始化 |
| `Wire.begin(addr)` | 作为从机初始化（填自己的地址） |
| `Wire.beginTransmission(addr)` | 开始向某地址发送 |
| `Wire.write(x)` | 写入要发送的数据 |
| `Wire.endTransmission()` | 结束并发送，返回 0 表示成功 |
| `Wire.requestFrom(addr, n)` | 向从机请求 n 个字节 |
| `Wire.available()` | 还有多少字节可读 |
| `Wire.read()` | 读取 1 个字节 |

>**<span style="color: red;">注意:</span>** I2C 上每个设备的地址**不能重复**。如果两个模块地址一样（比如两块同型号 OLED），需要用模块上的跳线或指令改地址，否则会冲突。

### 3.SPI 通讯
>**速度最快**的通讯方式，适合 SD 卡、TFT 彩屏、射频模块这类需要大量数据传输的场景。

| 特性 | 说明 |
| --- | --- |
| 线数 | 4 根：**MOSI、MISO、SCK、SS**，外加 GND |
| UNO 引脚 | D11=MOSI，D12=MISO，D13=SCK，**D10=SS** |
| 拓扑 | 一主多从，**每个从机一根独立的 SS（片选）线** |
| 速率 | 可达 **4 ~ 8 MHz**，远快于 I2C |
| 全双工 | 收发可以**同时**进行 |
| 上拉电阻 | 不需要 |

>四根线各自的作用：

| 线 | 全称 | 方向 | 作用 |
| --- | --- | --- | --- |
| MOSI | Master Out Slave In | 主 → 从 | 主机发给从机的数据 |
| MISO | Master In Slave Out | 从 → 主 | 从机回给主机的数据 |
| SCK | Serial Clock | 主 → 从 | 时钟信号，由主机产生 |
| SS | Slave Select | 主 → 从 | **拉低选中该从机**，拉高取消 |

**SPI 读设备 ID 的例子：**

```cpp
#include <SPI.h>

const int CS_PIN = 10;      // 片选引脚

void setup() {
  Serial.begin(9600);

  pinMode(CS_PIN, OUTPUT);
  digitalWrite(CS_PIN, HIGH);       // 默认不选中

  SPI.begin();

  digitalWrite(CS_PIN, LOW);        // 拉低片选，开始通讯
  SPI.transfer(0x9F);               // 发送指令（读 ID）
  for (int i = 0; i < 3; i++) {
    Serial.println(SPI.transfer(0x00), HEX);   // 发 0x00 占位，读回数据
  }
  digitalWrite(CS_PIN, HIGH);       // 拉高片选，结束通讯
}

void loop() { }
```

| 函数 | 作用 |
| --- | --- |
| `SPI.begin()` | 初始化 SPI |
| `SPI.transfer(x)` | 发送 1 字节，并**返回同时收到的 1 字节** |
| `SPI.beginTransaction(settings)` | 配置速率、位序、模式 |
| `SPI.endTransaction()` | 结束本次配置 |
| `digitalWrite(SS, LOW/HIGH)` | **手动控制片选**（SPI 库不会自动管） |

>⚠️ 和 I2C 不同，**SPI 的片选必须自己用 `digitalWrite()` 控制**：通讯前拉低，通讯后拉高。

### 4.三种协议对比与选型

| 对比项 | 串口 UART | I2C | SPI |
| --- | --- | --- | --- |
| 线数 | 2 + GND | 2 + GND | 4 + GND |
| UNO 引脚 | D0 / D1 | A4 / A5 | D10 ~ D13 |
| 速率 | 9600 ~ 115200 | 100k / 400kHz | 4 ~ 8 MHz |
| 拓扑 | 点对点 | 一主多从（地址区分） | 一主多从（片选区分） |
| 需要上拉 | 否 | **是** | 否 |
| 全双工 | 是 | 否 | 是 |
| 占用引脚 | 少 | **最少** | 多（每个从机一根 SS） |
| 典型器件 | 蓝牙、GPS、串口屏 | OLED、温湿度、EEPROM | SD 卡、TFT 屏、NRF24L01 |

**选型口诀：**

| 场景 | 推荐 |
| --- | --- |
| 只接一个模块 / 调试打印 | **串口 UART** |
| 接多个传感器、想省引脚 | **I2C** |
| 要传大量数据、要求速度快 | **SPI** |

### 5.综合实例 —— 串口指令 + 引脚操作 + 数据回传
>把前面学的全串起来：串口接收指令 → 控制 LED → 读模拟值 → 回传给电脑。

```cpp
const int LED_PIN = 13;
const int SENSOR_PIN = A0;

void setup() {
  Serial.begin(9600);
  pinMode(LED_PIN, OUTPUT);
  Serial.println("就绪：输入 on / off / read");
}

void loop() {
  // 1. 处理串口指令
  if (Serial.available() > 0) {
    String cmd = Serial.readStringUntil('\n');
    cmd.trim();

    if (cmd == "on") {
      digitalWrite(LED_PIN, HIGH);
      Serial.println("LED ON");
    } else if (cmd == "off") {
      digitalWrite(LED_PIN, LOW);
      Serial.println("LED OFF");
    } else if (cmd == "read") {
      int value = analogRead(SENSOR_PIN);
      float voltage = value * 5.0 / 1024.0;
      Serial.print("ADC=");
      Serial.print(value);
      Serial.print("  V=");
      Serial.println(voltage);
    } else {
      Serial.println("未知指令");
    }
  }

  // 2. 每 1 秒自动上报一次（非阻塞写法）
  static unsigned long lastTime = 0;
  if (millis() - lastTime >= 1000) {
    lastTime = millis();
    Serial.print("[心跳] 运行时间: ");
    Serial.print(millis() / 1000);
    Serial.println(" s");
  }
}
```

---

## 附录：新手常见问题速查

| 问题 | 原因 | 解决 |
| --- | --- | --- |
| 上传报错 `can't open device` | 串口被串口监视器占用 | 先关监视器，再上传 |
| 串口全是乱码 | 波特率不匹配 | 两边都改成 9600 或 115200 |
| LED 不亮 | 引脚设错 / 极性接反 / 没接限流电阻 | LED 长脚接正，短脚串 220Ω 到 GND |
| 按键一直触发 | 输入引脚悬空 | 改 `INPUT_PULLUP` 或加下拉电阻 |
| 程序跑一会儿就死机 | 内存溢出（String、递归） | 改用 `char[]`，减少全局变量 |
| `analogWrite()` 没反应 | 用在了非 PWM 引脚 | 换 D3 / D5 / D6 / D9 / D10 / D11 |
| 舵机抖动 / PWM 失效 | 舵机库占用 Timer1 | 避开 D9、D10 |
| I2C 扫描不到设备 | 没上拉 / 接线反 / 地址错 | 检查 SDA-SDA、SCL-SCL、GND 共地 |
