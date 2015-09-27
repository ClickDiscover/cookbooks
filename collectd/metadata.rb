name              'collectd'
maintainer        'FlagshipPromotions'
maintainer_email  'maintainer@flagshoppromotions.com'
license           'Unknown'
description       'Configures collectd'
version           '0.4.0'
recipe            'collectd', 'Installs and configures collectd'

# https://supermarket.chef.io/cookbooks/yum
depends           'yum'
