# 项目简介

## 项目概述
**项目名称**: cocos2d-x 第三方库源代码  
**项目类型**: Cocos2d-x 第三方库构建系统  
**仓库路径**: E:\work\cocos2d-x-3rd-party-libs-src

## 项目描述
这是一个包含 Cocos2d-x 捆绑的第三方库（二进制文件）源代码的仓库。

## 项目目标
此仓库适用于 Cocos2d-x 开发者和/或需要以下功能的人员：
- 生成某个库的更新版本（例如：将 libpng 1.6.2 升级到 1.6.14）
- 将 cocos2d-x 移植到其他平台（例如：移植到 Android ARM64 或 Tizen 等）
- 生成所有第三方库的 DEBUG 版本

## 技术栈
- 构建系统：Makefile
- 支持的平台：iOS, Mac, Android, Linux, Tizen, Windows 10 UWP
- 主要语言：C/C++

## 项目结构
- `contrib/src/`: 第三方库源代码和构建规则
- `build/`: 平台特定的构建脚本和配置
- `custom_modes/`: Memory Bank 模式指令文件

## 最后更新
2025-12-18

