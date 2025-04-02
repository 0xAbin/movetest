
// in move for contracts use modules

module token_coin::token {
    use std::string;
    use std::signer;
    use apots_framework::coin; // features like mint etc
    use apots_framework::apots_account;
    use apots_framework::managed_coin; // for Token fun (opzp) lib 
  
    //  Store - struct stored in global storage
    //  Drop - struct delete storage
    struct Token has store, drop {}

    // constants NAME : type string reference (imutable in move) value 
    const NAME: &str = "Token";
    const SYMBOL: &str = "TKN";
    const DECIMALS: u8 = 6;
    const MAX_SUPPLY: u64 = 1_000_000_000_000; 
   

    // entry function 
    //@account type as signer
    //&signer authorized account

    // mangedcoin :: int<> initialize custom coin with 
    // Singed account
    // utf (name and symbol converted to utd-8 string) 
    public entry fun init(account: &signer, init_supply: u64) {
        managed_coin::initialize<Token>(
            account,
            string::utf8(NAME),
            string::utf8(SYMBOL),
            DECIMALS,
            false // only deployer can mint
        );

        managed_coin::set_supply_cap<Token>(account, MAX_SUPPLY);
        register(account); 
        managed_coin::mint<TOKEN>(
            account,
            signer::address_of(account),
            init_supply
        );
    }



    // Register current account for this token
    public entry fun register(account: &signer) {
        let addr = signer::address_of(account);
        if (!coin::is_account_registered<Token>(addr)) {
            coin::register<Token>(account);
        }
    }

    // Auto-register if needed
    fun auto_register(recipient: address , senderL &signer){
        if (!coin::is_account_registered<Token>(recipient)) {
             // The sender can register on behalf of others *only if they are the coin admin*
            let maybe_signer = aptos_account::create_signer(recipient);
            if(option::is_some(&maybe_signer)){
                 coin::register<Token>(&option::extract(maybe_signer));
            }
        }
    }

    public entry fun mint(account: &signer, recipient: address, amount: u64) {
        auto_register_if_needed(recipient, account);
        managed_coin::mint<Token>(account, recipient, amount);
    }
    
    public entry fun burn(account: &signer, recipient: address, amount: u64) {
        auto_register_if_needed(recipient, account);
        managed_coin::burn<Token>(account, recipient, amount);
    }

    public entry fun transfer(sender: &singer , recipient: address, amount: u64) {
        auto_register_if_needed(recipient, sender);
        managed_coin::transfer<Token>(sender, recipient, amount);
    }

    public entry fun balance(addr: address): u64{
         coin::balance<MyToken>(addr)
    }
    
    public entry fun total_supply(): u64 {
        coin::total_supply<Token>()
    }
   
}