#!/bin/bash

# 長楽炉端烧 · 轻松版包装系统 —— 微信云开发静态托管部署脚本
# 使用前请确保：
#   1. 已安装 Node.js
#   2. 已创建微信云开发环境，并把环境 ID 写入 .env 文件
#   3. 已登录：tcb login（首次运行时脚本会引导登录）

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# 优先使用本地安装的 CloudBase CLI，其次查找全局命令
if [ -f "./node_modules/@cloudbase/cli/bin/tcb" ]; then
    TCB_CLI="./node_modules/@cloudbase/cli/bin/tcb"
elif command -v tcb &> /dev/null; then
    TCB_CLI="tcb"
else
    echo "未找到 CloudBase CLI，正在本地安装..."
    npm install @cloudbase/cli
    TCB_CLI="./node_modules/@cloudbase/cli/bin/tcb"
fi

echo "使用 CLI: $TCB_CLI"

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
$TCB_CLI login

# 准备部署目录（只包含需要上传的文件）
echo "准备部署目录..."
rm -rf dist
mkdir -p dist
cp index.html dist/
cp 長楽炉端烧_包装系统主视觉_轻松版.jpg dist/
cp 長楽炉端烧_外卖袋效果图_轻松版.jpg dist/
cp 長楽炉端烧_打包餐盒效果图_轻松版.jpg dist/
cp 長楽炉端烧_杯套效果图_轻松版.jpg dist/
cp 長楽炉端烧_筷子套效果图_轻松版.jpg dist/
cp 長楽炉端烧_湿巾包装效果图_轻松版.jpg dist/
cp 長楽炉端烧_牙签旗效果图_轻松版.jpg dist/
cp 長楽炉端烧_封口贴效果图_轻松版.jpg dist/
cp 長楽炉端烧_首次到店礼袋效果图_轻松版.jpg dist/
cp 長楽炉端烧_生日卡效果图_轻松版.jpg dist/
cp 長楽炉端烧_感谢卡效果图_轻松版.jpg dist/
cp 長楽炉端烧_用餐碗效果图_轻松版.jpg dist/
cp 長楽炉端烧_用餐盘效果图_轻松版.jpg dist/
cp 長楽炉端烧_厨师服装效果图_轻松版.jpg dist/
cp 長楽炉端烧_服务员服装效果图_轻松版.jpg dist/
cp 長楽炉端烧_店长服装效果图_轻松版.jpg dist/

# 部署 dist 目录到静态托管根路径
echo "开始上传文件..."
$TCB_CLI hosting deploy dist -e "$TCB_ENV_ID"

echo ""
echo "================================"
echo "部署完成"
echo "================================"
echo "默认访问地址可在微信云开发控制台查看"
echo "路径：云开发控制台 -> 基础服务 -> 静态网站托管 -> 默认域名"
