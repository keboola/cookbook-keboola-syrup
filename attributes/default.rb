default['aws']['aws_access_key_id'] = ''
default['aws']['aws_secret_access_key'] = ''
default['aws']['region'] = 'us-east-1'

default['apache']['package'] = 'httpd24'

default['php']['packages'] = %w{ php56 php56-opcache php56-devel php-pear php56-pdo php56-mysqlnd php56-pgsql php56-mbstring php56-mcrypt php56-pecl-apcu }

default['newrelic']['php_agent']['config_file'] = "/etc/php-5.6.d/newrelic.ini"


default['keboola-syrup']['github_token'] = ''

default['sysctl']['params']['vm']['vfs_cache_pressure'] = 10000
default['sysctl']['params']['net']['ipv4']['ip_forward'] =  1

default['rsyslog']['max_message_size'] = '32k'

# newrelic APM
default['keboola-syrup']['enable_newrelic_apm'] = 0

# newrelic infra
default['newrelic_infra']['license_key'] = ''


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
default['keboola-syrup']['docker']['install_docker'] = 0
default['keboola-syrup']['docker']['container_stats_queue']['url'] = 'https://sqs.us-east-1.amazonaws.com/147946154733/syrup-container-stats'
default['keboola-syrup']['docker']['container_stats_queue']['region'] = 'us-east-1'

# Provisioning attributes
default['keboola-syrup']['provisioning']['workers_count'] = 0

# config bitbucket_id_rsa
default['keboola-syrup']['configs-bucket'] = 'keboola-configs'

default['keboola-syrup']['region'] = 'us-east-1'

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
      id: "oauth-v2",
      repository_name: "oauth-v2-bundle",
      source: "github",
      has_recipe: true
    },
    {
      id: "ex-getstat",
      repository_name: "getstat-extractor-bundle",
      source: "github"
    },
    {
      id: "wr-google-drive",
      repository_name: "google-drive-writer-bundle",
      source: "github"
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
        id: "ex-salesforce",
        repository_name: "ex-salesforce",
        source: "github",
        has_recipe: true
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
        source: "github",
        has_post_recipe: true
    },
    {
        id: "restbox",
        repository_name: "restbox-bundle"
    },
    {
        id: "rt-lucky-guess",
        repository_name: "luckyguess-bundle",
        source: "github",
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
