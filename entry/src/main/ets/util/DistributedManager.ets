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

import { distributedDeviceManager } from '@kit.DistributedServiceKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { Want, AbilityConstant } from '@kit.AbilityKit';
import { common } from '@kit.AbilityKit';

const DOMAIN = 0x0000;
const TAG = 'DistributedManager';

/**
 * 设备信息接口
 */
export interface DeviceInfo {
  deviceId: string;
  deviceName: string;
  deviceType: string;
  networkId: string;
  isOnline: boolean;
}

/**
 * 流转状态枚举
 */
export enum MigrationStatus {
  IDLE = 'idle',              // 空闲
  DISCOVERING = 'discovering', // 发现设备中
  READY = 'ready',            // 准备就绪
  MIGRATING = 'migrating',    // 迁移中
  SUCCESS = 'success',        // 迁移成功
  FAILED = 'failed'           // 迁移失败
}

/**
 * 流转管理器
 * 负责设备发现、连接、迁移等分布式能力管理
 */
export class DistributedManager {
  private static instance: DistributedManager;
  private deviceManager: distributedDeviceManager.DeviceManager | null = null;
  private deviceDiscoveryCallback: ((devices: DeviceInfo[]) => void) | null = null;
  private statusChangeCallback: ((status: MigrationStatus) => void) | null = null;
  private discoveredDevices: DeviceInfo[] = [];
  private currentStatus: MigrationStatus = MigrationStatus.IDLE;
  private context: common.UIAbilityContext | null = null;

  private constructor() {}

  /**
   * 获取单例实例
   */
  public static getInstance(): DistributedManager {
    if (!DistributedManager.instance) {
      DistributedManager.instance = new DistributedManager();
    }
    return DistributedManager.instance;
  }

  /**
   * 初始化设备管理器
   */
  public async initialize(context: common.UIAbilityContext): Promise<boolean> {
    try {
      this.context = context;
      
      // 创建设备管理器
      this.deviceManager = distributedDeviceManager.createDeviceManager('com.example.paymentkit');
      
      if (!this.deviceManager) {
        hilog.error(DOMAIN, TAG, 'Failed to create device manager');
        return false;
      }

      // 注册设备状态监听
      this.registerDeviceStateListener();
      
      hilog.info(DOMAIN, TAG, 'Device manager initialized successfully');
      return true;
    } catch (error) {
      hilog.error(DOMAIN, TAG, `Initialize failed: ${JSON.stringify(error)}`);
      return false;
    }
  }

  /**
   * 注册设备状态监听器
   */
  private registerDeviceStateListener(): void {
    if (!this.deviceManager) {
      return;
    }

    try {
      // 监听设备上线
      this.deviceManager.on('deviceStateChange', (data: distributedDeviceManager.DeviceInfo) => {
        hilog.info(DOMAIN, TAG, `Device state changed: ${data.deviceName}`);
        this.updateDeviceList();
      });

      // 监听设备发现
      this.deviceManager.on('deviceFound', (data: distributedDeviceManager.DeviceInfo) => {
        hilog.info(DOMAIN, TAG, `Device found: ${data.deviceName}`);
        this.addDiscoveredDevice(data);
      });

      // 监听设备发现失败
      this.deviceManager.on('discoverFailed', (data: distributedDeviceManager.DeviceInfo) => {
        hilog.error(DOMAIN, TAG, `Device discover failed: ${data.deviceName}`);
      });

    } catch (error) {
      hilog.error(DOMAIN, TAG, `Register listener failed: ${JSON.stringify(error)}`);
    }
  }

  /**
   * 开始设备发现
   */
  public async startDeviceDiscovery(): Promise<boolean> {
    if (!this.deviceManager) {
      hilog.error(DOMAIN, TAG, 'Device manager not initialized');
      return false;
    }

    try {
      this.updateStatus(MigrationStatus.DISCOVERING);
      this.discoveredDevices = [];

      // 配置发现参数
      const subscribeInfo: distributedDeviceManager.SubscribeInfo = {
        subscribeId: 12345,
        mode: 'DISCOVER_MODE_ACTIVE',
        medium: 'AUTO',
        freq: 'MID',
        isSameAccount: false,
        isWakeRemote: true,
        capability: 'ddmpCapability'
      };

      // 开始发现设备
      this.deviceManager.startDeviceDiscovery(subscribeInfo);
      
      hilog.info(DOMAIN, TAG, 'Device discovery started');
      return true;
    } catch (error) {
      hilog.error(DOMAIN, TAG, `Start discovery failed: ${JSON.stringify(error)}`);
      this.updateStatus(MigrationStatus.FAILED);
      return false;
    }
  }

  /**
   * 停止设备发现
   */
  public stopDeviceDiscovery(): void {
    if (!this.deviceManager) {
      return;
    }

    try {
      this.deviceManager.stopDeviceDiscovery(12345);
      this.updateStatus(MigrationStatus.IDLE);
      hilog.info(DOMAIN, TAG, 'Device discovery stopped');
    } catch (error) {
      hilog.error(DOMAIN, TAG, `Stop discovery failed: ${JSON.stringify(error)}`);
    }
  }

  /**
   * 添加发现的设备
   */
  private addDiscoveredDevice(device: distributedDeviceManager.DeviceInfo): void {
    const deviceInfo: DeviceInfo = {
      deviceId: device.deviceId,
      deviceName: device.deviceName,
      deviceType: device.deviceType,
      networkId: device.networkId,
      isOnline: true
    };

    // 避免重复添加
    const exists = this.discoveredDevices.some(d => d.deviceId === deviceInfo.deviceId);
    if (!exists) {
      this.discoveredDevices.push(deviceInfo);
      this.notifyDeviceDiscovery();
    }
  }

  /**
   * 更新设备列表
   */
  private updateDeviceList(): void {
    if (!this.deviceManager) {
      return;
    }

    try {
      const devices = this.deviceManager.getAvailableDeviceList();
      this.discoveredDevices = devices.map(device => ({
        deviceId: device.deviceId,
        deviceName: device.deviceName,
        deviceType: device.deviceType,
        networkId: device.networkId,
        isOnline: true
      }));
      
      this.notifyDeviceDiscovery();
    } catch (error) {
      hilog.error(DOMAIN, TAG, `Update device list failed: ${JSON.stringify(error)}`);
    }
  }

  /**
   * 通知设备发现结果
   */
  private notifyDeviceDiscovery(): void {
    if (this.deviceDiscoveryCallback) {
      this.deviceDiscoveryCallback(this.discoveredDevices);
    }
  }

  /**
   * 更新流转状态
   */
  private updateStatus(status: MigrationStatus): void {
    this.currentStatus = status;
    if (this.statusChangeCallback) {
      this.statusChangeCallback(status);
    }
  }

  /**
   * 执行流转迁移
   */
  public async migrateToDevice(deviceId: string): Promise<boolean> {
    if (!this.context) {
      hilog.error(DOMAIN, TAG, 'Context not initialized');
      return false;
    }

    try {
      this.updateStatus(MigrationStatus.MIGRATING);
      
      // 构造迁移参数
      const want: Want = {
        deviceId: deviceId,
        bundleName: 'com.example.paymentkit',
        abilityName: 'EntryAbility',
        parameters: {
          // 可以传递需要同步的数据
          migrationData: 'payment_data'
        }
      };

      // 执行迁移
      await this.context.startAbility(want);
      
      this.updateStatus(MigrationStatus.SUCCESS);
      hilog.info(DOMAIN, TAG, `Migration to device ${deviceId} succeeded`);
      return true;
    } catch (error) {
      hilog.error(DOMAIN, TAG, `Migration failed: ${JSON.stringify(error)}`);
      this.updateStatus(MigrationStatus.FAILED);
      return false;
    }
  }

  /**
   * 继续迁移（在目标设备上调用）
   */
  public async continueMigration(want: Want): Promise<void> {
    try {
      hilog.info(DOMAIN, TAG, 'Continue migration on target device');
      // 处理迁移数据
      if (want.parameters && want.parameters.migrationData) {
        // 恢复应用状态
        hilog.info(DOMAIN, TAG, `Migration data: ${want.parameters.migrationData}`);
      }
    } catch (error) {
      hilog.error(DOMAIN, TAG, `Continue migration failed: ${JSON.stringify(error)}`);
    }
  }

  /**
   * 设置设备发现回调
   */
  public setDeviceDiscoveryCallback(callback: (devices: DeviceInfo[]) => void): void {
    this.deviceDiscoveryCallback = callback;
  }

  /**
   * 设置状态变化回调
   */
  public setStatusChangeCallback(callback: (status: MigrationStatus) => void): void {
    this.statusChangeCallback = callback;
  }

  /**
   * 获取已发现的设备列表
   */
  public getDiscoveredDevices(): DeviceInfo[] {
    return this.discoveredDevices;
  }

  /**
   * 获取当前状态
   */
  public getCurrentStatus(): MigrationStatus {
    return this.currentStatus;
  }

  /**
   * 释放资源
   */
  public release(): void {
    if (this.deviceManager) {
      try {
        this.stopDeviceDiscovery();
        this.deviceManager.off('deviceStateChange');
        this.deviceManager.off('deviceFound');
        this.deviceManager.off('discoverFailed');
        hilog.info(DOMAIN, TAG, 'Device manager released');
      } catch (error) {
        hilog.error(DOMAIN, TAG, `Release failed: ${JSON.stringify(error)}`);
      }
    }
  }
}
