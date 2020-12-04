
const execa = require('execa');
const installer = require('install-rstats');
const install_libcurl = require('./install-libcurl');
const clone_pak = require('./clone-pak');
const build_pak = require('./build-pak');

async function build_macos(rversions) {
    console.log('::group::Installing R versions: ' + rversions.join(', '));
    const sym_versions = rversions.map(function(v) {
        return v.replace(/\/[0-9.]*$/, '');
    })
    const num_versions = rversions.map(function(v) {
        return v.replace(/^devel\//, '');
    });
    await installer.install(sym_versions);
    console.log('::endgroup::')

    console.log('::group::Installing static libcurl from brew');
    await install_libcurl();
    console.log('::endgroup::')

    console.log('::group::Getting pak from GitHub');
    await clone_pak();
    console.log('::endgroup::')

    for (i = 0; i < num_versions.length; i++) {
        var ver = num_versions[i];
        console.log('::group::Bulding pak for R ' + ver);
        await build_pak(ver);
        console.log('::endgroup::');
    }
}

module.exports = build_macos;
