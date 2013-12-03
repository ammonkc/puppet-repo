# Class repo::epel
#
# Actions:
#   Configure the proper repositories and import GPG keys
#
# Reqiures:
#   You should probably be on an Enterprise Linux variant. (Centos, RHEL, Scientific, Oracle, Ascendos, et al)
#
# Sample Usage:
#  include repo::epel
#
class repo::epel (
    $enabled    = true,
    $gpgkey     = "RPM-GPG-KEY-EPEL-6",
    $repo       = "epel.repo",
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
                    # manage repo
                    yumrepo { 'epel':
                        name        => 'epel',
                        baseurl     => 'http://download.fedoraproject.org/pub/epel/6/$basearch',
                        mirrorlist  => 'https://mirrors.fedoraproject.org/metalink?repo=epel-6&arch=$basearch',
                        enabled     => $enable,
                        gpgcheck    => 1,
                        gpgkey      => "file:///etc/pki/rpm-gpg/${gpgkey}",
                        descr       => 'Extra Packages for Enterprise Linux 6 - $basearch',
                        require     => [
                                        File[$gpgkey],
                                        File[$repo],
                                       ],
                    }
                    yumrepo { 'epel-debuginfo':
                        baseurl        => '',
                        mirrorlist     => "http://mirrors.fedoraproject.org/mirrorlist?repo=epel-debug-${::os_maj_version}&arch=${::architecture}",
                        failovermethod => 'priority',
                        enabled        => '0',
                        gpgcheck       => '1',
                        gpgkey         => "file:///etc/pki/rpm-gpg/${gpgkey}",
                        descr          => 'Extra Packages for Enterprise Linux 6 - $basearch - Debug',
                    }
                    yumrepo { 'epel-source':
                        baseurl        => 'http://download.fedoraproject.org/pub/epel/6/SRPMS',
                        mirrorlist     => "http://mirrors.fedoraproject.org/mirrorlist?repo=epel-source-${::os_maj_version}&arch=${::architecture}",
                        failovermethod => 'priority',
                        enabled        => '0',
                        gpgcheck       => '1',
                        gpgkey         => "file:///etc/pki/rpm-gpg/${gpgkey}",
                        descr          => 'Extra Packages for Enterprise Linux 6 - $basearch - Source',
                    }
                    file { $repo:
                        replace     => false,
                        ensure      => "present",
                        path        => "/etc/yum.repos.d/${repo}",
                        mode        => 0644,
                        owner       => 'root',
                        group       => 'root',
                        source      => 'puppet:///modules/repo/epel-EL6-x86_64.repo';
                    }
                    # Create gpgkey
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
                    repo::gpgkey { 'EPEL-6':
                        path => "/etc/pki/rpm-gpg/${gpgkey}"
                    }
                }
            }
        }
    }
}
