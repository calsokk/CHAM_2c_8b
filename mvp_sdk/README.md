# CHAM SDK

## 项目结构

```
mvp_public
├── api_examples
├── coverage
│   └── html
│       └── mvp_public
│           └── util
├── python
├── deps
├── include
│   ├── mvp_private
│   │   └── lib
│   │       ├── linux
│   │       └── mac
│   └── mvp_public
│       ├── F3
│       └── util
├── scripts
└── tests

```

* `api_examples` 包含了三个 demo 样例
* `coverage` 包含了 SDK  的单元测试下的覆盖率
* `python` 包含了一层简单的 Python Wrapper 调用 SDK
* `deps` 包含了依赖的三方包的源码。包括
  * `microsoft/SEAL` （版本 3.7.2 ）基础的全同态加密库。本 SDK 涉及的所有同态加密的所有操作都基于 SEAL
  * `microsoft/GSL` （版本 3.1.0）提供 `gsl::span` 接口。
  * `intel/hexl`（版本1.2.2）为 SEAL 提供基于 AVX512 的加速。
  * `google/cpu_features` （版本 0.7.0) hexl 的依赖库。用于获取 CPU 支持的指令。
  * `google/googletests` 用于单元测试
  * `facebook/zstd`（版本 1.5.0) 用于 SEAL 中密文对象的序列化/反序列化。

* `include/mvp_public` 下则是本 SDK 的源码
* `scripts` 包含两个用于编译的脚本
* `tests` 单元测试。需要 Googletest

## 编译

### 前置需求
* C++ compiler 支持 c++17
* cmake (>=3.10)

### 执行编译
* `bash scripts/build-deps.sh` 会编译所有依赖的三方库 `deps/`默认会使用HEXL库，如CPU不支持，在编译时使用`bash script/build-deps.sh 0`将其关闭
* `bash scripts/build.sh` 会编译本 SDK
* `scripts/build.sh` 提供四个可变更项
  * `MVP_ENABLE_TESTS=ON` 设置 `OFF` 则跳过单元测试的编译
  * `MVP_ENABLE_DEMO=ON` 设置 `OFF` 则跳过 demo 样例的编译
  * `MVP_ENABLE_PYTHON_WRAPPER=ON` 设置 `OFF` 则跳过 Python wrapper 的编译
  * `PYTHON_EXE` 设置具体的 Python 版本

### 产出物

* SDK `libmvp_public.a` 存放在 `build/lib/` 目录下
* Python wrapper `_mvp_py.cpython-*.so` 存放在 `build/lib/` 目录下
* demo 样例存放在 `build/bin/` 目录下
* 单元测试 `mvp_pub_tests` 存放在 `build/bin/` 目录下

### Demo 1:

`api_examples/demo_standalone.cc` 样例展示了如何使用本 SDK 完成一次双方的矩阵向量乘。demo 参数: `nrows ncols is_v12 num_threads`

分别代表矩阵行数（2 <=nrows<=4096）；矩阵列数 (1<=ncols)；是否用 v1.2 功能；以及最大线程数目。

如 `build/bin/demo_standalone_cc 256 1024 1 4`  则会利用 FPGAv1.2 的功能 和 4 个线程去计算 256x1024 的矩阵向量乘。

### Demo 2:

在 `demo_standalone.cc`  的基础上。我们模拟网络通信。

`api_examples/demo_end_to_end.cc` 样例展示了如何使用本 SDK 完成一次双方的矩阵向量乘。即一方持有矩阵；而向量则以秘密分享的形式被两方持有。demo 参数: `nrows ncols is_matrix_holder` 分别代表矩阵行数（2 <=nrows<=4096）；矩阵列数 (1<=ncols)；以及是否是矩阵的持有方 (is_matrix_holder=0/1)。本样例需要启动 2 个进程去模拟协议执行双方。如

 `build/bin/demo_end_to_end_cc 256 1024 0 & build/bin/demo_end_to_end_cc 256 1024 1`

本样例会通过 `127.0.0.1:12345` 端口去模拟网络传输。请确保端口 `12345` 是可使用的。

### Demo 3:
`api_examples/demo_user_key.cc` 样例展示了使用 `api::ConvertUserKey` 接口直接利用用户已有的 SEAL 密钥进行运算。 如 H1 可以作为已有的 SEAL 应用的一部分；而无需生成新的密钥。减轻密钥管理的负担。即使既有的 SEAL 密钥是基于非 CKKS 方案也是可行的。

### Demo 4:
`python_example.py` 展示了 Python API 的使用。以联邦学习中为例子, 计算 mat*(vec0+vec1)+0.1*w.
