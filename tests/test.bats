setup() {
  set -eu -o pipefail
  brew_prefix=$(brew --prefix)
  load "${brew_prefix}/lib/bats-support/load.bash"
  load "${brew_prefix}/lib/bats-assert/load.bash"

  export DIR="$( cd "$( dirname "$BATS_TEST_FILENAME" )" >/dev/null 2>&1 && pwd )/.."
  export TESTDIR=~/tmp/test-solr
  mkdir -p $TESTDIR
  export PROJNAME=test-solr
  export DDEV_NON_INTERACTIVE=true
  ddev delete -Oy ${PROJNAME} >/dev/null 2>&1 || true
  cd "${TESTDIR}"
  ddev config --project-name=${PROJNAME} --project-type=typo3 --docroot=public --php-version 8.2
  ddev start -y >/dev/null
  ddev composer create "typo3/cms-base-distribution:^12" >/dev/null
  ddev restart >/dev/null
}

health_checks() {
  set +u # bats-assert has unset variables so turn off unset check
  # ddev restart is required because we have done `ddev get` on a new service
  run ddev restart
  #assert_success
  # Make sure we can hit the 8943 port successfully
  curl -s -o /dev/null -I -w '%{http_code}' https://${PROJNAME}.ddev.site:8943/solr/admin/cores\?action\=STATUS >/tmp/curlout.txt
  # Make sure `ddev solr` works
  DDEV_DEBUG=true run ddev solr
  #assert_success
  #assert_output --partial "FULLURL https://${PROJNAME}.ddev.site:8943"
}

teardown() {
  set -eu -o pipefail
  cd ${TESTDIR} || ( printf "unable to cd to ${TESTDIR}\n" && exit 1 )
  ddev delete -Oy ${PROJNAME} >/dev/null
  [ "${TESTDIR}" != "" ] && rm -rf ${TESTDIR}
}

@test "install from directory" {
  set -eu -o pipefail
  cd ${TESTDIR}
  echo "# ddev add-on get ${DIR} with project ${PROJNAME} in ${TESTDIR} ($(pwd))" >&3
  ddev add-on get ${DIR} >/dev/null
  ddev mutagen sync >/dev/null
  health_checks
}

@test "install from release" {
  set -eu -o pipefail
  cd ${TESTDIR} || ( printf "unable to cd to ${TESTDIR}\n" && exit 1 )
  echo "# ddev add-on get carsten-walther/ddev-typo3-solr with project ${PROJNAME} in ${TESTDIR} ($(pwd))" >&3
  ddev add-on get carsten-walther/ddev-typo3-solr >/dev/null
  ddev restart >/dev/null
  health_checks
}
