/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License,Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { CashierBindSheetContainer } from '../ui/CashierBindSheetContainer';
import { router } from '@kit.ArkUI';
import { ConfigurationConstant } from '@kit.AbilityKit';
import { ResponsiveLayoutUtil, BreakpointType, DeviceType } from '../util/ResponsiveLayoutUtil';
import { DistributedManager, DeviceInfo, MigrationStatus } from '../util/DistributedManager';
import { DeviceDiscoveryPanel } from '../ui/DistributedComponents';

@Entry
@Component
struct Index {
  @State isDarkMode: boolean = false;
  @State currentBreakpoint: BreakpointType = BreakpointType.SM;
  @State currentDeviceType: DeviceType = DeviceType.PHONE;
  @State windowWidth: number = 0;
  @State windowHeight: number = 0;
  @State showDistributedPanel: boolean = false;
  @State discoveredDevices: DeviceInfo[] = [];
  @State migrationStatus: MigrationStatus = MigrationStatus.IDLE;
  
  private responsiveUtil: ResponsiveLayoutUtil = ResponsiveLayoutUtil.getInstance();
  private distributedManager: DistributedManager = DistributedManager.getInstance();

  aboutToAppear(): void {
    // 初始化窗口尺寸
    this.updateResponsiveConfig();
    
    // 设置流转管理器回调
    this.distributedManager.setDeviceDiscoveryCallback((devices: DeviceInfo[]) => {
      this.discoveredDevices = devices;
    });
    
    this.distributedManager.setStatusChangeCallback((status: MigrationStatus) => {
      this.migrationStatus = status;
    });
  }

  // 更新响应式配置
  private updateResponsiveConfig(): void {
    this.currentBreakpoint = this.responsiveUtil.getCurrentBreakpoint();
    this.currentDeviceType = this.responsiveUtil.getCurrentDeviceType();
  }

  // Navigation button component - 响应式
  @Builder
  navButton(icon: Resource, title: string, targetPage: string) {
    Column() {
      Image(icon)
        .width(this.responsiveUtil.valueByBreakpoint(32, 40, 48, 56, 64))
        .height(this.responsiveUtil.valueByBreakpoint(32, 40, 48, 56, 64))
        .fillColor($r('sys.color.ohos_id_color_text_primary'))
      
      Text(title)
        .fontSize(this.responsiveUtil.valueByBreakpoint(12, 14, 16, 18, 20))
        .fontColor($r('sys.color.ohos_id_color_text_primary'))
        .margin({ top: this.responsiveUtil.valueByBreakpoint(4, 8, 12, 16, 20) })
    }
    .width(this.responsiveUtil.valueByBreakpoint(60, 80, 100, 120, 140))
    .height(this.responsiveUtil.valueByBreakpoint(60, 80, 100, 120, 140))
    .backgroundColor($r('sys.color.ohos_id_color_background'))
    .borderRadius(this.responsiveUtil.valueByBreakpoint(8, 12, 16, 20, 24))
    .justifyContent(FlexAlign.Center)
    .onClick(() => {
      router.pushUrl({ url: `pages/${targetPage}` });
    })
  }

  // 大屏布局
  @Builder
  largeScreenLayout() {
    Row() {
      // 左侧导航栏
      Column() {
        Text('支付收银台')
          .fontSize(this.responsiveUtil.valueByBreakpoint(18, 20, 24, 28, 32))
          .fontWeight(FontWeight.Bold)
          .fontColor($r('sys.color.ohos_id_color_text_primary'))
          .margin({ bottom: 32 })

        // 导航按钮垂直排列
        Column() {
          this.navButton($r('app.media.kit_hwpay_wallet'), '订单历史', 'OrderHistory');
          Blank().height(16)
          this.navButton($r('app.media.payment_logo'), '支付统计', 'Statistics');
          Blank().height(16)
          this.navButton($r('app.media.kit_hwpay_wallet'), '支付设置', 'Settings');
          Blank().height(16)
          
          // 流转按钮
          Column() {
            Image($r('app.media.kit_hwpay_wallet'))
              .width(40)
              .height(40)
              .fillColor($r('sys.color.ohos_id_color_text_primary'))
            
            Text('设备流转')
              .fontSize(14)
              .fontColor($r('sys.color.ohos_id_color_text_primary'))
              .margin({ top: 8 })
          }
          .width(80)
          .height(80)
          .backgroundColor($r('sys.color.ohos_id_color_background'))
          .borderRadius(12)
          .justifyContent(FlexAlign.Center)
          .onClick(() => {
            this.showDistributedPanel = true;
          })
        }
        .width('100%')
        
        Blank()
        
        // 主题切换按钮
        Button({ type: ButtonType.Circle }) {
          Image($r('app.media.kit_hwpay_right_v2'))
            .width(24)
            .height(24)
            .fillColor($r('sys.color.ohos_id_color_text_primary'))
        }
        .width(48)
        .height(48)
        .backgroundColor($r('sys.color.ohos_id_color_button_normal'))
        .onClick(() => {
          this.isDarkMode = !this.isDarkMode;
        })
      }
      .width(200)
      .height('100%')
      .padding(24)
      .backgroundColor($r('sys.color.ohos_id_color_background'))

      // 右侧内容区
      Column() {
        CashierBindSheetContainer();
      }
      .layoutWeight(1)
      .height('100%')
      .padding({ top: 24, right: 24, bottom: 24 })
    }
    .width('100%')
    .height('100%')
  }

  // 小屏布局
  @Builder
  smallScreenLayout() {
    Column() {
      // Top navigation bar
      Row() {
        Text('支付收银台')
          .fontSize(this.responsiveUtil.valueByBreakpoint(16, 20, 22, 24, 26))
          .fontWeight(FontWeight.Bold)
          .fontColor($r('sys.color.ohos_id_color_text_primary'))
          .layoutWeight(1)

        // Theme toggle button
        Button({ type: ButtonType.Circle }) {
          Image(this.isDarkMode ? $r('app.media.kit_hwpay_right_v2') : $r('app.media.kit_hwpay_right_v2'))
            .width(this.responsiveUtil.valueByBreakpoint(16, 20, 22, 24, 26))
            .height(this.responsiveUtil.valueByBreakpoint(16, 20, 22, 24, 26))
            .fillColor($r('sys.color.ohos_id_color_text_primary'))
        }
        .width(this.responsiveUtil.valueByBreakpoint(28, 36, 40, 44, 48))
        .height(this.responsiveUtil.valueByBreakpoint(28, 36, 40, 44, 48))
        .backgroundColor($r('sys.color.ohos_id_color_button_normal'))
        .onClick(() => {
          this.isDarkMode = !this.isDarkMode;
        })
      }
      .width('100%')
      .padding({ 
        left: this.responsiveUtil.valueByBreakpoint(8, 16, 20, 24, 32), 
        right: this.responsiveUtil.valueByBreakpoint(8, 16, 20, 24, 32), 
        top: this.responsiveUtil.valueByBreakpoint(8, 12, 16, 20, 24), 
        bottom: this.responsiveUtil.valueByBreakpoint(8, 12, 16, 20, 24) 
      })
      .backgroundColor($r('sys.color.ohos_id_color_background'))
      .zIndex(999)

      // Quick navigation
      Row() {
        this.navButton($r('app.media.kit_hwpay_wallet'), '订单历史', 'OrderHistory');
        
        Blank().width(this.responsiveUtil.valueByBreakpoint(8, 16, 20, 24, 32))
        
        this.navButton($r('app.media.payment_logo'), '支付统计', 'Statistics');
        
        Blank().width(this.responsiveUtil.valueByBreakpoint(8, 16, 20, 24, 32))
        
        this.navButton($r('app.media.kit_hwpay_wallet'), '支付设置', 'Settings');
        
        Blank().width(this.responsiveUtil.valueByBreakpoint(8, 16, 20, 24, 32))
        
        // 流转按钮
        Column() {
          Image($r('app.media.kit_hwpay_wallet'))
            .width(this.responsiveUtil.valueByBreakpoint(32, 40, 48, 56, 64))
            .height(this.responsiveUtil.valueByBreakpoint(32, 40, 48, 56, 64))
            .fillColor($r('sys.color.ohos_id_color_text_primary'))
          
          Text('流转')
            .fontSize(this.responsiveUtil.valueByBreakpoint(12, 14, 16, 18, 20))
            .fontColor($r('sys.color.ohos_id_color_text_primary'))
            .margin({ top: this.responsiveUtil.valueByBreakpoint(4, 8, 12, 16, 20) })
        }
        .width(this.responsiveUtil.valueByBreakpoint(60, 80, 100, 120, 140))
        .height(this.responsiveUtil.valueByBreakpoint(60, 80, 100, 120, 140))
        .backgroundColor($r('sys.color.ohos_id_color_background'))
        .borderRadius(this.responsiveUtil.valueByBreakpoint(8, 12, 16, 20, 24))
        .justifyContent(FlexAlign.Center)
        .onClick(() => {
          this.showDistributedPanel = true;
        })
      }
      .width('100%')
      .padding(this.responsiveUtil.valueByBreakpoint(8, 16, 20, 24, 32))
      .justifyContent(FlexAlign.Center)
      .backgroundColor($r('sys.color.ohos_id_color_background'))
      .zIndex(999)

      // Cashier container
      Column() {
        CashierBindSheetContainer();
      }
      .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('sys.color.ohos_id_color_sub_background'))
  }

  build() {
    Stack() {
      if (this.responsiveUtil.isLargeScreen()) {
        this.largeScreenLayout()
      } else {
        this.smallScreenLayout()
      }
      
      // 流转面板
      if (this.showDistributedPanel) {
        Column() {
          // 关闭按钮
          Row() {
            Blank()
            Button({ type: ButtonType.Circle }) {
              Text('×')
                .fontSize(24)
                .fontColor($r('sys.color.ohos_id_color_text_primary'))
            }
            .width(40)
            .height(40)
            .backgroundColor($r('sys.color.ohos_id_color_button_normal'))
            .onClick(() => {
              this.showDistributedPanel = false;
              this.distributedManager.stopDeviceDiscovery();
            })
          }
          .width('100%')
          .padding(16)
          
          // 设备发现面板
          DeviceDiscoveryPanel({
            devices: $discoveredDevices,
            migrationStatus: $migrationStatus,
            onStartDiscovery: () => {
              this.distributedManager.startDeviceDiscovery();
            },
            onStopDiscovery: () => {
              this.distributedManager.stopDeviceDiscovery();
            },
            onMigrate: (deviceId: string) => {
              this.distributedManager.migrateToDevice(deviceId);
            }
          })
        }
        .width('100%')
        .height('100%')
        .backgroundColor('rgba(0, 0, 0, 0.5)')
        .justifyContent(FlexAlign.Center)
        .padding(32)
        .onClick(() => {
          // 点击背景关闭面板
          this.showDistributedPanel = false;
          this.distributedManager.stopDeviceDiscovery();
        })
      }
    }
    .width('100%')
    .height('100%')
    .onAreaChange((oldValue: Area, newValue: Area) => {
      // 响应窗口尺寸变化
      const width = newValue.width as number;
      const height = newValue.height as number;
      this.windowWidth = width;
      this.windowHeight = height;
      this.responsiveUtil.updateWindowSize(width, height);
      this.updateResponsiveConfig();
    })
  }
}
