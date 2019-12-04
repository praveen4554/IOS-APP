const mongoose = require('mongoose');

const appSchema = mongoose.Schema({
    seckey: String,
    emailId: String
}, {
    timestamps: true
});
module.exports = mongoose.model('appsecrets', appSchema);
