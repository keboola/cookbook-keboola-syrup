default['aws']['aws_access_key_id'] = ''
default['aws']['aws_secret_access_key'] = ''


default['php']['packages'] = %w{ php54 php54-devel php-pear php54-pdo php54-mysql php54-mbstring php54-pgsql php54-mcrypt php54-pecl-apc }

default['newrelic']['php_agent']['config_file'] = "/etc/php.d/newrelic.ini"


default['keboola-syrup']['github_token'] = ''

default['sysctl']['params']['vm']['vfs_cache_pressure'] = 10000


# GoodData Writer attributes
default['keboola-syrup']['gooddata-writer']['enable_cron'] = 0
default['keboola-syrup']['gooddata-writer']['workers_count'] = 0

# Syrup queue attributes
default['keboola-syrup']['queue']['workers_count'] = 0

# Orchestrator attributes
default['keboola-syrup']['orchestrator']['workers_count'] = 0
default['keboola-syrup']['orchestrator']['enable_scheduler'] = 0

# Transformation attributes
default['keboola-syrup']['transformation']['workers_count'] = 0

default['keboola-syrup']['components'] = [
    {
        id: "ex-mandrill",
        repository_name: "mandrill-extractor-bundle",
        source: "github"
    },
    {
        id: "ex-youtube",
        repository_name: "youtube-extractor-bundle",
        source: "github"
    },
    {
        id: "ex-generic",
        repository_name: "generic-extractor-bundle"
    },
    {
        id: "transformation",
        repository_name: "transformation-bundle",
        source: "github",
        has_recipe: true
    },
    {
        id: "ex-facebook",
        repository_name: "ex-facebook-bundle",
        source: "github"
    },
    {
        id: "table-importer",
        repository_name: "sapi-table-importer",
        source: "github"
    },
    {
        id: "ag-geocoding",
        repository_name: "geocoding-augmentation",
        source: "github"
    },
    {
        id: "ex-appannie",
        repository_name: "appannie-extractor-bundle"
    },
    {
        id: "ex-salesforce",
        repository_name: "ex-salesforce",
        source: "github"
    },
    {
        id: "ex-adwords",
        repository_name: "adwords-extractor-bundle",
        has_recipe: true
    },
    {
        id: "ex-cloudsearch",
        repository_name: "cloudsearch-extractor"
    },
    {
        id: "ex-currency",
        repository_name: "currency-bundle"
    },
    {
        id: "ex-db",
        repository_name: "db-extractor-bundle",
        has_recipe: true
    },
    {
        id: "ex-doubleclick",
        repository_name: "doubleclick-extractor-bundle"
    },
    {
        id: "ex-elasticsearch",
        repository_name: "elasticsearch-extractor-bundle"
    },
    {
        id: "ag-forecastio",
        repository_name: "forecastio-augmentation",
        bundle_install: false,
        source: "github"
    },
    {
        id: "ex-gooddata",
        repository_name: "gooddata-extractor-bundle",
        bundle_install: false
    },
    {
        id: "ex-google-analytics",
        repository_name: "google-analytics-bundle"
    },
    {
        id: "ex-google-drive",
        repository_name: "google-drive-bundle",
        bundle_install: false
    },
    {
        id: "ex-google-youtube",
        repository_name: "google-youtube-bundle"
    },
    {
        id: "ex-instagram",
        repository_name: "instagram-extractor-bundle"
    },
    {
        id: "ex-mailchimp",
        repository_name: "mailchimp-extractor-bundle"
    },
    {
        id: "ex-marketo",
        repository_name: "marketo-extractor-bundle",
        has_recipe: true
    },
    {
        id: "ex-ooyala",
        repository_name: "ooyala-extractor-bundle"
    },
    {
        id: "ex-pingdom",
        repository_name: "keboola-pingdom-bundle"
    },
    {
        id: "ex-recurly",
        repository_name: "recurly-bundle"
    },
    {
        id: "ex-sklik",
        repository_name: "sklik-extractor-bundle"
    },
    {
        id: "ex-telfa",
        repository_name: "telfa-extractor-bundle"
    },
    {
        id: "ex-twitter",
        repository_name: "twitter-extractor-bundle",
        has_recipe: true
    },
    {
        id: "ex-zendesk",
        repository_name: "zendesk-extractor-bundle"
    },
    {
        id: "gooddata-writer",
        repository_name: "gooddata-writer",
        bundle_install: true,
        has_recipe: true
    },
    {
        id: "orchestrator",
        repository_name: "orchestrator-bundle",
        bundle_install: false,
        has_recipe: true
    },
    {
        id: "pigeon",
        repository_name: "mailimport-bundle",
        bundle_install: false
    },
    {
        id: "provisioning",
        repository_name: "keboola-provisioning-bundle"
    },
    {
        id: "queue",
        repository_name: "syrup-queue-bundle",
        bundle_install: false,
        has_recipe: true
    },
    {
        id: "restbox",
        repository_name: "restbox-bundle"
    },
    {
        id: "rt-hierarchy",
        repository_name: "hierarchy-bundle"
    },
    {
        id: "rt-json",
        repository_name: "jsonparser-bundle"
    },
    {
        id: "rt-lucky-guess",
        repository_name: "luckyguess-bundle",
        bundle_install: false
    },
    {
        id: "rt-split",
        repository_name: "textsplitter-bundle",
        bundle_install: false
    },
    {
        id: "sapi-importer",
        repository_name: "sapi-importer-bundle"
    },
    {
        id: "timeout",
        repository_name: "timeout-bundle"
    },
    {
        id: "wr-cloudsearch",
        repository_name: "cloudsearch-writer"
    },
    {
        id: "wr-db",
        repository_name: "db-writer-bundle"
    },
    {
        id: "rt-lucky-guess-r",
        repository_name: "luckyguess-r-bundle",
        bundle_install: false,
        has_recipe: true
    },
    {
        id: "wr-elasticsearch",
        repository_name: "elasticsearch-writer-bundle"
    },
    {
        id: "wr-iot",
        repository_name: "iot-writer-bundle",
        bundle_install: false
    },
    {
      id: "docker",
      repository_name: "docker-bundle",
      source: "github"
    }
]

default['keboola-syrup']['components-broken'] = [

]
