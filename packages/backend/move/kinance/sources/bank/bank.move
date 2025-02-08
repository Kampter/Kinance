module kinance::bank;

use sui::balance::{Self, Balance};
use sui::coin::{Coin, TreasuryCap};
use std::type_name::{Self, TypeName};

use kinance::interest::{Self, Interest, Interests};
use kinance::risk::{Self, Risk, Risks};
use kinance::ac_table::{Self, AcTable, AcTableCap};

public struct Bank has key, store {
    id: UID,
    // interest rate
    interest: AcTable<Interests, TypeName, Interest>,
    // risk
    risk: AcTable<Risks, TypeName, Risk>,
}

public fun new(ctx: &mut TxContext) : (
    Bank,
    AcTableCap<Interests>,
    AcTableCap<Risks>,
) {
    let (interest, interest_cap) = interest::new(ctx);
    let (risk, risk_cap) = risk::new(ctx);
    let bank = Bank {
        id: object::new(ctx),
        interest,
        risk,
    };
    (bank, interest_cap, risk_cap)
}
