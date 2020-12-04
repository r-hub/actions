
const winreg = require('winreg');
const bluebird = require('bluebird');

async function reg_query(ver, arch) {
    const dver = ver[0] + '.' + ver[1];
    const reg = new winreg({
        hive: winreg.HKLM,
        key: '\\Software\\R-core\\Rtools\\' + dver,
        arch: arch
    });

    bluebird.promisifyAll(reg)

    var values;
    try {
        values = await reg.valuesAsync();
    } catch(err) {
        values = false
    }

    return (values !== false);
}

async function rtools_version_needed(ver) {
    const q32 = reg_query(ver, 'x86');
    const q64 = reg_query(ver, 'x64');
    const ret = await Promise.all([q32, q64]);
    return !ret[0] && !ret[1];
}

module.exports = rtools_version_needed;
