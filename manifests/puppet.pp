class repo::puppet($enabled) {

    if $enabled == true {

        # Install the repo based on our EL version
        case $operatingsystem {
            'CentOS', 'Scientific': {
                case $operatingsystemrelease {

                    # EL5
                    /^5.*/: {
                        file {
                            "/etc/yum.repos.d/puppet.repo":
                                mode    => 0644,
                                owner   => 'root',
                                group   => 'root',
                                source  => 'puppet:///modules/repo/puppet-EL5-x86_64.repo';
                        }
                    }

                    # EL6
                    /^6.*/: {
                        file {
                            "/etc/yum.repos.d/puppet.repo":
                                mode    => 0644,
                                owner   => 'root',
                                group   => 'root',
                                source  => 'puppet:///modules/repo/puppet-EL6-x86_64.repo';
                        }
                    }
                }
            }
        }
    }
}
