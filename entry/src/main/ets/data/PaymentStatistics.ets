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

import { OrderRecord, OrderStatus } from './OrderRecord';

/**
 * Payment statistics data model
 */
export class PaymentStatistics {
  totalOrders: number = 0;           // 总订单数
  successOrders: number = 0;         // 成功订单数
  failedOrders: number = 0;          // 失败订单数
  totalAmount: number = 0;           // 总支付金额
  successAmount: number = 0;         // 成功支付金额
  averageAmount: number = 0;         // 平均支付金额
}

/**
 * Calculate payment statistics from order records
 * @param orders Order record array
 * @returns Payment statistics
 */
export const calculateStatistics = (orders: OrderRecord[]): PaymentStatistics => {
  const stats = new PaymentStatistics();
  
  stats.totalOrders = orders.length;
  
  orders.forEach(order => {
    const amount = parseFloat(order.amount) || 0;
    stats.totalAmount += amount;
    
    if (order.status === OrderStatus.SUCCESS) {
      stats.successOrders++;
      stats.successAmount += amount;
    } else if (order.status === OrderStatus.FAILED) {
      stats.failedOrders++;
    }
  });
  
  stats.averageAmount = stats.successOrders > 0 
    ? stats.successAmount / stats.successOrders 
    : 0;
  
  return stats;
};

/**
 * Payment method statistics
 */
export class PaymentMethodStats {
  methodName: string = '';
  count: number = 0;
  totalAmount: number = 0;
  percentage: number = 0;
}

/**
 * Calculate payment method statistics
 * @param orders Order record array
 * @returns Payment method statistics array
 */
export const calculateMethodStats = (orders: OrderRecord[]): PaymentMethodStats[] => {
  const methodMap = new Map<string, PaymentMethodStats>();
  
  // Filter success orders
  const successOrders = orders.filter(o => o.status === OrderStatus.SUCCESS);
  
  successOrders.forEach(order => {
    const method = order.paymentMethod;
    const amount = parseFloat(order.amount) || 0;
    
    if (methodMap.has(method)) {
      const stats = methodMap.get(method)!;
      stats.count++;
      stats.totalAmount += amount;
    } else {
      const stats = new PaymentMethodStats();
      stats.methodName = method;
      stats.count = 1;
      stats.totalAmount = amount;
      methodMap.set(method, stats);
    }
  });
  
  // Calculate percentage
  const totalSuccess = successOrders.length;
  const result = Array.from(methodMap.values());
  result.forEach(stats => {
    stats.percentage = totalSuccess > 0 ? (stats.count / totalSuccess * 100) : 0;
  });
  
  // Sort by count descending
  return result.sort((a, b) => b.count - a.count);
};
