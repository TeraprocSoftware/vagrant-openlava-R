#!/bin/bash
source "/vagrant/scripts/common.sh"

function installR {
	echo "install R"

	# mv /usr/local/lib/R/site-library/BatchJobs /usr/local/lib/R/site-library/orig.BatchJobs
    # tar xvf /vagrant/resources/BatchJobs-0323-rmpi-ol-fix.tar -C /usr/local/lib/R/site-library/
    # chown -Rf root:root /usr/local/lib/R/site-library/BatchJobs
	
	sed -i '/deb-src http:\/\/us-east-1.ec2.archive.ubuntu.com\/ubuntu\/ trusty main/a deb http:\/\/cran.utstat.utoronto.ca\/bin\/linux\/ubuntu trusty\/' /etc/apt/sources.list
    cat << EOF >> r-public-key.asc
-----BEGIN PGP PUBLIC KEY BLOCK-----
Version: GnuPG v1

mQENBEy9tcUBCACnWQfqdrcz7tQL/iCeWDYSYPwXpPMUMLE721HfFH7d8ErunPKP
Iwq1v4CrNmMjcainofbu/BfuZESSK1hBAItOk/5VTkzCJlzkrHY9g5v+XlBMPDQC
9u4AE/myw3p52+0NXsnBz+a35mxJKMl+9v9ztvueA6EmLr2xaLf/nx4XwXUMSi1L
p8i8XpAOz/Xg1fspPMRhuDAGYDnOh4uH1jADGoqYaPMty0yVEmzx74qvdIOvfgj1
6A/9LYXk67td6/JQ5LFCZmFsbahAsqi9inNgBZmnfXO4m4lhzeqNjJAgaw7Fz2zq
UmvpEheKKClgTQMWWNI9Rx1L8IKnJkuKnpzHABEBAAG0I01pY2hhZWwgUnV0dGVy
IDxtYXJ1dHRlckBnbWFpbC5jb20+iQE+BBMBAgAoBQJMvbXFAhsjBQkJZgGABgsJ
CAcDAgYVCAIJCgsEFgIDAQIeAQIXgAAKCRBRcWYZ4ITauTy9B/4hmPQ7CSqw5OS5
t8U5y38BlqHflqFev3llX68sDtzYfxQuQVS3fxOBoGmFQ/LSfXQYhDG6BZa4nDuD
ZEgb81Mvj0DJDl4lmyMdBoIvXhvdEPDd/rrOG+1t2+S429W9NIObKaZCs9abv2fn
IhrtyAWxc/iNR5rJmNXozvJVGAgAeNhBSrvZqFaPJ//BklbJhfVgNwt4GgtFl1va
U7LMaMrOWA9Hyd8dWAGuIhbYXOOFj1WZ/OhUlYXnsIe8XzaJ1y6LyVkCLhaJ+MVt
GwTXrFXRhBLQlhCYBfO25i/PGUWSvRhI8n/r+RMNOuy1HlFbexRYrtPXOLbiO8Al
FuIsX9nRuQENBEy9tcUBCADYcCgQCCF1WUSn7c/VXNvgmXzvv3lVX9WkV4QdpcJX
itXglXdTZwVxGv3AxDuaLEwxW7rbqKRPzWNjj4xTHxt2YtUjE+mLV58AFaQQU3al
dYG8JPr2eohMNZqp2BG2odczw5eaO5l5ETjC1nHUjDUm8us3TV3AXOajAjguGvpG
3DKnx/gmudrMBVSAEE64kefyBmSR683zkXhw+NgbTID9XW1OSqE+fLQf0ZzQEojM
dfYIeV8Q5sMAmU3J9AdlpyDrZaYRmiphgw8PZTMahhz/o6Bz7p6VqA4Ncmr225nn
tIsjUUz0iK6TsaOi9KrF23Rw+IDUJeYkdVbwGqavgJG1ABEBAAGJASUEGAECAA8F
Aky9tcUCGwwFCQlmAYAACgkQUXFmGeCE2rlB9Qf+JKMUzM0KVdTFWocGP+v4xTJs
nKjYfjPjOkFYAdxhjkiIq7h7ws0s+UKqmzSG4vX5Qz46GZcB7x0hVrN0gqCcfpru
PZOjXNkRwtsXbLfiurrZQ6dSPsNIE9L4DZdSTggwC3i7jiDlK6TtIMXD55VoVvVA
vmzt6/f7y4qsVxhZ/N3jMqq1vLUESw8eVq2ryZRU9OIUufb5JjGNJ1Zz0Zp8hV/I
PLoIv1OIocWov27YLcr6EnXuvXvU/MSm97YifdG9UYCE99nHTioSM0Q3cgpu5Epp
VNrc232gyG2vlHzhsstNBx55cUmAX2fEzxuRipLS0iq4L0zUGdgdjn4noGDzGA==
=BF1w
-----END PGP PUBLIC KEY BLOCK-----
EOF
    apt-key add r-public-key.asc

    apt-get update
    apt-get install -y r-base
    apt-get install -y r-base-dev
    apt-get install -y r-recommended

    apt-get install -y libxml2-dev
    # for libcurl-dev
    apt-get install -y libcurl4-gnutls-dev

    LD_LIBRARY_PATH=/usr/local/openmpi/lib:$LD_LIBRARY_PATH Rscript /vagrant/resources/install-packages.R

    # Hack BatchJobs to support RMPI on OL before BatchJobs has new package on web
    mv /usr/local/lib/R/site-library/BatchJobs /usr/local/lib/R/site-library/orig.BatchJobs
    tar -xzf /vagrant/resources/./BatchJobs_20150903.tar.gz -C /usr/local/lib/R/site-library/
    chown -Rf root:root /usr/local/lib/R/site-library/BatchJobs
	
	# set up R profile
	cp -f /vagrant/resources/Rprofile.site /etc/R/
}

echo "setup R"
installR