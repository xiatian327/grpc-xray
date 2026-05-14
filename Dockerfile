FROM alpine:latest

# 安装必要依赖 (去掉了 busybox，直接用原生的 unzip)
RUN apk add --no-cache tzdata ca-certificates wget unzip

# 创建工作目录
WORKDIR /app

# 下载最新版的 Xray-core，保存为 xray.zip，然后再解压
RUN wget -O xray.zip https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip \
    && unzip xray.zip -d /app \
    && rm -f xray.zip /app/*.dat /app/*.json \
    && chmod +x /app/xray

# 复制启动脚本并赋予执行权限
COPY entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

# 暴露端口
EXPOSE 3000

# 运行脚本
CMD ["/app/entrypoint.sh"]
