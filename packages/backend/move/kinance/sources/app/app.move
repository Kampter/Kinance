module kinance::app;

use kinance::bank::{Self, Bank};
use kinance::ac_table::{Self, AcTableCap};
use kinance::interest::{Self, Interests};
use kinance::risk::{Self, Risks};

public struct APP has drop{}

fun init (otw: APP, ctx: &mut TxContext) {
    // init app
    init_internal(otw, ctx);
}

public struct AdminCap has key, store {
    id: UID,
    interest_cap: AcTableCap<Interests>,
    risk_cap: AcTableCap<Risks>,
}

#[allow(lint(self_transfer))]
fun init_internal (otw: APP, ctx: &mut TxContext) {
    // init app internal
    let (bank, interest_cap, risk_cap) = bank::new(ctx);
    let admin_cap = AdminCap {
        id: object::new(ctx),
        interest_cap,
        risk_cap,
    };
    transfer::public_share_object(bank);
    transfer::transfer(admin_cap, ctx.sender());
}