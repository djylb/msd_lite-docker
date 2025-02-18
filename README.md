# msd_lite-docker

A Docker container for **msd_lite**, similar to **udpxy**, which converts multicast streams to unicast.

一个msd_lite的Docker容器，类似udpxy，将组播转换为单播流。

[DockerHub](https://hub.docker.com/r/duan2001/msd_lite)
[GHCR](https://github.com/djylb/msd_lite-docker/pkgs/container/msd_lite)

# Usage | 使用说明

## Auto configuration | 自动配置
```shell
# Use ENV
# (supports both parameter passing and environment variables, with environment variables taking priority)
docker run --name msd_lite -e IFNAME=enp7s0 -e PORT=7088 --net=host --restart=unless-stopped duan2001/msd_lite

# Or
docker run --name msd_lite --net=host --restart=unless-stopped duan2001/msd_lite vlan77 7088 # Network interface and port number (listening port can be omitted)
```

## Manual configuration | 手动配置

```shell
docker run -d --name=msd_lite --restart=unless-stopped -v ${PWD}/msd_lite:/etc/msd_lite --net=host duan2001/msd_lite

mv msd_lite/msd_lite.conf.sample msd_lite/msd_lite.conf

nano msd_lite/msd_lite.conf

docker restart msd_lite
```

## Advanced Usage | 高级用法

```shell
docker run -d --name=msd_lite -e IFNAME=br1 -e PORT=7088 --restart=unless-stopped -v ${PWD}/msd_lite:/etc/msd_lite --net=host duan2001/msd_lite
```

# Links

[msd_lite](https://github.com/rozhuk-im/msd_lite)
