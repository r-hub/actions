
const mycache = require('./cache');
const r_versions_bare = require('./r-versions-bare');
const get_nick = require('./get-nick');

async function r_oldrel(cache = true) {
    let cached = undefined;
    if (cache) { cached = mycache.get('r_oldrel'); }
    if (cached !== undefined) { return cached; }

    const versions = await r_versions_bare(cache);
    const oldrel = get_oldrel(versions);
    oldrel.nickname = await get_nick(oldrel.version);

    mycache.set('r_oldrel', oldrel);
    return oldrel;
}

function get_oldrel(versions) {
    const minors = versions.map(function(x) {
        return x.version.replace(/^([0-9]+\.[0-9]+).*$/, '$1');
    })

    // The first older version that has a different majot.minor version
    // is r-oldrel
    const rlsminor = Number(minors.pop());
    for (let i = versions.length - 2; i > 0; i--) {
        if (Number(minors[i]) != rlsminor) return(versions[i]);
    }
    throw new Error("Cannot decude r-oldrel version");
}

module.exports = r_oldrel;

if (process.env['NODE_ENV'] === 'test') {
    r_oldrel.internals = {
        get_oldrel: get_oldrel
    };
}
