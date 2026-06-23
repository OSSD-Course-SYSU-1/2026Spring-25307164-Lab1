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

import { display } from '@kit.ArkUI';

/**
 * 设备类型枚举
 */
export enum DeviceType {
  PHONE = 'phone',
  TABLET = 'tablet',
  TV = 'tv',
  WEARABLE = 'wearable',
  TWO_IN_ONE = '2in1',
  UNKNOWN = 'unknown'
}

/**
 * 断点类型枚举
 */
export enum BreakpointType {
  XS = 'xs',    // 小屏 < 320vp
  SM = 'sm',    // 手机竖屏 320-600vp
  MD = 'md',    // 手机横屏/小平板 600-840vp
  LG = 'lg',    // 平板/小屏电脑 840-1024vp
  XL = 'xl'     // 大屏电脑 > 1024vp
}

/**
 * 响应式布局配置
 */
export interface ResponsiveConfig {
  columns: number;           // 网格列数
  gutter: number;            // 间距
  margin: number;            // 外边距
  fontSize: number;          // 基础字体大小
  iconSize: number;          // 图标大小
  buttonHeight: number;      // 按钮高度
}

/**
 * 响应式布局工具类
 * 提供设备检测、断点计算、布局配置等功能
 */
export class ResponsiveLayoutUtil {
  private static instance: ResponsiveLayoutUtil;
  private currentBreakpoint: BreakpointType = BreakpointType.SM;
  private currentDeviceType: DeviceType = DeviceType.PHONE;
  private windowWidth: number = 0;
  private windowHeight: number = 0;

  // 断点阈值（单位：vp）
  private readonly BREAKPOINT_XS = 320;
  private readonly BREAKPOINT_SM = 600;
  private readonly BREAKPOINT_MD = 840;
  private readonly BREAKPOINT_LG = 1024;

  private constructor() {}

  /**
   * 获取单例实例
   */
  public static getInstance(): ResponsiveLayoutUtil {
    if (!ResponsiveLayoutUtil.instance) {
      ResponsiveLayoutUtil.instance = new ResponsiveLayoutUtil();
    }
    return ResponsiveLayoutUtil.instance;
  }

  /**
   * 更新窗口尺寸
   */
  public updateWindowSize(width: number, height: number): void {
    this.windowWidth = width;
    this.windowHeight = height;
    this.currentBreakpoint = this.calculateBreakpoint(width);
    this.currentDeviceType = this.detectDeviceType();
  }

  /**
   * 计算当前断点
   */
  private calculateBreakpoint(width: number): BreakpointType {
    if (width < this.BREAKPOINT_XS) {
      return BreakpointType.XS;
    } else if (width < this.BREAKPOINT_SM) {
      return BreakpointType.SM;
    } else if (width < this.BREAKPOINT_MD) {
      return BreakpointType.MD;
    } else if (width < this.BREAKPOINT_LG) {
      return BreakpointType.LG;
    } else {
      return BreakpointType.XL;
    }
  }

  /**
   * 检测设备类型
   */
  private detectDeviceType(): DeviceType {
    try {
      const displayInfo = display.getDefaultDisplaySync();
      const densityDpi = displayInfo.densityDPI;
      const width = displayInfo.width;
      const height = displayInfo.height;
      
      // 根据屏幕尺寸和密度判断设备类型
      const screenWidthInch = width / densityDpi;
      const screenHeightInch = height / densityDpi;
      const screenDiagonal = Math.sqrt(
        screenWidthInch * screenWidthInch + screenHeightInch * screenHeightInch
      );

      if (screenDiagonal < 2.5) {
        return DeviceType.WEARABLE;
      } else if (screenDiagonal < 7) {
        return DeviceType.PHONE;
      } else if (screenDiagonal < 11) {
        return DeviceType.TABLET;
      } else {
        return DeviceType.TWO_IN_ONE;
      }
    } catch (error) {
      return DeviceType.PHONE;
    }
  }

  /**
   * 获取当前断点
   */
  public getCurrentBreakpoint(): BreakpointType {
    return this.currentBreakpoint;
  }

  /**
   * 获取当前设备类型
   */
  public getCurrentDeviceType(): DeviceType {
    return this.currentDeviceType;
  }

  /**
   * 获取响应式配置
   */
  public getResponsiveConfig(): ResponsiveConfig {
    switch (this.currentBreakpoint) {
      case BreakpointType.XS:
        return {
          columns: 2,
          gutter: 8,
          margin: 8,
          fontSize: 12,
          iconSize: 16,
          buttonHeight: 32
        };
      case BreakpointType.SM:
        return {
          columns: 4,
          gutter: 12,
          margin: 16,
          fontSize: 14,
          iconSize: 20,
          buttonHeight: 40
        };
      case BreakpointType.MD:
        return {
          columns: 6,
          gutter: 16,
          margin: 24,
          fontSize: 16,
          iconSize: 24,
          buttonHeight: 44
        };
      case BreakpointType.LG:
        return {
          columns: 8,
          gutter: 20,
          margin: 32,
          fontSize: 18,
          iconSize: 28,
          buttonHeight: 48
        };
      case BreakpointType.XL:
        return {
          columns: 12,
          gutter: 24,
          margin: 48,
          fontSize: 20,
          iconSize: 32,
          buttonHeight: 52
        };
      default:
        return {
          columns: 4,
          gutter: 12,
          margin: 16,
          fontSize: 14,
          iconSize: 20,
          buttonHeight: 40
        };
    }
  }

  /**
   * 判断是否为大屏设备
   */
  public isLargeScreen(): boolean {
    return this.currentBreakpoint === BreakpointType.LG || 
           this.currentBreakpoint === BreakpointType.XL;
  }

  /**
   * 判断是否为平板设备
   */
  public isTablet(): boolean {
    return this.currentDeviceType === DeviceType.TABLET;
  }

  /**
   * 判断是否为手机设备
   */
  public isPhone(): boolean {
    return this.currentDeviceType === DeviceType.PHONE;
  }

  /**
   * 获取网格列宽
   */
  public getGridColumnWidth(): number {
    const config = this.getResponsiveConfig();
    const totalWidth = this.windowWidth - config.margin * 2;
    const gutterTotal = config.gutter * (config.columns - 1);
    return (totalWidth - gutterTotal) / config.columns;
  }

  /**
   * 根据断点返回不同的值
   */
  public valueByBreakpoint<T>(
    xs: T, sm: T, md: T, lg: T, xl: T
  ): T {
    switch (this.currentBreakpoint) {
      case BreakpointType.XS:
        return xs;
      case BreakpointType.SM:
        return sm;
      case BreakpointType.MD:
        return md;
      case BreakpointType.LG:
        return lg;
      case BreakpointType.XL:
        return xl;
      default:
        return sm;
    }
  }
}
