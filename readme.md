# 🚀 Hello Blockchain - Move Language Project

A simple Move smart contract to store and update a message on the Aptos-based Movement Testnet.

---

## 📁 Project Structure

movetest/
├── sources/
│   └── hello_blockchain.move      # Main module
├── tests/                         # Test files (if any)
├── scripts/                       # Optional Move scripts
├── Move.toml                      # Project manifest
├── config.yaml                    # CLI config for deployment
└── README.md                      # Project documentation

---

## ⚙️ Prerequisites

- ✅ [Install Aptos CLI](https://aptos.dev/tools/cli/install-cli/)
- ✅ Git
- ✅ (Optional) Node.js if planning to interact via JS or scripts

---

## 🔧 Setup

### 1. Update `Move.toml` with Your Blockchain Address

Replace the underscore (`_`) with your account address from `config.yaml`:

```toml
[addresses]
hello_blockchain = "address"

```


🛠️ Build & Test

✅ Compile the Code
```shell
aptos move compile
```


⸻

✅ Run Unit Tests
```shell
aptos move test
```
This runs any #[test] functions inside your module (e.g. sender_can_set_message).

⸻

🚀 Deploy to Movement Testnet

Make sure your config.yaml is correctly set up (see below), then:
```shell
aptos move publish --profile default
```
This deploys the module to the Movement Testnet using your keys and URL.

⸻

💬 Interact with Your Module

📝 Set a Message
```shell
aptos move run \
  --function hello_blockchain::message::set_message \
  --args string:"Hello from CLI" \
  --profile default

```

⸻

🔍 Get the Current Message
```shell
aptos move view \
  --function hello_blockchain::message::get_message \
  --args address:address \
  --profile default
```

⸻

⚙️ Config File (config.yaml)

Ensure your config.yaml looks like this:
```shell
profiles:
  default:
    network: movement-testnet
    private_key: ed25519-priv-<YOUR-PRIVATE-KEY>
    public_key: ed25519-pub-<YOUR-PUBLIC-KEY>
    account: <YOUR-ACCOUNT-ADDRESS>
    rest_url: "https://testnet.bardock.movementnetwork.xyz/v1"
    faucet_url: "https://faucet.testnet.bardock.movementnetwork.xyz/"
```

⸻ 

### 🧪 Writing Tests

Use test-only functions with the #[test] attribute. Example:

#[test(account = @0x1)]
public entry fun sender_can_set_message(account: signer) {
    // Test logic here
}

⸻