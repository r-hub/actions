
const resolve_url = require("./resolve-url");
const urls = require('./urls');
const semver = require('semver');

async function url_win(version) {
    if (version === 'devel') {
        return urls.win_dev;
    }
    const rel = await resolve_url("r-release");
    if (semver.eq(rel.version, version)) {
        return urls.win.replace(/%s/g, version);
    } else {
        return urls.win_old.replace(/%s/g, version);
    }
}

module.exports = url_win;
