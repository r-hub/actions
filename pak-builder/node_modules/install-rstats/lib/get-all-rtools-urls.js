
const get_major_version = require('./get-major-version');
const get_minor_version = require('./get-minor-version');
const rtools_version_needed = require('./rtools-version-needed');
const urls = require('./urls');

function unique(arr) {
    return arr.filter(function(elem, pos) {
        return arr.indexOf(elem) == pos;
    });
}

function get_rtools_url(rversion) {
    const major = get_major_version(rversion);
    const minor = get_minor_version(rversion);
    if (major == 3 && minor <= 2) {
        return '35'; // TODO: this should be '33', really
    } else if (major == 3) {
        return '35';
    } else {
        return '40';
    }
}

async function async_filter(arr, predicate) {
	const results = await Promise.all(arr.map(predicate));
	return arr.filter((_v, index) => results[index]);
}

async function get_all_rtools_urls(rversions) {
    const vers = unique(rversions.map(get_rtools_url));
    const versneeded = await async_filter(vers, rtools_version_needed);
    const rtoolsurls = versneeded.map(function(x) { return urls.rtools[x]});
    return rtoolsurls;
}

module.exports = get_all_rtools_urls;
