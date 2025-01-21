---
title: Make a conversation with Docker containers
layout: post
description: How can we manage to group two of them or more and allow them to communicate together?
date: 2020-11-22 00:00:00 +0200
categories: [devops]
tags: [docker, container, network]
image:
  path: ../assets/img/features/noaa-AQx2VH2731k-unsplash.jpg
  alt: Unsplash / NOAA
  caption: <a href="https://unsplash.com/photos/pod-of-melon-headed-whales-AQx2VH2731k">Unsplash / NOAA</a>
---

We have some times playing around the Docker container as standalone app. How can we manage to group two of them or more and allow them to communicate together?

A network between Docker container is called "Bridge". Bridge can be one of the followings:

1. **Default bridge**  
  This is the out-of-the-box bridge. Active containers will be automatically added into the default bridge. We can use a local IP of a container inside this bridge.
1. **User-defined bridge**  
  Its benefits are letting us refer other containers in the bridge by their names (not only IP addresses) and allowing to control which containers do connect to this bridge. So this bridge type has more secure.

---

## Bridge information

We can verify IP addresses and connected bridges of a containers by this command.

```sh
docker inspect -f '{{json .NetworkSettings.Networks}}' container_name | json_pp
```

Apply `-f` to format the output with `'{{json .NetworkSettings.Networks}}'` for JSON format then find the value at the jsonpath `$.NetworkSettings.Networks`. Finally apply `json_pp` (JSON Pretty Print) for JSON formatting output. Here is an example output.

```json
{
   "bridge" : {
      "GlobalIPv6PrefixLen" : 0,
      "Aliases" : null,
      "IPPrefixLen" : 16,
      "IPv6Gateway" : "",
      "IPAddress" : "172.17.0.4",
      "Gateway" : "172.17.0.1",
      "EndpointID" : "5d72289befb7a1bbaad35b4042dc3ae59fde42c90317d9d70c87b3038008607e",
      "MacAddress" : "02:42:ac:11:00:04",
      "DriverOpts" : null,
      "IPAMConfig" : null,
      "NetworkID" : "e6c26e049348db683f946490bd80d3fcc803578fd8ec1abae41c3b1b7e84ce5f",
      "Links" : null,
      "GlobalIPv6Address" : ""
   }
}
```

The "bridge" is name of the default bridge. Now we know that this container is "172.17.0.4" in the default bridge. We can ping this IP when we are in this bridge.

![ping](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/docker-network/Screen-Shot-2020-11-21-at-21.05.35.png)
*IP is reachable*

---

## User-defined bridge

It is the time we can build our bridges with this command.

```sh
docker network create bridge_name
```

And list all bridges.

```sh
docker network list
```

So we run this to add or remove a container in the bridges.

```sh
docker network connect bridge_name container_name
docker network disconnect bridge_name container_name
```

After all, run this to show a bridge's information.

```sh
docker network inspect bridge_name
```

Here is the sample result.

```json
[
    {
        "Name": "test",
        "Id": "f8a27b4a91f1009aaaa123e193fde235524e5f47c139eb0ef4d7fde7845bc9ed",
        "Created": "2020-11-01T11:08:49.3282456Z",
        "Scope": "local",
        "Driver": "bridge",
        "EnableIPv6": false,
        "IPAM": {
            "Driver": "default",
            "Options": {},
            "Config": [
                {
                    "Subnet": "172.18.0.0/16",
                    "Gateway": "172.18.0.1"
                }
            ]
        },
        "Internal": false,
        "Attachable": false,
        "Ingress": false,
        "ConfigFrom": {
            "Network": ""
        },
        "ConfigOnly": false,
        "Containers": {
            "9f149d228c696dc59ac5e3f36a472fb3ad3718fe6f430f8be9905fabdcd13161": {
                "Name": "cent02",
                "EndpointID": "d83a77953ef70310fb32ed4c80da8111390f4176c8958a1bc1985c60a2f430e4",
                "MacAddress": "02:42:ac:12:00:03",
                "IPv4Address": "172.18.0.3/16",
                "IPv6Address": ""
            },
            "f9a4d56b6f1c1316ad7f450c8bc1fc678bde07f495d2b363a839a49b8fd9601d": {
                "Name": "cent01",
                "EndpointID": "4853528b9c8883770276d68edd57be11fc4f8bdf25154011929662f5d3a789a9",
                "MacAddress": "02:42:ac:12:00:02",
                "IPv4Address": "172.18.0.2/16",
                "IPv6Address": ""
            }
        },
        "Options": {},
        "Labels": {}
    }
]
```

As we mentioned before, the container can be identified by its name since it is a user-defined bridge. We try to ping "cent01" container.

![ping 2](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/docker-network/Screen-Shot-2020-11-21-at-21.17.06.png)
*Container name is reachable now*

At the last, remove the bridge after use with the command.

```sh
docker network rm bridge_name
```

---

The bridge is useful for us if we want to develop multiple containers and require a communication system between them.

---

## References

- [Bridge network driver](https://docs.docker.com/engine/network/drivers/bridge/)
- [EP4 Docker ทีเล่น ทีจริง (Thai)](https://medium.com/nectec/ep4-docker-ทีเล่น-ทีจริง-c4dafb7a7e37)
