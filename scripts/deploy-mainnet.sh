#!/usr/bin/env bash
# =============================================================================
#  scripts/deploy-mainnet.sh
#  Deploy the VestFlow contract to Stellar Mainnet.
#
#  Prerequisites:
#    • Rust + wasm32v1-none target installed
#    • Stellar CLI installed  (https://developers.stellar.org/docs/tools/developer-tools/cli/install-cli)
#    • A funded deployer key in the Stellar CLI keystore
#
#  Usage:
#    chmod +x scripts/deploy-mainnet.sh
#    DEPLOYER_KEY=deployer ./scripts/deploy-mainnet.sh
#
#  The script will:
#    1. Build the WASM in release mode
#    2. Deploy to mainnet and print the contract ID
#    3. Remind you to update .env.local and CSP config
# =============================================================================
set -euo pipefail

# ── Config ────────────────────────────────────────────────────────────────────
NETWORK="mainnet"
NETWORK_PASSPHRASE="Public Global Stellar Network ; September 2015"
RPC_URL="https://mainnet.sorobanrpc.com"
WASM_PATH="target/wasm32v1-none/release/vestflow.wasm"
DEPLOYER_KEY="${DEPLOYER_KEY:-deployer}"   # override via env var

# ── Safety gate ──────────────────────────────────────────────────────────────
echo ""
echo "⚠️  You are about to deploy VestFlow to STELLAR MAINNET."
echo "   This is irreversible — the contract has no upgrade path."
echo ""
echo "   Mainnet deployment checklist:"
echo "   [ ] Security audit or internal review completed"
echo "   [ ] Immutability decision documented"
echo "   [ ] Deployer key management procedure followed"
echo "   [ ] .env.local updated with mainnet values"
echo "   [ ] next.config.ts CSP verified for mainnet RPC endpoint"
echo ""
read -rp "Type 'deploy' to continue: " CONFIRM
if [[ "${CONFIRM}" != "deploy" ]]; then
  echo "Aborted."
  exit 1
fi

# ── Build ─────────────────────────────────────────────────────────────────────
echo ""
echo "▶ Building WASM..."
(
  cd "$(dirname "$0")/../contracts/vestflow"
  cargo build --target wasm32v1-none --release 2>&1
)

# ── Deploy ────────────────────────────────────────────────────────────────────
echo ""
echo "▶ Deploying to ${NETWORK}..."
CONTRACT_ID=$(stellar contract deploy \
  --wasm "$(dirname "$0")/../${WASM_PATH}" \
  --source "${DEPLOYER_KEY}" \
  --network "${NETWORK}" \
  --rpc-url "${RPC_URL}" \
  --network-passphrase "${NETWORK_PASSPHRASE}")

echo ""
echo "✅  Contract deployed successfully!"
echo "   Contract ID: ${CONTRACT_ID}"
echo ""
echo "Next steps:"
echo "  1. Add to .env.local:  NEXT_PUBLIC_CONTRACT_ID=${CONTRACT_ID}"
echo "  2. Set:                NEXT_PUBLIC_NETWORK=mainnet"
echo "  3. Rebuild frontend:   npm run build"
