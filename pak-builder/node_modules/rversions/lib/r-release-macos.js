
const mycache = require('./cache');
const first_link = require('./first-link');

async function r_release_macos(cache = true) {
    let cached = undefined;
    if (cache) { cached = mycache.get('r_release_macos'); }
    if (cached !== undefined) { return cached; }

    const value = await first_link(
        'macos',
        'Cannot deduce version of latest macOS installer'
    );

    mycache.set('r_release_macos', value);
    return value;
}

module.exports = r_release_macos;
