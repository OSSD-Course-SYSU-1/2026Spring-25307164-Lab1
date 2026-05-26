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

import { OrderRecord, OrderStatus, orderHistoryData } from '../data/OrderRecord';
import { router } from '@kit.ArkUI';

@Entry
@Component
struct OrderHistoryPage {
  @State orderList: OrderRecord[] = orderHistoryData;

  // Get status color
  getStatusColor(status: OrderStatus): ResourceColor {
    switch (status) {
      case OrderStatus.SUCCESS:
        return '#00C853';
      case OrderStatus.FAILED:
        return '#FF5252';
      case OrderStatus.PENDING:
        return '#FFB300';
      case OrderStatus.CANCELLED:
        return '#9E9E9E';
      default:
        return '#9E9E9E';
    }
  }

  // Order item component
  @Builder
  orderItem(order: OrderRecord) {
    Column() {
      Row() {
        Column() {
          Text(order.merchantName)
            .fontSize(16)
            .fontWeight(FontWeight.Medium)
            .fontColor($r('sys.color.ohos_id_color_text_primary'))
          
          Text(order.paymentMethod)
            .fontSize(14)
            .fontColor($r('sys.color.ohos_id_color_text_secondary'))
            .margin({ top: 4 })
        }
        .alignItems(HorizontalAlign.Start)
        .layoutWeight(1)

        Column() {
          Text(`¥${order.amount}`)
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
            .fontColor($r('sys.color.ohos_id_color_text_primary'))
          
          Text(order.status)
            .fontSize(12)
            .fontColor(this.getStatusColor(order.status))
            .margin({ top: 4 })
        }
        .alignItems(HorizontalAlign.End)
      }
      .width('100%')
      .padding(16)

      Row() {
        Text(`订单号: ${order.orderId}`)
          .fontSize(12)
          .fontColor($r('sys.color.ohos_id_color_text_secondary'))
        
        Text(order.createTime)
          .fontSize(12)
          .fontColor($r('sys.color.ohos_id_color_text_secondary'))
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
      .padding({ left: 16, right: 16, bottom: 12 })
    }
    .width('100%')
    .backgroundColor($r('sys.color.ohos_id_color_background'))
    .borderRadius(12)
    .margin({ bottom: 12 })
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

        Text('订单历史')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('sys.color.ohos_id_color_text_primary'))
          .layoutWeight(1)
          .textAlign(TextAlign.Center)

        Blank().width(40)
      }
      .width('100%')
      .padding(16)

      // Order list
      List() {
        ForEach(this.orderList, (order: OrderRecord) => {
          ListItem() {
            this.orderItem(order);
          }
        })
      }
      .width('100%')
      .layoutWeight(1)
      .padding({ left: 16, right: 16 })
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('sys.color.ohos_id_color_sub_background'))
  }
}
