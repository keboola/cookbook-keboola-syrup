name             'keboola-syrup'
maintainer       'YOUR_COMPANY_NAME'
maintainer_email 'YOUR_EMAIL'
license          'All rights reserved'
description      'Installs/Configures syrup'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

depends 'aws', '~> 2.4.0'
depends 'keboola-php'
depends 'keboola-common'
depends 'keboola-apache2'