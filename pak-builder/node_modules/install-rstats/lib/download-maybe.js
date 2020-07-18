
const temp = require('temp-dir');
const got = require('got');
const mkdirp = require('mkdirp');
const filenamify = require('filenamify')

const stream = require('stream');
const fs = require('fs');
const path = require('path');
const {promisify} = require('util');

const pipeline = promisify(stream.pipeline);
const unlink = promisify(fs.unlink);
const access = promisify(fs.access);
const rename = promisify(fs.rename);

async function download_maybe(url, spinner) {
    const filename = path.join(
        temp,
        filenamify(path.basename(url), { replacement: '-' })
    );

    // If the file exists, we just return it. Otherwise we download it
    // It would be great to check that it is a non-broken file somehow...

    try {
        await access(filename);

    } catch(err) {

        try {
            const str = got.stream(url);
            if (spinner !== undefined) {
                spinner.dls[url] = { current: 0, total: 0 };
                str.on('downloadProgress', function(data) {
                    spinner.dls[url].total = data.total;
                    spinner.dls[url].current = data.transferred;
                    spinner.show();
                });
            }
            await mkdirp(path.dirname(filename));
            await pipeline(str, fs.createWriteStream(filename + '.partial'));
            await rename(filename + '.partial', filename);

        } catch(err) {
            try { await unlink(filename); } catch(err) { }
            try { await unlink(filename + 'partial') } catch (err) { }
            throw err;
        }
    }

    return filename;
}

module.exports = download_maybe;
