
const temp = require('temp-dir');
const fs = require('fs');
const {promisify} = require('util');
const write_file = promisify(fs.writeFile);
const path = require('path');

async function tempfile(prefix = "node-") {
    const filename = prefix + Math.random()
          .toString(36)
          .replace(/[^a-z]+/g, '')
          .substr(0, 10);

    const filepath = path.join(temp, filename);

    await write_file(filepath, Buffer.alloc(0));
    return filepath;
}

module.exports = tempfile;
