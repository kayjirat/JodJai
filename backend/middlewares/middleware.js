const myMiddleware = (req, res, next) => {
    console.log(`${req.method} request for ${req.url}`);
    next();
};

module.exports = myMiddleware;
