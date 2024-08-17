#!/usr/bin/env bash

ip netns add ns1
ip netns add ns2

ip link add vnet0 type bridge
ip link set vnet0 up
brctl show

ip link add veth1 type veth peer veth1-br
ip link add veth2 type veth peer veth2-br

ip link set veth1 netns ns1
ip link set veth2 netns ns2

ip link set veth1-br master vnet0
ip link set veth2-br master vnet0

ip netns exec ns1 ip addr add 192.168.15.1/24 dev veth1
ip netns exec ns2 ip addr add 192.168.15.2/24 dev veth2

ip netns exec ns1 ip link set veth1 up
ip netns exec ns2 ip link set veth2 up
ip link set veth1-br up
ip link set veth2-br up

ip netns exec ns1 ping 192.168.15.2
ip netns exec ns2 ping 192.168.15.1

ip netns delete ns1
ip netns delete ns2
ip link set dev vnet0 down
ip link del vnet0

