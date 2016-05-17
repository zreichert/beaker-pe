# default - History
## Tags
* [LATEST - 4 Apr, 2016 (b3175863)](#LATEST)
* [0.1.1 - 4 Apr, 2016 (8203d928)](#0.1.1)
* [0.1.0 - 29 Feb, 2016 (4fc88d8c)](#0.1.0)

## Details
### <a name = "LATEST">LATEST - 4 Apr, 2016 (b3175863)

* (GEM) update beaker-pe version to 0.1.2 (b3175863)

* Merge pull request #3 from demophoon/fix/master/pe-14934-robust-puppetdb-check (c3bebe59)


```
Merge pull request #3 from demophoon/fix/master/pe-14934-robust-puppetdb-check

(PE-14934) Add more robust puppetdb check
```
* (PE-14934) Add more robust puppetdb check (7112971a)


```
(PE-14934) Add more robust puppetdb check

Before this commit we were still failing before the last puppet agent
run in do_install because we also run puppet agent in some cases before
the last run. This commit adds in the wait during that agent run as well
as a check on the status endpoint in puppetdb to be sure that it is
running in the case that the port is open but puppetdb is not ready for
requests.
```
### <a name = "0.1.1">0.1.1 - 4 Apr, 2016 (8203d928)

* (HISTORY) update beaker-pe history for gem release 0.1.1 (8203d928)

* (GEM) update beaker-pe version to 0.1.1 (6ccb5a59)

* Merge pull request #2 from demophoon/fix/master/pe-14934 (4e0b668e)


```
Merge pull request #2 from demophoon/fix/master/pe-14934

(PE-14934) Test if puppetdb is up when running puppet agent on pdb node
```
* (PE-14934) Test if puppetdb is up when running puppet agent on pdb node (882ca94f)


```
(PE-14934) Test if puppetdb is up when running puppet agent on pdb node

Before this commit we were running into an issue where puppetdb would
sometimes not be up and running after puppet agent restarted the
service. This commit waits for the puppetdb service to be up after
running puppet agent on the database node so that the next agent run
doesn't fail.
```
### <a name = "0.1.0">0.1.0 - 29 Feb, 2016 (4fc88d8c)

* Initial release.
