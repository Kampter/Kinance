module kinance::interest;
/*
    Interest module
    this module is used to calculate interest rate
    will implement dynamic interest rate in the future
*/
use std::uq32_32::{Self, UQ32_32};

public struct Interest has copy, store, drop{
    base_interest_rate_per_sec: UQ32_32,
}

public fun new() : Interest {
    let interest = Interest {
        base_interest_rate_per_sec: uq32_32::from_int(10),
    };
    interest
}