# 技术上下文

## 构建工具
- **Make**: 主要构建工具
- **CMake**: 部分库使用
- **autoconf/automake**: 配置工具
- **libtool**: 库管理工具

## 编译器要求
- **Mac**: XCode Command Line Tools
- **Linux**: gcc, g++ (可能需要 multilib)
- **Android**: Android NDK r16+
- **Tizen**: Tizen Studio

## 平台特定配置
配置文件位于 `build/` 目录：
- `android.ini`
- `ios.ini`
- `linux.ini`
- `mac.ini`
- `main.ini`
- `tizen.ini`
- `tvos.ini`

## 架构支持
- **iOS**: armv7, arm64, i386, x86_64
- **Android**: arm, armv7, arm64, x86
- **Mac**: x86_64
- **Tizen**: armv7

## 构建输出
每个库构建后生成：
- `include/`: 导出的头文件
- `prebuilt/`: 编译好的静态库（fat library）

## 最后更新
2025-12-18

