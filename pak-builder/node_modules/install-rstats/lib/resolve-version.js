
const resolve_url = require('./resolve-url');

async function resolve_version(version, os = undefined) {
    if (version === undefined) { version = 'release'; }

    if (version === 'devel') {
        // Do nothing with devel

    } else if (version === 'release') {
        let rrls;
        if (os === undefined) {
            rrls = await resolve_url('r-release');
        } else if (os === 'macos' || os === 'mac' || os === 'macOS' ||
                   os === 'darwin') {
            rrls = await resolve_url('r-release-macos');
        } else if (os === 'windows' || os === 'win' || os === 'win32') {
            rrls = await resolve_url('r-release-win');
        } else {
            throw new Error('Unknown OS in `resolve_version()`: ' + os);
        }

        version = rrls.version;

    } else if (version === 'oldrel') {
        const rold = await resolve_url('r-oldrel');
        version = rold.version;

    } else if (/^[0-9]+\.[0-9]+$/.test(version)) {
        const maj = version.replace(/^([0-9]+)\..*$/, '$1');
        const min = version.replace(/^[0-9]+\.([0-9]+).*$/, '$1');
        const rls = await resolve_url('r-versions');
        const majors = rls.map(function(x) {
            return x.version.replace(/^([0-9]+)\..*$/, '$1');
        })
        const minors = rls.map(function(x) {
            return x.version.replace(/^[0-9]+\.([0-9]+).*$/, '$1');
        })
        let i;
        for (i = rls.length - 1; i >= 0; i--) {
            if (majors[i] == maj && minors[i] == min) break;
        }

        if (i < 0) {
            throw new Error('Unknown minor R version: ' + version);
        } else {
            version = rls[i].version;
        }

    } else {
        const rls = await resolve_url('r-versions');
        const vrs = rls.map(function(x) { return x.version; });
        if (vrs.indexOf(version) == -1) {
            throw new Error('Unknown R version: ' + version);
        }
    }

    return version;
}

module.exports = resolve_version;
