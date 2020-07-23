
const execa = require('execa');
const core = require('@actions/core')
const pat  = core.getInput('token') || process.env['GITHUB_PAT_PAK'];

const exec = require('./exec');
const get_workdir = require('./workdir');

async function push_repo() {
    console.log("::group::Publishing repository");

    if (!pat) {
        throw('Cannot publish without a token')
    }

    const wd = process.cwd();
    try {
        const workdir = await get_workdir();
        process.chdir(workdir);
        const url = 'https://' + pat + '@github.com/r-lib/r-lib.github.io.git';
        process.chdir('r-lib.github.io');

        try {
            await execa('git', ['config', '--global', 'user.email'])
        } catch(err) {
            await execa(
                'git',
                ['config', '--global', 'user.email', 'csardi.gabor@gmail.com']
            );
        }

        try {
            await execa('git', ['config', '--global', 'user.name'])
        } catch(err) {
            await execa(
                'git',
                ['config', '--global', 'user.name', 'pak builder']);
        }

        await exec('git', ['pull']);
        await exec('git', ['add', '-A', '.']);
        await exec('git', ['commit', '-m', 'Update pak binaries']);
        await exec('git', ['push']);

    } finally {
        process.chdir(wd);
        console.log('::endgroup::');
    }
}

module.exports = push_repo;
