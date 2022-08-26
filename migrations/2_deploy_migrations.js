const Deploy = artifacts.require("VerifyingSigs");

module.exports = function (deployer) {
    deployer.deploy(Deploy);
};