# 任务跟踪

## 当前状态
- **状态**: PLAN 模式 - 详细计划已完成
- **模式**: PLAN → IMPLEMENT（准备切换）
- **最后更新**: 2025-12-18

## 活动任务

### 任务 #001: 升级 curl 和 openssl
- **复杂度**: Level 3
- **状态**: PLAN 完成，准备实施
- **创建时间**: 2025-12-18

#### 任务描述
升级项目中的两个第三方库：
1. **curl**: 从 7.52.1 (2017) 升级到 **7.88.1** ✅
2. **openssl**: 从 1.1.0c (2016) 升级到 **1.1.1w** ✅

#### 当前版本信息
- **curl**: 7.52.1
  - 位置: `contrib/src/curl/rules.mak`
  - 补丁: 无
  - 依赖: zlib, openssl
  
- **openssl**: 1.1.0c
  - 位置: `contrib/src/openssl/rules.mak`
  - 补丁: 
    - `android-clang.patch` (Android 平台)
    - `ios-armv7-crash.patch` (iOS 平台)
  - 自定义配置: `config/20-ios-tvos-cross.conf`

#### 关键考虑因素
1. **依赖关系**: curl 依赖 openssl，应先升级 openssl
2. **平台兼容性**: 需要支持 iOS, Mac, Android, Linux, Tizen, Windows 10 UWP
3. **补丁兼容性**: openssl 的补丁可能需要更新或重新应用
4. **构建配置**: 可能需要更新平台特定的构建配置
5. **版本兼容性**: 需要确保新版本之间的兼容性

#### 分析结果

**需要更新的文件**:
1. `contrib/src/curl/rules.mak`
   - 更新 `CURL_VERSION`
   - 更新 `CURL_URL`
   - 检查构建配置兼容性

2. `contrib/src/openssl/rules.mak`
   - 更新 `OPENSSL_VERSION`
   - 更新 `OPENSSL_URL`
   - 评估补丁兼容性
   - 检查平台配置兼容性（特别是 OpenSSL 3.x 的配置变化）

3. `contrib/src/openssl/android-clang.patch`
   - 评估在新版本上的兼容性
   - 可能需要更新或移除

4. `contrib/src/openssl/ios-armv7-crash.patch`
   - 评估在新版本上的兼容性
   - 可能需要更新或移除

5. `contrib/src/openssl/config/20-ios-tvos-cross.conf`
   - OpenSSL 3.x 配置系统有重大变化，需要重新评估

6. `contrib/src/curl/SHA512SUMS` 和 `contrib/src/openssl/SHA512SUMS`
   - 更新校验和

**关键风险点**:
1. **OpenSSL 1.1.x → 3.x 重大升级**:
   - API 有重大变化
   - 配置系统从 `Configure` 脚本改为 `config` 系统
   - iOS/tvOS 交叉编译配置需要重新适配
   - 补丁可能不再适用

2. **依赖关系**:
   - curl 依赖 openssl，必须先升级 openssl
   - 需要确保新版本兼容

3. **平台兼容性**:
   - 6 个平台都需要测试
   - Android 和 iOS 的补丁需要特别关注

#### 目标升级版本（已确认）
- **openssl**: **1.1.1w** ✅（用户确认）
  - 1.1.x 系列最后版本
  - 风险较低，配置系统兼容
  - 补丁文件可能仍然适用
  - 当前版本: 1.1.0c → 目标版本: 1.1.1w
  
- **curl**: **7.88.1** ✅（用户确认）
  - 7.x 系列版本，与 OpenSSL 1.1.1w 兼容
  - 当前版本: 7.52.1 → 目标版本: 7.88.1
  - 版本跨度: 7.52.1 → 7.88.1（约 6 年差距）

#### 升级策略
**OpenSSL 1.1.1w 的优势**:
- ✅ 配置系统与 1.1.0c 兼容，迁移风险低
- ✅ 补丁文件可能仍然适用（需要验证）
- ✅ 平台特定配置（iOS/tvOS/Android）应该可以复用
- ⚠️ 注意：OpenSSL 1.1.1 系列已于 2023 年 9 月结束官方支持

**升级顺序**:
1. 先升级 openssl 到 1.1.1w
2. 验证补丁兼容性
3. 测试构建
4. 再升级 curl（确保与新 openssl 兼容）

---

## 📋 LEVEL 3 详细升级计划

### 1. 需求分析

#### 1.1 功能需求
- 将 OpenSSL 从 1.1.0c 升级到 1.1.1w
- 将 curl 从 7.52.1 升级到 7.88.1
- 保持所有平台（iOS, Mac, Android, Linux, Tizen, Windows 10 UWP）的构建兼容性
- 确保补丁文件在新版本上正常工作
- 更新 SHA512SUMS 校验和文件

#### 1.2 非功能需求
- **兼容性**: 确保新版本与现有构建系统兼容
- **稳定性**: 保持所有平台的构建稳定性
- **可维护性**: 保持代码清晰，便于未来维护

### 2. 受影响的组件

#### 2.1 直接影响的文件
1. **OpenSSL 相关**:
   - `contrib/src/openssl/rules.mak` - 构建规则
   - `contrib/src/openssl/SHA512SUMS` - 校验和
   - `contrib/src/openssl/android-clang.patch` - Android 补丁
   - `contrib/src/openssl/ios-armv7-crash.patch` - iOS 补丁
   - `contrib/src/openssl/config/20-ios-tvos-cross.conf` - iOS/tvOS 配置

2. **curl 相关**:
   - `contrib/src/curl/rules.mak` - 构建规则
   - `contrib/src/curl/SHA512SUMS` - 校验和

#### 2.2 间接影响的组件
- 依赖 curl 和 openssl 的其他库（如果有）
- 构建脚本和配置文件（可能需要调整）

### 3. 架构考虑

#### 3.1 升级顺序
由于 curl 依赖 openssl，必须按以下顺序升级：
1. **阶段 1**: 升级 OpenSSL 到 1.1.1w
2. **阶段 2**: 验证 OpenSSL 构建成功
3. **阶段 3**: 升级 curl 到 7.88.1

#### 3.2 平台特定考虑
- **iOS/tvOS**: 使用自定义配置文件 `20-ios-tvos-cross.conf`，需要验证兼容性
- **Android**: 使用 `android-clang.patch`，需要验证补丁兼容性
- **其他平台**: 标准配置，风险较低

### 4. 实施策略

#### 4.1 分阶段实施
采用分阶段、可回滚的实施策略：
1. 先完成 OpenSSL 升级并验证
2. 再完成 curl 升级并验证
3. 每个阶段完成后进行测试

#### 4.2 风险缓解
- 保留原始文件备份
- 逐步验证每个平台的构建
- 如果补丁不兼容，准备手动修复方案

### 5. 详细实施步骤

#### 阶段 1: OpenSSL 升级 (1.1.0c → 1.1.1w)

**步骤 1.1: 更新版本信息**
- [x] 更新 `contrib/src/openssl/rules.mak` 中的 `OPENSSL_VERSION := 1.1.1w`
- [x] 更新 `OPENSSL_URL`（已确认 URL 格式正确）

**步骤 1.2: 验证补丁兼容性**
- [ ] 下载 OpenSSL 1.1.1w 源代码
- [ ] 测试应用 `android-clang.patch`
  - 如果失败，分析差异并更新补丁
- [ ] 测试应用 `ios-armv7-crash.patch`
  - 如果失败，分析差异并更新补丁

**步骤 1.3: 验证配置文件兼容性**
- [ ] 检查 `config/20-ios-tvos-cross.conf` 是否与 OpenSSL 1.1.1w 兼容
- [ ] 验证 iOS/tvOS 交叉编译配置仍然有效

**步骤 1.4: 更新校验和**
- [x] 下载 OpenSSL 1.1.1w tarball
- [x] 计算 SHA512 校验和: `b4c625fe56a4e690b57b6a011a225ad0cb3af54bd8fb67af77b5eceac55cc7191291d96a660c5b568a08a2fbf62b4612818e7cca1bb95b2b6b4fc649b0552b6d`
- [x] 更新 `contrib/src/openssl/SHA512SUMS`

**步骤 1.5: 测试构建**
- [ ] 在至少一个平台上测试构建（建议从 Linux 或 Mac 开始）
- [ ] 验证构建成功
- [ ] 如果失败，调试并修复

#### 阶段 2: curl 升级 (7.52.1 → 7.88.1)

**步骤 2.1: 更新版本信息**
- [x] 更新 `contrib/src/curl/rules.mak` 中的 `CURL_VERSION := 7.88.1`
- [x] 更新 `CURL_URL`（已确认 URL 格式正确）

**步骤 2.2: 验证构建配置兼容性**
- [ ] 检查 curl 7.88.1 的构建选项是否与现有配置兼容
- [ ] 验证 `--with-ssl=$(PREFIX)` 选项仍然有效
- [ ] 检查平台特定选项（Linux, tvOS）是否需要更新

**步骤 2.3: 更新校验和**
- [x] 下载 curl 7.88.1 tarball
- [x] 计算 SHA512 校验和: `67701d458548712bbfaa55f2ebefbf87cdbba01b7b1200f608b1c3af67e8dd8e243fa89f256446d217d658a5a1242331d8b0168ab600351e74ee0e2511e79dae`
- [x] 更新 `contrib/src/curl/SHA512SUMS`

**步骤 2.4: 测试构建**
- [ ] 在至少一个平台上测试构建
- [ ] 验证与新的 OpenSSL 1.1.1w 链接成功
- [ ] 如果失败，调试并修复

#### 阶段 3: 全面测试

**步骤 3.1: 多平台构建测试**
- [ ] iOS 平台测试（所有架构）
- [ ] Android 平台测试（所有架构）
- [ ] Mac 平台测试
- [ ] Linux 平台测试
- [ ] Tizen 平台测试（如果可能）
- [ ] Windows 10 UWP 测试（如果可能）

**步骤 3.2: 功能验证**
- [ ] 验证 OpenSSL 功能正常
- [ ] 验证 curl 功能正常
- [ ] 验证 curl 与 OpenSSL 集成正常

### 6. 依赖关系

#### 6.1 库依赖
- **curl 依赖 openssl**: 必须先升级 openssl
- **curl 依赖 zlib**: zlib 不需要升级（假设当前版本兼容）

#### 6.2 构建依赖
- 构建系统（Makefile）不需要修改
- 补丁应用机制不需要修改
- 平台特定配置可能需要调整

### 7. 挑战和缓解措施

#### 挑战 1: 补丁兼容性
**风险**: OpenSSL 补丁可能不适用于 1.1.1w
**缓解措施**:
- 先测试补丁应用
- 如果失败，分析差异并手动更新补丁
- 参考 OpenSSL 1.1.1w 的变更日志

#### 挑战 2: 配置文件兼容性
**风险**: iOS/tvOS 配置文件可能不兼容
**缓解措施**:
- OpenSSL 1.1.1w 仍使用 1.1.x 配置系统，兼容性应该良好
- 如果出现问题，参考 OpenSSL 官方文档更新配置

#### 挑战 3: 平台特定问题
**风险**: 某些平台可能出现构建错误
**缓解措施**:
- 逐个平台测试
- 记录每个平台的具体问题
- 参考官方文档和社区资源

#### 挑战 4: curl 与 OpenSSL 兼容性
**风险**: curl 7.88.1 可能与 OpenSSL 1.1.1w 有兼容性问题
**缓解措施**:
- curl 7.88.1 应该与 OpenSSL 1.1.1w 兼容（都是较新的版本）
- 如果出现问题，检查 curl 的构建日志

### 8. 创意阶段组件

#### 8.1 不需要创意阶段的组件
- 版本号更新：直接替换
- 校验和更新：直接计算和替换
- 构建配置：大部分可以直接复用

#### 8.2 可能需要创意阶段的组件
- **补丁更新**（如果补丁不兼容）:
  - 需要分析补丁差异
  - 可能需要重新设计补丁
  - 需要评估是否仍然需要该补丁
  
- **配置文件调整**（如果配置不兼容）:
  - 需要理解 OpenSSL 配置系统
  - 可能需要调整平台特定配置

**建议**: 如果补丁或配置出现不兼容问题，可以转入 CREATIVE 模式进行设计探索。

### 9. 验证检查清单

在完成计划前，验证以下项目：
- [x] 所有需求已分析
- [x] 所有受影响的组件已识别
- [x] 架构考虑已文档化
- [x] 实施策略已确定
- [x] 详细步骤已创建
- [x] 依赖关系已文档化
- [x] 挑战和缓解措施已识别
- [x] 创意阶段组件已识别

### 10. 下一步

- [x] **PLAN 模式完成**
- [x] **IMPLEMENT 模式进行中**
- [x] **GitHub Actions workflow 已创建**

**建议**: 由于大部分工作都是直接的版本更新和配置调整，不需要复杂的创意设计，建议直接转入 IMPLEMENT 模式。如果实施过程中遇到补丁或配置不兼容的问题，可以临时转入 CREATIVE 模式解决。

### 11. zlib macOS 兼容性修复

**问题**: zlib 1.2.8 在 Xcode 16.4+ 和 macOS SDK 15.5+ 上编译失败
- **错误**: `fdopen` 宏定义导致语法错误
- **修复**: 
  - 创建补丁 `contrib/src/zlib/macos-fdopen-fix.patch` 修复宏定义
  - 添加编译标志 `-Wno-deprecated-non-prototype` 禁用 C23 警告
  - 更新 `contrib/src/zlib/rules.mak` 在 macOS 上应用补丁

### 12. Windows Win32 支持

**添加内容**:
- 在 GitHub Actions workflow 中添加 Windows 构建测试
- 使用 MSYS2/MinGW 环境进行兼容性测试
- 验证 Windows 特定的构建配置

**注意**: 
- Windows Win32 的生产构建通常需要在 Visual Studio 中手动设置项目（如 README 所述）
- CI 中的 Windows 测试主要用于验证配置和源代码的正确性
- 实际的生产构建应遵循 README.md 中的 Visual Studio 说明

### 13. GitHub Actions 自动化测试

已创建 `.github/workflows/build-test.yml` workflow，包含以下测试：

1. **Linux 构建测试**: 在 Ubuntu 上测试 openssl 和 curl 的构建
2. **macOS 构建测试**: 在 macOS 上测试 openssl 和 curl 的构建
3. **Windows 构建测试**: 在 Windows 上验证配置和源代码（使用 MSYS2/MinGW）
4. **版本验证**: 验证版本号是否正确更新
5. **SHA512SUMS 验证**: 验证校验和文件格式
6. **补丁兼容性测试**: 测试补丁在新版本上的兼容性

**使用方法**:
- 推送到 GitHub 后，workflow 会自动运行
- 也可以手动触发（workflow_dispatch）
- 构建结果会作为 artifacts 保存 7 天

## 任务历史
暂无历史任务

