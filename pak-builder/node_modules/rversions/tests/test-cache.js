
// This is in a separate file, so it will be run in a separate process,
// and will not interfere with the cache of the other test file(s).

const test = require('ava');
const srv = require('./helpers/server');

let me, mycache;

test.before(async () => {
    await srv();
    me = require('..');
    mycache = require('../lib/cache');
});

test('cache', async t => {
    mycache.set('foo', 'bar');
    t.is(mycache.get('foo'), 'bar');

    mycache.del('foo');
    t.is(mycache.get('foo'), undefined);
});

test('caching', async t => {
    mycache.del('r_versions');
    mycache.del('r_release');
    mycache.del('r_oldrel');
    mycache.del('r_release_macos');
    mycache.del('r_release_tarball');
    mycache.del('r_release_win');

    t.is(mycache.get('r_versions'), undefined);
    await me.r_versions();
    t.true(mycache.get('r_versions') !== undefined);

    t.is(mycache.get('r_release'), undefined);
    await me.r_release();
    t.true(mycache.get('r_release') !== undefined);
    
    t.is(mycache.get('r_oldrel'), undefined);
    await me.r_oldrel();
    t.true(mycache.get('r_oldrel') !== undefined);

    t.is(mycache.get('r_release_macos'), undefined);
    await me.r_release_macos();
    t.true(mycache.get('r_release_macos') !== undefined);

    t.is(mycache.get('r_release_tarball'), undefined);
    await me.r_release_tarball();
    t.true(mycache.get('r_release_tarball') !== undefined);
    
    t.is(mycache.get('r_release_win'), undefined);
    await me.r_release_win();
    t.true(mycache.get('r_release_win') !== undefined);
});
