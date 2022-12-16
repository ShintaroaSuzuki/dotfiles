module.exports.onWindow = (browserWindow) => browserWindow.setVibrancy("dark");

module.exports.decorateConfig = (config) => {
    config.backgroundColor = "rgba(0, 0, 0, 0.99)";
    return config;
};
