const replace = require('gulp-replace');
const { src, dest, watch, series } = require('gulp');
const zip = require('gulp-zip');
const fs = require('fs');
const argv = require('yargs').argv;

function build() {

    const { version, addonVersion } = require('./package.json');
    let esoPath = 'live';

    if( argv.pts ) {
        esoPath = 'pts';
    }

    return src('src/**')
        .pipe(replace('{{VERSION}}', version))
        .pipe(replace('{{ADDONVERSION}}', addonVersion))
        .pipe(replace('{{LOGGING}}', 'true'))
        .pipe(dest(`../../Elder Scrolls Online/${esoPath}/AddOns/ITTsDonationBot`));
}

function deploy() {

    const { name, version, addonVersion } = require('./package.json');

    return src('src/**')
        .pipe(replace('{{VERSION}}', version))
        .pipe(replace('{{ADDONVERSION}}', addonVersion))
        .pipe(replace('{{LOGGING}}', 'false'))
        .pipe(dest(`../releases/${name}/${name}`))
}

function zipBuild(){
    const { name, version } = require('./package.json');
    const zipName = `${name}@${version}.zip`;

    return src([`../releases/${name}/${name}/**/*`], { base:`../releases/${name}`})
        .pipe(zip(zipName))
        .pipe(dest(`../releases/${name}`));
}

function clean(cb) {
    const { name, version, addonVersion } = require('./package.json');
    fs.rmSync(`../releases/${name}/${name}`, { recursive: true, force: true });
    cb();
}

exports.deploy = series(deploy,zipBuild,clean)
exports.watch = function() { 

    if( argv.pts ) {
        console.log('\x1b[33mStreaming to ESO PTS enviornment\x1b[0m');
    } else {
        console.log('\x1b[33mStreaming to ESO LIVE enviornment\x1b[0m');
    }

    watch('src/**', series(build))
}

