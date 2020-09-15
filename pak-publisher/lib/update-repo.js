
const r = require('./r');
const get_workdir = require('./workdir');

async function update_repo(rversions) {
    const wd = process.cwd();
    try {
        const workdir = await get_workdir();
        process.chdir(workdir);
        for (i = 0; i < rversions.length; i++) {
            var ver = rversions[i];
            console.log("Updating CRAN repo for R " + ver);
            if (process.platform === 'linux') {
                await r(undefined, 'main()');
            } else {
                await r(ver, 'main()');
            }
        }
    } finally {
        process.chdir(wd);
    }
}

module.exports = update_repo;
