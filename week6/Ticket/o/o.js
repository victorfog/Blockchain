var TutorialToken = artifacts.require("TutorialToken");

contract('TutorialToken', function(accounts) {
    let owner = accounts[0];
    let second_account = accounts[1];
    let token;

    beforeEach(async function() {
        token = await TutorialToken.deployed();
    });

    it('should return the correct totalSupply after construction', async function() {
        let totalSupply = await token.totalSupply();

        assert.equal(totalSupply, 12000);
    });

    it('transfer updates balance of counterparties', async function() {
        await token.transfer(second_account, 100);
        let owner_balance = await token.balanceOf(owner);
        let second_account_balance = await token.balanceOf(second_account);

        assert.equal(owner_balance, 12000 - 100);
        assert.equal(second_account_balance, 100);
    });
});

Подробнее: https://www.coinside.ru/2017/11/06/pishem-svoj-token-erc20-na-solidity-s-pomoshhyu-truffle/




    var Pay = artifacts.require("./Pay.sol");

contract('Pay', function(accounts) {
    it("should put 10000 wei in the first account", function() {
        return Pay.deployed().then(function(instance) {
            pay = instance;
            //console.log(pay.estimateGas());
            return pay.getBalance.call(accounts[0]);
        }).then(function(balance){
            startingBalance = balance;
            return pay.pay(accounts[1], 2500, {from: accounts[0]});
        }).then(function() {
            return pay.getBalance.call(accounts[0]);
        }).then(function(balance) {
            assert.equal(startingBalance, balance);
        })
    });
});