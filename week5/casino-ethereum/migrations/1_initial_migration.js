var Migrations = artifacts.require("Migrations.sol");

module.exports = function(deployer) {
  deployer.deploy(Migrations, {from: "0x62eF1148859520D853fe99839DD19Ff29Ec8cC48"});
};
