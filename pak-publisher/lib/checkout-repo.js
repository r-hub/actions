
const core = require('@actions/core');
const pat  = core.getInput('token') || process.env['GITHUB_PAT_PAK'];

const { promisify } = require('util');
const fs = require('fs');
const access = promisify(fs.access);

const exec = require('./exec');
const get_workdir = require('./workdir');

async function checkout_repo() {
    console.log("::group::Checking out repository");

    if (! pat) {
        console.warn('!!! No GITHUB_TOKEN, will not be able to publish');
    }

    const wd = process.cwd();
    try {
        const workdir = await get_workdir();
        process.chdir(workdir);
        const url = 'https://' + pat + '@github.com/r-lib/r-lib.github.io.git';
        var ex = true;
        try { await access('r-lib.github.io') } catch(err) { ex = false; }
        if (! ex) {
            await exec('git', ['clone', url]);
        } else {
            process.chdir('r-lib.github.io');
            await exec('git', ['pull']);
        }
        
    } finally {
        process.chdir(wd);
        console.log("::endgroup::");
    }
}

module.exports = checkout_repo;
