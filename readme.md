
# Move Language 
---

## 📁 Project Structure

movetest/
├── sources/
│   └── hello_blockchain.move
├── tests/
├── scripts/
├── Move.toml
├── config.yaml
└── README.md

---

## ⚙️ Prerequisites

- [Install Aptos CLI](https://aptos.dev/tools/cli/install-cli/)
- Node with Move and Git installed

---

## 🔧 Setup

### 1. Update `Move.toml` with your address

Replace the underscore with your account address from `config.yaml`:

```toml
[addresses]
hello_blockchain = "address"

⸻

🛠️ Compile the Code

aptos move compile

⸻

✅ Run Unit Tests

aptos move test

This runs the test function sender_can_set_message.

⸻

🚀 Publish Module to Testnet

aptos move publish --profile default

Uses your config.yaml to deploy to Movement Testnet.

⸻

📝 Set a Message (Entry Function)

aptos move run \
  --function hello_blockchain::message::set_message \
  --args string:"Hello from CLI" \
  --profile default

⸻

🔍 Get the Current Message

aptos move view \
  --function hello_blockchain::message::get_message \
  --args address:address \
  --profile default

⸻

📄 Config File (config.yaml)

Your config.yaml should contain:

profiles:
  default:
    network: movement-testnet
    private_key: ed25519-priv-<YOUR-PRIVATE-KEY>
    public_key: ed25519-pub-<YOUR-PUBLIC-KEY>
    account: <YOUR-ACCOUNT-ADDRESS>
    rest_url: "https://testnet.bardock.movementnetwork.xyz/v1"
    faucet_url: "https://faucet.testnet.bardock.movementnetwork.xyz/"

⸻

🧪 Testing Accounts

Use the #[test(account = @0x1)] syntax to create test-only functions inside your module.

⸻
