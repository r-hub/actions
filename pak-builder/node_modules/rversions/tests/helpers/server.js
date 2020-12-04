
const createTestServer = require('create-test-server');

// We use a test server, unless NODE_RVERSIONS_NOMOCK is set _or_
// we are running in a Travis cron job.

async function srv() {
    if (! process.env.NODE_RVERSIONS_NOMOCK &&
        process.env.TRAVIS_EVENT_TYPE !== "cron") {
        const {promisify} = require('util');
        const fs = require('fs');
        const readFile = promisify(fs.readFile);
        
        srv = await createTestServer();
        
        process.env.NODE_RVERSIONS_SVN = srv.url + '/tags';
        srv.propfind('/tags', async (req, res) => {
            const xml = await readFile('tests/fixtures/tags.txt', 'utf8');
            res.send(xml);
        });
        
        process.env.NODE_RVERSIONS_NICK = srv.url + '/nick/R-%s';
        srv.get('/nick/:ver', async (req, res) => {
            const ver = req.params.ver;
            if (ver == "R-3-6-2") {
                res.send("Dark and Stormy Night");
            } else if (ver == "R-3-6-3") {
                res.send('Holding the Windsock');
            } else {
                res.send('This is ' + req.params.ver);
            }
        });
        
        process.env.NODE_RVERSIONS_MACOS = srv.url + '/dl/macos/%s';
        process.env.NODE_RVERSIONS_TARBALL = srv.url + '/dl/tarball/%s';
        process.env.NODE_RVERSIONS_WIN = srv.url + '/dl/win/%s';
        srv.head('/dl/:os/:ver', async (req, res) => {
            const os = req.params.os;
            const ver = req.params.ver;
            if (os === "macos" && ver === "3.6.3") {
                res.status(404).end();
            } else {
                res.send();
            }
        });
    }
}

module.exports = srv;
