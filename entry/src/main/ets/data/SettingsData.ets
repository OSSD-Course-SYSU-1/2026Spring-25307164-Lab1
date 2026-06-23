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
 * Payment confirmation method enum
 */
export enum ConfirmMethod {
  PASSWORD = '支付密码',
  FINGERPRINT = '指纹识别',
  FACE = '人脸识别',
  NONE = '无需确认'
}

/**
 * Payment settings model
 */
export class PaymentSettings {
  defaultPaymentMethod: string = '微信支付';  // 默认支付方式
  paymentReminder: boolean = true;            // 支付提醒开关
  smallAmountNoPassword: boolean = false;     // 小额免密支付
  smallAmountLimit: number = 100;             // 小额免密限额
  confirmMethod: ConfirmMethod = ConfirmMethod.PASSWORD;  // 支付确认方式
  autoSaveCard: boolean = true;               // 自动保存银行卡
  showTransactionDetails: boolean = true;     // 显示交易详情
}

/**
 * Available payment methods
 */
export const availablePaymentMethods: string[] = [
  '微信支付',
  '支付宝',
  '云闪付',
  'xx银行储蓄卡 (0606)',
  'xx银行储蓄卡 (0909)'
];

/**
 * Global settings instance
 */
export let globalSettings: PaymentSettings = new PaymentSettings();
