const authen = require('./authen');
const journal = require('./journal');
const user = require('./user');

class Routes {
    constructor(app) {
        this.app = app;
    }
    getRoutes() {
        this.app.use('/api/authen', authen);
        this.app.use('/api/journal', journal);
        this.app.use('/api/user', user);
    }
}

module.exports = Routes;