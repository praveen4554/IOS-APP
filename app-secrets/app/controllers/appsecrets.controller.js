const appSecrets = require('../models/appsecrets.model.js');
const secUtils = require('../helpers/crypt.utils');
const randomstring = require("randomstring");
const utf8 = require('utf8');
// Create and Save a new Secrets
exports.create = (req, res) => {
    // Validate request
    // if(!req.body.secret) {
    //     return res.status(400).send({
    //         message: "Secret content can not be empty"
    //     });
    // }

    
    // Create a Secret
   // console.log(req.body);
    const secret = new appSecrets({
        emailId: req.body.emailId,
        seckey: req.body.seckey
        //'-----BEGIN RSA PUBLIC KEY-----'+req.body.seckey.replace(/ /g,"+")+'-----END RSA PUBLIC KEY-----'
    });
    let respData = {"id" :"", "encrypted":""};
    let randomData = randomstring.generate({
            length: 12,
            charset: 'alphabetic'
        });
   let secJson = secUtils.encrypt('-----BEGIN RSA PUBLIC KEY-----\n'+req.body.seckey+'\n-----END RSA PUBLIC KEY-----', 'praveen');
    //console.log(secJson);
    var arr = ["?Qՙ�z�\u000b��JF�M�v^3�ر=���@Q5�8Eۏ�cA>ͣ��Z0^�/�3������'�"];
 // return secUtils.decrypt(arr)
    // Save secret in the database

    secret.save()
    .then(data => {
        respData.id = data._id
        respData.encrypted = secJson
        res.send(respData);
    }).catch(err => {
        console.log(err);
        res.status(500).send({
            message: err.message || "Some error occurred while creating the secret."
        });
    });
};

// Retrieve and return all secret from the database.
exports.findAll = (req, res) => {
    appSecrets.find()
    .then(secrets => {
        res.send(secrets);
    }).catch(err => {
        res.status(500).send({
            message: err.message || "Some error occurred while retrieving secrets."
        });
    });
};

// Find a single secret with a secretId
exports.findOne = (req, res) => {
    appSecrets.findById(req.params.secretId)
    .then(secret => {
        console.log("Secret ----", secret)
        let text = {"iv":"","encryptedData":""}
        text.iv = secret.title
        text.encryptedData = secret.secret
        console.log("Text ing ", text)
        let secJson = secUtils.decrypt(text);
        console.log("Security JSON", secJson)
        if(!secJson) {
            return res.status(404).send({
                message: "Secret not found with id " + req.params.secretId
            });            
        }
        res.send(secJson);
    }).catch(err => {
        if(err.kind === 'ObjectId') {
            return res.status(404).send({
                message: "Secret not found with id " + req.params.secretId
            });                
        }
        return res.status(500).send({
            message: "Error retrieving Secret with id " + req.params.secretId
        });
    });
};

// Update a secret identified by the secretId in the request
exports.update = (req, res) => {
    // Validate Request
    if(!req.body.secret) {
        return res.status(400).send({
            message: "Secret content can not be empty"
        });
    }

    // Find secret and update it with the request body
    appSecrets.findByIdAndUpdate(req.params.secretId, {
        title: req.body.title || "Untitled Secret",
        content: req.body.secret
    }, {new: true})
    .then(secret => {
        if(!secret) {
            return res.status(404).send({
                message: "secret not found with id " + req.params.secretId
            });
        }
        res.send(secret);
    }).catch(err => {
        if(err.kind === 'ObjectId') {
            return res.status(404).send({
                message: "secret not found with id " + req.params.secretId
            });                
        }
        return res.status(500).send({
            message: "Error updating secret with id " + req.params.secretId
        });
    });
};

// Delete a secret with the specified secretId in the request
exports.delete = (req, res) => {
    appSecrets.findByIdAndRemove(req.params.secretId)
    .then(secret => {
        if(!secret) {
            return res.status(404).send({
                message: "Secret not found with id " + req.params.secretId
            });
        }
        res.send({message: "Secret deleted successfully!"});
    }).catch(err => {
        if(err.kind === 'ObjectId' || err.name === 'NotFound') {
            return res.status(404).send({
                message: "Secret not found with id " + req.params.secretId
            });                
        }
        return res.status(500).send({
            message: "Could not delete Secret with id " + req.params.secretId
        });
    });
};
