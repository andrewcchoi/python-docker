#!/bin/bash
# Permissive firewall configuration for intermediate sandbox
# Allows most outbound traffic for development convenience

set -e

echo "Setting up permissive firewall rules..."

# Flush existing rules
iptables -F
iptables -X
iptables -t nat -F
iptables -t nat -X
iptables -t mangle -F
iptables -t mangle -X

# Default policies - allow outbound, drop inbound (except established)
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT

# Allow loopback
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

# Allow established and related connections
iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

# Allow incoming traffic on Flask port (5000)
iptables -A INPUT -p tcp --dport 5000 -j ACCEPT

# Allow common development ports (permissive for convenience)
# HTTP/HTTPS
iptables -A INPUT -p tcp --dport 80 -j ACCEPT
iptables -A INPUT -p tcp --dport 443 -j ACCEPT

# Common databases
iptables -A INPUT -p tcp --dport 5432 -j ACCEPT  # PostgreSQL
iptables -A INPUT -p tcp --dport 3306 -j ACCEPT  # MySQL
iptables -A INPUT -p tcp --dport 6379 -j ACCEPT  # Redis
iptables -A INPUT -p tcp --dport 27017 -j ACCEPT # MongoDB

# Allow DNS
iptables -A INPUT -p udp --dport 53 -j ACCEPT
iptables -A INPUT -p tcp --dport 53 -j ACCEPT

# Allow ICMP (ping)
iptables -A INPUT -p icmp -j ACCEPT

echo "Permissive firewall rules configured successfully"
echo "Outbound: All traffic allowed"
echo "Inbound: Flask port 5000 and common development services allowed"
