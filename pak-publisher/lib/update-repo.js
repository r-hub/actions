
const r = require('./r');
const get_workdir = require('./workdir');

async function update_repo(rversions) {
    const wd = process.cwd();
    try {
        const workdir = await get_workdir();
        process.chdir(workdir);
        console.log("Updating CRAN repo")
        await r(undefined, 'main()');
    } finally {
        process.chdir(wd);
    }
}

module.exports = update_repo;
