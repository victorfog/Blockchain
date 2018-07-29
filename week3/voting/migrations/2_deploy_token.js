'use strict';


const anonymousVoting = artifacts.require('anonymousVoting.sol');


module.exports = function(deployer, network) {
    let now = new Date();
    let currentTime = Math.floor(now.getTime()/1000);
    console.log(currentTime);
    deployer.deploy(anonymousVoting, currentTime, currentTime+1, currentTime+2);
};
