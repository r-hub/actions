
function get_major_version(x) {
    return x.replace(/^([0-9]+)\..*$/, '$1');
}

module.exports = get_major_version;
