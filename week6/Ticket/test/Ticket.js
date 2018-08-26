'use strict';

import expectError from './helpers/expectThrow';
//import {assertBigNumberEqual} from "./helpers/asserts";

const Ticket = artifacts.require("Ticket.sol");
// const TicketArtifact = require('./../build/contracts/Ticket'); //для получения адреса  **
// let Token = Ticket(TicketArtifact); // в рамках пполучения адреса контракта  **
// Token.setProvider(window.web3.currentProvider); // **
// let tokenInstance = await Token.deployed();
// let addressTiket = tokenInstance.address;


contract('Ticket', function(accounts) {
    console.log('');
// selfAddress = ?
     it('Only owner can start contract', async function() {
         const ticketContract = await Ticket.new({from: accounts[0]});
         await ticketContract.start(accounts[0], {from: accounts[0]});
         await expectError(ticketContract.start(accounts[1], {from: accounts[1]}));

     });

    it('buy ticket', async function() {
        const ticketContract = await Ticket.new({from: accounts[0]});
        ticketContract.start(ticketContract.address);

        let ticketsNumber = 1;
        let ticketsPrice = await ticketContract.calculatePrice(ticketsNumber);

        await ticketContract.buy(accounts[1], ticketsNumber,
            {from: accounts[1], value: ticketsPrice});
    });

    // // start exper
    //
    //  const contract = require('truffle-contract');  // maby
    //  const TokenArtifact = require('./../../build/contracts/YourToken.json'); // ok
    //
    //  var Token = contract(TokenArtifact); ok
    //  Token.setProvider(window.web3.currentProvider);
    //  var tokenInstance = await Token.deployed();
    //
    //
    //
    //
    //  ///end exp

   it('Check Tiket', async function() {
       const ticketContract = await Ticket.new({from: accounts[0]});
       await expectError (ticketContract.start(accounts[0], {from: accounts[1]}));
       await ticketContract.hash(accounts[1], 5, {from: accounts[1]});
   });

});