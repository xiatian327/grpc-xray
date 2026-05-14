#!/bin/sh

# 读取环境变量，如果没有则使用默认值
PORT=${PORT:-3000}
UUID=${UUID:-"5efabea4-f6d4-91fd-b8f0-17e004c89c60"}
# 在 gRPC 中，我们用 SUB_PATH 或 WSPATH 作为 ServiceName
SERVICE_NAME=${SUB_PATH:-"mypath"}

echo "👉 配置项: 端口=$PORT, UUID=$UUID, gRPC服务名=$SERVICE_NAME"

# 生成 Xray 的 config.json
cat <<EOF > /app/config.json
{
  "log": {
    "loglevel": "warning"
  },
  "inbounds": [
    {
      "port": $PORT,
      "protocol": "vless",
      "settings": {
        "clients": [
          {
            "id": "$UUID"
          }
        ],
        "decryption": "none"
      },
      "streamSettings": {
        "network": "grpc",
        "grpcSettings": {
          "serviceName": "$SERVICE_NAME"
        }
      }
    }
  ],
  "outbounds": [
    {
      "protocol": "freedom"
    }
  ]
}
EOF

# 启动 Xray
echo "🚀 启动 Xray gRPC 直连服务..."
exec /app/xray -config /app/config.json