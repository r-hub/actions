
const resolve_all_versions = require('./resolve-all-versions');
const url_macos = require('./url-macos');
const download_files = require('./download-files');
const {promisify} = require('util');
const sudo = promisify(require('sudo-prompt').exec);
const execa = require('execa');
const ora = require('ora');
const Tail = require('tail').Tail;
const path = require('path');
const tempfile = require('./tempfile');

async function install_macos(versions) {

    const rversions = await resolve_all_versions(versions, 'macos');
    const urls = rversions.map(url_macos);
    const filenames = await download_files(urls);

    // Run install script to do the rest
    const vs = rversions.join(", ");
    const script = path.join(__dirname, "/installer.sh");
    const outfile = await tempfile();

    var tail = new Tail(outfile);
    tail.on('line', function(data) {
        console.log("→ " + data);
    });

    const spin = ora('Installing R version(s): ' + vs).start();
    spin.info();

    try {
        await sudo(
            script + ' ' + filenames.join(" ") + " 2>&1 >> " + outfile,
            { name: 'installrstats' }
        )
    } catch(error) {
        tail.unwatch()
        throw error;
    }

    tail.unwatch()

    const script2 = path.join(__dirname, "/create-lib.sh");
    const {stdout} = await execa(script2);
    console.log(stdout);
}

module.exports = install_macos;
