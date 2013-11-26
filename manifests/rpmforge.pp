# Class repo::rpmforge
#
# Actions:
#   Configure the proper repositories and import GPG keys
#
# Reqiures:
#   You should probably be on an Enterprise Linux variant. (Centos, RHEL, Scientific, Oracle, Ascendos, et al)
#
# Sample Usage:
#  include repo::rpmforge
#
class repo::rpmforge (
    $enabled    = true,
    $gpgkey     = 'RPM-GPG-KEY-rpmforge-dag',
    $repo       = 'rpmforge.repo',
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
                    yumrepo { 'rpmforge.repo':
                        name        => 'rpmforge',
                        baseurl     => 'http://apt.sw.be/redhat/el6/en/$basearch/rpmforge',
                        mirrorlist  => 'http://apt.sw.be/redhat/el6/en/mirrors-rpmforge',
                        enabled     => $enable,
                        gpgcheck    => 1,
                        descr       => 'RHEL $releasever - RPMforge.net - dag',
                        gpgkey      => "file:///etc/pki/rpm-gpg/${gpgkey}",
                        require     => [
                            File[$gpgkey],
                            File[$repo],
                        ]
                    }
                    file { $repo:
                        replace     => false,
                        ensure      => "present",
                        path        => "/etc/yum.repos.d/${repo}",
                        mode        => 0644,
                        owner       => 'root',
                        group       => 'root',
                        source      => 'puppet:///modules/repo/rpmforge-EL6-x86_64.repo';
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
                    repo::gpgkey{ "rpgmforge-dag":
                        path => "/etc/pki/rpm-gpg/${gpgkey}"
                    }
                }
            }
        }
    }
}
