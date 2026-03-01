# VPS 快速部署

一键脚本，在 CentOS 9 Stream 上自动完成以下操作：

1. **Wget 安装** - 下载并安装 wget 工具
2. **BBR 加速** - 开启 TCP BBR 拥塞控制算法，提升网络性能
3. **Sing-box 部署** - 安装并配置 Sing-box 代理工具



## 使用方法

- 一键安装

```shell
curl -Ls https://raw.githubusercontent.com/frank-lam/vps-ss/master/sing-box/install-sb-bbr-on-centos9s.sh | sudo bash
```

- 可选

```shell
# 限制磁盘读写速度
systemctl set-property user-0.slice IOWriteBandwidthMax="/dev/vda1 120M" IOReadBandwidthMax="/dev/vda1 120M"
```



## 系统要求

- 操作系统：CentOS 9 Stream (x86_64)
- 架构：64 位



## 验证

脚本执行完成后，可使用以下命令验证 BBR 是否开启：

```shell
sysctl net.ipv4.tcp_congestion_control
```

输出结果包含 `bbr` 即表示成功。
