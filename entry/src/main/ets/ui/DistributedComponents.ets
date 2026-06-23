/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
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

import { DeviceInfo, MigrationStatus } from '../util/DistributedManager';

/**
 * 设备图标组件
 */
@Component
export struct DeviceIcon {
  @Prop deviceType: string = 'phone';
  
  build() {
    Image(this.getDeviceIcon())
      .width(40)
      .height(40)
      .fillColor($r('sys.color.ohos_id_color_text_primary'))
  }
  
  private getDeviceIcon(): Resource {
    switch (this.deviceType) {
      case 'phone':
        return $r('app.media.kit_hwpay_wallet');
      case 'tablet':
        return $r('app.media.kit_hwpay_wallet');
      case 'tv':
        return $r('app.media.kit_hwpay_wallet');
      default:
        return $r('app.media.kit_hwpay_wallet');
    }
  }
}

/**
 * 设备列表项组件
 */
@Component
export struct DeviceListItem {
  @Prop device: DeviceInfo | null = null;
  @Prop isMigrating: boolean = false;
  onDeviceClick?: (device: DeviceInfo) => void;
  
  build() {
    Row() {
      // 设备图标
      DeviceIcon({ deviceType: this.device?.deviceType || 'phone' })
      
      Blank().width(16)
      
      // 设备信息
      Column() {
        Text(this.device?.deviceName || 'Unknown Device')
          .fontSize(16)
          .fontWeight(FontWeight.Medium)
          .fontColor($r('sys.color.ohos_id_color_text_primary'))
        
        Text(this.getDeviceTypeText())
          .fontSize(14)
          .fontColor($r('sys.color.ohos_id_color_text_secondary'))
          .margin({ top: 4 })
      }
      .alignItems(HorizontalAlign.Start)
      .layoutWeight(1)
      
      // 在线状态
      if (this.device?.isOnline) {
        Text('在线')
          .fontSize(12)
          .fontColor('#00AA00')
          .backgroundColor('#E8F5E9')
          .borderRadius(4)
          .padding({ left: 8, right: 8, top: 4, bottom: 4 })
      } else {
        Text('离线')
          .fontSize(12)
          .fontColor('#999999')
          .backgroundColor('#F5F5F5')
          .borderRadius(4)
          .padding({ left: 8, right: 8, top: 4, bottom: 4 })
      }
    }
    .width('100%')
    .height(80)
    .backgroundColor($r('sys.color.ohos_id_color_background'))
    .borderRadius(12)
    .padding(16)
    .onClick(() => {
      if (this.device && this.onDeviceClick) {
        this.onDeviceClick(this.device);
      }
    })
    .opacity(this.isMigrating ? 0.5 : 1)
    .enabled(!this.isMigrating)
  }
  
  private getDeviceTypeText(): string {
    switch (this.device?.deviceType) {
      case 'phone':
        return '手机';
      case 'tablet':
        return '平板';
      case 'tv':
        return '电视';
      case 'wearable':
        return '穿戴设备';
      default:
        return '未知设备';
    }
  }
}

/**
 * 流转状态指示器
 */
@Component
export struct MigrationStatusIndicator {
  @Prop status: MigrationStatus = MigrationStatus.IDLE;
  
  build() {
    Row() {
      // 状态图标
      if (this.status === MigrationStatus.DISCOVERING || 
          this.status === MigrationStatus.MIGRATING) {
        LoadingProgress()
          .width(20)
          .height(20)
          .color($r('sys.color.ohos_id_color_emphasize'))
      } else if (this.status === MigrationStatus.SUCCESS) {
        Text('✓')
          .fontSize(20)
          .fontColor('#00AA00')
      } else if (this.status === MigrationStatus.FAILED) {
        Text('✗')
          .fontSize(20)
          .fontColor('#FF0000')
      }
      
      Blank().width(8)
      
      // 状态文本
      Text(this.getStatusText())
        .fontSize(14)
        .fontColor($r('sys.color.ohos_id_color_text_primary'))
    }
    .padding({ left: 16, right: 16, top: 8, bottom: 8 })
    .backgroundColor($r('sys.color.ohos_id_color_background'))
    .borderRadius(8)
  }
  
  private getStatusText(): string {
    switch (this.status) {
      case MigrationStatus.IDLE:
        return '空闲';
      case MigrationStatus.DISCOVERING:
        return '发现设备中...';
      case MigrationStatus.READY:
        return '准备就绪';
      case MigrationStatus.MIGRATING:
        return '迁移中...';
      case MigrationStatus.SUCCESS:
        return '迁移成功';
      case MigrationStatus.FAILED:
        return '迁移失败';
      default:
        return '未知状态';
    }
  }
}

/**
 * 设备发现面板
 */
@Component
export struct DeviceDiscoveryPanel {
  @Link devices: DeviceInfo[];
  @Link migrationStatus: MigrationStatus;
  onStartDiscovery: () => void = () => {};
  onStopDiscovery: () => void = () => {};
  onMigrate: (deviceId: string) => void = () => {};
  
  build() {
    Column() {
      // 标题栏
      Row() {
        Text('设备流转')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('sys.color.ohos_id_color_text_primary'))
        
        Blank()
        
        // 状态指示器
        MigrationStatusIndicator({ status: this.migrationStatus })
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 12, bottom: 12 })
      
      Divider().color($r('sys.color.ohos_id_color_list_separator'))
      
      // 操作按钮
      Row() {
        Button(this.migrationStatus === MigrationStatus.DISCOVERING ? '停止发现' : '发现设备')
          .fontSize(16)
          .fontColor(Color.White)
          .backgroundColor($r('sys.color.ohos_id_color_emphasize'))
          .borderRadius(8)
          .layoutWeight(1)
          .onClick(() => {
            if (this.migrationStatus === MigrationStatus.DISCOVERING) {
              this.onStopDiscovery();
            } else {
              this.onStartDiscovery();
            }
          })
      }
      .width('100%')
      .padding(16)
      
      // 设备列表
      if (this.devices.length > 0) {
        Text(`发现 ${this.devices.length} 个设备`)
          .fontSize(14)
          .fontColor($r('sys.color.ohos_id_color_text_secondary'))
          .margin({ left: 16, bottom: 8 })
        
        List() {
          ForEach(this.devices, (device: DeviceInfo) => {
            ListItem() {
              DeviceListItem({
                device: device,
                isMigrating: this.migrationStatus === MigrationStatus.MIGRATING,
                onDeviceClick: (selectedDevice: DeviceInfo) => {
                  this.onMigrate(selectedDevice.deviceId);
                }
              })
            }
          }, (device: DeviceInfo) => device.deviceId)
        }
        .width('100%')
        .layoutWeight(1)
        .padding({ left: 16, right: 16 })
        .divider({ 
          strokeWidth: 1, 
          color: $r('sys.color.ohos_id_color_list_separator'),
          startMargin: 16,
          endMargin: 16
        })
      } else {
        Column() {
          Text('暂无可用设备')
            .fontSize(16)
            .fontColor($r('sys.color.ohos_id_color_text_secondary'))
          
          Text('点击"发现设备"搜索附近的设备')
            .fontSize(14)
            .fontColor($r('sys.color.ohos_id_color_text_secondary'))
            .margin({ top: 8 })
        }
        .width('100%')
        .layoutWeight(1)
        .justifyContent(FlexAlign.Center)
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('sys.color.ohos_id_color_sub_background'))
    .borderRadius(16)
  }
}
