'use strict';

import expectError from './helpers/expectThrow';
import {assertBigNumberEqual} from "./helpers/asserts";

const voting = artifacts.require('anonymousVoting.sol');

contract('anonymousVotingTest', function(accounts) {

    it('test construction', async function() {
        //given
        let currect = now();
        const votingContract = await voting.new(currect, currect+1, currect+2);
    });

    it('test voting correct. none is voted', async function() {
        //given
        let currect = now();
        const votingContract = await voting.new(currect, currect+2, currect+4);

        //when
        await sleep(2000);

        //then
        await sleep(2000);

        let cons;
        let pros;
        [cons, pros] = await votingContract.stats();
        assertBigNumberEqual(cons, 0);
        assertBigNumberEqual(pros, 0);
    });

    it('test voting correct', async function() {
        //given
        let currect = now();
        const votingContract = await voting.new(currect, currect+2, currect+4);

        //when
        await votingContract.vote(true, {from: accounts[1]});

        //then
        await sleep(2000);

        await sleep(2000);
        let cons;
        let pros;
        [cons, pros] = await votingContract.stats();
        assertBigNumberEqual(cons, 0);
        assertBigNumberEqual(pros, 1);
    });

    it('test voting. many votes. different votes', async function() {
        //given
        let currect = now();
        const votingContract = await voting.new(currect, currect+2, currect+4);

        //when
        await votingContract.vote(true, {from: accounts[0]});

        await votingContract.vote(false, {from: accounts[1]});

        await sleep(2000);

        //then
        await sleep(2000);

        let cons;
        let pros;
        [cons, pros] = await votingContract.stats();
        assertBigNumberEqual(cons, 1);
        assertBigNumberEqual(pros, 1);
    });

    it('test voting is not available yet', async function() {
        //given
        let currect = now();
        const votingContract = await voting.new(currect+10, currect+12, currect+14);

        //when
        await expectError(votingContract.vote(true, {from: accounts[1]}));
    });

    it('test voting. double voting. different votes', async function() {
        //given
        let currect = now();
        const votingContract = await voting.new(currect, currect+2, currect+4);

        //when
        await votingContract.vote(true, {from: accounts[1]});

        await expectError(votingContract.vote(false, {from: accounts[1]}));
    });

    it('test voting. too late', async function() {
        //given
        let currect = now();
        const votingContract = await voting.new(currect, currect+1, currect+2);

        //when
        await sleep(1000);
        await sleep(1000);
        await expectError(votingContract.vote(true, {from: accounts[0]}));
    });
});

const sleep = require('util').promisify(setTimeout);

function now() {
    return Math.floor(Date.now() / 1000);
}