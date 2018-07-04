const crypto = require('crypto');
const secp256k1 = require('secp256k1');

const msg = process.argv[2]; // message to be signed you pass
const digested = digest(msg);
console.log(`0) Alice's message: 
    message: ${msg}
    message digest: ${digested.toString("hex")}`);

// generate privateKey
let privateKey;
let i=0;
do {
  privateKey = crypto.randomBytes(32);
  i++;
  console.log("try :" + i);
} while (!secp256k1.privateKeyVerify(privateKey));
// get the public key in a compressed format
const publicKey = secp256k1.publicKeyCreate(privateKey);
console.log(`1) Alice aquired new keypair:
    publicKey: ${publicKey.toString("hex")}
    privateKey: ${privateKey.toString("hex")}`);
//



function digest(str, algo = "sha256") {
  return crypto.createHash(algo).update(str).digest();
}

/*
var str = "my string"
var result = crypto.createHash('md5').update(str).digest("hex");
var resultsha256 = crypto.createHash('sha256').update(str).digest("hex");
console.log("hello, word!");
console.log("md5 result -", result);
console.log("sha256 resultsha256 -", resultsha256);
*/