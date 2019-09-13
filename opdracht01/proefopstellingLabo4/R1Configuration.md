R1#show running-config
Building configuration...


Current configuration : 1468 bytes
!
! Last configuration change at 16:36:11 UTC Mon Feb 25 2019
!
version 15.5
service timestamps debug datetime msec
service timestamps log datetime msec
no platform punt-keepalive disable-kernel-core
!
hostname R1
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
enable secret 5 $1$cSmT$Ihg0.BoXTAA9AKFRNalte/
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
license udi pid ISR4321/K9 sn FDO222744LX
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
 ip address 172.16.3.1 255.255.255.0
 negotiation auto
!
interface GigabitEthernet0/0/1
 no ip address
 shutdown
 negotiation auto
!
interface Serial0/1/0
 ip address 172.16.2.1 255.255.255.0
!
interface Serial0/1/1
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
ip route 0.0.0.0 0.0.0.0 172.16.2.2
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
 password PASSWORD
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

R1#
