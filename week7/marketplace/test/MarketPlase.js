'use strict';

import expectError from './helpers/expectThrow';
import {assertBigNumberEqual} from "./helpers/asserts";

const MarketPlace = artifacts.require("MarketPlace.sol");


contract('MarketPlace', function(accounts) {
    console.log('!');

    let fileList = [
        {Name: "Box", Hash: "tipaHashkakoyto1", SwarmHash: "swaraddresshesh1", Price: 101, Description: "its my first model",  Sender: {from: accounts[1]}},
        {Name: "Box2", Hash: "tipaHashkakoyto2", SwarmHash: "swaraddresshesh2", Price: 102, Description: "its my first model2",  Sender: {from: accounts[1]}},
        {Name: "Box3", Hash: "tipaHashkakoyto3", SwarmHash: "swaraddresshesh3", Price: 103, Description: "its my first model2",  Sender: {from: accounts[1]}},
        {Name: "Box4", Hash: "tipaHashkakoyto4", SwarmHash: "swaraddresshesh4", Price: 104, Description: "its my first model",  Sender: {from: accounts[2]}},
        {Name: "Box5", Hash: "tipaHashkakoyto5", SwarmHash: "swaraddresshesh5", Price: 105, Description: "its my first model1",  Sender: {from: accounts[1]}},
        {Name: "Box6", Hash: "tipaHashkakoyto6", SwarmHash: "swaraddresshesh6", Price: 106, Description: "its my first model1",  Sender: {from: accounts[2]}},
        {Name: "Box7", Hash: "tipaHashkakoyto7", SwarmHash: "swaraddresshesh7", Price: 107, Description: "its my first model",  Sender: {from: accounts[1]}},
    ];

    async function initOrders(MarketContract) {
        let updatedFileList = fileList.slice();
        let i = 0;
        var j = 0;

        let eventHandler = MarketContract.NewFile({fromBlock: 0, toBlock: 'latest'});
        eventHandler.watch(function(error, result) {
            if (!error) {
                updatedFileList[j].FileID = result.args._FileID.toNumber();
                j++;
            } else {
                console.log("PANIC!!!!", error);
            }
        });
        await sleep(100);

        for (let file of fileList) {
            await MarketContract.addFile(file.Name, file.Hash, file.SwarmHash, file.Price, file.Description,  file.Sender);
            i++;
        }
        await sleep(500);
        eventHandler.stopWatching();
        return updatedFileList;
    }

    it('Create 7 model, 2 users', async function() {
        const MarketContract = await MarketPlace.new({from: accounts[0]});
        let updatedOrdersList = await initOrders(MarketContract);

    });


    // it('Create order from user1 ', async function() {
    //     const MarketContract = await MarketPlace.new({from: accounts[0]});
    //     let updatedOrdersList = initOrders(MarketContract);
    //
    //     console.log(updatedOrdersList);
    //
    //     //await sleep(2000);
    //     let myFile = updatedOrdersList[1];
    //     await MarketContract.createOrder(myFile.FileID,  {from: accounts[1], value: myFile.Price});
    //     //console.log(_FileID);
    //     Assert.equal()
    //
    // });

    it('Create Order', async function() {
        const MarketContract = await MarketPlace.new({from: accounts[4]});
        let updatedOrdersList = await initOrders(MarketContract);

        await MarketContract.createOrder(1,  {from: accounts[4], value: 102});
    });

    it('Create order for non-existent file', async function() {
        const MarketContract = await MarketPlace.new({from: accounts[4]});
        let updatedOrdersList = await initOrders(MarketContract);
        await expectError(MarketContract.createOrder(9,  {from: accounts[4], value: 300}));
    });

    it('Create Order. Too low price. Should fail.', async function() {
        const MarketContract = await MarketPlace.new({from: accounts[4]});
        let updatedOrdersList = await initOrders(MarketContract);

        await expectError(MarketContract.createOrder(1,  {from: accounts[4], value: 2}));
    });

    it('Create Order. Witch wrong file. .', async function() {
        const MarketContract = await MarketPlace.new({from: accounts[4]});
        let updatedOrdersList = await initOrders(MarketContract);

        await expectError(MarketContract.createOrder(10,  {from: accounts[4], value: 200}));
    });

    it('approveOrder', async function() {
        const MarketContract = await MarketPlace.new({from: accounts[4]});
        let updatedOrdersList = await initOrders(MarketContract);

        var _OrderID;

        let eventContractHendler = MarketContract.EventCreateOrder();
        eventContractHendler.watch(function(error, result) {
            if (!error) {
                _OrderID = result.args._orderID.toNumber();
            } else {
                console.log("PANIC!!!!", error);
            }
        });
        await sleep(100);

        await MarketContract.createOrder(3, {from: accounts[5], value: 104});
        await sleep(500);
        await MarketContract.approveOrder(_OrderID, true, {from: accounts[5]});
    });

});

const sleep = require('util').promisify(setTimeout);
