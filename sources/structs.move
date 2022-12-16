/// Each individual NFT is an instance of Pigment. It contains all
/// the necessary metadata. This module also contains some helper functions that
/// are used for creating a new pigment or for manipulating existing pigments.
module nft_on_sui::pigment {
    use sui::object::{Self, ID, UID};
    use sui::tx_context::TxContext;
    use std::option::{Self,Option};

    /// All NFTs are represented as a Pigment object
    struct Pigment has key, store {
        id: UID,
        name: vector<u8>,
        collection: ID,
        url: vector<u8>,
        issue_count: u8,
    }

    /// create a new Pigment
    public fun new(
        collection: ID,
        name: vector<u8>,
        url: vector<u8>,
        issue_count: u8,
        ctx: &mut TxContext
    ): Pigment {
        Pigment {
            id: object::new(ctx),
            name: name,
            collection: collection,
            url,
            issue_count,
        }
    }

    /// update existing Pigment
    public fun update(
        pi: &mut Pigment,
        name: Option<vector<u8>>,
        url: Option<vector<u8>>
    ) {
        if (option::is_some(&name)) pi.name = *option::borrow(&name);
        if (option::is_some(&url)) pi.url = *option::borrow(&url);
    }
    
    /// delete existing Pigment
    public fun delete(
        pi: Pigment
    ) {
        // Delete using unpacking
        let Pigment {id, name: _, collection: _, url: _, issue_count: _} = pi;
        object::delete(id);
    }

    // !------- Getters for pigment attributes -------!

    // Get name
    public fun get_name(pi: &Pigment): vector<u8> {
        pi.name
    }

    // Get url
    public fun get_url(pi: &Pigment): vector<u8> {
        pi.url
    }

    // Get collection
    public fun get_collection(pi: &Pigment): object::ID {
        pi.collection
    }

    // Get issue count
    public fun get_issue_count(pi: &Pigment): u8 {
        pi.issue_count
    }


    #[test]
    fun new_correct_init() {
        use sui::tx_context;
        use sui::transfer;
        use sui::object;
        
        let user = @0xAA;
        let ctx = tx_context::dummy();

        let new_pigment = new(
            object::id_from_address(@0xFF),
            b"",
            b"",
            1,
            &mut ctx
        );

        assert!(new_pigment.name == b"", 1);
        assert!(new_pigment.url == b"", 1);
        assert!(new_pigment.issue_count == 1, 1);

        transfer::transfer(new_pigment, user);
    }
}

/// Set of pigments grouped together into a collection. Each collection has
/// a `name`, `inception` date, `creator` name and finally the `size` of the
/// collection.
module nft_on_sui::collection {
    use sui::object::{Self, UID};
    use sui::tx_context::TxContext;
    use std::option::{Self, Option};

    /// Every NFT is part of a collection which is created with this struct
    struct Collection has key, store {
        id: UID,
        name: vector<u8>,
        inception: u64,
        creator: vector<u8>,
        size: u8,
        issued: u8,
    }

    /// Supposed to be only used once to create an empty collection object.
    /// This basically denotes that the Pigment this will be used with is a
    /// stand-alone object.
    public fun none(
        ctx: &mut TxContext
    ): Collection {
        Collection {
            id: object::new(ctx),
            name: b"",
            inception: 0,
            creator: b"",
            size: 1,
            issued: 0,
        }
    }

    /// create a new Collection object
    public fun new(
        name: vector<u8>,
        inception: u64,
        creator: vector<u8>,
        size: u8,
        ctx: &mut TxContext
    ): Collection {
        Collection {
            id: object::new(ctx),
            name,
            inception,
            creator,
            size,
            issued: 0u8,
        }
    }

    #[test]
    fun new_correct_init() {
        use sui::tx_context;
        use sui::transfer;

        let user: address = @0xAA;
        let ctx = tx_context::dummy();
    
        let col = new(
            b"",
            0,
            b"",
            0,
            &mut ctx,
        );

        assert!(col.name == b"", 1);
        assert!(col.inception == 0, 1);
        assert!(col.creator == b"", 1);
        assert!(col.size == 0, 1);

        transfer::transfer(col, user);
    }

    /// update existing Collection object
    public fun update(
        col: &mut Collection,
        name: Option<vector<u8>>,
        size: Option<u8>
    ) {
        if (option::is_some(&name)) col.name = *option::borrow(&name);
        if (option::is_some(&size)) col.size = *option::borrow(&size);
    }

    /// delete a Collection object
    public fun delete(
        col: Collection
    ) {
        let Collection { id, name: _, inception: _, creator: _, size: _, issued: _} = col;
        object::delete(id);
    }

    // !------- Setters for collection attributes -------!
    
    /// increment issued count
    public fun increment_issued(col: &mut Collection) {
        col.issued = col.issued + 1;
    }

    // !------- Getters for collection attributes -------!

    /// Get name
    public fun get_name(col: &Collection): vector<u8> {
        col.name
    }

    /// Get inception
    public fun get_inception(col: &Collection): u64 {
        col.inception
    }

    /// Get creator
    public fun get_creator(col: &Collection): vector<u8> {
        col.creator
    }

    /// Get size
    public fun get_size(col: &Collection): u8 {
        col.size
    }

    /// Get issued
    public fun get_tokens_issued(col: &Collection): u8 {
        col.issued
    }

}
