
const rversions = require('rversions');
const api = process.env.R_VERSIONS_API_URL ||
      'https://api.r-hub.io/rversions/';
const got = require('got');

async function resolve_rv(endpoint) {
    const mp = {
        'r-release': 'r_release',
        'r-release-macos': 'r_release_macos',
        'r-release-win': 'r_release_win',
        'r-oldrel': 'r_oldrel',
        'r-versions': 'r_versions'
    };
    const mb = mp[endpoint];
    if (mb === undefined) {
        throw(new Error('Unknown rvresions APIx endpoint: ' + endpoint));
    }
    return await rversions[mb]();
}

async function resolve_url(endpoint) {
    var body;
    try {
        body = await got(api + endpoint).json();
    } catch(err) {
        body = await resolve_rv(endpoint);
    }

    return body;
}

module.exports = resolve_url;
