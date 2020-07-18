
const test = require('ava');
const srv = require('./helpers/server');

let me, mycache, get_nick;

test.before(async () => {
    await srv();
    me = require('..');
    get_nick = require('../lib/get-nick');
    mycache = require('../lib/cache');
});

test('get_nick', async t => {
    // get_nick
    // We remove this from the cache, so we can test that it is downloaded
    // on demand and updated in the cache.
    delete get_nick.internals.cached['3.6.3'];
    t.is(get_nick.internals.cached['3.6.3'], undefined);
    const p362 = get_nick('3.6.2');
    const p363 = get_nick('3.6.3');
    const nicks = await Promise.all([p362, p363]);
    t.deepEqual(nicks, [ 'Dark and Stormy Night', 'Holding the Windsock' ]);
    t.is(get_nick.internals.cached['3.6.3'], 'Holding the Windsock');

    // download_nick
    const n363 = await get_nick.internals.download_nick('3.6.3');
    t.is(n363, 'Holding the Windsock');
});

function run(dummy = '') {
    test('r_versions' + dummy, async t => {
        // We run it twice, the second result comes from the cache
        for (let i = 0; i < 2; i++) {
            const result = await me.r_versions();
            t.is(result[0].version, '0.60');
            t.is(result[0].nickname, null);

            const versions = result.map(function(x) { return x.version; })
            t.true(versions.indexOf('3.6.3') > -1);
            t.is(result[versions.indexOf('2.14.0')].nickname, 'Great Pumpkin');

            const dates = result.map(function(x) { return Date.parse(x.date); })
            t.pass()
        }
    });

    test('r_release' + dummy, async t => {
        for (let i = 0; i < 2; i++) {
            const result = await me.r_release();
            t.deepEqual(
                Object.keys(result).sort(),
                ['date', 'nickname', 'version']
            );
            t.true(/^[0-9]+\.[0-9]+\.[0-9]+$/.test(result.version));
            Date.parse(result.date);
            t.pass()
            t.is(result.nickname, await get_nick(result.version));
        }
    });

    test('r_oldrel' + dummy, async t => {
        for (let i = 0; i < 2; i++) {
            const vers = await Promise.all([me.r_release(), me.r_oldrel()]);
            const rm = vers[0].version.replace(/^[0-9]+\.([0-9]+).*$/, '$1');
            const om = vers[1].version.replace(/^[0-9]+\.([0-9]+).*$/, '$1');
            t.is(Number(rm) - 1, Number(om));
        }
    });

    test('r_release_macos' + dummy, async t => {
        for (let i = 0; i < 2; i++) {
            const result = await me.r_release_macos();
            t.deepEqual(
                Object.keys(result).sort(),
                ['URL', 'date', 'nickname', 'version']
            )
            t.true(/^[0-9]+\.[0-9]+\.[0-9]+$/.test(result.version));
            Date.parse(result.date);
            t.pass()
            t.is(result.nickname, await get_nick(result.version));
        }
    });

    test('r_release_tarball' + dummy, async t => {
        for (let i = 0; i < 2; i++) {
            const result = await me.r_release_tarball();
            t.deepEqual(
                Object.keys(result).sort(),
                ['URL', 'date', 'nickname', 'version']
            )
            t.true(/^[0-9]+\.[0-9]+\.[0-9]+$/.test(result.version));
            Date.parse(result.date);
            t.pass()
            t.is(result.nickname, await get_nick(result.version));
        }
    });

    test('r_release_win' + dummy, async t => {
        for (let i = 0; i < 2; i++) {
            const result = await me.r_release_win();
            t.deepEqual(
                Object.keys(result).sort(),
                ['URL', 'date', 'nickname', 'version']
            )
            t.true(/^[0-9]+\.[0-9]+\.[0-9]+$/.test(result.version));
            Date.parse(result.date);
            t.pass()
            t.is(result.nickname, await get_nick(result.version));
        }
    });
}

// Test the proper implementation
run();

// Test the dummy
process.env.NODE_RVERSIONS_DUMMY = 'true';
run('-dummy');
