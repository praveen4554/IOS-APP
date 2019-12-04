const crypto = require('crypto');
const algorithm = 'aes-256-cbc';
const key = crypto.randomBytes(32);
const iv = crypto.randomBytes(16);
const nodersa = require('node-rsa'); 


function encrypt(publicKey,text) {
    //let cipher = crypto.createCipheriv(algorithm, Buffer.from(key), iv);
    //let encrypted = cipher.update(text);
    //encrypted = Buffer.concat([encrypted, cipher.final()]);
    // let encryptStr = iv.toString('hex') + ":"+encrypted.toString('hex');
    //console.log('text');
    //let data = crypto.publicEncrypt(Buffer.from(key),Buffer.from(text));
    console.log(publicKey);
    const key = new nodersa(publicKey,'pkcs1-public');
    const encrypted = key.encrypt( text );
    console.log(encrypted);
    
        return encrypted; 
    // return {encryptedData: encryptStr}
}

function decrypt(text) {
   let encryptedText = Buffer.from(text[0], 'utf8');
   //console.log("Encrypted Text ", encryptedText)
    const privKey = "-----BEGIN RSA PRIVATE KEY-----MIIBOwIBAAJBAJO3KtvgU2a6EPBcT7WIt+h0nN3WAG64OtiRVNrKt4ist15Xz2/IN3kBCajYvbvMhRKaxF/3evJTF372bZKFgI0CAwEAAQJAGTJWWjkyoMQ+XXGxmwqeLEWv+Fsnqbs9NnHb4pJPqj1hieYET7rXpirOqmcRK9DShsHL1wnPJF/ydk4xCLbmIQIhAMoY135jWcexU6fYHcF51dBB7fNyKD+B8G4QarmI/781AiEAux0pVlgisoiTvOJYwPjYCQdC73Vi0a6mD33fsWflLvkCIFZHcsB/k9XAK9HNXy65YAHwE7FKPEqYo9epZJbfGSg9AiEAmpPLu44SFAWqbydahQjOiB7cmDAUk/7BJxkovEmFVxkCIQDIvdZ0arjS4jBjv8v1dTu3RIJVmL+iMSUWCSBdzTgTDg==-----END RSA PRIVATE KEY-----"
    try {
        
     const key = new nodersa( privKey);
      const encrypted = key.decrypt( encryptedText, 'utf8');
      console.log(encrypted);
    return encrypted; 
        //let decipher = crypto.createDecipheriv(algorithm, Buffer.from(key), iv);
        //console.log("Decipher IV ", decipher)
        //let decrypted = decipher.update(encryptedText);
        //decrypted = Buffer.concat([decrypted, decipher.final()]);
        //return decrypted.toString();
    } catch (e ){
        console.log("Exception ",e)
        return ""
    }

}

//
// var hw = encrypt("Some serious stuff")
// console.log(hw)
// console.log(decrypt(hw))

module.exports.encrypt = encrypt;
module.exports.decrypt = decrypt;