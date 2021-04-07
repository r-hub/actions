
const exec = require('./exec');
const path = require('path');

const clone_pak = require('./clone-pak');
const get_workdir = require('./workdir');

async function docker_build(sym, ver) {
    if (!process.env.GITHUB_PAT) {
        console.warn("No GITHUB_PAT environment variable, build might fail");
    }
    await exec('docker', [
        'build', '-t', 'rhub/pak-builder:' + ver,
        '--build-arg', 'R_MAJOR=' + sym,
        '--build-arg', 'GITHUB_PAT=' + process.env.GITHUB_PAT,
        '-f', path.join(__dirname, 'Dockerfile'),
        __dirname
    ]);

    await exec('docker', [
        'run',
        '-e', 'GITHUB_PAT=' + process.env.GITHUB_PAT,
        '-e', 'GITHUB_WORKFLOW=' + process.env.GITHUB_WORKFLOW,
        '-e', 'GITHUB_REPOSITORY=' + process.env.GITHUB_REPOSITORY,
        '-e', 'GITHUB_SHA=' + process.env.GITHUB_SHA,
        '-e', 'GITHUB_REF=' + process.env.GITHUB_REF,
        '-v', process.cwd() + ':/root/pak',
        '-v', __dirname + '/installer.R:/root/pak/installer.R',
        'rhub/pak-builder:' + ver
    ]);
}

async function build_linux(rversions) {

    console.log('::group::Getting pak from GitHub');
    await clone_pak();
    console.log('::endgroup::')

    const sym_versions = rversions.map(function(v) {
        return v.replace(/\/[0-9.]*$/, '');
    })
    const num_versions = rversions.map(function(v) {
        return v.replace(/^devel\//, '');
    });
    for (i = 0; i < sym_versions.length; i++) {
        var sym = sym_versions[i];
        var ver = num_versions[i];
        console.log('::group::Building image for R ' + ver);
        const wd = process.cwd();
        try {
            const workdir = await get_workdir();
            process.chdir(workdir);
            await docker_build(sym, ver);
        } finally {
            process.chdir(wd);
            console.log('::endgroup::');
        }
    }
}

module.exports = build_linux;
