const authen = require('./authen');

class Routes {
    constructor(app) {
        this.app = app;
    }

    getRoutes() {
        this.app.use('/api/authen', authen);
    }
}

module.exports = Routes;