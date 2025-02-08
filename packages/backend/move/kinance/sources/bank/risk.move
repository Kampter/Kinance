module kinance::risk;
/*
    risk module
    this module is used to calculate risk then liquidate the position
*/
use std::type_name::{Self, TypeName};

const MaxLiquidationThreshold: u64 = 85;

public struct Risks has drop{}

public struct Risk has copy, store, drop{
    type_name: TypeName,
    // 
    liquidation_factor: u64,
    // liquidation threshold
    liquidation_threshold: u64,
}

public fun new() : Risk {
    let risk = Risk {
        type_name: type_name::new(),
        liquidation_factor: 10,
        liquidation_threshold: 85,
    };
    risk
}