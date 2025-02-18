# msd_lite-docker

一个msd_lite的Docker容器，类似udpxy，将组播转换为单播流。

[DockerHUB](https://hub.docker.com/r/duan2001/msd_lite)

[GHCR](https://github.com/djylb/msd_lite-docker/pkgs/container/msd_lite)

## 使用说明
```shell
# 直接配置组播所在网卡和监听端口号（支持参数传递和环境变量两种配置方式，环境变量优先级最高）
docker run --name msd_lite -e IFNAME=enp7s0 -e PORT=7088 --net=host --restart=unless-stopped duan2001/msd_lite
# 或者
docker run --name msd_lite --net=host --restart=unless-stopped duan2001/msd_lite vlan77 7088 # 网卡 端口号 （监听端口号可省略）


# 手动配置文件
# 第一次启动后将msd_lite目录下的配置文件msd_lite.conf.sample重命名为msd_lite.conf，然后根据需要修改配置
docker run -d --name=msd_lite --restart=unless-stopped -v ${PWD}/msd_lite:/etc/msd_lite --net=host duan2001/msd_lite
# 之后再次启动即可
docker start msd_lite


# 高级用法
docker run -d --name=msd_lite -e IFNAME=br1 -e PORT=7088 --restart=unless-stopped -v ${PWD}/msd_lite:/etc/msd_lite --net=host duan2001/msd_lite
```

## Links

[msd_lite](https://github.com/rozhuk-im/msd_lite)
