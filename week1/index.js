const crypto = require('crypto');
const secp256k1 = require('secp256k1');

const msg = process.argv[2]; // message to be signed you pass
const msg2 = "test"
const digested = digest(msg);
const digested2 = digest(msg2)
console.log(`0) Alice's message: 
    message: ${msg}
    message digest: ${digested.toString("hex")}
    message: ${msg2}
    message digest: ${digested2.toString("hex")}    
`)

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

// Sign the message

console.log(`2) Alice signed her message digest with her privateKey to get its signature:`);
const sigObj = secp256k1.sign(digested, privateKey);
const sigObj2 = secp256k1.sign(digested2, privateKey);
const sig = sigObj.signature;
const sig2 = sigObj2.signature;
console.log("	Signature:", sig.toString("hex"));
console.log("	Signature2:", sig2.toString("hex"));


// end Sign the message


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