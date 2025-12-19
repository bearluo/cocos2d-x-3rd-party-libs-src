# Win32 构建指南 - OpenSSL 和 curl

本指南说明如何在 Windows 平台上构建适用于 Win32 桌面应用的 OpenSSL 和 curl 库。

## 前置要求

### 必需工具

1. **Visual Studio 2015 或更高版本**
   - 建议使用 Visual Studio 2019 或 2022
   - 确保安装了 "Desktop development with C++" 工作负载

2. **Perl**
   - OpenSSL 构建需要 Perl
   - 推荐安装 [Strawberry Perl](http://strawberryperl.com/) 或 [ActiveState Perl](https://www.activestate.com/products/perl/)
   - 确保 Perl 已添加到系统 PATH 环境变量

3. **NASM**（可选，但推荐）
   - 用于 OpenSSL 的汇编代码优化
   - 从 [NASM 官网](https://www.nasm.us/) 下载并安装
   - 添加到系统 PATH 环境变量

4. **CMake**
   - 用于 curl 的构建配置
   - 从 [CMake 官网](https://cmake.org/download/) 下载并安装
   - 确保添加到系统 PATH 环境变量

## 构建 OpenSSL 1.1.1w

### 步骤 1: 下载源码

从项目源码目录获取 OpenSSL 源码：

```batch
cd contrib\src
# 如果还没有下载，构建系统会自动下载
# 或者手动下载：
# https://www.openssl.org/source/openssl-1.1.1w.tar.gz
```

### 步骤 2: 解压源码

```batch
# 如果使用项目构建系统，源码会在 contrib\src\openssl-1.1.1w
# 或者手动解压到工作目录
```

### 步骤 3: 打开 Visual Studio 命令提示符

根据目标架构选择：
- **x64**: 打开 "x64 Native Tools Command Prompt for VS 2022"（或对应版本）
- **x86**: 打开 "x86 Native Tools Command Prompt for VS 2022"

### 步骤 4: 配置 OpenSSL

导航到 OpenSSL 源码目录，运行配置命令：

**对于 x64 架构：**
```batch
cd openssl-1.1.1w
perl Configure VC-WIN64A --prefix=C:\OpenSSL-Win64 --openssldir=C:\OpenSSL-Win64\ssl
```

**对于 x86 架构：**
```batch
cd openssl-1.1.1w
perl Configure VC-WIN32 --prefix=C:\OpenSSL-Win32 --openssldir=C:\OpenSSL-Win32\ssl
```

**配置选项说明：**
- `VC-WIN64A`: 64位架构（AMD64）
- `VC-WIN32`: 32位架构
- `--prefix`: 安装目录
- `--openssldir`: OpenSSL 配置文件目录

**其他常用选项：**
- `no-shared`: 只构建静态库（默认会同时构建静态和动态库）
- `no-unit-test`: 跳过单元测试
- `no-asm`: 不使用汇编代码（如果 NASM 未安装）

### 步骤 5: 编译和安装

```batch
nmake
nmake install
```

编译完成后，OpenSSL 将安装到指定的 `--prefix` 目录。

### 步骤 6: 验证安装

```batch
C:\OpenSSL-Win64\bin\openssl version
```

应该显示：`OpenSSL 1.1.1w ...`

## 构建 curl 7.88.1

### 步骤 1: 下载源码

从项目源码目录获取 curl 源码：

```batch
cd contrib\src
# 如果还没有下载，构建系统会自动下载
# 或者手动下载：
# http://curl.haxx.se/download/curl-7.88.1.tar.gz
```

### 步骤 2: 解压源码

```batch
# 如果使用项目构建系统，源码会在 contrib\src\curl-7.88.1
# 或者手动解压到工作目录
```

### 步骤 3: 创建构建目录

```batch
cd curl-7.88.1
mkdir build
cd build
```

### 步骤 4: 使用 CMake 配置

在构建目录中运行 CMake 配置命令：

**对于 x64 架构（Release）：**
```batch
cmake .. -G "Visual Studio 17 2022" -A x64 ^
  -DCMAKE_INSTALL_PREFIX=C:\curl-Win64 ^
  -DOPENSSL_ROOT_DIR=C:\OpenSSL-Win64 ^
  -DCURL_USE_OPENSSL=ON ^
  -DBUILD_SHARED_LIBS=ON ^
  -DCMAKE_BUILD_TYPE=Release
```

**对于 x86 架构（Release）：**
```batch
cmake .. -G "Visual Studio 17 2022" -A Win32 ^
  -DCMAKE_INSTALL_PREFIX=C:\curl-Win32 ^
  -DOPENSSL_ROOT_DIR=C:\OpenSSL-Win32 ^
  -DCURL_USE_OPENSSL=ON ^
  -DBUILD_SHARED_LIBS=ON ^
  -DCMAKE_BUILD_TYPE=Release
```

**CMake 选项说明：**
- `-G "Visual Studio 17 2022"`: 生成 Visual Studio 2022 项目文件（根据你的 VS 版本调整）
- `-A x64` 或 `-A Win32`: 目标架构
- `-DCMAKE_INSTALL_PREFIX`: curl 安装目录
- `-DOPENSSL_ROOT_DIR`: OpenSSL 安装目录（必须与之前构建的 OpenSSL 路径一致）
- `-DCURL_USE_OPENSSL=ON`: 启用 OpenSSL 支持
- `-DBUILD_SHARED_LIBS=ON`: 构建动态库（DLL），设为 `OFF` 则构建静态库
- `-DCMAKE_BUILD_TYPE=Release`: 构建类型（Release 或 Debug）

**其他常用选项：**
- `-DCURL_ZLIB=ON`: 启用 zlib 支持（需要先构建 zlib）
- `-DCURL_DISABLE_LDAP=ON`: 禁用 LDAP 支持
- `-DCURL_DISABLE_PROGRESS_METER=ON`: 禁用进度条

### 步骤 5: 编译和安装

```batch
cmake --build . --config Release
cmake --install . --config Release
```

### 步骤 6: 验证安装

```batch
C:\curl-Win64\bin\curl.exe --version
```

应该显示 curl 版本信息，并包含 "OpenSSL" 支持。

## 使用项目构建系统（实验性）

虽然项目的主要构建系统（`build.sh`）主要针对 Unix-like 系统，但理论上可以使用 MSYS2/MinGW 环境来构建。不过，**推荐使用上述 Visual Studio 方法**，因为：

1. 更稳定可靠
2. 生成的是原生 Windows 库
3. 与 Windows 开发工具链完全兼容

## 常见问题

### 1. OpenSSL 配置失败：找不到 Perl

**解决方案：**
- 确保 Perl 已安装并添加到 PATH
- 在命令提示符中运行 `perl --version` 验证

### 2. curl CMake 找不到 OpenSSL

**解决方案：**
- 确保 `-DOPENSSL_ROOT_DIR` 指向正确的 OpenSSL 安装目录
- 检查 OpenSSL 目录结构：
  - `bin/` 包含 DLL 文件
  - `lib/` 包含库文件
  - `include/openssl/` 包含头文件

### 3. 链接错误：找不到 OpenSSL 库

**解决方案：**
- 确保在链接时添加了 OpenSSL 库路径
- 在 Visual Studio 项目中设置：
  - **Additional Include Directories**: `C:\OpenSSL-Win64\include`
  - **Additional Library Directories**: `C:\OpenSSL-Win64\lib`
  - **Additional Dependencies**: `libssl.lib;libcrypto.lib`

### 4. 运行时错误：找不到 DLL

**解决方案：**
- 将 OpenSSL 和 curl 的 `bin` 目录添加到系统 PATH
- 或者将 DLL 文件复制到应用程序目录

## 输出文件位置

### OpenSSL
- **头文件**: `C:\OpenSSL-Win64\include\openssl\`
- **静态库**: `C:\OpenSSL-Win64\lib\libssl.lib`, `libcrypto.lib`
- **动态库**: `C:\OpenSSL-Win64\bin\libssl-1_1-x64.dll`, `libcrypto-1_1-x64.dll`

### curl
- **头文件**: `C:\curl-Win64\include\curl\`
- **静态库**: `C:\curl-Win64\lib\curl.lib`（如果 `BUILD_SHARED_LIBS=OFF`）
- **动态库**: `C:\curl-Win64\bin\libcurl.dll`
- **导入库**: `C:\curl-Win64\lib\libcurl_imp.lib` 或 `libcurl.lib`

## 参考资源

- [OpenSSL 官方文档](https://www.openssl.org/docs/)
- [curl 官方文档](https://curl.se/docs/)
- [CMake 文档](https://cmake.org/documentation/)

## 注意事项

1. **版本匹配**: 确保使用的 OpenSSL 和 curl 版本与项目要求一致（OpenSSL 1.1.1w, curl 7.88.1）
2. **架构一致性**: 确保 OpenSSL 和 curl 使用相同的架构（x64 或 x86）
3. **运行时库**: 确保应用程序使用的运行时库（MT/MTd/MD/MDd）与构建的库一致
4. **依赖顺序**: 必须先构建 OpenSSL，再构建 curl（因为 curl 依赖 OpenSSL）

