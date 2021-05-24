
const urls = require('./urls');
const semver = require('semver');

function url_macos(version) {
    if (version === 'devel') {
        return urls.macos_dev;

    } else if (semver.eq(version, '3.2.5')) {
        return urls.macos_325;

    } else if (semver.lt(version, "3.4.0")) {
        return urls.macos_old2.replace('%s', version);

    } else if (semver.lt(version, "4.0.0")) {
        return urls.macos_old.replace('%s', version);

    } else {
        return urls.macos.replace('%s', version);
    }
}

module.exports = url_macos;
