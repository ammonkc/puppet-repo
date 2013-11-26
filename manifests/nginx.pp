class repo::nginx($enabled) {

    if $enabled == true {

        # Install the repo based on our EL version
        case $operatingsystem {
            'CentOS', 'Scientific': {
                case $operatingsystemrelease {

                    # EL6
                    /^6.*/: {
                        file {
                            "/etc/yum.repos.d/nginx.repo":
                                mode    => 0644,
                                owner   => 'root',
                                group   => 'root',
                                source  => 'puppet:///modules/repo/nginx-EL6-x86_64.repo';
                        }
                    }
                }
            }
        }
    }
}
