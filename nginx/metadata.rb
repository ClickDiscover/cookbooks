name              'nginx'
maintainer        'FlagshipPromotions'
maintainer_email  'maintainer@flagshoppromotions.com'
license           'Unknown'
description       'Configures nginx'
version           '0.2.0'
recipe            'nginx', 'Configures nginx'
depends           'route53', 'sslmate'
