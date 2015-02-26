Settings = require('settings-sharelatex')
logger = require("logger-sharelatex")
ldap = require('ldapjs')

module.exports = 
	authDN: (body, callback)->
		found = false
		if (!Settings.ldap)
			callback null, true
		else
			if (Settings.ldap.anonymous)
				lclient = ldap.createClient({ url: Settings.ldap.host })
			else
				lclient = ldap.createClient({ url: Settings.ldap.host, maxConnections: 10, bindDN: Settings.ldap.bindDN, bindCredentials: Settings.ldap.bindCredentials	})

			filter = "(cn=" + body.email + ")"
			opts = { filter: filter, scope: 'sub' }
			
			lclient.search Settings.ldap.base, opts, (err, res)->
				res.on 'searchEntry', (entry)->
					found = true
					lclient.bind entry.object['dn'], body.password, (err)->
						body.email = entry.object[Settings.ldap.emailAttr].toLowerCase()
						body.password = entry.object[Settings.ldap.dnObj]
						callback err, err == null
				res.on 'error', (err)->
					callback err, err == null
				res.on 'end', (err)->
					if (found == false)
						callback result, found
					
