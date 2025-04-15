#!/bin/bash

# 获取当前日期
date=$(date +"%Y%m%d")

# 定义基本下载文件
base_files=("examples" "quick" "release" "docs")

# 创建下载目录
download_path="./downloads"

# 下载文件函数
download_file() {
    local file=$1
    local url="https://github.com/gogf/goframe.org-pdf/releases/latest/download/${file}.pdf"
    local output_file="${download_path}/${date}_${file}.pdf"
    
    # 确保下载目录存在
    if [ ! -d "$download_path" ]; then
        echo "创建下载目录: $download_path"
        mkdir -p "$download_path"
    fi
    
    # 检查文件是否已存在
    if [ -f "$output_file" ]; then
        echo "文件已存在，跳过下载: $output_file"
        return 0
    fi
    
    echo "正在下载: ${file}.pdf"
    
    # 获取HTTP状态码和下载文件
    local http_code=$(curl -s -w "%{http_code}" -L "$url" -o "$output_file")
    
    # 判断状态码
    if [ "$http_code" = "200" ]; then
        echo "下载完成: $output_file (状态码: $http_code)"
        return 0
    else
        echo "下载失败: ${file}.pdf (状态码: $http_code)"
        # 删除可能不完整的文件
        rm -f "$output_file"
        return 1
    fi
}

# 下载基本文件
for file in "${base_files[@]}"; do
    download_file "$file"
done

# 下载文档部分，自动检测可用部分
# "docs_part1" "docs_part2" "docs_part3" "docs_part4" "docs_part5" "docs_part6"
part=1
while true; do
    file="docs_part${part}"
    if ! download_file "$file"; then
        # 如果下载失败，说明已经没有更多部分了，退出循环
        break
    fi
    part=$((part+1))
done

echo "所有下载任务完成"
