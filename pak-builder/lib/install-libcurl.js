
const execa = require('execa');
const path = require('path');

const exec = require('./exec');
const r = require('./r');
const get_workdir = require('./workdir');
const { promisify } = require('util');
const copy_file = promisify(require('fs').copyFile);

// There is apparently no way in brew to install or update a package
// automatically, so we have to do this hack. The final 'brew list'
// will fail if any of the packages are not present.

async function install_libcurl() {
    try { await exec('brew', 'update'); } catch (err) { }
    process.env['HOMEBREW_NO_AUTO_UPDATE'] = '1';
    try { await exec('brew', ['uninstall', 'composer', 'php']);    } catch(err) { }
    try { await exec('brew', ['install', 'curl']);     } catch(err) { }
    try { await exec('brew', ['upgrade', 'curl']);     } catch(err) { }
    try { await exec('brew', ['install', 'brotli']);   } catch(err) { }
    try { await exec('brew', ['upgrade', 'brotli']);   } catch(err) { }
    try { await exec('brew', ['install', 'nghttp2']);  } catch(err) { }
    try { await exec('brew', ['upgrade', 'nghttp2']);  } catch(err) { }
    await execa('brew', ['list', 'curl', 'brotli', 'nghttp2', 'libidn2']);
    await patch_cares();
    await recompile_cares();
    await patch_brotli();
    await recompile_brotli();
    await patch_nghttp2();
    await recompile_nghttp2();
    await patch_libcurl();
    await recompile_libcurl();
    await get_curl_package();
}

async function patch_cares() {
    console.log('Patching c-ares');
    const out = await execa('brew', ['edit', 'curl'], { 'env': { 'EDITOR': 'true' }});
    const formula = out.stdout.replace(/^Editing /, '');
    const formuladir = path.dirname(formula);
    const patch = path.join(__dirname, '/c-ares.rb.patch');
    const wd = process.cwd();
    try {
        process.chdir(formuladir);
        await exec('git', ['checkout', '--', 'c-ares.rb']);
        await exec('patch', ['-i', patch]);
    } finally {
        process.chdir(wd);
    }
}

async function patch_libcurl() {
    console.log('Patching libcurl');
    const out = await execa('brew', ['edit', 'curl'], { 'env': { 'EDITOR': 'true' }});
    const formula = out.stdout.replace(/^Editing /, '');
    const formuladir = path.dirname(formula);
    const patch = path.join(__dirname, '/curl.rb.patch');
    const wd = process.cwd()
    try {
        process.chdir(formuladir);
        await exec('git', ['checkout', '--', 'curl.rb']);
        await exec('patch', ['-i', patch]);
    } finally {
        process.chdir(wd);
    }
}

async function patch_brotli() {
    console.log('Patching brotli');
    const out = await execa('brew', ['edit', 'brotli'], { 'env': { 'EDITOR': 'true' }});
    const formula = out.stdout.replace(/^Editing /, '');
    const formuladir = path.dirname(formula);
    const patch = path.join(__dirname, '/brotli.rb.patch');
    const wd = process.cwd()
    try {
        process.chdir(formuladir);
        await exec('git', ['checkout', '--', 'brotli.rb']);
        await exec('patch', ['-i', patch]);
    } finally {
        process.chdir(wd);
    }
}

async function patch_nghttp2() {
    console.log('Patching nghttp2');
    const out = await execa('brew', ['edit', 'nghttp2'], { 'env': { 'EDITOR': 'true' }});
    const formula = out.stdout.replace(/^Editing /, '');
    const formuladir = path.dirname(formula);
    const patch = path.join(__dirname, '/nghttp2.rb.patch');
    const wd = process.cwd()
    try {
        process.chdir(formuladir);
        await exec('git', ['checkout', '--', 'nghttp2.rb']);
        await exec('patch', ['-i', patch]);
    } finally {
        process.chdir(wd);
    }
}

async function recompile_cares() {
    await exec('brew', ['reinstall', 'c-ares', '-s', '-v']);
}

async function recompile_libcurl() {
    await exec('brew', ['reinstall', 'curl', '-s', '-v']);
}

async function recompile_brotli() {
    await exec('brew', ['reinstall', 'brotli', '-s', '-v']);
}

async function recompile_nghttp2() {
    await exec('brew', ['reinstall', 'nghttp2', '-s', '-v']);
}

async function get_curl_package () {
    const wd = process.cwd();
    try {
        const workdir = await get_workdir();
        process.chdir(workdir);
        await r(undefined, 'download_curl()');
        const makefile = path.join(__dirname, 'Makevars-curl.in');
        await copy_file(makefile, 'curl/src/Makevars.in');
    } finally {
        process.chdir(wd);
    }
}

install_libcurl.patch_libcurl     = patch_libcurl;
install_libcurl.recompile_libcurl = recompile_libcurl;
install_libcurl.get_curl_package  = get_curl_package;

module.exports = install_libcurl;
