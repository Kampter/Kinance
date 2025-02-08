module kinance::bank;

use sui::balance::{Self, Balance};
use sui::coin::{Coin, TreasuryCap};
use kinance::interest::{Self, Interest};

// ERRORS
const ERR_NOT_ENOUGH_BALANCE_FROM_POOL: u64 = 1;
const ERR_NOT_OWNER: u64 = 2;
const ERR_INPUT_OVER_LIMIT: u64 = 3;

public struct Bank<phantom T, phantom YT> has key, store {
    id: UID,
    // balance of lending pool
    balance: Balance<T>, 
    // balance of yield token
    yt_balance: Balance<YT>,
    // interest rate
    interest: Interest,
    // borrow interest rate
    borrow_interest_rate: u64,
}

public struct Receipt<T> has key {
    id: UID,
    balance: Balance<T>,
    amount: u64,
}

public struct AdminCap has key, store {
    id: UID,
}

public fun new<T, YT>(ctx: &mut TxContext) : Bank<T, YT> {
    let bank = Bank<T, YT> {
        id: object::new(ctx),
        balance: balance::zero(),
        yt_balance: balance::zero(),
        lending_interest_rate: 10,
        borrow_interest_rate: 15,
    };
    bank
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
    lendingPool.balance.join(balance);

    let receipt = Receipt {
        id: object::new(ctx),
        amount: amount,
        owner: owner,
    };

    transfer::transfer(receipt, ctx.sender());
}

// withdraw from lending pool
// if withdraw all, return coin and receipt
// if withdraw part, return coin and new receipt
public fun withdraw<T>(
    lendingPool: &mut LendingPool<T>, 
    amount: u64, 
    receipt: Receipt<T>,
    ctx: &mut TxContext,
): (Coin<T>, Receipt<T>){
    let owner = ctx.sender();
    assert!(receipt.owner == owner, ERR_NOT_OWNER);

    let receipt_amount = receipt.balance.value();
    assert!(amount <= receipt_amount, ERR_INPUT_OVER_LIMIT);
    assert!(amount > 0, ERR_INPUT_OVER_LIMIT);

    let pool_balance = lendingPool.balance.value();
    assert!(pool_balance >= amount, ERR_NOT_ENOUGH_BALANCE_FROM_POOL);

    let balance = lendingPool.balance.split(amount);
    let coin = balance.into_coin(ctx);

    let new_receipt = Receipt {
        id: object::new(ctx),
        balance: balance,
        owner: owner,
    };

    transfer::public_transfer(coin, ctx.sender());
    transfer::transfer(receipt, ctx.sender());
    (coin, new_receipt)
}


// borrow coin from lending pool
// return coin and receipt

// not implemented interest rate yet
// not consider people have enought asset lend to pool to make sure he can borrow
public fun borrow<T>(
    lendingPool: &mut LendingPool<T>, 
    amount: u64, 
    ctx: &mut TxContext,
): (Coin<T>, Receipt<T>){
    let owner = ctx.sender();
    let pool_balance = lendingPool.balance.value();
    assert!(pool_balance >= amount, ERR_NOT_ENOUGH_BALANCE_FROM_POOL);

    let balance = lendingPool.balance.split(amount);
    let coin = balance.into_coin(ctx);

    let receipt = Receipt {
        id: object::new(ctx),
        balance: balance,
        owner: owner,
    };
    transfer::public_transfer(coin, ctx.sender());
    transfer::transfer(receipt, ctx.sender());
    (coin, receipt)
}
