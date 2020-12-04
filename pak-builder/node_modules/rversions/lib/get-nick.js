
const urls = require('./urls');

const got = require('got');

let cached = {
  '0.60': null,
  '0.61': null,
  '0.61.1': null,
  '0.61.2': null,
  '0.61.3': null,
  '0.62': null,
  '0.62.1': null,
  '0.62.2': null,
  '0.62.3': null,
  '0.62.4': null,
  '0.63': null,
  '0.63.1': null,
  '0.63.2': null,
  '0.63.3': null,
  '0.64': null,
  '0.64.1': null,
  '0.64.2': null,
  '0.65': null,
  '0.65.1': null,
  '0.90': null,
  '0.90.1': null,
  '0.99': null,
  '1.0': null,
  '1.0.1': null,
  '1.1': null,
  '1.1.1': null,
  '1.2': null,
  '1.2.1': null,
  '1.2.2': null,
  '1.2.3': null,
  '1.3': null,
  '1.3.1': null,
  '1.4': null,
  '1.4.1': null,
  '1.5.0': null,
  '1.5.1': null,
  '1.6.0': null,
  '1.6.1': null,
  '1.6.2': null,
  '1.7.0': null,
  '1.7.1': null,
  '1.8.0': null,
  '1.8.1': null,
  '1.9.0': null,
  '1.9.1': null,
  '2.0.0': null,
  '2.0.1': null,
  '2.1.0': null,
  '2.1.1': null,
  '2.2.0': null,
  '2.2.1': null,
  '2.3.0': null,
  '2.3.1': null,
  '2.4.0': null,
  '2.4.1': null,
  '2.5.0': null,
  '2.5.1': null,
  '2.6.0': null,
  '2.6.1': null,
  '2.6.2': null,
  '2.7.0': null,
  '2.7.1': null,
  '2.7.2': null,
  '2.8.0': null,
  '2.8.1': null,
  '2.9.0': null,
  '2.9.1': null,
  '2.9.2': null,
  '2.10.0': null,
  '2.10.1': null,
  '2.11.0': null,
  '2.11.1': null,
  '2.12.0': null,
  '2.12.1': null,
  '2.12.2': null,
  '2.13.0': null,
  '2.13.1': null,
  '2.13.2': null,
  '2.14.0': 'Great Pumpkin',
  '2.14.1': 'December Snowflakes',
  '2.14.2': 'Gift-Getting Season',
  '2.15.0': 'Easter Beagle',
  '2.15.1': 'Roasted Marshmallows',
  '2.15.2': 'Trick or Treat',
  '2.15.3': 'Security Blanket',
  '3.0.0': 'Masked Marvel',
  '3.0.1': 'Good Sport',
  '3.0.2': 'Frisbee Sailing',
  '3.0.3': 'Warm Puppy',
  '3.1.0': 'Spring Dance',
  '3.1.1': 'Sock it to Me',
  '3.1.2': 'Pumpkin Helmet',
  '3.1.3': 'Smooth Sidewalk',
  '3.2.0': 'Full of Ingredients',
  '3.2.1': 'World-Famous Astronaut',
  '3.2.2': 'Fire Safety',
  '3.2.3': 'Wooden Christmas-Tree',
  '3.2.4': 'Very Secure Dishes',
  '3.2.5': 'Very, Very Secure Dishes',
  '3.3.0': 'Supposedly Educational',
  '3.3.1': 'Bug in Your Hair',
  '3.3.2': 'Sincere Pumpkin Patch',
  '3.3.3': 'Another Canoe',
  '3.4.0': 'You Stupid Darkness',
  '3.4.1': 'Single Candle',
  '3.4.2': 'Short Summer',
  '3.4.3': 'Kite-Eating Tree',
  '3.4.4': 'Someone to Lean On',
  '3.5.0': 'Joy in Playing',
  '3.5.1': 'Feather Spray',
  '3.5.2': 'Eggshell Igloo',
  '3.5.3': 'Great Truth',
  '3.6.0': 'Planting of a Tree',
  '3.6.1': 'Action of the Toes',
  '3.6.2': 'Dark and Stormy Night',
  '3.6.3': 'Holding the Windsock'
}

async function get_nick(version) {
    let nick = cached[version];
    if (nick !== undefined) { return nick; }
    nick = await download_nick(version);
    cached[version] = nick;
    return nick;
}

async function download_nick(version) {    
    const nick_url = urls.nick.replace('%s', version.replace(/\./g, '-'));
    const resp = await got(nick_url);
    return resp.body.trim();
}

module.exports = get_nick;

if (process.env['NODE_ENV'] === 'test') {
    get_nick.internals = {
        cached: cached,
        get_nick: get_nick,
        download_nick : download_nick
    };
}
