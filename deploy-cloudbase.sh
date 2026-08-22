#!/bin/bash

# 長楽炉端烧 · 轻松版包装系统 —— 微信云开发静态托管部署脚本
# 使用前请确保：
#   1. 已安装 Node.js
#   2. 已全局安装 CloudBase CLI：npm i -g @cloudbase/cli
#   3. 已登录：tcb login
#   4. 已创建微信云开发环境，并把环境 ID 写入 .env 文件

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# 检查 tcb 命令
if ! command -v tcb &> /dev/null; then
    echo "错误：未找到 tcb 命令"
    echo "请先安装 CloudBase CLI：npm i -g @cloudbase/cli"
    exit 1
fi

# 读取环境 ID
if [ -f .env ]; then
    export $(grep -v '^#' .env | xargs)
fi

if [ -z "$TCB_ENV_ID" ] || [ "$TCB_ENV_ID" = "your-env-id-here" ]; then
    echo "请先在 .env 文件中填写你的微信云开发环境 ID（TCB_ENV_ID）"
    echo "格式参考：.env.example"
    exit 1
fi

echo "================================"
echo "部署到微信云开发静态托管"
echo "环境 ID: $TCB_ENV_ID"
echo "================================"

# 登录检查（如果未登录会自动跳转浏览器）
echo "检查登录状态..."
tcb login

# 部署当前目录到静态托管根路径
echo "开始上传文件..."
tcb hosting deploy . -e "$TCB_ENV_ID"

echo ""
echo "================================"
echo "部署完成"
echo "================================"
echo "默认访问地址可在微信云开发控制台查看"
echo "路径：云开发控制台 -> 基础服务 -> 静态网站托管 -> 默认域名"
