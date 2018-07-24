'use strict';


const Bonus = artifacts.require('bonus.sol');


module.exports = function(deployer, network) {
    deployer.deploy(Bonus);
};
