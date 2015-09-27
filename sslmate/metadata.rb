name              'sslmate'
maintainer        'FlagshipPromotions'
maintainer_email  'maintainer@flagshoppromotions.com'
license           'Unknown'
description       'Issues SSL certs using sslmate'
version           '0.0.2'
recipe            'sslmate', 'Issues SSL certs'
depends           'route53'

# https://supermarket.chef.io/cookbooks/yum
depends           'yum'
