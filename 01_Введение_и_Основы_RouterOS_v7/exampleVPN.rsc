# =====================================================================
# Policy-Based Routing: Направление конкретных доменов в туннель v2raya
# =====================================================================

# 1. Создаем отдельную таблицу маршрутизации
/routing table
add disabled=no fib name=VPN

# 2. Перехватываем DNS-запросы к нужным доменам и динамически добавляем их IP в VPN_LIST
/ip dns static
add address-list=VPN_LIST forward-to=8.8.8.8 match-subdomain=yes name=googlevideo.com type=FWD
add address-list=VPN_LIST forward-to=8.8.8.8 match-subdomain=yes name=ytimg.com type=FWD
add address-list=VPN_LIST forward-to=8.8.8.8 match-subdomain=yes name=ggpht.com type=FWD
add address-list=VPN_LIST forward-to=8.8.8.8 match-subdomain=yes name=youtube.com type=FWD
add address-list=VPN_LIST forward-to=8.8.8.8 match-subdomain=yes name=github.com type=FWD
add address-list=VPN_LIST forward-to=8.8.8.8 match-subdomain=yes name=githubusercontent.com type=FWD

# (Опционально) Статичное добавление доменов/IP напрямую в список
/ip firewall address-list
add address=www.youtube.com list=VPN_LIST

# 3. Маркируем трафик из локальной сети, идущий к адресам из VPN_LIST
/ip firewall mangle
add action=mark-routing chain=prerouting dst-address-list=VPN_LIST in-interface-list=LAN new-routing-mark=VPN comment="Mark traffic for v2ray domains"

# 4. Отправляем промаркированный трафик на шлюз v2raya 
# ВНИМАНИЕ: Замените IP-адрес шлюза на актуальный перед импортом!
/ip route
add disabled=no dst-address=0.0.0.0/0 gateway={YOUR_V2RAYA_IP} routing-table=VPN comment="Route VPN_LIST to v2raya server"