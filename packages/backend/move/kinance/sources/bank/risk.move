module kinance::risk;
/*
    risk module
    this module is used to calculate risk then liquidate the position
*/
use std::type_name::{Self, TypeName};

use kinance::ac_table::{Self, AcTable, AcTableCap};

// the value are in percentage
const MinCollateralFactor: u64 = 95; // 95%
const MaxLiquidationThreshold: u64 = 85; // 85%

public struct Risk has copy, store, drop{
    type_name: TypeName,
    // collateral factor
    collateral_factor: u64,
    // liquidation factor 
    liquidation_factor: u64,
}

public struct Risks has drop{}

public fun collateral_factor(risk: &Risk): u64 { risk.collateral_factor }
public fun liquidation_factor(risk: &Risk): u64 { risk.liquidation_factor }
public fun type_name(risk: &Risk): TypeName { risk.type_name }

public fun new(ctx: &mut TxContext) : (
    AcTable<Risks, TypeName, Risk>,
    AcTableCap<Risks>,
) {
    let (table, cap) = ac_table::new<Risks, TypeName, Risk>(Risks{}, true, ctx);
    (table, cap)
}