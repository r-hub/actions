
const mycache = require('./cache');
const urls = require('./urls');

const got = require('got');
const xpath = require('xpath');
const dom = require('xmldom').DOMParser;

async function r_versions_bare(cache = true) {
    let cached = undefined;
    if (cache) { cached = mycache.get('r_versions_bare'); }
    if (cached !== undefined) { return cached; }

    const opts = {
        method: 'PROPFIND',
        headers: {
            Depth: '1'
        }
    };
    const resp = await got(urls.svn, opts);
    const doc = new dom().parseFromString(resp.body);
    const expr = xpath.parse('.//D:propstat/D:prop');
    const props = expr.select({ node: doc, isHtml: true });
    const versions = props.map(function(n) {
        const xdate = xpath.parse('.//D:creationdate');
        const xtag = xpath.parse('.//D:getetag');
        const date = xdate.select({ node: n, isHtml: true })[0].textContent;
        const tag =
              xtag.select({ node: n, isHtml: true })[0]
              .textContent
              .replace(/^.*\/tags\/R-([-0-9]+).*$/, '$1');

        if (/^[0-9]+-[0-9]+(-[0-9]+|)$/.test(tag)) {
            const version = tag.replace(/-/g, ".");
            return {
                version: version,
                date: date
            };
        } else {
            return null;
        }
    });

    const releases = versions
          .filter(function(x) { return x !== null; })
          .sort(function(a, b) {
              if (a.date < b.date) {
                  return -1;
              } else {
                  return 1;
              }
          })

    mycache.get('r_versions_bare', releases);
    return releases;
}

module.exports = r_versions_bare;
