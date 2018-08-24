'use strict';


const Ticket = artifacts.require('Ticket.sol');


module.exports = function(deployer, network) {
    deployer.deploy(Ticket);
};

