
const execa = require('execa');
const installer = require('install-rstats');
const install_libcurl = require('./install-libcurl');
const clone_pak = require('./clone-pak');
const build_pak = require('./build-pak');

async function build_macos(rversions) {
    console.log('::group::Installing R versions: ' + rversions.join(', '));
    await installer.install(rversions);
    console.log('::endgroup::')

    console.log('::group::Installing static libcurl from brew');
    await install_libcurl();
    console.log('::endgroup::')

    console.log('::group::Getting pak from GitHub');
    await clone_pak();
    console.log('::endgroup::')

    rversions.forEach(async function(ver) {
        console.log('::group::Bulding pak for R ' + ver);
        await build_pak(ver);
        console.log('::endgroup::');
    });
}

module.exports = build_macos;
