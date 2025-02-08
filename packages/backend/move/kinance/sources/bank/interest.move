module kinance::interest;
/*
    Interest module
    this module is used to calculate interest rate
    will implement dynamic interest rate in the future
*/
use std::uq32_32::{Self, UQ32_32};
use std::type_name::{Self, TypeName};

use kinance::ac_table::{Self, AcTable, AcTableCap};

public struct Interest has copy, store, drop{
    type_name: TypeName,
    base_interest_rate_per_sec: UQ32_32,
}

public struct Interests has drop{}

public fun type_name(interest: &Interest): TypeName { interest.type_name }
public fun base_interest_rate_per_sec(interest: &Interest): UQ32_32 { interest.base_interest_rate_per_sec }

public fun new(ctx: &mut TxContext) : (
    AcTable<Interests, TypeName, Interest>,
    AcTableCap<Interests>,
) {
    let (table, cap) = ac_table::new<Interests, TypeName, Interest>(Interests{}, true, ctx);
    (table, cap)
}