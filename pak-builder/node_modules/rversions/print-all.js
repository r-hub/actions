
const me = require('.');

(async () => {

    // First query all versions, because this is cached
    var ver = await me.r_versions();

    // Then we can do the rest in parallel
    var rel = me.r_release();
    var old = me.r_oldrel();
    var ol1 = me.r_oldrel(which = 1);
    var ol2 = me.r_oldrel(which = 2);
    var ol3 = me.r_oldrel(which = 3);
    var ol4 = me.r_oldrel(which = 4);
    var ol5 = me.r_oldrel(which = 5);
    var mac = me.r_release_macos();
    var tar = me.r_release_tarball();
    var win = me.r_release_win();
    var dev = me.r_devel();

    var all = await Promise.all(
        [rel, old, ol1, ol2, ol3, ol4, ol5, mac, tar, win, dev]
    );

    var all2 = {
        "r_versions":        ver,
        "r_release":         all[0],
        "r_oldrel":          all[1],
        "r_oldrel/1":        all[2],
        "r_oldrel/2":        all[3],
        "r_oldrel/3":        all[4],
        "r_oldrel/4":        all[5],
        "r_oldrel/5":        all[6],
        "r_release_macos":   all[7],
        "r_release_tarball": all[8],
        "r_release_win":     all[9],
        "r_devel":           all[10]
    };

    console.log(all2);
})();
