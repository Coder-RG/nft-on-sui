/// Each individual NFT is an instance of Pigment. It contains all
/// the necessary metadata. This module also contains some helper functions that
/// are used for creating a new pigment or for manipulating existing pigments.
module nft_on_sui::pigment {
    use sui::object::{Self, UID};
    use sui::tx_context::TxContext;
    use std::option::{Self,Option};
    use nft_on_sui::collection::{Self, Collection};

    struct Pigment has key {
        id: UID,
        name: vector<u8>,
        collection: Collection,
        url: vector<u8>,
        issue_count: u8,
    }

    /// create a new Pigment
    public fun new(
        collection: Collection,
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
        pigment: &mut Pigment,
        name: Option<vector<u8>>,
        url: Option<vector<u8>>
    ) {
        if (option::is_some(&name)) pigment.name = *option::borrow(&name);
        if (option::is_some(&url)) pigment.url = *option::borrow(&url);
    }
    
    /// delete existing Pigment
    public fun delete(
        pigment: Pigment
    ) {
        // Delete using unpacking
        let Pigment {id, name: _, collection: col, url: _, issue_count: _} = pigment;
        object::delete(id);
        collection::delete(col);
    }

}

/// Set of pigments grouped together into a collection. Each collection has
/// a `name`, `inception` date, `creator` name and finally the `size` of the
/// collection.
module nft_on_sui::collection {
    use sui::object::{Self, UID};
    use sui::tx_context::TxContext;
    use std::option::{Self, Option};

    struct Collection has key, store {
        id: UID,
        name: vector<u8>,
        inception: u64,
        creator: vector<u8>,
        size: u8,
    }

    /// Supposed to be only used once to create an empty collection object.
    /// This basically denotes that the Pigment this will be used with is a
    /// stand-alone object.
    public fun none(ctx: &mut TxContext): Collection {
        Collection {
            id: object::new(ctx),
            name: b"",
            inception: 0,
            creator: b"",
            size: 1,
        }
    }

    /// create a new Collection object
    fun new(name: vector<u8>, inception: u64, creator: vector<u8>, size: u8, ctx: &mut TxContext): Collection {
        Collection {
            id: object::new(ctx),
            name,
            inception,
            creator,
            size
        }
    }

    /// update existing Collection
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
        let Collection { id, name: _, inception: _, creator: _, size: _ } = col;
        object::delete(id);
    }
}
