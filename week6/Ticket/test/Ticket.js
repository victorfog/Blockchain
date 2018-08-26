'use strict';

import expectError from './helpers/expectThrow';
//import {assertBigNumberEqual} from "./helpers/asserts";

const Ticket = artifacts.require("Ticket.sol");


contract('Ticket', function(accounts) {
    console.log('');

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


   it('Check Tiket', async function() {
       const ticketContract = await Ticket.new({from: accounts[0]});
       await expectError (ticketContract.start(accounts[0], {from: accounts[1]}));
       await ticketContract.hash(accounts[1], 5, {from: accounts[1]});
   });

});