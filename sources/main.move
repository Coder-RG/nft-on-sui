module nft_on_sui::main {
    use sui::object::{Self, UID};
    use sui::transfer;
    use sui::tx_context::TxContext;
    
    const CONTRACT: address = @0xBE;

    fun init(_ctx: &mut TxContext) {}
    
    struct Info has key {
        id: UID,
        nft_issued: u16,
    }

    public entry fun create_info(ctx: &mut TxContext) {
        let info = Info { id: object::new(ctx), nft_issued: 0u16 };
        transfer::transfer(info, CONTRACT);
    }

    #[test]
    fun this_will_warn() {
        
        assert!(1==1, 2);
    }

    #[test]
    fun test_create_info() {
        use sui::test_scenario;

        let user: address = @0xBEE;

        // create the Info struct
        let scenario_val = test_scenario::begin(user);
        let scenario = &mut scenario_val;
        {
            create_info(test_scenario::ctx(scenario));
        };

        // check if CONTRACT actually contains Info
        test_scenario::next_tx(scenario, user);
        {
            let info = test_scenario::take_from_address<Info>(scenario, CONTRACT);
            assert!(info.nft_issued == 0, 1);
            test_scenario::return_to_address(CONTRACT, info);
        };

        test_scenario::end(scenario_val);
    }
}