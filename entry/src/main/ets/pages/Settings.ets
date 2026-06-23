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

import { PaymentSettings, ConfirmMethod, availablePaymentMethods, globalSettings } from '../data/SettingsData';
import { router } from '@kit.ArkUI';

@Entry
@Component
struct SettingsPage {
  @State settings: PaymentSettings = new PaymentSettings();
  @State showMethodPicker: boolean = false;
  @State showConfirmPicker: boolean = false;

  aboutToAppear() {
    // Copy settings from global
    this.settings.defaultPaymentMethod = globalSettings.defaultPaymentMethod;
    this.settings.paymentReminder = globalSettings.paymentReminder;
    this.settings.smallAmountNoPassword = globalSettings.smallAmountNoPassword;
    this.settings.smallAmountLimit = globalSettings.smallAmountLimit;
    this.settings.confirmMethod = globalSettings.confirmMethod;
    this.settings.autoSaveCard = globalSettings.autoSaveCard;
    this.settings.showTransactionDetails = globalSettings.showTransactionDetails;
  }

  // Setting item component
  @Builder
  settingItem(title: string, subtitle: string, onClick: () => void) {
    Row() {
      Column() {
        Text(title)
          .fontSize(16)
          .fontColor($r('sys.color.ohos_id_color_text_primary'))
        
        Text(subtitle)
          .fontSize(12)
          .fontColor($r('sys.color.ohos_id_color_text_secondary'))
          .margin({ top: 4 })
      }
      .alignItems(HorizontalAlign.Start)
      .layoutWeight(1)

      Image($r('app.media.kit_hwpay_right_v2'))
        .width(20)
        .height(20)
        .fillColor($r('sys.color.ohos_id_color_text_secondary'))
    }
    .width('100%')
    .padding(16)
    .backgroundColor($r('sys.color.ohos_id_color_background'))
    .borderRadius(12)
    .onClick(onClick)
  }

  // Toggle item component
  @Builder
  toggleItem(title: string, description: string, isOn: boolean, onToggle: (value: boolean) => void) {
    Row() {
      Column() {
        Text(title)
          .fontSize(16)
          .fontColor($r('sys.color.ohos_id_color_text_primary'))
        
        Text(description)
          .fontSize(12)
          .fontColor($r('sys.color.ohos_id_color_text_secondary'))
          .margin({ top: 4 })
      }
      .alignItems(HorizontalAlign.Start)
      .layoutWeight(1)

      Toggle({ type: ToggleType.Switch, isOn: isOn })
        .onChange(onToggle)
        .selectedColor('#007DFF')
    }
    .width('100%')
    .padding(16)
    .backgroundColor($r('sys.color.ohos_id_color_background'))
    .borderRadius(12)
  }

  // Section header
  @Builder
  sectionHeader(title: string) {
    Text(title)
      .fontSize(14)
      .fontColor($r('sys.color.ohos_id_color_text_secondary'))
      .margin({ top: 16, bottom: 8 })
  }

  build() {
    Column() {
      // Top navigation bar
      Row() {
        Image($r('app.media.kit_hwpay_right_v2'))
          .width(24)
          .height(24)
          .fillColor($r('sys.color.ohos_id_color_text_primary'))
          .rotate({ angle: 180 })
          .onClick(() => {
            router.back();
          })

        Text('支付设置')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('sys.color.ohos_id_color_text_primary'))
          .layoutWeight(1)
          .margin({ left: 16 })
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 12, bottom: 12 })

      Scroll() {
        Column() {
          // Payment method settings
          this.sectionHeader('支付方式设置')
          
          this.settingItem(
            '默认支付方式',
            this.settings.defaultPaymentMethod,
            () => {
              this.showMethodPicker = true;
            }
          )

          // Security settings
          this.sectionHeader('安全设置')
          
          this.settingItem(
            '支付确认方式',
            this.settings.confirmMethod,
            () => {
              this.showConfirmPicker = true;
            }
          )

          this.toggleItem(
            '小额免密支付',
            `单笔${this.settings.smallAmountLimit}元以下无需密码`,
            this.settings.smallAmountNoPassword,
            (value: boolean) => {
              this.settings.smallAmountNoPassword = value;
            }
          )

          // Notification settings
          this.sectionHeader('通知设置')
          
          this.toggleItem(
            '支付提醒',
            '支付成功或失败时发送通知',
            this.settings.paymentReminder,
            (value: boolean) => {
              this.settings.paymentReminder = value;
            }
          )

          // Other settings
          this.sectionHeader('其他设置')
          
          this.toggleItem(
            '自动保存银行卡',
            '支付成功后自动保存银行卡信息',
            this.settings.autoSaveCard,
            (value: boolean) => {
              this.settings.autoSaveCard = value;
            }
          )

          this.toggleItem(
            '显示交易详情',
            '在通知中显示交易金额和商户',
            this.settings.showTransactionDetails,
            (value: boolean) => {
              this.settings.showTransactionDetails = value;
            }
          )

          // Save button
          Button('保存设置')
            .width('100%')
            .height(48)
            .fontSize(16)
            .fontWeight(FontWeight.Medium)
            .backgroundColor('#007DFF')
            .borderRadius(24)
            .margin({ top: 24 })
            .onClick(() => {
              // Save settings
              globalSettings.defaultPaymentMethod = this.settings.defaultPaymentMethod;
              globalSettings.paymentReminder = this.settings.paymentReminder;
              globalSettings.smallAmountNoPassword = this.settings.smallAmountNoPassword;
              globalSettings.confirmMethod = this.settings.confirmMethod;
              globalSettings.autoSaveCard = this.settings.autoSaveCard;
              globalSettings.showTransactionDetails = this.settings.showTransactionDetails;
              
              // Show success message
              AlertDialog.show({
                title: '保存成功',
                message: '支付设置已保存',
                autoCancel: true,
                alignment: DialogAlignment.Center
              });
            })

          Blank().height(20)
        }
        .width('100%')
        .padding({ left: 16, right: 16 })
      }
      .layoutWeight(1)
      .scrollBar(BarState.Off)
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('sys.color.ohos_id_color_sub_background'))
    .bindSheet($$this.showMethodPicker, this.methodPickerSheet(), {
      height: 300,
      backgroundColor: $r('sys.color.ohos_id_color_background'),
      dragBar: true
    })
    .bindSheet($$this.showConfirmPicker, this.confirmPickerSheet(), {
      height: 280,
      backgroundColor: $r('sys.color.ohos_id_color_background'),
      dragBar: true
    })
  }

  // Payment method picker sheet
  @Builder
  methodPickerSheet() {
    Column() {
      Text('选择默认支付方式')
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 16, bottom: 16 })

      ForEach(availablePaymentMethods, (method: string) => {
        Row() {
          Text(method)
            .fontSize(16)
            .fontColor($r('sys.color.ohos_id_color_text_primary'))
            .layoutWeight(1)

          if (this.settings.defaultPaymentMethod === method) {
            Image($r('app.media.kit_hwpay_right_v2'))
              .width(20)
              .height(20)
              .fillColor('#007DFF')
          }
        }
        .width('100%')
        .padding(16)
        .onClick(() => {
          this.settings.defaultPaymentMethod = method;
          this.showMethodPicker = false;
        })
      })
    }
    .width('100%')
  }

  // Confirm method picker sheet
  @Builder
  confirmPickerSheet() {
    Column() {
      Text('选择支付确认方式')
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 16, bottom: 16 })

      ForEach([
        ConfirmMethod.PASSWORD,
        ConfirmMethod.FINGERPRINT,
        ConfirmMethod.FACE,
        ConfirmMethod.NONE
      ], (method: ConfirmMethod) => {
        Row() {
          Text(method)
            .fontSize(16)
            .fontColor($r('sys.color.ohos_id_color_text_primary'))
            .layoutWeight(1)

          if (this.settings.confirmMethod === method) {
            Image($r('app.media.kit_hwpay_right_v2'))
              .width(20)
              .height(20)
              .fillColor('#007DFF')
          }
        }
        .width('100%')
        .padding(16)
        .onClick(() => {
          this.settings.confirmMethod = method;
          this.showConfirmPicker = false;
        })
      })
    }
    .width('100%')
  }
}
