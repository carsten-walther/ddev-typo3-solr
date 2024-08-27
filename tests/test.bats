setup() {
  set -eu -o pipefail
  export DIR="$( cd "$( dirname "$BATS_TEST_FILENAME" )" >/dev/null 2>&1 && pwd )/.."
  export TESTDIR=~/tmp/test-solr
  mkdir -p $TESTDIR
  export PROJNAME=test-solr
  export DDEV_NON_INTERACTIVE=true
  ddev delete -Oy ${PROJNAME} >/dev/null 2>&1 || true
  cd "${TESTDIR}"
  ddev config --project-name=${PROJNAME} --default-container-timeout 360
  ddev start -y >/dev/null
  ddev composer create "typo3/cms-base-distribution:^12"
}

health_checks() {
  # ddev restart is required because we have done `ddev get` on a new service
  ddev restart
  # Make sure the custom `ddev solr` command works
  ddev solr | grep COMMAND >/dev/null
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
  ddev get ${DIR}
  ddev restart
  health_checks
}

@test "install from release" {
  set -eu -o pipefail
  cd ${TESTDIR} || ( printf "unable to cd to ${TESTDIR}\n" && exit 1 )
  echo "# ddev get carsten-walther/ddev-typo3-solr with project ${PROJNAME} in ${TESTDIR} ($(pwd))" >&3
  ddev get carsten-walther/ddev-typo3-solr
  ddev restart >/dev/null
  health_checks
}
