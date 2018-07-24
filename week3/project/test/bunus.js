'use strict';


import expectThrow from './helpers/expectThrow';
import {assertBigNumberEqual} from "./helpers/asserts";

const bonus = artifacts.require('bonus.sol');

function now() {
    return Math.floor(Date.now() / 1000);
}

contract('bonus', function(accounts) {


    it('test construction', async function () {
        const bonusInstance = await bonus.new({from: accounts[0]});
        assert.notEqual(await bonusInstance.balanceOf(accounts[0]), 0 );
    });

    it('test order', async function () {
        const bonusInstance = await bonus.new({from: accounts[0]});
        let enterTime = now();
        await bonusInstance.makeOrder(12123, enterTime, {from: accounts[1]});
        assertBigNumberEqual(await bonusInstance.balanceOf(accounts[1]), 0);

    });

    it ('test compliteOrder', async function () {
        const bonusInstance = await bonus.new({from: accounts[0]});
        let enterTime = now();
        await bonusInstance.makeOrder(12123, enterTime, {from: accounts[1]});
        await bonusInstance.compliteOrder(accounts[1], {from: accounts[0]});
        assertBigNumberEqual(await bonusInstance.balanceOf(accounts[1]), 1);
        assertBigNumberEqual(await bonusInstance.balanceOf(accounts[0]), 41);

    })

});
