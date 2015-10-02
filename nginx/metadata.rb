name              'nginx'
maintainer        'FlagshipPromotions'
maintainer_email  'maintainer@flagshoppromotions.com'
license           'Unknown'
description       'Configures nginx'
version           '0.3.0'
recipe            'nginx', 'Configures nginx without SSL'
recipe            'nginx::ssl', 'Configures nginx with SSL'

# http://supermarket.chef.io/cookbooks/yum
depends           'yum'
depends           'route53'
depends           'sslmate'
