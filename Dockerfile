FROM alpine:latest

# 安装必要依赖
RUN apk add --no-cache tzdata ca-certificates wget busybox unzip

# 创建工作目录
WORKDIR /app

# 下载最新版的 Xray-core (以 amd64 架构为例，SAP CF 环境通常是 x86_64)
RUN wget -qO- https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip | busybox unzip -d /app - \
    && rm /app/*.dat /app/*.json \
    && chmod +x /app/xray

# 复制启动脚本并赋予执行权限
COPY entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

# 暴露端口 (通常云平台会覆盖这个，留作本地测试用)
EXPOSE 3000

# 运行脚本
CMD ["/app/entrypoint.sh"]