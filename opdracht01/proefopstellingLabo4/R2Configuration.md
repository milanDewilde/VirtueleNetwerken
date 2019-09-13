R2(config)#do show running-config
Building configuration...


Current configuration : 1563 bytes
!
! Last configuration change at 15:32:15 UTC Mon Feb 25 2019
!
version 15.5
service timestamps debug datetime msec
service timestamps log datetime msec
no platform punt-keepalive disable-kernel-core
!
hostname R2
!
boot-start-marker
boot-end-marker
!
!
vrf definition Mgmt-intf
 !
 address-family ipv4
 exit-address-family
 !
 address-family ipv6
 exit-address-family
!
enable secret 5 $1$J6DR$VdNOCnQT8mv2zMjTKUDMZ0
!
no aaa new-model
!
!
!
!
!
!
!
!
!
!
!



no ip domain lookup
!
!
!
!
!
!
!
!
!
!
subscriber templating
multilink bundle-name authenticated
!
!
!
!
license udi pid ISR4321/K9 sn FDO22273YW2
!
spanning-tree extend system-id
!
!
redundancy
 mode none
!
!
vlan internal allocation policy ascending
!
!
!
!
!
!
interface GigabitEthernet0/0/0
 ip address 172.16.1.1 255.255.255.0
 negotiation auto
!
interface GigabitEthernet0/0/1
 no ip address
 shutdown
 negotiation auto
!
interface Serial0/1/0
 ip address 172.16.2.2 255.255.255.0
!
interface Serial0/1/1
 ip address 192.168.1.2 255.255.255.0
!
interface GigabitEthernet0
 vrf forwarding Mgmt-intf
 no ip address
 shutdown
 negotiation auto
!
interface Vlan1
 no ip address
 shutdown
!
ip forward-protocol nd
no ip http server
no ip http secure-server
ip tftp source-interface GigabitEthernet0
ip route 172.16.3.0 255.255.255.0 Serial0/1/0
ip route 192.168.2.0 255.255.255.0 192.168.1.1
!
!
!
!
!
control-plane
!
!
line con 0
 exec-timeout 0 0
 password password
 logging synchronous
 login
 stopbits 1
line aux 0
 stopbits 1
line vty 0 4
 exec-timeout 0 0
 logging synchronous
 login
!
!
end