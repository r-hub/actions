
if (!process.env.NODE_RVERSIONS_DUMMY) {

    const r_versions        = require('./lib/r-versions');
    const r_release         = require('./lib/r-release');
    const r_oldrel          = require('./lib/r-oldrel');
    const r_release_macos   = require('./lib/r-release-macos');
    const r_release_tarball = require('./lib/r-release-tarball');
    const r_release_win     = require('./lib/r-release-win');

    module.exports = {
        r_versions:        r_versions,
        r_release:         r_release,
        r_oldrel:          r_oldrel,
        r_release_macos:   r_release_macos,
        r_release_tarball: r_release_tarball,
        r_release_win:     r_release_win
    };

} else {

    const dummy = require('./lib/dummy');

    module.exports = {
        r_versions:        dummy.r_versions,
        r_release:         dummy.r_release,
        r_oldrel:          dummy.r_oldrel,
        r_release_macos:   dummy.r_release_macos,
        r_release_tarball: dummy.r_release_tarball,
        r_release_win:     dummy.r_release_win
    };
}
