# default - History
## Tags
* [LATEST - 18 May, 2016 (d9a052a4)](#LATEST)
* [0.1.2 - 4 Apr, 2016 (a6fd7bef)](#0.1.2)
* [0.1.1 - 4 Apr, 2016 (8203d928)](#0.1.1)
* [0.1.0 - 29 Feb, 2016 (4fc88d8c)](#0.1.0)

## Details
### <a name = "LATEST">LATEST - 18 May, 2016 (d9a052a4)

* (GEM) update beaker-pe version to 0.2.0 (d9a052a4)

* Merge pull request #1 from Renelast/fix/windows_masterless (ef4be9a2)


```
Merge pull request #1 from Renelast/fix/windows_masterless

Fixes windows masterless installation
```
* Merge branch 'master' of https://github.com/puppetlabs/beaker-pe into fix/windows_masterless (f1a96fb2)

* Merge pull request #7 from tvpartytonight/BKR-656 (aa566657)


```
Merge pull request #7 from tvpartytonight/BKR-656

(maint) Remove leftover comments
```
* (maint) Remove leftover comments (c7ce982b)


```
(maint) Remove leftover comments

This removes some straggling comments and adds a comment to the new
metadata object in the `ClassMixedWithDSLInstallUtils` class.
```
* Merge pull request #6 from tvpartytonight/BKR-656 (c1ea366b)


```
Merge pull request #6 from tvpartytonight/BKR-656

BKR-656
```
* (BKR-656) refactor pe_ver setting into independent method (0d918c46)


```
(BKR-656) refactor pe_ver setting into independent method

Previous to this commit, transforming a host object prior to upgrading
was handled in the upgrade_pe_on method. This change removes that logic
from that method and allows for independent transformation to happen in
a new prep_host_for_upgrade method.
```
* (BKR-656) Update spec tests for do_install (b602661f)


```
(BKR-656) Update spec tests for do_install

Commit 7112971ac7b14b8c3e9703523bbb8526af6fdfbe introduced changes to
the do_install method but did not have any updates for the spec tests.
This commit adds those tests in.
```
* Adds type defaults and runs puppet agent on masterless windows (e7d06a3f)

* Fixes windows masterless installation (9ff54261)


```
Fixes windows masterless installation

Setting up a masterless windows client would fail with the following error:

Exited: 1
/usr/local/rvm/gems/ruby-2.2.1/gems/beaker-2.37.0/lib/beaker/host.rb:330:in `exec': Host 'sxrwjhkia9gzo03' exited with 1 running: (Beaker::Host::CommandFailure)
 cmd.exe /c puppet config set server
Last 10 lines of output were:
        Error: puppet config set takes 2 arguments, but you gave 1
        Error: Try 'puppet help config set' for usage

As far as I could see this error is caused by the 'setup_defaults_and_config_helper_on' function which tries to set the master configuration setting in puppet.conf. But since there is no master varaible available this failes.

This patch should fix that by only calling setup_defaults_and_config_helper_on whern we're not doing a masterless installation.
```
### <a name = "0.1.2">0.1.2 - 4 Apr, 2016 (a6fd7bef)

* (HISTORY) update beaker-pe history for gem release 0.1.2 (a6fd7bef)

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
