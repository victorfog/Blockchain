'use strict';

import expectError from './helpers/expectThrow';
//import {assertBigNumberEqual} from "./helpers/asserts";

const Ticket = artifacts.require("Ticket.sol");


 contract('Ticket', function(accounts) {
    console.log('');
// selfAddress = ?
     it('Only owner can start contract', async function() {
         const ticketContract = await Ticket.new({from: accounts[0]});
         await ticketContract.start(accounts[0], {from: accounts[0]});
         await expectError(ticketContract.start(accounts[1], {from: accounts[1]}));

     });



   it('test hash', async function() {
       const ticketContract = await Ticket.new({from: accounts[0]});
        //typeof ticketContract;
       // console.log(ticketContract);
        await expectError (ticketContract.start(accounts[0], {from: accounts[1]}));
        await ticketContract.hash(accounts[1], 5, {from: accounts[1]});
   });

});