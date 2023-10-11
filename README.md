![project is maintained](https://img.shields.io/maintenance/yes/2024.svg)

# ddev-typo3-solr <!-- omit in toc -->

- [What is ddev-typo3-solr?](#what-is-ddev-typo3-solr)
- [Getting started](#getting-started)
- [Using cores](#using-cores)

## What is ddev-typo3-solr?

ddev-typo3-solr provides Solr (Cloud) using a single Solr node, which is sufficient
for local development requirements.

## Getting started

1. Install apache-solr-for-typo3/solr

    ```shell
    ddev composer req "apache-solr-for-typo3/solr:^12.0.0-RC1"
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

## Using cores

Set your desired language core to the language in your sites/XXX/config.yaml.

```yaml
base: 'https://%env(DDEV_SITENAME)%.%env(DDEV_TLD)%/'
...
languages:
  -
    title: English
    enabled: true
    languageId: 0
    base: /
    locale: en_US.UTF-8
    navigationTitle: English
    flag: us
    hreflang: 'en-US'
    websiteTitle: 'TYPO3 Website'
    solr_core_read: core_en

rootPageId: 1
...
solr_enabled_read: true
solr_host_read: '%env(DDEV_SITENAME)%.%env(DDEV_TLD)%'
solr_path_read: /solr/
solr_port_read: '8983'
solr_scheme_read: http
solr_use_write_connection: false
...
websiteTitle: 'TYPO3 Website'
```

You are able to use the DDEV constants in yout local environment. Keep in mind to replace them in production to the coorect one.

**Contributed and maintained by [@carsten-walther](https://github.com/carsten-walther)**
