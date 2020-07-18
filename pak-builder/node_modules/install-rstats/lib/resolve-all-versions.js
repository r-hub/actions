
const resolve_version = require('./resolve-version');
const ora = require('ora');
const unique = require('array-unique');

async function resolve_all_versions(versions, os) {
    var result;

    const spin = ora('Resolving ' + versions.length + ' R version(s)')
          .start();

    try {
        var pversions = versions.map(
            function(v) { return resolve_version(v, os); }
        );
        const result = await Promise.all(pversions);
        spin.succeed();
        return unique(result);
    } catch(error) {
        spin.fail();
        throw error;
    }
}

module.exports = resolve_all_versions;
