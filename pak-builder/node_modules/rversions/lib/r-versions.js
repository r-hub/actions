
const mycache = require('./cache');
const r_versions_bare = require('./r-versions-bare');
const get_nick = require('./get-nick');

async function r_versions(cache = true) {
    let cached = undefined;
    if (cache) { cached = mycache.get('r_versions'); }
    if (cached !== undefined) { return cached; }
    const ver = await r_versions_bare(cache);
    const result = await Promise.all(ver.map(async function(x) {
        x.nickname = await get_nick(x.version);
        return x;
    }))

    mycache.set('r_versions', result);
    return result;
}

module.exports = r_versions;
