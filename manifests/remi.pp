# Class repo::remi
#
# Actions:
#   Configure the proper repositories and import GPG keys
#
# Reqiures:
#   You should probably be on an Enterprise Linux variant. (Centos, RHEL, Scientific, Oracle, Ascendos, et al)
#
# Sample Usage:
#  include repo::remi
#
class repo::remi (
    $enabled    = true,
    $gpgkey     = 'RPM-GPG-KEY-remi',
    $repo       = 'remi.repo',
) {
    # Install the repo based on our EL version
    case $operatingsystem {
        'CentOS', 'Scientific': {
            case $operatingsystemrelease {

                # EL6
                /^6.*/: {
                    validate_bool($enabled)
                    if $enabled == true {
                        $enable = 1
                    } else {
                        $enable = 0
                    }
                    # Manage repo
                    yumrepo { 'remi.repo':
                        name        => 'remi',
                    #    baseurl     => 'http://rpms.famillecollet.com/enterprise/$releasever/remi/$basearch/',
                        mirrorlist  => 'http://rpms.famillecollet.com/enterprise/$releasever/remi/mirror',
                        enabled     => $enable,
                        gpgcheck    => 0,
                        gpgkey      => "file:///etc/pki/rpm-gpg/${gpgkey}",
                        descr       => 'Les RPM de remi pour Enterprise Linux $releasever - $basearch',
                        require     => [
                            File[$gpgkey],
                            File[$repo],
                            Yumrepo['epel.repo'],
                        ],
                    }
                    file { $repo:
                        replace     => false,
                        ensure      => "present",
                        path        => "/etc/yum.repos.d/${repo}",
                        mode        => 0644,
                        owner       => 'root',
                        group       => 'root',
                        source      => 'puppet:///modules/repo/remi-EL6-x86_64.repo',
                    }
                    file { $gpgkey:
                        replace     => false,
                        ensure      => "present",
                        path        => "/etc/pki/rpm-gpg/${gpgkey}",
                        mode        => 0644,
                        owner       => 'root',
                        group       => 'root',
                        source      => "puppet:///modules/repo/${gpgkey}",
                    }
                    # Import gpgkey
                    #repo::gpgkey{ 'remi':
                    #    path        => "/etc/pki/rpm-gpg/${gpgkey}",
                    #}
                }
            }
        }
    }
}
