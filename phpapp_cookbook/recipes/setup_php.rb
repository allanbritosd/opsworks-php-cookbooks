node.override['apache']['version'] = '2.4'

node.override['php']['directives'] = {
  'date.timezone' => 'UTC',
  'upload_tmp_dir' => '/tmp',
  'display_errors' => 'Off',
  'memory_limit' => '128M',
  'post_max_size' => '16M',
  'output_buffering' => 'On',
  'short_open_tag' => 'On',
  'session.save_path' => '/tmp',
  'error_log' => '/var/log/php_errors.log',
  'max_input_vars' => '10000',
  'opcache.fast_shutdown' => '0',
  'upload_max_filesize' => '12M'
}

case node[:platform]
  when 'rhel', 'fedora', 'suse', 'centos'
    node.override['php']['packages'] = ['php70w', 'php70w-devel', 'php70w-cli', 'php70w-bcmath', 'php70w-snmp', 'php70w-soap', 'php70w-xml', 'php70w-xmlrpc', 'php70w-process', 'php70w-mysqlnd', 'php70w-opcache', 'php70w-pdo', 'php70w-imap', 'php70w-mbstring', 'php70w-intl', 'php70w-mcrypt', 'php70w-gd']

    # add the EPEL repo
    yum_repository 'epel' do
      description 'Extra Packages for Enterprise Linux'
      mirrorlist 'http://mirrors.fedoraproject.org/mirrorlist?repo=epel-7&arch=x86_64'
      gpgkey 'http://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-7'
      action :create
    end

    # add the webtatic repo
    yum_repository 'webtatic' do
      description 'webtatic Project'
      mirrorlist 'http://repo.webtatic.com/yum/el7/x86_64/mirrorlist'
      gpgkey 'http://repo.webtatic.com/yum/RPM-GPG-KEY-webtatic-el7'
      action :create
    end

    include_recipe "php::package"
    include_recipe "php::ini"
    include_recipe "apache2::default"
    include_recipe "apache2::mod_rewrite"

 when 'amazon'
    node.override['php']['packages'] = ['php70', 'php70-devel', 'php70-cli', 'php70-bcmath', 'php70-snmp', 'php70-soap', 'php70-xml', 'php70-xmlrpc', 'php70-process', 'php70-mysqlnd', 'php70-opcache', 'php70-pdo', 'php70-imap', 'php70-mbstring', 'php70-intl', 'php70-mcrypt', 'php70-gd']

    include_recipe "php::package"
    include_recipe "php::ini"
    include_recipe "apache2::default"
    include_recipe "apache2::mod_rewrite"

    end

include_recipe "build-essential"