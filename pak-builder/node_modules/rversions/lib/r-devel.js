
const mycache = require('./cache');
const urls = require('./urls');

const got = require('got');

async function r_devel(cache = true) {
    let cached = undefined;
    if (cache) { cached = mycache.get('r_devel'); }
    if (cached !== undefined) { return cached; }

    const p1 = got(urls.devel);
    const p2 = got(urls.devel_nick);

    var all = await Promise.all([p1, p2]);
    var ver = all[0].body.trim().split(' ')[0];
    var nick = all[1].body.trim();

    const value = {
        'version': ver,
        date: null,
        'nickname': nick
    };
    
    mycache.set('r_devel', value);
    return value;
}

module.exports = r_devel;
