
const me = require('.');

(async () => {

    // First query all versions, because this is cached
    var ver = await me.r_versions();

    // Then we can do the rest in parallel
    var rel = me.r_release();
    var old = me.r_oldrel();
    var mac = me.r_release_macos();
    var tar = me.r_release_tarball();
    var win = me.r_release_win();

    var all = await Promise.all([rel, old, mac, tar, win]);

    var all2 = {
        "r_versions":        ver,
        "r_release":         all[0],
        "r_oldrel":          all[1],
        "r_release_macos"  : all[2],
        "r_release_tarball": all[3],
        "r_release_win":     all[4]
    };

    console.log(all2);
})();
