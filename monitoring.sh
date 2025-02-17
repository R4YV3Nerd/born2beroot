#!/bin/bash

#                     	   v My Server Stats v

########################### The Architecture ###############################
OS=$(uname -s)
hostname=$(hostname)
kernel_release=$(uname -r)
build_number=$(uname -v | awk '{print $1, $2}')
distro_version_build_date=$(uname -v | awk '{print $4 " " $5 " " $6}')
architecture=$(uname -m)
os_type=$(uname -o)
############################################################################

############################# System Stats #################################
#Physical Cores:
cpu=$(grep 'physical id' /proc/cpuinfo | sort -u | wc -l)
#Threads:
vcpu=$(nproc)
#RAM_Usage:
memUsage=$(free -m | grep Mem | awk '{printf "%d/%dMB (%.2f%%)\n", $3,$2,($3/$2)*100}')
#Disk_Space_Usage:
diskUsage=$(df -hm --total | grep total | awk '{printf "%d/%0.fGb (%s)\n", $3, $2/1024 + 1, $5}')
#CPU_Usage_Average:
cpuLoad=$(uptime | awk -F"load average:" '{print $2}' | awk -F', ' '{printf "%.1f\n", $1*100}')
#Last_Boot_time:
lastBoot=$(who -b | awk '{print $3,$4}')
#Logical_Volume_Manager:
lvmUsage=$(lsblk | grep -q lvm && echo yes || echo no)
#Network_connetions:
tcp=$(ss -neopt state established | grep default | awk '{print $5}')
#Users_logs:
users_logs=$(who | cut -d' ' -f1 | sort -u | wc -l)
#Network_Interface:
INTERFACE=$(ip route | grep default | awk '{print $5}')
#MAC_Address:
MAC=$(ip addr show $INTERFACE | grep "link/ether" | cut -d' ' -f6)
#IP_Address:
IP=$(hostname -I | cut -d' ' -f1)
#Sudo_command_cout:
sudoCmdCount=$(sudoreplay -l -d /var/log/sudo/ | grep COMMAND | wc -l)
###########################################################################

# Output the stats
echo -e "
\t#Architecture: $OS $hostname $kernel_release $build_number $distro_version_build_date $architecture $os_type
\t#CPU physical: $cpu
\t#vCPU physical: $vcpu
\t#Memory Usage: $memUsage
\t#Disk Usage: $diskUsage
\t#CPU Load: $cpuLoad
\t#Last Boot: $lastBoot
\t#LVM use: $lvmUsage
\t#Connections TCP: $tcp ESTABLISHED
\t#User log: $users_logs
\t#Network: IP $IP ($MAC)
\t#Sudo: $sudoCmdCount cmd" | wall
