module token_coin::token {
    use std::signer;
    use aptos_framework::coin;
    use aptos_framework::managed_coin;
    use aptos_framework::event;

    /// The token type
    struct Token has store, drop {}

    /// Admin controls mint/burn
    struct Admin has key {
        addr: address,
    }

    /// Token metadata stored on-chain
    struct Metadata has key {
        name: vector<u8>,
        symbol: vector<u8>,
        decimals: u8,
        cap: u64,
    }

    /// Mint and burn event payloads
    struct MintEvent has drop, store {
        recipient: address,
        amount: u64,
    }

    struct BurnEvent has drop, store {
        from: address,
        amount: u64,
    }

    struct Events has key {
        mint_events: event::EventHandle<MintEvent>,
        burn_events: event::EventHandle<BurnEvent>,
    }

    /// Token initializer
    public entry fun init(
        account: &signer,
        name: vector<u8>,
        symbol: vector<u8>,
        decimals: u8,
        cap: u64,
        init_supply: u64
    ) {
        // Create token with metadata
        managed_coin::initialize<Token>(
            account,
            name,
            symbol,
            decimals,
            true
        );

        managed_coin::register_supply_cap<Token>(account, cap);

        // Save metadata & admin
        move_to(account, Metadata { name, symbol, decimals, cap });
        move_to(account, Admin { addr: signer::address_of(account) });

        // Setup event handles
        let mint_events = event::new_event_handle_from_account<MintEvent>(account);
        let burn_events = event::new_event_handle_from_account<BurnEvent>(account);
        move_to(account, Events { mint_events, burn_events });

        // Register and mint initial supply
        register(account);
        managed_coin::mint<Token>(account, signer::address_of(account), init_supply);
        emit_mint_event(account, signer::address_of(account), init_supply);
    }

    /// Register an account to hold this token
    public entry fun register(account: &signer) {
        let addr = signer::address_of(account);
        if (!coin::is_account_registered<Token>(addr)) {
            coin::register<Token>(account);
        }
    }

    /// Mint tokens to another address (admin only)
    public entry fun mint(account: &signer, recipient: address, amount: u64) {
        assert!(is_admin(account), 0);
        if (!coin::is_account_registered<Token>(recipient)) {
            abort 2;
        }
        managed_coin::mint<Token>(account, recipient, amount);
        emit_mint_event(account, recipient, amount);
    }

    /// Burn tokens from admin's account (admin only)
    public entry fun burn(account: &signer, amount: u64) {
        assert!(is_admin(account), 1);
        managed_coin::burn<Token>(account, amount);
        emit_burn_event(account, signer::address_of(account), amount);
    }

    /// Transfer tokens to someone else
    public entry fun transfer(sender: &signer, recipient: address, amount: u64) {
        if (!coin::is_account_registered<Token>(recipient)) {
            abort 3;
        }
        coin::transfer<Token>(sender, recipient, amount);
    }

    /// View balance
    public fun balance(addr: address): u64 {
        coin::balance<Token>(addr)
    }

    /// View total supply
    public fun total_supply(): u64 {
        coin::supply<Token>().value
    }

    /// View token metadata
    public fun metadata(): &Metadata acquires Metadata {
        borrow_global<Metadata>(@0x1) // Replace with actual deployer address
    }

    /// Internal: check if caller is admin
    fun is_admin(account: &signer): bool acquires Admin {
        let admin = borrow_global<Admin>(signer::address_of(account));
        signer::address_of(account) == admin.addr
    }

    /// Internal: emit MintEvent
    fun emit_mint_event(account: &signer, to: address, amount: u64) acquires Events {
        let ev = borrow_global_mut<Events>(signer::address_of(account));
        event::emit_event<MintEvent>(&mut ev.mint_events, MintEvent { recipient: to, amount, });
    }

    /// Internal: emit BurnEvent
    fun emit_burn_event(account: &signer, from: address, amount: u64) acquires Events {
        let ev = borrow_global_mut<Events>(signer::address_of(account));
        event::emit_event<BurnEvent>(&mut ev.burn_events, BurnEvent { from, amount, });
    }
}