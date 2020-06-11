const path = require('path');

const log = require(path.resolve('modules', 'logutil.js'));
const logPre = log.logPre.modules.nav.pre;
log.consoleLogger.trace(`${logPre} loading`);

const config = require(path.resolve('modules', 'configutil.js'));
const authDb =  config.get(config.subject.auth, 'authdb');
const navHashname = config.get(config.subject.auth, 'navhashname');
const roleHashname = config.get(config.subject.auth, 'rolehashname');

const redis = require(path.resolve('modules', 'redisclientpool.js'));

function getNav(roleid, callback) {
    redis.moduleClient.hget(roleHashname, roleid, (err, role) => {
        if(err) {
            log.moduleLogger.error(`${logPre} err in get role from dbsvr ${err}`);
            callback(new Error('get role error'));
        } else if(role) {
            try {
                let roleObj = JSON.parse(role);
                callback(null ,roleObj.nav);   
            } catch(e) {    //impossible
                log.moduleLogger.warn(`${logPre} err in parse role of ${roleid} ${e}`);
                callback(new Error('parse role error'));
            }
        } else {
            log.moduleLogger.warn(`${logPre} role not found ${roleid}`);
            callback(null, false, { message: `role not found ${roleid}` });
        }
    });
}

function setNav(req, res, next) {
    const roleid = req.user.role;
    getNav(roleid, (err, res, message) => {
        if(err) {
            next(err);
        } else if(res) {
            req.session.nav = res;
            next();
        } else {
            next(new Error(message.message));
        }
    });
}

function pageNav(userNav, reqUrl) {
    let curMainNav = '';
    let curSubNav = '';
    const mainNav = {};
    const subNav = {};
    for(let nav of Object.keys(userNav)) {
        if(userNav[nav].url === reqUrl) {
            curMainNav = nav;
            curSubNav = '';
        }
        if(userNav[nav].child) {
            let child = userNav[nav].child;
            for(let sub of Object.keys(child)) {
                if(child[sub].url === reqUrl) {
                    curMainNav = nav;
                    curSubNav = sub;
                }
            }
        }
    }

    if(!curMainNav) {
        for(let nav of Object.keys(userNav)) {
            mainNav[userNav[nav].order] = { title: userNav[nav].title, url: userNav[nav].url };
        }
    } else if(curMainNav && !curSubNav) {
        for(let nav of Object.keys(userNav)) {
            if(nav === curMainNav) {
                mainNav[userNav[nav].order] = { title: userNav[nav].title, url: userNav[nav].url, active: true };
                if(userNav[nav].child) {
                    let child = userNav[nav].child;
                    for(let sub of Object.keys(child)) {
                        subNav[child[sub].order] = { title: child[sub].title, url: child.child[sub].url };
                    }
                }
            } else {
                mainNav[userNav[nav].order] = { title: userNav[nav].title, url: userNav[nav].url};
            }
        }
    } else {
        for(let nav of Object.keys(userNav)) {
            if(nav === curMainNav) {
                mainNav[userNav[nav].order] = { title: userNav[nav].title, url: userNav[nav].url, active: true };
                if(userNav[nav].child) {                    
                    let child = userNav[nav].child;
                    for(let sub of Object.keys(child)) {
                        if(sub === curSubNav) {
                            subNav[child[sub].order] = { title: child[sub].title, url: child[sub].url, active: true };
                        } else {
                            subNav[child[sub].order] = { title: child[sub].title, url: child[sub].url };
                        }
                    }
                }
            } else {
                mainNav[userNav[nav].order] = { title: userNav[nav].title, url: userNav[nav].url};
            }
        }
    }
    
    return { mainNav, subNav };
}

function navMid(req, res, next) {
    if(req.session.nav) {
        const userNav = pageNav(req.session.nav, req.originalUrl);
        req.session.pageNav = userNav;
    }
    next();
}

module.exports.getNav = getNav;
module.exports.setNav = setNav;
module.exports.navMid = navMid;

log.consoleLogger.trace(`${logPre} loaded`);