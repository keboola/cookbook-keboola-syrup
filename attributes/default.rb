default['aws']['aws_access_key_id'] = ''
default['aws']['aws_secret_access_key'] = ''


default['php']['packages'] = %w{ php56 php56-opcache php56-devel php-pear php56-pdo php56-mysqlnd php56-pgsql php56-mbstring php56-mcrypt php56-pecl-apcu }

default['newrelic']['php_agent']['config_file'] = "/etc/php-5.6.d/newrelic.ini"


default['keboola-syrup']['github_token'] = ''

default['datadog']['api_token'] = ''

default['sysctl']['params']['vm']['vfs_cache_pressure'] = 10000

default['rsyslog']['max_message_size'] = '32k'

# newrelic APM
default['keboola-syrup']['enable_newrelic_apm'] = 0

# Docker monitoring
default['keboola-syrup']['enable_docker_monitoring'] = 0

# GoodData Writer attributes
default['keboola-syrup']['gooddata-writer']['enable_cron'] = 0
default['keboola-syrup']['gooddata-writer']['workers_count'] = 0

# Syrup queue attributes
default['keboola-syrup']['queue']['workers_count'] = 0

# Orchestrator attributes
default['keboola-syrup']['orchestrator']['workers_count'] = 0
default['keboola-syrup']['orchestrator']['enable_scheduler'] = 0
default['keboola-syrup']['orchestrator']['enable_watchdog'] = 0

# Transformation attributes
default['keboola-syrup']['transformation']['workers_count'] = 0

# Docker attributes
default['keboola-syrup']['docker']['workers_count'] = 0
default['keboola-syrup']['docker']['data_device'] = "/dev/md1"

# install only listed components if not empty
default['keboola-syrup']['install-components'] = []

default['keboola-syrup']['components'] = [
    {
      id: "oauth",
      repository_name: "oauth-bundle",
      source: "github",
      has_recipe: true
    },
    {
      id: "ex-linkdex",
      repository_name: "linkdex-extractor-bundle",
      source: "github"
    },
    {
      id: "ex-getstat",
      repository_name: "getstat-extractor-bundle",
      source: "github"
    },
    {
      id: "wr-google-drive",
      repository_name: "google-drive-wirter-bundle"
    },
    {
      id: "ex-fb-ads",
      repository_name: "facebookads-extractor-bundle",
      source: "github"
    },
    {
        id: "ex-db",
        repository_name: "db-extractor-bundle",
        source: "github",
        has_recipe: true
    },
    {
        id: "ex-mandrill",
        repository_name: "mandrill-extractor-bundle",
        source: "github"
    },
    {
        id: "ex-generic",
        repository_name: "generic-extractor-bundle"
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
        repository_name: "adwords-extractor",
        source: "github",
        has_recipe: true
    },
    {
         id: "ex-sklik",
         repository_name: "sklik-extractor",
         source: "github"
    },
    {
        id: "ex-currency",
        repository_name: "currency-bundle"
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
        source: "github"
    },
    {
        id: "ex-google-analytics",
        repository_name: "google-analytics-bundle",
        source: "github"
    },
    {
        id: "ex-google-drive",
        repository_name: "google-drive-bundle",
        source: "github"
    },
    {
        id: "ex-youtube",
        repository_name: "youtube-extractor-bundle",
        source: "github"
    },
    {
        id: "ex-instagram",
        repository_name: "instagram-extractor-bundle"
    },
    {
        id: "ex-marketo",
        repository_name: "marketo-extractor-bundle",
        has_recipe: true
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
        id: "pigeon",
        repository_name: "mailimport-bundle",
        bundle_install: false
    },
    {
        id: "ex-google-bigquery",
        repository_name: "google-bigquery-bundle"
    },
    {
        id: "provisioning",
        repository_name: "provisioning-bundle",
        source: "github"        
    },
    {
        id: "restbox",
        repository_name: "restbox-bundle"
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
        id: "wr-db",
        repository_name: "db-writer-bundle",
        source: "github"
    },
    {
        id: "wr-elasticsearch",
        repository_name: "elasticsearch-writer-bundle"
    },
    {
      id: "ex-magento",
      repository_name: "magento-extractor-bundle",
      source: "github"
    },
    {
      id: "shiny",
      repository_name: "shiny-bundle",
      has_recipe: true
    },
    {
        id: "shinyapps",
        repository_name: "shinyapps-bundle"
    },
    {
        id: "queue",
        repository_name: "syrup-queue",
        source: "github",
        bundle_install: false,
        has_recipe: true,
        has_post_recipe: true
    },
    {
        id: "orchestrator",
        repository_name: "orchestrator-bundle",
        source: "github",
        bundle_install: false,
        has_recipe: true,
        has_post_recipe: true
    },
    {
      id: "docker",
      repository_name: "docker-bundle",
      source: "github",
      has_recipe: true,
      has_post_recipe: true
    },
    {
        id: "transformation",
        repository_name: "transformation-bundle",
        source: "github",
        has_recipe: true
    },
    {
        id: "gooddata-writer",
        repository_name: "gooddata-writer",
        source: "github",
        has_recipe: true,
        has_post_recipe: true
    }
]

default['keboola-syrup']['components-broken'] = [

]
