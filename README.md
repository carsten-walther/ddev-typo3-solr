[![tests](https://github.com/carsten-walther/ddev-typo3-solr/actions/workflows/tests.yml/badge.svg)](https://github.com/carsten-walther/ddev-typo3-solr/actions/workflows/tests.yml) ![project is maintained](https://img.shields.io/maintenance/yes/2024.svg)

# ddev-typo3-solr <!-- omit in toc -->

- [What is ddev-typo3-solr?](#what-is-ddev-typo3-solr)
- [Getting started](#getting-started)

## What is ddev-typo3-solr?

ddev-typo3-solr provides Solr (Cloud) using a single Solr node, which is sufficient
for local development requirements.

## Getting started

1. Install apache-solr-for-typo3/solr

    ```shell
    ddev composer req "apache-solr-for-typo3/solr:^12.0.0-beta-1"
    ```

2. Install the addon

    ```shell
    ddev get carsten-walther/ddev-typo3-solr
    ```

3. Restart DDEV to start the addon.

   ```shell
   ddev restart
   ```

Once up and running, access Solr's UI within your browser by opening
`http://<projectname>.ddev.site:8983`. For example, if the project is named
"myproject" the hostname will be `http://myproject.ddev.site:8983`.

To access the Solr container from DDEV's web container, use  `http://solr:8983`.

**Contributed and maintained by [@carsten-walther](https://github.com/carsten-walther)**
