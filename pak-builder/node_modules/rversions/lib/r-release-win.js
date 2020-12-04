
const mycache = require('./cache');
const first_link = require('./first-link');

async function r_release_win(cache = true) {
    let cached = undefined;
    if (cache) { cached = mycache.get('r_release_win'); }
    if (cached !== undefined) { return cached; }

    const value = await first_link(
        'win',
        'Cannot deduce version of latest Windows installer'
    );

    mycache.set('r_release_win', value);
    return value;
}

module.exports = r_release_win;
