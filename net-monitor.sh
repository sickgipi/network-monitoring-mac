#!/bin/bash
# 🌐 net-monitor.sh - Script di monitoraggio rete base
# 👤 Autore: Giovanni Bueno
# 📅 Uso: ./net-monitor.sh

LOG_FILE="network_report_$(date +%Y%m%d_%H%M).txt"

echo "🌐 Generazione report di rete in corso..."
echo "========================================" > "$LOG_FILE"
echo "📅 Data: $(date)" >> "$LOG_FILE"
echo "🖥️ Host: $(hostname)" >> "$LOG_FILE"

echo -e "\n🔌 IP Locali Attivi:" >> "$LOG_FILE"
ifconfig | grep "inet " | grep -v "127.0.0.1" | awk '{print $2}' >> "$LOG_FILE"

echo -e "\n🚪 Gateway Predefinito:" >> "$LOG_FILE"
netstat -nr | grep "default" | awk '{print $2}' | head -1 >> "$LOG_FILE"

echo -e "\n🌍 Test Connettività (8.8.8.8):" >> "$LOG_FILE"
if ping -c 3 -W 2 8.8.8.8 >/dev/null 2>&1; then
    echo "✅ RAGGIUNGIBILE" >> "$LOG_FILE"
else
    echo "❌ NON RAGGIUNGIBILE" >> "$LOG_FILE"
fi

echo -e "\n🌐 IP Pubblico:" >> "$LOG_FILE"
curl -s --max-time 5 ifconfig.me >> "$LOG_FILE" 2>/dev/null || echo "N/D" >> "$LOG_FILE"

echo -e "\n🔍 Servizi in ascolto (top 5):" >> "$LOG_FILE"
lsof -i -P -n 2>/dev/null | grep LISTEN | awk '{print $1, $9}' | sort | uniq -c | sort -rn | head -5 >> "$LOG_FILE" 2>/dev/null || echo "Nessun dato" >> "$LOG_FILE"

echo "========================================" >> "$LOG_FILE"
echo "✅ Report salvato: $LOG_FILE"
