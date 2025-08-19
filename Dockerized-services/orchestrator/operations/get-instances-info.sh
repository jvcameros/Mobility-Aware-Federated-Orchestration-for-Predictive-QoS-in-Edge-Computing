#!/bin/bash
set -euo pipefail

# Configuración
OUTPUT_FILE="instances-info.json"
CLUSTER_NET=${CLUSTER_NET:-}
if [[ -z "$CLUSTER_NET" ]]; then
  echo "❌ Error: La variable CLUSTER_NET no está definida. Exporta CLUSTER_NET=<nombre_de_red> antes de ejecutar." >&2
  exit 1
fi

echo "[]" > "$OUTPUT_FILE"

# Función para obtener la información de puertos de una instancia
echo "🔍 Definiendo función get_ports_json..."
get_ports_json() {
  local INSTANCE_ID="$1"
  local PORTS_JSON="[]"

  PORTS_RAW=$(openstack port list --server "$INSTANCE_ID" -f json) || {
    echo "⚠️ Error obteniendo puertos de $INSTANCE_ID" >&2
    echo "[]"
    return
  }

  mapfile -t PORTS < <(echo "$PORTS_RAW" | jq -c '.[]')
  for port in "${PORTS[@]}"; do
    PORT_ID=$(echo "$port" | jq -r '.ID')
    PORT_NAME=$(echo "$port" | jq -r '.Name')

    # Extraer network del nombre del puerto (penúltimo segmento)
    IFS='-' read -r -a parts <<< "$PORT_NAME"
    if [[ ${#parts[@]} -ge 2 ]]; then
      NETWORK=${parts[-2]}
    else
      NETWORK="unknown"
    fi

    FIXED_IP=$(echo "$port" | jq -r '."Fixed IP Addresses"[0].ip_address // empty')

    FLOATING_IPS_RAW=$(openstack floating ip list --port "$PORT_ID" -f json || echo '[]')
    FLOATING_IPS=$(echo "$FLOATING_IPS_RAW" | jq '[.[]."Floating IP Address"]' 2>/dev/null || echo '[]')

    PORT_JSON=$(jq -n \
      --arg port_id "$PORT_ID" \
      --arg network "$NETWORK" \
      --arg fixed_ip "$FIXED_IP" \
      --argjson floating_ips "$FLOATING_IPS" \
      '{ port_id: $port_id, network: $network, fixed_ip: ($fixed_ip // null), floating_ips: $floating_ips }')

    PORTS_JSON=$(echo "$PORTS_JSON" | jq ". + [$PORT_JSON]")
  done

  echo "$PORTS_JSON"
}

echo "🔍 Obteniendo lista de instancias..."
mapfile -t INSTANCES < <(openstack server list -f json | jq -c '.[]')
for instance in "${INSTANCES[@]}"; do
  NAME=$(echo "$instance" | jq -r '.Name')
  ID=$(echo "$instance" | jq -r '.ID')

  # Filtrar instancias: incluir masters y orchestrator_*, excluir workers, resto según red local
  if [[ "$NAME" == worker-* ]]; then
    continue
  elif [[ "$NAME" =~ ^master ]]; then
    : # incluir masters
  elif [[ "$NAME" =~ ^orchestrator_ ]]; then
    : # incluir orquestadores (prefijos orchestrator_)
  else
    # Para otros nodos, incluir solo si tienen puerto en la red local
    PORTS_RAW=$(openstack port list --server "$ID" -f json)
    if ! echo "$PORTS_RAW" | jq -e --arg net "$CLUSTER_NET" '.[] | select(.Name | test("-\($net)-"))' >/dev/null; then
      continue
    fi
  fi

  echo "📦 Procesando $NAME ($ID)..."
  PORTS_JSON=$(get_ports_json "$ID")

  INSTANCE_JSON=$(jq -n \
    --arg name "$NAME" \
    --argjson ports "$PORTS_JSON" \
    '{ name: $name, ports: $ports }')

  TMP=$(mktemp)
  jq ". + [$INSTANCE_JSON]" "$OUTPUT_FILE" > "$TMP" && mv "$TMP" "$OUTPUT_FILE"
done

echo "✅ File generado: $OUTPUT_FILE"
