
const mycache = require('./cache');
const r_versions_bare = require('./r-versions-bare');
const get_nick = require('./get-nick');

async function r_release(cache = true) {
    let cached = undefined;
    if (cache) { cached = mycache.get('r_release'); }
    if (cached !== undefined) { return cached; }

    const vers = await r_versions_bare(cache);
    const release = vers.pop();
    release.nickname = await get_nick(release.version);

    mycache.set('r_release', release);
    return release;
}

module.exports = r_release;
