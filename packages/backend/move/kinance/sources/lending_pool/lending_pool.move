module kinance::lending_pool;

use sui::balance::{Balance};
use sui::coin::{Coin};

// will implement dynamic interest rate in the future, use constant for now
const LEND_INTESREST_RATE: u64 = 10;
const BORROW_INTESREST_RATE: u64 = 15;
const OPERATION_COST: u64 = 1;

public struct LendingPool<phantom T> has key{
    id: UID,
    balance: Balance<T>,
}

public struct Receipt<phantom T> has key{
    id: UID,
    amount: u64,
    // start_time: u64,
    owner: address,
}

public fun lend<T>(
    lendingPool: &mut LendingPool<T>, 
    coin: Coin<T>, 
    ctx: &mut TxContext,
): (Receipt<T>){
    let owner = ctx.sender();
    let balance = coin.into_balance();
    let amount = balance.value() * (1-OPERATION_COST);
    lendingPool.balance.join((balance));

    Receipt {
        id: object::new(ctx),
        amount: amount,
        owner: owner,
    }
}
