#!/bin/bash
# ============================================================
#  Veeam Agent for Linux – Notifica Telegram a fine job
#  Posiziona questo file su: /etc/veeam/scripts/post_job_telegram.sh
#  Rendilo eseguibile:       chmod +x /etc/veeam/scripts/post_job_telegram.sh
#
#  Token e Chat ID NON vanno scritti qui: mettili in un file separato
#  (non pubblicato su GitHub), ad esempio /etc/veeam/scripts/telegram.conf:
#      TELEGRAM_BOT_TOKEN="123456:ABC..."
#      TELEGRAM_CHAT_ID="123456789"
#      JOB_DIR="/percorso/dei/backup"
#  e proteggilo con: chmod 600 /etc/veeam/scripts/telegram.conf
# ============================================================

CONFIG_FILE="/etc/veeam/scripts/telegram.conf"
[ -f "$CONFIG_FILE" ] && source "$CONFIG_FILE"

if [ -z "${TELEGRAM_BOT_TOKEN}" ] || [ -z "${TELEGRAM_CHAT_ID}" ]; then
    echo "Errore: TELEGRAM_BOT_TOKEN o TELEGRAM_CHAT_ID non impostati in ${CONFIG_FILE}" >&2
    exit 1
fi

# Variabili fornite da Veeam Agent
# VEEAM_JOB_NAME        – nome del job
# VEEAM_JOB_RESULT_CODE – codice: 0=Success, 1=Warning, 2=Failed
JOB_NAME="${VEEAM_JOB_NAME:-Backup Job}"
JOB_RESULT_CODE="${VEEAM_JOB_RESULT_CODE:-0}"

case "${JOB_RESULT_CODE}" in
    0) EMOJI="✅"; JOB_RESULT="Success" ;;
    1) EMOJI="⚠️"; JOB_RESULT="Warning" ;;
    *) EMOJI="❌"; JOB_RESULT="Failed"  ;;
esac

DATETIME=$(date "+%d/%m/%Y %H:%M:%S")
HOST=$(hostname)

# Dimensione totale dei file di backup del job (opzionale: serve JOB_DIR nel file di config)
BACKUP_SIZE="N/D"
if [ -n "${JOB_DIR}" ] && [ -d "${JOB_DIR}" ]; then
    SIZE_BYTES=$(find "${JOB_DIR}" \( -name "*.vbk" -o -name "*.vib" -o -name "*.vrb" \) -printf '%s\n' 2>/dev/null \
                 | awk '{sum+=$1} END {print sum+0}')
    if [ "${SIZE_BYTES}" -gt 0 ] 2>/dev/null; then
        BACKUP_SIZE=$(awk "BEGIN {printf \"%.2f GB\", ${SIZE_BYTES}/1073741824}")
    fi
fi

# Messaggio in HTML (più robusto del Markdown con nomi che contengono "_" o "*")
html_escape() { sed -e 's/&/\&amp;/g' -e 's/</\&lt;/g' -e 's/>/\&gt;/g' <<< "$1"; }
JOB_NAME_H=$(html_escape "${JOB_NAME}")
HOST_H=$(html_escape "${HOST}")

MESSAGE="${EMOJI} <b>Veeam Backup – ${JOB_NAME_H}</b>
🖥 <b>Server:</b> <code>${HOST_H}</code>
📋 <b>Job:</b> <code>${JOB_NAME_H}</code>
📅 <b>Data/Ora:</b> ${DATETIME}
💾 <b>Dimensione backup:</b> ${BACKUP_SIZE}
📊 <b>Esito:</b> ${JOB_RESULT}"

curl -s -X POST "https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/sendMessage" \
    --data-urlencode "chat_id=${TELEGRAM_CHAT_ID}" \
    --data-urlencode "text=${MESSAGE}" \
    --data-urlencode "parse_mode=HTML" \
    > /dev/null 2>&1

exit 0
