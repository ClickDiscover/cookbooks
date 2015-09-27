name              'php-fpm'
maintainer        'FlagshipPromotions'
maintainer_email  'maintainer@flagshoppromotions.com'
license           'Unknown'
description       'Configures PHP-FPM'
version           '0.8'
recipe            'php-fpm', 'Configures PHP-FPM'
recipe            'php-fpm::collectd', 'Configures collectd for PHP-FPM'
depends           'collectd'

# https://supermarket.chef.io/cookbooks/yum
depends           'yum'
