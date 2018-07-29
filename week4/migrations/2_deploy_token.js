'use strict';


const VulnerableOne = artifacts.require('Audit_contract.sol');


module.exports = function(deployer, network) {
    deployer.deploy(VulnerableOne);
};
