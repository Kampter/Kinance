module kinance::lending_pool;

use sui::balance::{Balance};
use sui::coin::{Coin};

// will implement dynamic interest rate in the future, use constant for now
const LEND_INTESREST_RATE: u64 = 10;
const BORROW_INTESREST_RATE: u64 = 15;
const OPERATION_COST: u64 = 1;

// ERRORS
const ERR_NOT_ENOUGH_BALANCE_FROM_POOL: u64 = 1;
const ERR_NOT_OWNER: u64 = 2;

public struct LendingPool<phantom T> has key {
    id: UID,
    balance: Balance<T>,
}

public struct Receipt has key, store {
    id: UID,
    amount: u64,
    owner: address,
}

// lend coin to lending pool
// return receipt
// not implemented interest rate yet
public fun lend<T>(
    lendingPool: &mut LendingPool<T>, 
    coin: Coin<T>, 
    ctx: &mut TxContext,
){
    let owner = ctx.sender();
    let balance = coin.into_balance();
    let amount = balance.value();
    lendingPool.balance.join((balance));

    let receipt = Receipt {
        id: object::new(ctx),
        amount: amount,
        owner: owner,
    };
    
    transfer::transfer(receipt, ctx.sender());
}

// borrow coin from lending pool
// return coin and receipt

// not implemented interest rate yet
// not consider people have enought asset lend to pool to make sure he can borrow
public fun borrow<T>(
    lendingPool: &mut LendingPool<T>, 
    amount: u64, 
    ctx: &mut TxContext,
): (Coin<T>, Receipt){
    let owner = ctx.sender();
    let pool_balance = lendingPool.balance.value();
    assert!(pool_balance >= amount, ERR_NOT_ENOUGH_BALANCE_FROM_POOL);

    let balance = lendingPool.balance.split(amount);
    let coin = balance.into_coin(ctx);

    let receipt = Receipt {
        id: object::new(ctx),
        amount: amount,
        owner: owner,
    };
    transfer::public_transfer(coin, ctx.sender());
    transfer::transfer(receipt, ctx.sender());
    (coin, receipt)
}

// repay to lending pool
public fun repay<T>(
    lendingPool: &mut LendingPool<T>, 
    receipt: Receipt<T>, 
    ctx: &mut TxContext,
): (){
    let owner = ctx.sender();
    assert!(receipt.owner == owner, NOT_OWNER);
    let amount = receipt.amount;
    let balance = Balance::new(amount);
    lendingPool.balance.join((balance));
    transfer::transfer(receipt, ctx.sender());
}

// withdraw lending pool
public fun withdraw<T>(
    lendingPool: &mut LendingPool<T>, 
    amount: u64, 
    ctx: &mut TxContext,
): (){
    let owner = ctx.sender();
    let balance = Balance::new(amount);
    lendingPool.balance.split((balance));
    transfer::transfer(balance.into_coin(), ctx.sender());
}