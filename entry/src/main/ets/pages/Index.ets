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

@Entry
@Component
struct Index {
  @State isDarkMode: boolean = false;

  // Navigation button component
  @Builder
  navButton(icon: Resource, title: string, targetPage: string) {
    Column() {
      Image(icon)
        .width(40)
        .height(40)
        .fillColor($r('sys.color.ohos_id_color_text_primary'))
      
      Text(title)
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
      router.pushUrl({ url: `pages/${targetPage}` });
    })
  }

  build() {
    Column() {
      // Top navigation bar
      Row() {
        Text('支付收银台')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('sys.color.ohos_id_color_text_primary'))
          .layoutWeight(1)

        // Theme toggle button
        Button({ type: ButtonType.Circle }) {
          Image(this.isDarkMode ? $r('app.media.kit_hwpay_right_v2') : $r('app.media.kit_hwpay_right_v2'))
            .width(20)
            .height(20)
            .fillColor($r('sys.color.ohos_id_color_text_primary'))
        }
        .width(36)
        .height(36)
        .backgroundColor($r('sys.color.ohos_id_color_button_normal'))
        .onClick(() => {
          this.isDarkMode = !this.isDarkMode;
          // Toggle theme (simplified version)
        })
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 12, bottom: 12 })

      // Quick navigation
      Row() {
        this.navButton($r('app.media.kit_hwpay_wallet'), '订单历史', 'OrderHistory');
        
        Blank().width(16)
        
        this.navButton($r('app.media.payment_logo'), '支付统计', 'Statistics');
      }
      .width('100%')
      .padding(16)
      .justifyContent(FlexAlign.Center)

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
}
