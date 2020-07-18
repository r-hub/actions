
const mycache = require('./cache');
const first_link = require('./first-link');

async function r_release_tarball(cache = true) {
    let cached = undefined;
    if (cache) { cached = mycache.get('r_release_tarball'); }
    if (cached !== undefined) { return cached; }

    const value = await first_link(
        'tarball',
        'Cannot deduce version of latest tarball'
    );

    mycache.set('r_release_tarball', value);
    return value;
}

module.exports = r_release_tarball;
