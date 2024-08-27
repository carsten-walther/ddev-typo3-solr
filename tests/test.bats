setup() {
  set -eu -o pipefail
  export DIR="$( cd "$( dirname "$BATS_TEST_FILENAME" )" >/dev/null 2>&1 && pwd )/.."
  export TESTDIR=~/tmp/test-ddev-typo3-solr
  mkdir -p $TESTDIR
  export PROJNAME=test-ddev-typo3-solr
  export DDEV_NON_INTERACTIVE=true
  ddev delete -Oy ${PROJNAME} >/dev/null 2>&1 || true
  cd "${TESTDIR}"
  ddev config --project-name=${PROJNAME}
  ddev start -y >/dev/null
}

health_checks() {
  set +u # bats-assert has unset variables so turn off unset check
  # ddev restart is required because we have done `ddev get` on a new service
  run ddev restart
  assert_success
  # Make sure we can hit the 8037 port successfully
  curl -s -I -f  http://${PROJNAME}.ddev.site:8983 >/tmp/curlout.txt
  # Make sure `ddev solr` works
  DDEV_DEBUG=true run ddev solr
  assert_success
  assert_output --partial "FULLURL http://${PROJNAME}.ddev.site:8983"
}

teardown() {
  set -eu -o pipefail
  cd ${TESTDIR} || ( printf "unable to cd to ${TESTDIR}\n" && exit 1 )
  ddev delete -Oy ${PROJNAME} >/dev/null 2>&1
  [ "${TESTDIR}" != "" ] && rm -rf ${TESTDIR}
}

@test "install from directory" {
  set -eu -o pipefail
  cd ${TESTDIR}
  echo "# ddev get ${DIR} with project ${PROJNAME} in ${TESTDIR} ($(pwd))" >&3
  ddev get ${DIR} >/dev/null 2>&1
  ddev mutagen sync >/dev/null 2>&1
  health_checks
}

@test "install from release" {
  set -eu -o pipefail
  cd ${TESTDIR} || ( printf "unable to cd to ${TESTDIR}\n" && exit 1 )
  echo "# ddev get carsten-walther/ddev-typo3-solr with project ${PROJNAME} in ${TESTDIR} ($(pwd))" >&3
  ddev get carsten-walther/ddev-typo3-solr >/dev/null 2>&1
  ddev restart >/dev/null 2>&1
  health_checks
}
