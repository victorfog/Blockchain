'use strict';


import expectThrow from './helpers/expectThrow';

const Token_week3 = artifacts.require('Token_week3.sol');


contract('Token_week3Test', function() {


    it('test construction', async function () {
        const token = await Token_week3.new();
    });
});
