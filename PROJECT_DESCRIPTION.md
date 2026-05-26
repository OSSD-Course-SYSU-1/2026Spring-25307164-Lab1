# 鸿蒙支付收银台工程文件描述文档

## 📋 项目概述

**项目名称**：鸿蒙支付收银台示例（PaymentKit Sample Code）  
**项目类型**：HarmonyOS应用（Entry模块）  
**开发语言**：ArkTS  
**SDK版本**：HarmonyOS 5.0.4 Release  
**项目来源**：华为官方PaymentKit示例代码

---

## 📁 工程目录结构

```
paymentkit-samplecode-uxcodeproject-arkts-master/
├── AppScope/                          # 应用全局配置
│   ├── app.json5                      # 应用配置文件
│   └── resources/                     # 应用级资源
│       └── base/element/string.json   # 应用字符串资源
├── entry/                             # 主模块（Entry）
│   ├── src/main/
│   │   ├── ets/                       # ArkTS源代码
│   │   │   ├── data/                  # 数据模型层
│   │   │   │   ├── CustPayType.ets    # 自定义支付类型枚举
│   │   │   │   ├── PaymentType.ets    # 支付方式数据模型
│   │   │   │   └── TestData.ets       # 测试数据
│   │   │   ├── entryability/          # 应用入口
│   │   │   │   └── EntryAbility.ets   # 生命周期管理
│   │   │   ├── pages/                 # 页面层
│   │   │   │   └── Index.ets          # 主页面入口
│   │   │   ├── ui/                    # UI组件层
│   │   │   │   ├── Amount.ets         # 金额显示组件
│   │   │   │   ├── CashierBindSheetContainer.ets  # 收银台容器
│   │   │   │   ├── CashierComponent.ets           # 收银台主组件
│   │   │   │   ├── ConfirmButton.ets  # 确认支付按钮
│   │   │   │   ├── PaymentItemComp.ets # 支付方式项组件
│   │   │   │   └── PaymentOrderComp.ets # 商户订单组件
│   │   │   └── util/                  # 工具类
│   │   │       └── PaymentUtil.ets    # 支付工具函数
│   │   ├── resources/                 # 资源文件
│   │   │   ├── base/                  # 基础资源
│   │   │   │   ├── element/           # 字符串、颜色、尺寸
│   │   │   │   ├── media/             # 图片资源
│   │   │   │   └── profile/           # 配置文件
│   │   │   ├── dark/                  # 暗黑模式资源
│   │   │   ├── en_US/                 # 英文资源
│   │   │   └── zh_CN/                 # 中文资源
│   │   └── module.json5               # 模块配置文件
│   ├── build-profile.json5            # 构建配置
│   ├── hvigorfile.ts                  # 构建脚本
│   └── oh-package.json5               # 依赖配置
├── hvigor/                            # Hvigor构建工具配置
├── screenshots/                       # 截图目录
│   └── device/                        # 设备截图
│       └── cashier_run_result.png     # 运行效果截图
├── build-profile.json5                # 应用构建配置
├── hvigorfile.ts                      # 应用构建脚本
├── oh-package.json5                   # 应用依赖配置
├── README.md                          # 项目说明文档
└── LICENSE                            # Apache 2.0许可证
```

---

## 📄 核心文件详细说明

### 1. 配置文件

#### 1.1 AppScope/app.json5
**文件路径**：`AppScope/app.json5`  
**文件作用**：应用级全局配置  
**主要内容**：
```json5
{
  "app": {
    "bundleName": "com.example.uxcodeproject",    // 应用包名
    "vendor": "example",                          // 开发者名称
    "versionCode": 1000000,                       // 版本号
    "versionName": "1.0.0",                       // 版本名称
    "icon": "$media:app_icon",                    // 应用图标
    "label": "$string:app_name"                   // 应用名称
  }
}
```

#### 1.2 entry/src/main/module.json5
**文件路径**：`entry/src/main/module.json5`  
**文件作用**：模块配置文件，定义模块基本信息和能力  
**主要内容**：
- **模块类型**：entry（入口模块）
- **支持设备**：phone（手机）
- **主入口**：EntryAbility
- **页面配置**：引用main_pages.json
- **能力配置**：定义了EntryAbility，支持系统主界面启动

---

### 2. 数据模型层（data/）

#### 2.1 CustPayType.ets
**文件路径**：`entry/src/main/ets/data/CustPayType.ets`  
**文件作用**：自定义支付类型枚举定义  
**代码行数**：21行  
**核心内容**：
```typescript
export enum CustPayType {
  NewBankCard = 'NewBankCard',  // 新增银行卡
}
```
**功能说明**：定义自定义支付类型枚举，目前仅包含新增银行卡类型。

#### 2.2 PaymentType.ets
**文件路径**：`entry/src/main/ets/data/PaymentType.ets`  
**文件作用**：支付方式数据模型类  
**代码行数**：25行  
**核心内容**：
```typescript
export class PaymentType {
  payTypeSerialNo?: string;      // 支付方式序列号
  payTypeDesc?: string;          // 支付方式描述（显示名称）
  paymentTypeTip?: string;       // 支付方式提示信息
  isAvailable?: boolean;         // 是否可用
  custPayType: string = '';      // 自定义支付类型
}
```
**功能说明**：定义支付方式的数据结构，包含支付方式的各项属性信息。

#### 2.3 TestData.ets
**文件路径**：`entry/src/main/ets/data/TestData.ets`  
**文件作用**：测试数据定义  
**代码行数**：46行  
**核心内容**：
- **paymentTypeList**：银行卡支付方式列表
  - xx银行储蓄卡 (0606)
  - xx银行储蓄卡 (0909)
- **paymentTypes3PayShow**：第三方支付方式列表
  - 云闪付
  - 微信支付

**功能说明**：提供测试用的支付方式数据，模拟真实支付场景。

---

### 3. 应用入口（entryability/）

#### 3.1 EntryAbility.ets
**文件路径**：`entry/src/main/ets/entryability/EntryAbility.ets`  
**文件作用**：应用生命周期管理入口  
**代码行数**：59行  
**核心功能**：
- **onCreate**：应用创建时初始化，设置颜色模式
- **onDestroy**：应用销毁时的清理工作
- **onWindowStageCreate**：窗口创建时加载主页面（pages/Index）
- **onWindowStageDestroy**：窗口销毁处理
- **onForeground**：应用进入前台
- **onBackground**：应用进入后台

**关键代码**：
```typescript
windowStage.loadContent('pages/Index', (err) => {
  // 加载主页面
});
```

---

### 4. 页面层（pages/）

#### 4.1 Index.ets
**文件路径**：`entry/src/main/ets/pages/Index.ets`  
**文件作用**：应用主页面入口  
**代码行数**：26行  
**核心内容**：
```typescript
@Entry
@Component
struct Index {
  build() {
    Column() {
      CashierBindSheetContainer();  // 加载收银台容器
    }.width('100%');
  }
}
```
**功能说明**：作为应用的主入口页面，加载收银台容器组件。

---

### 5. UI组件层（ui/）

#### 5.1 CashierComponent.ets ⭐核心组件
**文件路径**：`entry/src/main/ets/ui/CashierComponent.ets`  
**文件作用**：收银台主界面组件  
**代码行数**：256行  
**核心属性**：
- `mercShortName`：商户名称（默认："华为支付测试商户"）
- `paymentAmount`：支付金额（默认："0.01"）
- `selectedPaymentType`：选中的支付方式（@State状态变量）
- `selectedPayTypeSerialNo`：选中的支付方式序列号（@State状态变量）

**核心Builder方法**：
1. **orderDetail()**：头部商户订单信息区域
2. **displayHeader()**：支付方式列表标题
3. **moreBankFooter()**：其他支付方式入口
4. **paymentListBuilder()**：支付方式列表构建
5. **paymentListContent()**：支付方式列表容器
6. **buttonArea()**：底部按钮区域
7. **cashierUI()**：收银台完整UI布局

**功能说明**：收银台的核心组件，整合了商户信息、支付方式列表和支付按钮。

#### 5.2 CashierBindSheetContainer.ets
**文件路径**：`entry/src/main/ets/ui/CashierBindSheetContainer.ets`  
**文件作用**：收银台半模态容器  
**代码行数**：43行  
**核心功能**：
- 使用`bindSheet`实现半模态弹窗
- 配置半模态参数：
  - `height: SheetSize.FIT_CONTENT`（自适应高度）
  - `showClose: true`（显示关闭按钮）
  - `backgroundColor: '#E5FFFFFF'`（半透明背景）
  - `blurStyle: BlurStyle.COMPONENT_THICK`（模糊效果）

**功能说明**：将收银台组件包装为半模态弹窗形式展示。

#### 5.3 Amount.ets
**文件路径**：`entry/src/main/ets/ui/Amount.ets`  
**文件作用**：金额显示组件  
**代码行数**：43行  
**核心属性**：
- `amount`：金额数值（@Prop）
- `currency`：货币符号（默认："¥"）
- `color`：文字颜色

**UI结构**：
```
Row {
  Text {
    Span("¥")  // 货币符号，24号字体
    Span("0.01")  // 金额数值，36号字体
  }
}
```
**功能说明**：以大字号显示支付金额，货币符号和金额数值分别使用不同字号。

#### 5.4 PaymentOrderComp.ets
**文件路径**：`entry/src/main/ets/ui/PaymentOrderComp.ets`  
**文件作用**：商户订单信息组件  
**代码行数**：37行  
**核心属性**：
- `mercShortName`：商户名称（@Prop）
- `paymentAmount`：支付金额（@Prop）

**UI结构**：
```
Column {
  Text("华为支付测试商户")  // 商户名称
  Amount({ amount: "0.01" })  // 金额组件
}
```
**功能说明**：展示商户名称和支付金额信息。

#### 5.5 PaymentItemComp.ets
**文件路径**：`entry/src/main/ets/ui/PaymentItemComp.ets`  
**文件作用**：支付方式项组件  
**代码行数**：103行  
**核心属性**：
- `paymentType`：支付方式数据（@Prop）
- `canChecked`：是否可选中（@Prop）
- `isChecked`：是否已选中（@Prop）
- `onSelect`：选中回调函数

**UI结构**：
```
Row {
  Image()  // 支付方式图标
  Flex {
    Text("xx银行储蓄卡")  // 支付方式名称
    Text("提示信息")  // 可选提示
  }
  Radio() 或 Image()  // 选中状态或箭头图标
}
```
**功能说明**：单个支付方式的展示组件，支持选中状态显示和点击交互。

#### 5.6 ConfirmButton.ets
**文件路径**：`entry/src/main/ets/ui/ConfirmButton.ets`  
**文件作用**：确认支付按钮组件  
**代码行数**：65行  
**核心属性**：
- `text`：按钮文字（@Prop）

**UI特性**：
- 圆角按钮（borderRadius: 20）
- 最小高度40vp
- 支持触摸聚焦（focusOnTouch: true）
- 支持状态效果（stateEffect: true）

**功能说明**：支付确认按钮，点击后执行支付逻辑（当前为示例，未实现具体支付功能）。

---

### 6. 工具类（util/）

#### 6.1 PaymentUtil.ets
**文件路径**：`entry/src/main/ets/util/PaymentUtil.ets`  
**文件作用**：支付相关工具函数  
**代码行数**：39行  
**核心函数**：

1. **isNewCardPaymentType(paymentType: PaymentType): boolean**
   - 功能：判断是否为新卡支付类型
   - 参数：支付方式对象
   - 返回：布尔值

2. **getBorderRadius(length: number): number**
   - 功能：计算图标圆角值
   - 公式：`7 / 27 * length`
   - 参数：图标边长
   - 返回：圆角值

**功能说明**：提供支付相关的通用工具函数。

---

## 🎨 资源文件说明

### 1. 图片资源（media/）
- `app_icon.png`：应用图标
- `payment_logo.png`：支付方式默认图标
- `kit_hwpay_wallet.webp`：华为支付钱包图标
- `kit_hwpay_right_v2.svg`：右箭头图标
- `startIcon.png`：启动图标
- `foreground.png`：前景图标
- `background.png`：背景图标

### 2. 字符串资源（element/string.json）
- `app_name`：应用名称
- `kit_hwpay_desc`：华为支付描述
- `kit_hwpay_change_other_pay_type`：更换支付方式文案
- `kit_hwpay_checkout_confirm_pay`：确认支付按钮文案

### 3. 颜色资源（element/color.json）
- 支持亮色和暗色两套颜色主题
- 使用系统颜色资源保持一致性

---

## 🔧 技术架构特点

### 1. 组件化设计
- 采用ArkTS组件化开发模式
- 使用`@Component`装饰器定义组件
- 使用`@Builder`装饰器构建UI片段
- 使用`@State`和`@Prop`进行状态管理

### 2. 状态管理
- `@State`：组件内部可变状态
- `@Prop`：父子组件单向数据传递
- 状态变化自动触发UI更新

### 3. UI布局
- 使用Flex、Column、Row进行布局
- 使用List和ListItemGroup实现列表
- 使用bindSheet实现半模态弹窗

### 4. 样式规范
- 遵循HarmonyOS设计规范
- 使用系统资源（$r('sys.xxx')）保持一致性
- 支持深色模式自适应

---

## 📊 代码统计

| 文件类型 | 文件数量 | 代码行数 |
|---------|---------|---------|
| 配置文件（.json5） | 8 | ~150行 |
| ArkTS代码（.ets） | 11 | ~700行 |
| 资源文件 | 15+ | - |
| **总计** | **34+** | **~850行** |

---

## 🚀 功能特性

### 已实现功能
✅ 商户信息展示  
✅ 支付金额显示  
✅ 支付方式列表展示  
✅ 支付方式选择交互  
✅ 选中状态显示  
✅ 半模态弹窗展示  
✅ 深色模式支持  

### 待实现功能
⏳ 真实支付流程  
⏳ 支付结果反馈  
⏳ 订单历史记录  
⏳ 支付统计功能  

---

## 📝 开发规范

### 1. 命名规范
- 组件名：大驼峰（CashierComponent）
- 函数名：小驼峰（selectPaymentType）
- 变量名：小驼峰（paymentAmount）
- 常量名：全大写下划线（FONT_FAMILY_HEITI）

### 2. 文件组织
- 按功能模块划分目录
- 数据、UI、工具分离
- 资源文件统一管理

### 3. 代码风格
- 遵循Apache 2.0许可证
- 包含版权声明头
- 使用系统资源保持一致性

---

## 📌 总结

本项目是一个基于HarmonyOS的支付收银台UI示例，展示了如何使用ArkTS和ArkUI构建符合鸿蒙设计规范的支付界面。项目结构清晰，组件化程度高，代码规范，适合作为学习HarmonyOS UI开发的参考示例。

**核心价值**：
1. 展示了HarmonyOS组件化开发最佳实践
2. 实现了符合设计规范的支付收银台UI
3. 提供了可复用的UI组件库
4. 演示了状态管理和数据流的使用方法

---

**文档版本**：v1.0  
**创建日期**：2025-05-26  
**作者**：HarmonyOS开发助手
