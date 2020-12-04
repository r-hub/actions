
function get_minor_version(x) {
    return x.replace(/^[0-9]+\.([0-9]+).*$/, '$1');
}

module.exports = get_minor_version;
