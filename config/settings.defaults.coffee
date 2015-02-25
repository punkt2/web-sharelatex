Path = require('path')
http = require('http')
http.globalAgent.maxSockets = 300

# Make time interval config easier.
seconds = 1000
minutes = 60 * seconds

# These credentials are used for authenticating api requests
# between services that may need to go over public channels
httpAuthUser = "sharelatex"
httpAuthPass = "password"
httpAuthUsers = {}
httpAuthUsers[httpAuthUser] = httpAuthPass

sessionSecret = "secret-please-change"

module.exports =
	# File storage
	# ------------
	#
	# ShareLaTeX stores binary files like images in S3.
	# Fill in your Amazon S3 credential below.
	s3:
		key: ""
		secret: ""
		bucketName : ""


	# Databases
	# ---------
	mongo:
		url : 'mongodb://127.0.0.1/sharelatex'

	redis:
		web:
			host: "localhost"
			port: "6379"
			password: ""

		api:
			host: "localhost"
			port: "6379"
			password: ""

	# Service locations
	# -----------------

	# Configure which ports to run each service on. Generally you
	# can leave these as they are unless you have some other services
	# running which conflict, or want to run the web process on port 80.
	internal:
		web:
			port: webPort = 3000
			host: "0.0.0.0"
		documentupdater:
			port: docUpdaterPort = 3003

	# Tell each service where to find the other services. If everything
	# is running locally then this is easy, but they exist as separate config
	# options incase you want to run some services on remote hosts.
	apis:
		web:
			url: "http://localhost:#{webPort}"
			user: httpAuthUser
			pass: httpAuthPass
		documentupdater:
			url : "http://localhost:#{docUpdaterPort}"
		thirdPartyDataStore:
			url : "http://localhost:3002"
			emptyProjectFlushDelayMiliseconds: 5 * seconds
		tags:
			url :"http://localhost:3012"
		spelling:
			url : "http://localhost:3005"
		trackchanges:
			url : "http://localhost:3015"
		docstore:
			url : "http://localhost:3016"
			pubUrl: "http://localhost:3016"
		chat:
			url: "http://localhost:3010"
			internal_url: "http://localhost:3010"
		blog:
			port: 3008
		university:
			url: "http://localhost:3011"
		filestore:
			url: "http://localhost:3009"
		clsi:
			url: "http://localhost:3013"
		clsi_priority:
			url: "http://localhost:3013"
		templates:
			url: "http://localhost:3007"
		githubSync:
			url: "http://localhost:3022"
		recurly:
			privateKey: ""
			apiKey: ""
			subdomain: ""
		geoIpLookup:
			url: "http://localhost:8080/json"
			
	templates:
		user_id: process.env.TEMPLATES_USER_ID or "5395eb7aad1f29a88756c7f2"
		
	# The websocket layer of ShareLaTeX runs as separate service.
	# When running locally or in development, you can point the client to this
	# service directly. If you are running behind a reverse proxy (Nginx, etc)
	# then websocketsUrl should be the same as siteUrl, with your reverse
	# proxy responible for sending websocket traffic to the websocket service
	# rather than connecting directly.
	websocketsUrl: "http://localhost:3026"

	# Where your instance of ShareLaTeX can be found publically. Used in emails
	# that are sent out, generated links, etc.
	siteUrl : siteUrl = 'http://localhost:3000'

	# cookie domain
	# use full domain for cookies to only be accesabble from that domain,
	# replace subdomain with dot to have them accessable on all subdomains
	# cookieDomain: ".sharelatex.dev"
	cookieName:"sharelatex.sid"

	# Same, but with http auth credentials.
	httpAuthSiteUrl: 'http://#{httpAuthUser}:#{httpAuthPass}@localhost:3000'

	# Security
	# --------
	security:
		sessionSecret: sessionSecret

	# ldap configuration
	# Anonymous ldap use search for authentication
	# Otherwise use bind for authentication
	#ldap: 
	#	host: 'ldap://ldap.host.com:389'
	#	dnObj: 'cn'
	#   	base: 'dc=example,dc=com'
	#   	bindDN: 'cn=user,ou=Users,dc=ipp,dc=mpg,dc=de'
	#   	bindCredentials: 'pass'
	#	emailAtt: 'mail'
	#	failMessage: 'LDAP User Fail'
	#	fieldName: 'LDAP User'
	#	placeholder: 'LDAP User ID'

	httpAuthUsers: httpAuthUsers

	# Default features
	# ----------------
	#
	# You can select the features that are enabled by default for new
	# new users.
	defaultFeatures: defaultFeatures =
		collaborators: -1
		dropbox: true
		versioning: true
		compileTimeout: 60
		compileGroup: "standard"

	plans: plans = [{
		planCode: "personal"
		name: "Personal"
		price: 0
		features: defaultFeatures
	}]

	# i18n
	# ------
	# 
	i18n:
		subdomainLang:
			www: {lngCode:"en", url: siteUrl}
		defaultLng: "en"

	# Spelling languages
	# ------------------
	#
	# You must have the corresponding aspell package installed to 
	# be able to use a language.
	languages: [
		{name: "English", code: "en"},
		{name: "French", code: "fr"}
	]

	# Email support
	# -------------
	#
	#	ShareLaTeX uses nodemailer (http://www.nodemailer.com/) to send transactional emails.
	#	To see the range of transport and options they support, see http://www.nodemailer.com/docs/transports
	#email:
	#	fromAddress: ""
	#	replyTo: ""
	#	lifecycle: false
	## Example transport and parameter settings for Amazon SES
	#	transport: "SES"
	#	parameters:
	#		AWSAccessKeyID: ""
	#		AWSSecretKey: ""


	# Third party services
	# --------------------
	#
	# ShareLaTeX's regular newsletter is managed by Markdown mail. Add your
	# credentials here to integrate with this.
	# markdownmail:
	# 	secret: ""
	# 	list_id: ""
	#
	# Fill in your unique token from various analytics services to enable
	# them.
	# analytics:
	# 	ga:
	# 		token: ""
	# 
	# ShareLaTeX's help desk is provided by tenderapp.com
	# tenderUrl: ""
	#
	# Client-side error logging is provided by getsentry.com
	# sentry:
	#   src: ""
	#   publicDSN: ""
	#
	# src should be either a remote url like
	#    //cdn.ravenjs.com/1.1.16/jquery,native/raven.min.js
	# or a local file in the js/libs directory.
	# The publicDSN is the token for the client-side getSentry service.

	# Production Settings
	# -------------------

	# Should javascript assets be served minified or not. Note that you will
	# need to run `grunt compile:minify` within the web-sharelatex directory
	# to generate these.
	useMinifiedJs: false

	# Should static assets be sent with a header to tell the browser to cache
	# them.
	cacheStaticAssets: false

	# If you are running ShareLaTeX over https, set this to true to send the
	# cookie with a secure flag (recommended).
	secureCookie: false

	# If you are running ShareLaTeX behind a proxy (like Apache, Nginx, etc)
	# then set this to true to allow it to correctly detect the forwarded IP
	# address and http/https protocol information.
	behindProxy: false

	# Internal configs
	# ----------------
	path:
		# If we ever need to write something to disk (e.g. incoming requests
		# that need processing but may be too big for memory, then write
		# them to disk here).
		dumpFolder: Path.resolve __dirname + "/../data/dumpFolder"
		uploadFolder: Path.resolve __dirname + "/../data/uploads"
	
	# Automatic Snapshots
	# -------------------
	automaticSnapshots:
		# How long should we wait after the user last edited to 
		# take a snapshot?
		waitTimeAfterLastEdit: 5 * minutes
		# Even if edits are still taking place, this is maximum
		# time to wait before taking another snapshot.
		maxTimeBetweenSnapshots: 30 * minutes

	# Smoke test
	# ----------
	# Provide log in credentials and a project to be able to run
	# some basic smoke tests to check the core functionality.
	#
	# smokeTest:
	# 	user: ""
	# 	password: ""
	# 	projectId: ""

	nav:
		title: "ShareLaTeX Community Edition"
		
		left_footer: [{
			text: "Powered by <a href='https://www.sharelatex.com'>ShareLaTeX</a> © 2014"
		}]

		right_footer: [{
			text: "<i class='fa fa-github-square'></i> Fork on Github!"
			url: "https://github.com/sharelatex/sharelatex"
		}]

		header: [{
	#		text: "Register"
	#		url: "/register"
	#		only_when_logged_out: true
	#	}, {
			text: "Log In"
			url: "/register"
			only_when_logged_out: true
		}, {
			text: "Projects"
			url: "/project"
			only_when_logged_in: true
		}, {
			text: "Account"
			only_when_logged_in: true
			dropdown: [{
				text: "Account Settings"
				url: "/user/settings"
			}, {
				divider: true
			}, {
				text: "Log out"
				url: "/logout"
			}]
		}]
	
#	templates: [{
#		name : "cv_or_resume",
#		url : "/templates/cv"
#	}, {
#		name : "cover_letter",
#		url : "/templates/cover-letters"
#	}, {
#		name : "journal_article",
#		url : "/templates/journals"
#	}, {
#		name : "presentation",
#		url : "/templates/presentations"
#	}, {
#		name : "thesis",
#		url : "/templates/thesis"
#	}, {
#		name : "bibliographies",
#		url : "/templates/bibliographies"
#	}, {
#		name : "view_all",
#		url : "/templates"
#	}]


	redirects:
		"/templates/index": "/templates/"

	proxyUrls: {}
	
	reloadModuleViewsOnEachRequest: true
