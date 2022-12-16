module nft_on_sui::main {
    use sui::object;
    use sui::transfer;
    use sui::tx_context::{Self, TxContext};
    
    use nft_on_sui::pigment::{Self, Pigment};
    use nft_on_sui::collection::{Self, Collection};

    #[test_only]
    use sui::test_scenario;
    #[test_only]
    use std::option;

    const EASSERTION_ERROR: u64 = 61;
    const EMINT_LIMIT_REACHED: u64 = 1;

    /// Used to initialize a module when it is first published to the chain.
    /// For the time, we don't need to initialize anything.
    fun init(_ctx: &mut TxContext) {}
    
    /// Creates a new collection
    public entry fun new_collection(
        name: vector<u8>,
        inception: u64,
        creator: vector<u8>,
        size: u8,
        ctx: &mut TxContext
    ) {
        // Create a new Collection object with the given parameters
        let new_col = collection::new(name, inception, creator, size, ctx);

        // transfer this object to the sender, for now the sender will be the
        // owner of the collection.
        transfer::transfer(new_col, tx_context::sender(ctx));
    }

    /// Mint a pigment inside a collection
    public entry fun new_pigment(
        name: vector<u8>,
        url: vector<u8>,
        col: &mut Collection,
        ctx: &mut TxContext,
    ) {
        let issue_count: u8 = collection::get_tokens_issued(col);
        // Chech if mint limit has reached
        if (issue_count >= collection::get_size(col)) abort EMINT_LIMIT_REACHED;

        // get the collection identifier
        let collection_id = object::id<Collection>(col);
        // Create a new Pigment object
        let new_pigment: Pigment = pigment::new(collection_id, name, url, issue_count, ctx);
        // increment the issued count in collection
        collection::increment_issued(col);

        transfer::transfer(new_pigment, tx_context::sender(ctx));
    }

    public entry fun transfer(
        recipient: address,
        pi: Pigment,
        _ctx: &mut TxContext,
    ) {
        transfer::transfer(pi, recipient);
    }

    #[test]
    fun test_create_new_collection() {
        use sui::test_scenario;

        let user: address = @0xAA;
        let scenario_val = test_scenario::begin(user);
        let scenario = &mut scenario_val;
        {
            new_collection(
                b"My collection",
                230054,
                b"Me",
                10,
                test_scenario::ctx(scenario),
            );
        };
        test_scenario::next_tx(scenario, user);
        {
            let col = test_scenario::take_from_sender<Collection>(scenario);
            assert!(collection::get_name(&col) == b"My collection", EASSERTION_ERROR);
            assert!(collection::get_inception(&col) == 230054, EASSERTION_ERROR);
            assert!(collection::get_creator(&col) == b"Me", EASSERTION_ERROR);
            assert!(collection::get_size(&col) == 10u8, EASSERTION_ERROR);

            test_scenario::return_to_sender<Collection>(scenario, col);
        };

        test_scenario::end(scenario_val);
    }

    #[test]
    fun test_create_new_pigment() {
        let admin: address = @0xAD;
        let _user: address = @0xB0B;

        let scenario_val = test_scenario::begin(admin);
        let scenario = &mut scenario_val;
        // create a new collection
        {
            new_collection(
                b"My collection",
                230054,
                b"Me",
                10,
                test_scenario::ctx(scenario),
            );
        };
        // create a new pigment
        test_scenario::next_tx(scenario, admin);
        {
            let col = test_scenario::take_from_sender<Collection>(scenario);

            new_pigment(
                b"My pigment",
                b"pigment://my-pigment",
                &mut col,
                test_scenario::ctx(scenario),
            );

            test_scenario::return_to_sender(scenario, col);
        };
        // assert all's well
        test_scenario::next_tx(scenario, admin);
        {
            // Get the newly minted pigment
            let pi = test_scenario::take_from_sender<Pigment>(scenario);
            // Get the id of the previously minted collection
            let col_id = test_scenario::most_recent_id_for_sender<Collection>(scenario);
            let id = option::destroy_some<object::ID>(col_id);

            assert!(pigment::get_name(&pi) == b"My pigment", EASSERTION_ERROR);
            assert!(pigment::get_url(&pi) == b"pigment://my-pigment", EASSERTION_ERROR);
            assert!(pigment::get_collection(&pi) == id, EASSERTION_ERROR);
            assert!(pigment::get_issue_count(&pi) == 0u8, EASSERTION_ERROR);

            test_scenario::return_to_sender<Pigment>(scenario, pi);
        };

        test_scenario::end(scenario_val);
    }

}