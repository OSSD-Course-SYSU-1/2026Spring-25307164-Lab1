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

import { orderHistoryData } from '../data/OrderRecord';
import { PaymentStatistics, PaymentMethodStats, calculateStatistics, calculateMethodStats } from '../data/PaymentStatistics';
import { router } from '@kit.ArkUI';

@Entry
@Component
struct StatisticsPage {
  @State statistics: PaymentStatistics = calculateStatistics(orderHistoryData);
  @State methodStats: PaymentMethodStats[] = calculateMethodStats(orderHistoryData);

  // Stat card component
  @Builder
  statCard(title: string, value: string, subtitle?: string) {
    Column() {
      Text(title)
        .fontSize(14)
        .fontColor($r('sys.color.ohos_id_color_text_secondary'))
      
      Text(value)
        .fontSize(28)
        .fontWeight(FontWeight.Bold)
        .fontColor($r('sys.color.ohos_id_color_text_primary'))
        .margin({ top: 8 })
      
      if (subtitle) {
        Text(subtitle)
          .fontSize(12)
          .fontColor($r('sys.color.ohos_id_color_text_secondary'))
          .margin({ top: 4 })
      }
    }
    .width('100%')
    .padding(20)
    .backgroundColor($r('sys.color.ohos_id_color_background'))
    .borderRadius(16)
    .alignItems(HorizontalAlign.Center)
  }

  // Progress bar component
  @Builder
  progressBar(label: string, percentage: number, color: ResourceColor) {
    Column() {
      Row() {
        Text(label)
          .fontSize(14)
          .fontColor($r('sys.color.ohos_id_color_text_primary'))
          .layoutWeight(1)
        
        Text(`${percentage.toFixed(1)}%`)
          .fontSize(14)
          .fontWeight(FontWeight.Medium)
          .fontColor(color)
      }
      .width('100%')
      .margin({ bottom: 8 })

      Row() {
        Row()
          .width(`${percentage}%`)
          .height(8)
          .backgroundColor(color)
          .borderRadius(4)
      }
      .width('100%')
      .height(8)
      .backgroundColor($r('sys.color.ohos_id_color_fourth'))
      .borderRadius(4)
    }
    .width('100%')
    .margin({ bottom: 16 })
  }

  build() {
    Column() {
      // Header
      Row() {
        Button({ type: ButtonType.Circle }) {
          Image($r('app.media.kit_hwpay_right_v2'))
            .width(20)
            .height(20)
            .fillColor($r('sys.color.ohos_id_color_text_primary'))
            .rotate({ angle: 180 })
        }
        .width(40)
        .height(40)
        .backgroundColor($r('sys.color.ohos_id_color_button_normal'))
        .onClick(() => {
          router.back();
        })

        Text('支付统计')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('sys.color.ohos_id_color_text_primary'))
          .layoutWeight(1)
          .textAlign(TextAlign.Center)

        Blank().width(40)
      }
      .width('100%')
      .padding(16)

      // Statistics cards
      Scroll() {
        Column() {
          // Overview stats
          Row() {
            Column() {
              this.statCard('总订单数', `${this.statistics.totalOrders}`, '笔')
            }
            .layoutWeight(1)
            .margin({ right: 8 })

            Column() {
              this.statCard('成功订单', `${this.statistics.successOrders}`, '笔')
            }
            .layoutWeight(1)
            .margin({ left: 8 })
          }
          .width('100%')
          .margin({ bottom: 16 })

          Row() {
            Column() {
              this.statCard('总支付金额', `¥${this.statistics.totalAmount.toFixed(2)}`)
            }
            .layoutWeight(1)
            .margin({ right: 8 })

            Column() {
              this.statCard('平均支付', `¥${this.statistics.averageAmount.toFixed(2)}`)
            }
            .layoutWeight(1)
            .margin({ left: 8 })
          }
          .width('100%')
          .margin({ bottom: 24 })

          // Payment method stats
          Column() {
            Text('支付方式统计')
              .fontSize(16)
              .fontWeight(FontWeight.Medium)
              .fontColor($r('sys.color.ohos_id_color_text_primary'))
              .width('100%')
              .margin({ bottom: 16 })

            ForEach(this.methodStats, (stats: PaymentMethodStats) => {
              this.progressBar(stats.methodName, stats.percentage, '#007DFF');
            })
          }
          .width('100%')
          .padding(20)
          .backgroundColor($r('sys.color.ohos_id_color_background'))
          .borderRadius(16)
        }
        .width('100%')
        .padding(16)
      }
      .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('sys.color.ohos_id_color_sub_background'))
  }
}
