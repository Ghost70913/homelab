#!/bin/bash
# ============================================================
#  Veeam Agent for Linux – Post-job Telegram Notification
#  Posiziona questo file su: /etc/veeam/scripts/post_job_telegram.sh
#  Rendilo eseguibile: chmod +x /etc/veeam/scripts/post_job_telegram.sh
# ============================================================

# ─── CONFIGURAZIONE ─────────────────────────────────────────
TELEGRAM_BOT_TOKEN=""       # Token del tuo bot Telegram
TELEGRAM_CHAT_ID=""           # Chat ID dove inviare il messaggio
# ────────────────────────────────────────────────────────────

# Variabili fornite da Veeam Agent (disponibili automaticamente)
# VEEAM_JOB_NAME        – nome del job
# VEEAM_JOB_RESULT      – risultato: Success | Warning | Failed
# VEEAM_JOB_RESULT_CODE – codice: 0=Success, 1=Warning, 2=Failed

JOB_NAME="${VEEAM_JOB_NAME:-Backup Job}"
JOB_RESULT_CODE="${VEEAM_JOB_RESULT_CODE:-0}"
case "${VEEAM_JOB_RESULT_CODE}" in
    0) JOB_RESULT="Success" ;;
    1) JOB_RESULT="Warning" ;;
    *) JOB_RESULT="Failed" ;;
esac
DATETIME=$(date "+%d/%m/%Y %H:%M:%S")
HOSTNAME=$(hostname)

# Calcola dimensione totale del job di backup corrente
BACKUP_SIZE="N/D"
JOB_DIR="\percoso job ${JOB_NAME}" # inserisci percorso job 

if [ -d "${JOB_DIR}" ]; then
    SIZE_BYTES=$(sudo find "${JOB_DIR}" \( -name "*.vbk" -o -name "*.vib" -o -name "*.vrb" \) -printf '%s\n' 2>/dev/null | awk '{sum+=$1} END {print sum}')
    if [ -n "${SIZE_BYTES}" ] && [ "${SIZE_BYTES}" -gt 0 ] 2>/dev/null; then
        BACKUP_SIZE=$(awk "BEGIN {printf \"%.2f GB\", ${SIZE_BYTES}/1073741824}")
    fi
fi
# Scegli emoji in base all'esito
case "${JOB_RESULT_CODE}" in
    0) EMOJI="✅"; STATO="SUCCESSO" ;;
    1) EMOJI="⚠️"; STATO="WARNING" ;;
    *) EMOJI="❌"; STATO="FALLITO" ;;
esac

# Componi il messaggio

MESSAGE="${EMOJI} *Veeam Backup – ${JOB_NAME}*
🖥 *Server:* \`${HOSTNAME}\`
📋 *Job:* \`${JOB_NAME}\`
📅 *Data/Ora:* ${DATETIME}
💾 *Dimensione backup:* ${BACKUP_SIZE}
📊 *Esito:* ${JOB_RESULT}


# Invia il messaggio via Telegram API
curl -s -X POST "https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/sendMessage" \
    --data-urlencode "chat_id=${TELEGRAM_CHAT_ID}" \
    --data-urlencode "text=${MESSAGE}" \
    --data-urlencode "parse_mode=Markdown" \
    > /dev/null 2>&1

exit 0
