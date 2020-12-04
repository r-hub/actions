
const download_maybe = require('./download-maybe');
const ora = require('ora');
const pretty_bytes = require('pretty-bytes');

async function download_files(urls) {

    var done = 0;
    const spin = ora('Downloading files: ' + done + '/' + urls.length).start();
    var spinner = {
        dls: { },
        show: function() {
            var current = 0, total = 0;
            for (const url in spinner.dls) {
                current += spinner.dls[url].current;
                total += spinner.dls[url].total;
            }
            spin.text = 'Downloading files: ' + done + '/' +
                urls.length + ' ' + pretty_bytes(current) + '/' +
                pretty_bytes(total);
        }
    };

    try {
        var pdl = urls.map(async function(url) {
            const filename = await download_maybe(url, spinner);
            done++;
            spinner.show();
            return filename;
        })

    } catch(error) {
        spin.fail();
        throw error;
    }

    const filenames = await Promise.all(pdl);
    spin.succeed();
    return filenames;
}

module.exports = download_files;
