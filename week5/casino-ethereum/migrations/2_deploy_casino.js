const casinoContract = artifacts.require("Casino.sol");

module.exports = function(deployer, network) {
    deployer.deploy(casinoContract, web3.toWei(0.1, 'ether'), {from: "0x62eF1148859520D853fe99839DD19Ff29Ec8cC48"});
};