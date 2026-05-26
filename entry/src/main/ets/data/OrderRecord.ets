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

/**
 * Order status enum
 */
export enum OrderStatus {
  SUCCESS = '支付成功',
  FAILED = '支付失败',
  PENDING = '待支付',
  CANCELLED = '已取消'
}

/**
 * Order record data model
 */
export class OrderRecord {
  orderId: string = '';              // 订单ID
  merchantName: string = '';         // 商户名称
  amount: string = '';               // 支付金额
  paymentMethod: string = '';        // 支付方式
  status: OrderStatus = OrderStatus.PENDING;  // 订单状态
  createTime: string = '';           // 创建时间
  completeTime?: string;             // 完成时间
}

/**
 * Mock order history data
 */
export const orderHistoryData: OrderRecord[] = [
  {
    orderId: '202505260001',
    merchantName: '华为支付测试商户',
    amount: '0.01',
    paymentMethod: 'xx银行储蓄卡 (0606)',
    status: OrderStatus.SUCCESS,
    createTime: '2025-05-26 10:30:25',
    completeTime: '2025-05-26 10:30:28'
  },
  {
    orderId: '202505260002',
    merchantName: '华为支付测试商户',
    amount: '99.00',
    paymentMethod: '微信支付',
    status: OrderStatus.SUCCESS,
    createTime: '2025-05-26 09:15:10',
    completeTime: '2025-05-26 09:15:15'
  },
  {
    orderId: '202505260003',
    merchantName: '华为支付测试商户',
    amount: '199.00',
    paymentMethod: '云闪付',
    status: OrderStatus.FAILED,
    createTime: '2025-05-25 18:20:30',
  },
  {
    orderId: '202505260004',
    merchantName: '华为支付测试商户',
    amount: '50.00',
    paymentMethod: 'xx银行储蓄卡 (0909)',
    status: OrderStatus.SUCCESS,
    createTime: '2025-05-25 14:45:00',
    completeTime: '2025-05-25 14:45:05'
  },
  {
    orderId: '202505260005',
    merchantName: '华为支付测试商户',
    amount: '299.00',
    paymentMethod: '微信支付',
    status: OrderStatus.CANCELLED,
    createTime: '2025-05-24 20:10:00',
  }
];
