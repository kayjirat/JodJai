const authen = require('./authen');
const goal = require('./goal');
const subgoal = require('./subgoal');

class Routes {
    constructor(app) {
        this.app = app;
    }
    getRoutes() {
        this.app.use('/api/authen', authen);
        this.app.use('/api/goal', goal);
        this.app.use('/api/subgoal', subgoal);
    }
}

module.exports = Routes;