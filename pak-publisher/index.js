
const core = require('@actions/core')

const pat  = core.getInput('token') || process.env['GITHUB_PAT_PAK'];
if (pat) {
    process.env['GITHUB_PAT'] = process.env['GITHUB_TOKEN'] = pat;
}

const checkout_repo = require('./lib/checkout-repo');
const update_repo   = require('./lib/update-repo');
const push_repo     = require('./lib/push-repo');

async function run() {
    try {
        await checkout_repo();
        await update_repo();
        await push_repo();
    } catch (error) {
        console.log(error)
        core.setFailed(error.message);
    }
}

run()
