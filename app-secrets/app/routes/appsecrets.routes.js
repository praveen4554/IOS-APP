module.exports = (app) => {
    const secrets = require('../controllers/appsecrets.controller.js');

    // Create a new secret
    app.post('/appsecrets', secrets.create);

    // Retrieve all Secrets
    app.get('/appsecrets', secrets.findAll);

    // Retrieve a single Secret with secretId
    app.get('/appsecrets/:secretId', secrets.findOne);

    // Update a App Secret with secretId
    app.put('/appsecrets/:secretId', secrets.update);

    // Delete a Secret with secretId
    app.delete('/appsecrets/:secretId', secrets.delete);
}
