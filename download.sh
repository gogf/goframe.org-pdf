#!/bin/bash

# 获取当前日期
date=$(date +"%Y%m%d")

# 定义下载文件列表
files=("docs_1-100" "docs_101-200" "docs_201-300" "docs_301-400" "docs_401-470" "docs_401-479" "examples" "quick" "release")

# 创建下载目录
download_path="./downloads"
mkdir -p "$download_path"

# 下载文件
for file in "${files[@]}"; do
    url="https://github.com/gogf/goframe.org-pdf/releases/latest/download/${file}.pdf"
    output_file="${download_path}/${date}_${file}.pdf"
    echo "正在下载: ${file}.pdf"
    if curl -L "$url" -o "$output_file" 2>/dev/null; then
        echo "下载完成: $output_file"
    else
        echo "下载失败: ${file}.pdf"
    fi
done

echo "所有下载任务完成"
