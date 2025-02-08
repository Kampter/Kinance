module kinance::app;

use kinance::bank::{Self, Bank};
use std::option;

public struct APP has drop{}

fun init (otw: APP, ctx: &mut TxContext) {
    // init app
    init_internal(otw, ctx);
}

fun init_internal (otw: APP, ctx: &mut TxContext) {
    // init app internal
    let bank = 
}