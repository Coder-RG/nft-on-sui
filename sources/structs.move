module nft_on_sui::nft {
    use sui::object::{Self, UID};
    use sui::tx_context::TxContext;
    use std::option::{Self, Option};
    use nft_on_sui::collection::Collection;

    struct Pigment has key {
        id: UID,
        name: vector<u8>,
        collection: Option<Collection>,
        url: vector<u8>,
        issue_count: u8,
    }

    fun new(
        collection: Option<Collection>,
        item_name: vector<u8>,
        url: vector<u8>,
        issue_count: u8,
        ctx: &mut TxContext
    ): Pigment {
        Pigment {
            id: object::new(ctx),
            name: item_name,
            collection: collection,
            url,
            issue_count,
        }
    }

}

/// Set of paintings grouped together into a collection. Each collection has
/// a `name`, `inception` date, `creator` name and finally the `size` of the
/// collection.
module nft_on_sui::collection {
    use sui::object::UID;
    
    struct Collection has key, store {
        id: UID,
        name: vector<u8>,
        inception: u64,
        creator: vector<u8>,
        size: u8,
    }
}
