---
title: 【快速入门】ESP32-S3基础
published: 2026-09-11
description: 基于 Arduino-ESP32 2.0.6，从装开发板包、导入离线包，到 LEDC PWM、Wi-Fi、BLE、ESP-NOW 与 USB 的完整上手笔记。
tags: [快速入门, 教学, ESP32-S3]
category: 嵌入式快速入门
---

> **本文环境**：Arduino IDE 2.x ＋ **Arduino-ESP32 核心 2.0.6** ＋ ESP32-S3（DevKit / 立创 ESP32S3 系列）
> **注意版本**：2.x 和 3.x 的 API **不兼容**（尤其 PWM 和 BLE）。本文全部代码按 **2.0.6** 编写，3.x 的差异在对应章节单独标注。
> **适合读者**：学过 C 语言，看过 Arduino 基础（`setup()` / `loop()` / `digitalWrite()`）

## 一、开箱：先认清这块板子

### 1. ESP32-S3 是什么
ESP32-S3 是乐鑫的**双核 32 位 MCU**，性能比 Arduino UNO 强两个数量级：

| 项目 | ESP32-S3 | Arduino UNO（对比） |
| --- | --- | --- |
| 主频 | **240 MHz 双核**（LX7） | 16 MHz 单核 |
| 内置 SRAM | 512 KB | 2 KB |
| Flash | 外挂 4~16 MB | 32 KB |
| PSRAM | 可选 2~16 MB | 无 |
| 无线 | **Wi-Fi 2.4GHz + BLE 5** | 无 |
| 逻辑电平 | **3.3V** | 5V |

**<span style="color: red;">第一个大坑：ESP32-S3 是 3.3V 逻辑。</span>** 绝大多数引脚**不能直接接 5V**，接错会永久损坏。UNO 上能直接接的 5V 传感器，在这里要加电平转换或选 3.3V 版本。

### 2. 型号命名怎么看（N8R2 / N16R8 / R16N8）
这是买板子时最容易懵的地方。规则是：

- **N 后面的数字 = Flash（闪存）大小**
- **R 后面的数字 = PSRAM（外扩内存）大小**

| 型号写法 | Flash | PSRAM | Arduino 里怎么设 |
| --- | --- | --- | --- |
| N4R2 | 4 MB | 2 MB | Flash 4MB ＋ **QSPI PSRAM** |
| N8R2 | 8 MB | 2 MB | Flash 8MB ＋ **QSPI PSRAM** |
| N16R8 | 16 MB | 8 MB | Flash 16MB ＋ **OPI PSRAM** |
| **R16N8**（立创命名） | **8 MB** | **16 MB** | Flash **8MB** ＋ **OPI PSRAM** |

> **<span style="color: red;">别只信型号名。</span>** 不同厂商的前缀顺序不统一（有的写 N16R8，有的写 R8N8）。**最权威的是模组金属屏蔽罩上印的字**，形如 `ESP32-S3-WROOM-1-N16R8`——照着它填设置就不会错。

**PSRAM 到底是 QSPI 还是 OPI？** 记不住就用这条经验：**2MB 一般是 QSPI，8MB / 16MB 基本是 OPI**。实在不确定就两个都试一遍，选错的表现是：编译能过，但一运行就重启。

> 📷 **图 1 ｜ 模组屏蔽罩丝印特写（能看到 N16R8 这种字样）**（图片位置预留）
> 替换为：`![模组丝印](images/esp32s3-module-mark.jpg)`

### 3. 板子上的接口
S3 开发板通常有**两个 Type-C 口**，这是新手最容易插错的地方：

| 接口 | 丝印常写 | 作用 | 说明 |
| --- | --- | --- | --- |
| **USB-OTG 口** | USB / OTG | 原生 USB，可做 CDC/HID/MSC | 走 S3 内部的 USB 外设（GPIO19/20） |
| **UART 口** | UART / COM / CH340 | 经 CH340 转串口 | 最稳，上传和看打印都靠它 |
| BOOT 键 | BOOT / IO0 | 按住再按 RST 进下载模式 | 上传失败时的救命键 |
| RST 键 | RST / EN | 复位 | |
| 电源排针 | 3V3 / 5V / GND | 给外部模块供电 | **GND 必须共地** |

**建议**：新手先用 **UART 口**（稳定、无 USB 配置烦恼），等要玩 USB 功能再换 OTG 口。

> 📷 **图 2 ｜ 两个 Type-C 口与 BOOT / RST 键的位置**（图片位置预留）
> 替换为：`![双 Type-C 接口](images/esp32s3-usb-ports.jpg)`

### 4. 引脚禁忌（一定要看）
有些引脚**不能随便用**，否则板子起不来或功能失效：

| 引脚 | 为什么特殊 | 建议 |
| --- | --- | --- |
| GPIO0 | strapping（决定启动模式） | 只当 BOOT 用，别接外设 |
| GPIO3 / GPIO45 / GPIO46 | strapping（影响启动电压） | 上电时必须保持默认电平 |
| **GPIO19 / GPIO20** | **原生 USB D- / D+** | 用了 USB 功能就别再接东西 |
| GPIO26~32 | 接内部 Flash / PSRAM | **完全不可用** |

## 二、Arduino IDE 环境搭建

### 1. 安装 Arduino IDE
1. 打开 `https://www.arduino.cc/en/software`
2. 下载 **Arduino IDE 2.x** Windows 版，双击安装，一路默认
3. 装好后先别急着建项目

### 2. 在线安装开发板包
1. 打开 **文件 → 首选项**
2. 找到 **附加开发板管理器网址**，填入下面这一行：

```
https://raw.githubusercontent.com/espressif/arduino-esp32/gh-pages/package_esp32_index.json
```

3. 点 **确定**，再打开左侧 **开发板管理器**
4. 搜索 **esp32**，找到 **esp32 by Espressif Systems**，点 **安装**

> **<span style="color: red;">国内下载很慢或直接失败是常态</span>**，因为包放在 GitHub 上。官方文档也承认这点，建议国内用户改用极狐镜像仓库 `https://jihulab.com/esp-mirror/espressif/arduino-esp32`。
> 但最省事的办法是**用离线包**——也就是下一节。

### 3. 导入离线包（推荐）
离线包的原理很简单：**把核心解压到 Arduino 的 packages 目录**，IDE 就会认为已经装好了。

**步骤：**

1. **完全关闭 Arduino IDE**（这一步很关键，IDE 开着会导致文件被占用）
2. 打开这个目录（`AppData` 是隐藏文件夹，要在「查看」里勾上「隐藏的项目」）：

```
C:\Users\<你的用户名>\AppData\Local\Arduino15\packages
```

3. 把离线包解压进去，最终目录结构必须长这样：

```
Arduino15\packages\esp32\hardware\esp32\2.0.6\
                                          ├─ boards.txt
                                          ├─ cores\
                                          ├─ libraries\
                                          └─ variants\
Arduino15\packages\esp32\tools\
                    ├─ xtensa-esp32s3-elf-gcc\
                    ├─ esptool_py\
                    └─ ...
```

4. 重新打开 IDE → 开发板管理器 → 应该能看到 **esp32 2.0.6 已安装**

**验证是否装对**：随便选个 ESP32 开发板，能编译通过就说明核心可用。

> **<span style="color: red;">常见错误：</span>** 解压后多套了一层文件夹（变成 `2.0.6\2.0.6\boards.txt`），IDE 就认不出来。目录里必须**直接**能看到 `boards.txt`。

### 4. 开发板设置（★ 全文最重要的一节）
选好 **工具 → 开发板 → esp32 → ESP32S3 Dev Module** 之后，下面这几个选项**必须逐个确认**。这些选项名来自 2.0.6 的 `boards.txt`，和你 IDE 里看到的一字不差：

| 选项 | 常见取值 | 怎么选 |
| --- | --- | --- |
| **Flash Size** | 4MB / **8MB** / **16MB** | 按模组实际 Flash 选，选大了能编过但跑不起来 |
| **PSRAM** | Disabled / **QSPI PSRAM** / **OPI PSRAM** | 2MB→QSPI；8MB/16MB→OPI；没有就 Disabled |
| **Partition Scheme** | Default 4MB / 8M / **16M Flash (3MB APP/9.9MB FATFS)** | Flash 是 16MB 就该选 16M 的方案 |
| **USB CDC On Boot** | Disabled / **Enabled** | 用 OTG 口看打印时**必须 Enabled** |
| **USB Mode** | Hardware CDC and JTAG / **USB-OTG (TinyUSB)** | 要玩 USB HID / MSC 就选 TinyUSB |
| **Upload Speed** | **921600** / 115200 / 230400 | 上传不稳就降到 115200 |
| **CPU Frequency** | **240MHz (WiFi)** | 默认即可 |

**<span style="color: red;">为什么「USB CDC On Boot」这么重要？</span>**
用 OTG 口时，如果不把它设为 Enabled，`Serial.println()` 的**一个字都看不到**——因为 `Serial` 还绑在 UART 上，而你没插 UART 口。这是新手最常见的「代码没问题但啥也没打印」。

> 📷 **图 3 ｜ 工具菜单里这几个选项的位置**（图片位置预留）
> 替换为：`![开发板设置项](images/esp32s3-board-options.jpg)`

### 5. 端口与上传
1. 工具 → 端口 → 选 **COMx**（拔插一次板子看哪个是新出现的）
2. 工具 → 开发板 → **ESP32S3 Dev Module**
3. 点 ➡️ 上传

**上传失败的四种情况：**

| 现象 | 原因 | 解决 |
| --- | --- | --- |
| `Failed to connect to ESP32-S3` | 没进下载模式 | **按住 BOOT → 点一下 RST → 松开 BOOT**，再上传 |
| `Serial port busy` | 串口被占用 | 关掉串口监视器再上传 |
| 一直 `Connecting.....` | 波特率太高 | Upload Speed 改成 115200 |
| 端口根本找不到 | 缺 CH340 驱动 | 装 CH340 驱动（UART 口） |

### 6. 第一个程序：点灯
S3 开发板的板载 LED **不一定是 GPIO13**（这点和 UNO 不同！），常见是 **GPIO48**；部分板子上是 WS2812 彩色灯，不是普通 LED。**先查你板子的原理图或丝印**。

```cpp
void setup() {
  pinMode(48, OUTPUT);          // 换成你板子上 LED 对应的引脚
}

void loop() {
  digitalWrite(48, HIGH);
  delay(500);
  digitalWrite(48, LOW);
  delay(500);
}
```

> **<span style="color: red;">注意：</span>** 如果板载的是 **WS2812 彩灯**，它需要专用库（`Adafruit_NeoPixel` 或 `FastLED`），用 `digitalWrite()` 是点不亮的。

## 三、GPIO 与 PWM

### 1. 基础 GPIO
和 Arduino 一样，但电平是 3.3V：

| 函数 | 作用 | 注意 |
| --- | --- | --- |
| `pinMode(pin, OUTPUT/INPUT/INPUT_PULLUP)` | 设置模式 | |
| `digitalWrite(pin, HIGH/LOW)` | 输出 3.3V / 0V | **不是 5V** |
| `digitalRead(pin)` | 读电平 | |
| `analogRead(pin)` | 读模拟量 | **S3 返回 0~4095**（12 位），不是 UNO 的 0~1023 |

**ADC 换算公式**：`电压 = 读数 × 3.3 / 4095`

> `analogRead()` 的引脚用 **GPIO 编号**，不是 UNO 的 `A0` 写法（虽然 S3 也定义了 `A0~A10` 宏，但建议直接用 GPIO 号，更清楚）。

### 2. PWM 是什么，LEDC 又是什么
PWM（脉冲宽度调制）就是**快速开关**，用「开的时间占比」（占空比）来模拟不同电压。

ESP32-S3 的 PWM 由 **LEDC 外设**产生，比 UNO 强得多：

| 项目 | UNO | ESP32-S3（LEDC） |
| --- | --- | --- |
| 频率 | 固定 ~490Hz | **可调**（几 Hz ~ 40MHz） |
| 分辨率 | 固定 8 位（0~255） | **可调 1~16 位** |
| 通道 | 6 个 | 多个独立通道 |

### 3. 2.x 的 PWM 三件套
> ⚠️ 这是 2.x 写法。3.x 已删除 `ledcSetup` 和 `ledcAttachPin`，见本节末尾。

```cpp
ledcSetup(通道号, 频率, 分辨率位数);   // 1. 配置通道
ledcAttachPin(引脚, 通道号);          // 2. 把引脚绑到通道
ledcWrite(通道号, 占空比);            // 3. 输出
```

| 参数 | 说明 |
| --- | --- |
| 通道号 | 0 ~ 15（API 范围，实际可用数取决于芯片），**同一条通道只能给一个引脚** |
| 频率 | 单位 Hz。LED 调光用 5000，舵机用 50 |
| 分辨率 | 位数。8 位 → 占空比 0~255；10 位 → 0~1023；12 位 → 0~4095 |

**关键限制：频率 × 2^分辨率 不能超过约 80MHz。** 超了 `ledcSetup()` 会返回 0（失败）。

| 用途 | 频率 | 分辨率 | 占空比范围 |
| --- | --- | --- | --- |
| LED 调光 | 5000 | 8 位 | 0 ~ 255 |
| 呼吸灯（更细腻） | 5000 | 10 位 | 0 ~ 1023 |
| 舵机 | **50** | 16 位 | 见下文 |

### 4. 呼吸灯实战
```cpp
#define LED_PIN   48      // 换成你的 LED 引脚
#define CHANNEL   0       // 使用 0 号通道
#define FREQ      5000    // 5kHz
#define RES       8       // 8 位分辨率 → 0~255

void setup() {
  ledcSetup(CHANNEL, FREQ, RES);
  ledcAttachPin(LED_PIN, CHANNEL);
}

void loop() {
  // 由暗到亮
  for (int duty = 0; duty <= 255; duty += 5) {
    ledcWrite(CHANNEL, duty);
    delay(15);
  }
  // 由亮到暗
  for (int duty = 255; duty >= 0; duty -= 5) {
    ledcWrite(CHANNEL, duty);
    delay(15);
  }
}
```

> **<span style="color: red;">一定要先 `ledcSetup` 再 `ledcAttachPin`</span>**，顺序反了没有输出。这是 2.x 最容易错的地方。

### 5. 用 PWM 驱动舵机（50Hz）
舵机的控制信号是 **50Hz**（周期 20ms），**高电平 0.5ms~2.5ms** 对应 0°~180°。

用 16 位分辨率时，20ms 对应 65536 个计数：

| 角度 | 脉宽 | 占空比计算 | duty 值 |
| --- | --- | --- | --- |
| 0° | 0.5 ms | 0.5/20 | ≈ 1638 |
| 90° | 1.5 ms | 1.5/20 | ≈ 4915 |
| 180° | 2.5 ms | 2.5/20 | ≈ 8192 |

```cpp
#define SERVO_PIN  5
#define CH         1

void servoWrite(int angle) {
  // 角度 0~180 映射到 1638~8192
  int duty = map(angle, 0, 180, 1638, 8192);
  ledcWrite(CH, duty);
}

void setup() {
  ledcSetup(CH, 50, 16);          // 50Hz + 16位
  ledcAttachPin(SERVO_PIN, CH);
}

void loop() {
  servoWrite(0);    delay(1000);
  servoWrite(90);   delay(1000);
  servoWrite(180);  delay(1000);
}
```

### 6. 3.x 的写法有什么不同
如果你以后升级到 3.x，**PWM 代码全部要改**：

| 2.x（本文） | 3.x |
| --- | --- |
| `ledcSetup(ch, freq, res)` | **已删除** |
| `ledcAttachPin(pin, ch)` | **已删除** |
| — | `ledcAttach(pin, freq, res)` 一次搞定 |
| `ledcWrite(ch, duty)` | `ledcWrite(pin, duty)`（改成按引脚） |
| `ledcDetachPin(pin)` | `ledcDetach(pin)` |

## 四、Wi-Fi

> S3 只支持 **2.4GHz**，**连不上 5GHz 的 Wi-Fi**。手机热点记得开 2.4G。

### 1. STA 模式（连路由器）
```cpp
#include <WiFi.h>

const char* SSID = "你的WiFi名";
const char* PASS = "你的WiFi密码";

void setup() {
  Serial.begin(115200);
  WiFi.mode(WIFI_STA);
  WiFi.begin(SSID, PASS);

  Serial.print("连接中");
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  Serial.println();
  Serial.print("已连接，IP 是: ");
  Serial.println(WiFi.localIP());
}

void loop() { }
```

### 2. 扫描周边 Wi-Fi
```cpp
#include <WiFi.h>

void setup() {
  Serial.begin(115200);
  WiFi.mode(WIFI_STA);
  WiFi.disconnect();

  int n = WiFi.scanNetworks();
  Serial.printf("发现 %d 个网络\n", n);
  for (int i = 0; i < n; i++) {
    Serial.printf("%d: %-20s  信号 %d dBm  加密:%d\n",
                  i + 1, WiFi.SSID(i).c_str(), WiFi.RSSI(i), WiFi.encryptionType(i));
  }
}

void loop() { }
```

### 3. AP 模式（自己开热点）
```cpp
#include <WiFi.h>

void setup() {
  Serial.begin(115200);
  WiFi.mode(WIFI_AP);
  WiFi.softAP("ESP32S3-AP", "12345678");   // 热点名 / 密码（至少 8 位）
  Serial.print("热点已开，IP: ");
  Serial.println(WiFi.softAPIP());
}

void loop() { }
```

### 4. 断线自动重连
```cpp
void checkWiFi() {
  static unsigned long last = 0;
  if (WiFi.status() != WL_CONNECTED && millis() - last > 5000) {
    last = millis();
    Serial.println("掉线了，重连中...");
    WiFi.disconnect();
    WiFi.begin(SSID, PASS);
  }
}
```
在 `loop()` 里调用 `checkWiFi()` 即可，**不要用 while 死等**，否则别的任务全卡住。

## 五、蓝牙（BLE）

### 1. ★ 先搞清楚：ESP32-S3 没有经典蓝牙
这是本文**最重要的一条**，网上大量教程在这里是错的。

| 特性 | ESP32（初代） | **ESP32-S3** |
| --- | --- | --- |
| 经典蓝牙 BT Classic（SPP / A2DP） | ✅ 有 | **❌ 没有** |
| BLE（低功耗蓝牙） | ✅ | ✅ |

依据是乐鑫官方 Arduino-ESP32 特性表（[Libraries 文档](https://docs.espressif.com/projects/arduino-esp32/en/latest/libraries.html)），S3 的 BT Classic 一栏标的是 **➖ Not available on the SoC**——**芯片上根本没有这个硬件**。

**带来的实际后果：**

- `BluetoothSerial` 库在 S3 上**编译不过**
- 所有「蓝牙音箱」「蓝牙串口 SPP」「蓝牙手柄」教程**在 S3 上都不适用**
- 想无线传数据，用 **BLE** 或 **ESP-NOW**（见下一章）

### 2. BLE 的几个概念
BLE 的数据是**按层次组织**的，先记住三个词：

| 概念 | 中文 | 类比 |
| --- | --- | --- |
| **Service** | 服务 | 一个功能模块（如「串口服务」） |
| **Characteristic** | 特征值 | 模块里的一个数据通道（可读/可写/可通知） |
| **UUID** | 唯一标识 | 每个服务和特征值的身份证号 |

常用的 **Nordic UART Service (NUS)** UUID（手机 App 普遍支持，做「无线串口」就用这套）：

| 用途 | UUID |
| --- | --- |
| 服务 | `6E400001-B5A3-F393-E0A9-E50E24DCCA9E` |
| 手机 → ESP32（写） | `6E400002-B5A3-F393-E0A9-E50E24DCCA9E` |
| ESP32 → 手机（通知） | `6E400003-B5A3-F393-E0A9-E50E24DCCA9E` |

### 3. 一个最小 BLE 服务器（2.x 代码）
```cpp
#include <BLEDevice.h>
#include <BLEServer.h>
#include <BLEUtils.h>
#include <BLE2902.h>

BLECharacteristic *pTxChar;
bool connected = false;

#define SERVICE_UUID "6E400001-B5A3-F393-E0A9-E50E24DCCA9E"
#define RX_UUID      "6E400002-B5A3-F393-E0A9-E50E24DCCA9E"
#define TX_UUID      "6E400003-B5A3-F393-E0A9-E50E24DCCA9E"

// 连接 / 断开回调
class ServerCB : public BLEServerCallbacks {
  void onConnect(BLEServer *s) {
    connected = true;
    Serial.println("手机已连接");
  }
  void onDisconnect(BLEServer *s) {
    connected = false;
    Serial.println("手机断开，重新广播");
    s->startAdvertising();
  }
};

// 收到手机数据
class RxCB : public BLECharacteristicCallbacks {
  void onWrite(BLECharacteristic *c) {
    std::string v = c->getValue();          // 2.x 返回 std::string
    if (v.length() > 0) {
      Serial.print("收到: ");
      Serial.println(v.c_str());
    }
  }
};

void setup() {
  Serial.begin(115200);

  BLEDevice::init("ESP32S3-BLE");                       // 蓝牙名（手机搜到的名字）
  BLEServer *server = BLEDevice::createServer();
  server->setCallbacks(new ServerCB());

  BLEService *svc = server->createService(SERVICE_UUID);

  BLECharacteristic *rx = svc->createCharacteristic(
      RX_UUID,
      BLECharacteristic::PROPERTY_WRITE | BLECharacteristic::PROPERTY_WRITE_NR);
  rx->setCallbacks(new RxCB());

  pTxChar = svc->createCharacteristic(
      TX_UUID,
      BLECharacteristic::PROPERTY_NOTIFY);
  pTxChar->addDescriptor(new BLE2902());                 // 没有它手机收不到通知

  svc->start();

  BLEAdvertising *adv = BLEDevice::getAdvertising();
  adv->addServiceUUID(SERVICE_UUID);
  adv->setScanResponse(true);
  adv->start();

  Serial.println("等待手机连接...");
}

void loop() {
  // 每 2 秒给手机发一次数据
  static unsigned long last = 0;
  if (connected && millis() - last > 2000) {
    last = millis();
    String msg = "运行 " + String(millis() / 1000) + " 秒";
    pTxChar->setValue(msg.c_str());        // 2.x 传 std::string
    pTxChar->notify();
  }
}
```

**测试方法：**
1. 手机装 **nRF Connect**（安卓/iOS 都有）
2. 扫描，找到 `ESP32S3-BLE`，连接
3. 展开那个服务，在 `6E400002` 上点「写入」，发点文字
4. 打开串口监视器，就能看到 ESP32 收到内容
5. 在 `6E400003` 上点「订阅通知」，就能看到 ESP32 发来的数据

### 4. 用 BLE 做「无线串口」
这是 (a) 方案的核心思路：**把 BLE 的两条通道当作串口的收发线**，手机端用「蓝牙串口」App 就能像连 COM 口一样操作。

- **手机 → ESP32**：手机写入 `RX_UUID`，ESP32 在 `onWrite()` 里拿到数据
- **ESP32 → 手机**：ESP32 `setValue()` + `notify()` 发到 `TX_UUID`

因为用的是 **NUS 标准 UUID**，可以直接用现成 App：

| 平台 | 推荐 App | 说明 |
| --- | --- | --- |
| 安卓 | **Serial Bluetooth Terminal** | 直接支持 NUS，能当串口终端用 |
| 安卓/iOS | **nRF Connect / LightBlue** | 通用调试工具 |

> **和真串口的区别**：BLE 不能「一边发一边等」，数据是**分包**的。一次传输的 MTU 通常只有 **20 字节**（可协商到 200+），发大段文字要**自己分片**，而且可能丢失。所以它是「无线调试通道」，不适合传大文件。

### 5. BLE 和 USB 虚拟串口怎么选（b 方案对比）

| 对比项 | BLE 无线串口 | USB CDC 虚拟串口 |
| --- | --- | --- |
| 连接方式 | 无线电 | 一根 Type-C 线 |
| 距离 | 空旷 10~30 米 | 线长（一般 < 2m） |
| 速度 | 慢（几 KB/s，MTU 受限） | 快（USB 全速 12Mbps） |
| 稳定性 | 会受 2.4G 干扰、可能丢包 | 非常稳定 |
| 电脑端 | 要手机/蓝牙适配器 | 插上就是个 COM 口 |
| 适合 | 远程看数据、手机遥控 | 开发调试、传大数据 |

**结论**：**调试用 USB 串口，部署后要远程访问才用 BLE。**

## 六、ESP-NOW
> ESP-NOW 是乐鑫自己的**无连接、点对点**协议：不用路由器、不用配对，两个设备只要知道对方 MAC 就能发数据。延迟极低（毫秒级），特别适合**遥控器、多个传感器组网**。

### 1. 先拿到 MAC 地址
```cpp
#include <WiFi.h>

void setup() {
  Serial.begin(115200);
  WiFi.mode(WIFI_STA);
  Serial.print("我的 MAC: ");
  Serial.println(WiFi.macAddress());     // 形如 3C:84:27:AA:BB:CC
}

void loop() { }
```
**两台设备各跑一次，记下对方的 MAC。**

### 2. 接收端
```cpp
#include <esp_now.h>
#include <WiFi.h>

typedef struct {
  int   id;
  float value;
} MyData;

MyData data;

void OnRecv(const uint8_t *mac, const uint8_t *incoming, int len) {
  memcpy(&data, incoming, sizeof(data));
  Serial.printf("收到 id=%d value=%.2f\n", data.id, data.value);
}

void setup() {
  Serial.begin(115200);
  WiFi.mode(WIFI_STA);

  if (esp_now_init() != ESP_OK) {
    Serial.println("ESP-NOW 初始化失败");
    return;
  }
  esp_now_register_recv_cb(OnRecv);      // 2.x 签名: (mac, data, len)
}

void loop() { }
```

### 3. 发送端
```cpp
#include <esp_now.h>
#include <WiFi.h>

typedef struct {
  int   id;
  float value;
} MyData;

// 填接收端的 MAC
uint8_t peerMac[] = {0x3C, 0x84, 0x27, 0xAA, 0xBB, 0xCC};
MyData data;

void OnSent(const uint8_t *mac, esp_now_send_status_t status) {
  Serial.println(status == ESP_NOW_SEND_SUCCESS ? "发送成功" : "发送失败");
}

void setup() {
  Serial.begin(115200);
  WiFi.mode(WIFI_STA);

  esp_now_init();
  esp_now_register_send_cb(OnSent);

  esp_now_peer_info_t peer = {};
  memcpy(peer.peer_addr, peerMac, 6);
  peer.channel = 0;                       // 0 = 跟随当前信道
  peer.encrypt = false;
  esp_now_add_peer(&peer);
}

void loop() {
  data.id = 1;
  data.value = analogRead(1) * 3.3 / 4095.0;
  esp_now_send(peerMac, (uint8_t *)&data, sizeof(data));
  delay(1000);
}
```

### 4. 一对多
一台主控要控制多个节点，有两种做法：

| 做法 | 说明 | 适合 |
| --- | --- | --- |
| 广播 | MAC 填 `FF:FF:FF:FF:FF:FF`，所有节点都收到 | 同步下发指令 |
| 逐个添加 peer | 每个节点 `esp_now_add_peer()`，按需单独发 | 分别控制 |

```cpp
// 广播地址
uint8_t broadcast[] = {0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF};
```

> **ESP-NOW 的坑：**
> - 双方必须在**同一信道**（都连同一个路由器，或都用 channel 0 跟随）
> - ESP-NOW **没有确认和重传**机制，重要数据要自己做序号和校验
> - 单包最大 **250 字节**

## 七、USB

ESP32-S3 内置 **USB-OTG**，让它可以扮演各种 USB 设备。前提是线插 **OTG 口**，并在 **工具 → USB Mode** 里选对模式。

### 1. S3 能做哪些 USB 设备

| 模式 | 作用 | 需要的设置 |
| --- | --- | --- |
| **USB CDC** | 虚拟串口，替代 CH340 | USB CDC On Boot = **Enabled** |
| **USB HID** | 模拟键盘 / 鼠标 / 手柄 | USB Mode = **USB-OTG (TinyUSB)** |
| **USB MSC** | 变成一个 U 盘 | MSC On Boot = **Enabled (Requires USB-OTG Mode)** |
| USB DFU | 固件升级模式 | DFU On Boot = Enabled |

### 2. USB CDC 虚拟串口
把 **USB CDC On Boot** 设为 **Enabled**，然后用 OTG 口连电脑：

```cpp
void setup() {
  Serial.begin(115200);
  delay(1000);                 // 等 USB 枚举完成，否则前几行会丢
  Serial.println("这条消息走的是原生 USB！");
}

void loop() { }
```

电脑上会出现一个 COM 口（可能叫 **USB JTAG/serial debug unit** 或 **USB 串行设备**），打开就能看到打印——**不需要 CH340**。

> **为什么加 `delay(1000)`？** USB 枚举需要时间，太快打印会丢前几行。这是 CDC 的经典坑。

### 3. USB HID：模拟键盘
先把 **USB Mode 设为 USB-OTG (TinyUSB)**，然后：

```cpp
#include "USB.h"
#include "USBHIDKeyboard.h"

USBHIDKeyboard Keyboard;

void setup() {
  USB.begin();
  Keyboard.begin();
  delay(3000);                 // 等电脑认出键盘
  Keyboard.println("Hello from ESP32-S3!");
}

void loop() { }
```

烧录后拔掉再插上，电脑会把它识别成**一个键盘**，然后自动打出那行字。

> **<span style="color: red;">安全提示：</span>** HID 键盘代码一上电就会执行。如果写了个死循环狂发按键，可能把你电脑搞到打不开东西——建议先留 `delay(5000)` 给自己拔线的时间。

### 4. USB MSC：变成 U 盘
把 **MSC On Boot** 设为 **Enabled**，插上电脑后会出现一个盘符，里面是你板子内部 Flash 上的文件系统。适合做「配置文件拷进去」这种免数据线传输。

### 5. USB 口和 UART 口到底有啥区别

| | UART 口（CH340） | USB 口（原生 OTG） |
| --- | --- | --- |
| 芯片 | 经 CH340 转换 | 直连 S3 内部 USB |
| 需要驱动 | 需要 CH340 驱动 | 系统自带 |
| 能做 CDC | ✅ | ✅（要开 CDC On Boot） |
| 能做 HID / MSC | ❌ | ✅ |
| 稳定性 | 更稳 | 偶尔要重插 |
| 上传 | 一直可以 | 需选对 Upload Mode |

### 6. (c) USB 蓝牙适配器（dongle）——能做，但不在 Arduino 里
这是很多人的想法：**把 ESP32-S3 插到电脑上，让电脑多出一个蓝牙适配器**。

**技术上可行**：让 S3 通过 USB 扮演一个 **HCI 蓝牙控制器**（USB Bluetooth dongle 的标准设备类），电脑的操作系统用自带的蓝牙协议栈，S3 只负责「射频收发」。

**但要注意三点：**

1. **Arduino 框架下没有现成方案。** Arduino-ESP32 核心只提供 CDC / HID / MSC 这几类设备类，**没有 HCI dongle 的设备类**，需要自己写 USB 描述符和端点。这条路必须走 **ESP-IDF**（乐鑫的 `esp-iot-solution` 里有 `usb_dongle` 例程）。
2. **驱动是个问题。** Windows 对非标蓝牙 dongle 支持很差，通常需要额外驱动；Linux 下相对好用。
3. **Arduino 里能做到的近似方案**：把 S3 做成 **BLE HID**（模拟键盘/鼠标/手柄）或 **BLE 串口**——功能上替代了「蓝牙适配器」的一部分用途，但**电脑不会多出一个蓝牙图标**。

> **给初学者的实际建议**：真想玩这个，等熟悉了 ESP-IDF 再说。现在买个十几块的 USB 蓝牙适配器，成本远低于自己折腾。

## 八、综合实战：手机 BLE 遥控 + PWM 调光
把前面的东西串起来：手机发指令 → BLE 接收 → PWM 调亮度 → 数据回传手机。

```cpp
#include <BLEDevice.h>
#include <BLEServer.h>
#include <BLEUtils.h>
#include <BLE2902.h>

#define LED_PIN 48
#define CH      0
BLECharacteristic *pTx;
bool connected = false;

#define SERVICE_UUID "6E400001-B5A3-F393-E0A9-E50E24DCCA9E"
#define RX_UUID      "6E400002-B5A3-F393-E0A9-E50E24DCCA9E"
#define TX_UUID      "6E400003-B5A3-F393-E0A9-E50E24DCCA9E"

class ServerCB : public BLEServerCallbacks {
  void onConnect(BLEServer *s) {
    connected = true;
  }
  void onDisconnect(BLEServer *s) {
    connected = false;
    s->startAdvertising();
  }
};

class RxCB : public BLECharacteristicCallbacks {
  void onWrite(BLECharacteristic *c) {
    std::string v = c->getValue();
    int duty = atoi(v.c_str());          // 手机发 "0"~"255"
    if (duty < 0)   duty = 0;
    if (duty > 255) duty = 255;
    ledcWrite(CH, duty);                 // 调光
    Serial.printf("收到 duty=%d\n", duty);
  }
};

void setup() {
  Serial.begin(115200);

  ledcSetup(CH, 5000, 8);
  ledcAttachPin(LED_PIN, CH);

  BLEDevice::init("ESP32S3-DIMMER");
  BLEServer *server = BLEDevice::createServer();
  server->setCallbacks(new ServerCB());
  BLEService *svc = server->createService(SERVICE_UUID);

  BLECharacteristic *rx = svc->createCharacteristic(
      RX_UUID, BLECharacteristic::PROPERTY_WRITE | BLECharacteristic::PROPERTY_WRITE_NR);
  rx->setCallbacks(new RxCB());

  pTx = svc->createCharacteristic(TX_UUID, BLECharacteristic::PROPERTY_NOTIFY);
  pTx->addDescriptor(new BLE2902());

  svc->start();
  BLEAdvertising *adv = BLEDevice::getAdvertising();
  adv->addServiceUUID(SERVICE_UUID);
  adv->setScanResponse(true);
  adv->start();
}

void loop() {
  static unsigned long last = 0;
  if (connected && millis() - last > 1000) {
    last = millis();
    String s = "运行 " + String(millis() / 1000) + "s";
    pTx->setValue(s.c_str());
    pTx->notify();
  }
}
```

## 附录

### 1. 常用引脚速查（以 DevKit 为准，各板略有差异）

| 类别 | 引脚 | 备注 |
| --- | --- | --- |
| 原生 USB | GPIO19 (D-)、GPIO20 (D+) | 用 USB 功能时别占用 |
| UART0 | GPIO43 (TX)、GPIO44 (RX) | 接 CH340，也是下载口 |
| I2C（默认） | GPIO8 (SDA)、GPIO9 (SCL) | 可自定义 |
| SPI | GPIO10~13 | 可自定义 |
| ADC1 | GPIO1~GPIO10 | Wi-Fi 开启时仍可用 |
| ADC2 | GPIO11~GPIO20 | **开 Wi-Fi 后不可用** |
| Strapping | GPIO0 / 3 / 45 / 46 | 上电时保持默认电平 |
| 内部占用 | GPIO26~32 | 接 Flash/PSRAM，**禁用** |

### 2. 常见报错速查

| 现象 | 原因 | 解决 |
| --- | --- | --- |
| 上传报 `Failed to connect` | 没进下载模式 | 按住 BOOT → 点 RST → 松 BOOT |
| 串口一个字符都没有 | USB CDC On Boot 没开 | 工具里设为 Enabled，或换 UART 口 |
| 一运行就重启 | PSRAM 类型选错 | 8/16MB 选 OPI，2MB 选 QSPI |
| `Sketch too big` | 分区方案太小 | 换更大的 Partition Scheme |
| `BluetoothSerial.h: No such file` | **S3 没有经典蓝牙** | 改用 BLE |
| `ledcSetup` 在 3.x 报错 | API 变了 | 改用 `ledcAttach(pin, freq, res)` |
| ADC 读数乱跳 | 用了 ADC2 且开着 Wi-Fi | 换到 ADC1（GPIO1~10） |
| ESP-NOW 收不到 | 信道不一致 / MAC 填错 | 检查信道，核对 MAC |
| 连不上 Wi-Fi | 用了 5GHz 频段 | 换 2.4GHz |

### 3. 参考资料
- Arduino-ESP32 官方文档：`https://docs.espressif.com/projects/arduino-esp32/`
- 2.x → 3.0 迁移指南（PWM / BLE 变更）：`https://docs.espressif.com/projects/arduino-esp32/en/latest/migration_guides/2.x_to_3.0.html`
- ESP32-S3 产品页：`https://www.espressif.com.cn/zh-hans/products/socs/esp32-s3`
