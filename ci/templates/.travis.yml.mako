language: python
sudo: false
cache: pip

env:
  global:<% from textwrap import wrap %>
    LD_PRELOAD: /lib/x86_64-linux-gnu/libSegFault.so
    SEGFAULT_SIGNALS: all
    CODECOV_TOKEN:
      ${secure("codecov_token")}
    CC_TEST_REPORTER_ID:
      ${secure("cc_test_reporter_id")}
    COVERALLS_REPO_TOKEN:
      ${secure("coveralls_repo_token")}

matrix:
  include:<%
    from builtins import sorted
    cover_env = ",report,coveralls,codecov,ocular"
    def sort_key(pair):
        env, config = pair
        return (
            env.startswith("py"),
            not config.get("cover", True),
            env,
        )
%>
% for env, config in sorted(environments.items(), key=sort_key):
    - python: "${config["python"]}"
% if config["python"] == "3.7":
      dist: xenial
      sudo: required
% endif
      env:
        - TOXENV=${(env + (cover_env if config.get("cover", True) else ""))}
% endfor

before_install:
  - python --version
  - uname -a
  - lsb_release -a

install:
  - |
    set -ex
    if [[ $TRAVIS_PYTHON_VERSION == 'pypy' ]]; then
      (cd $HOME
       wget https://bitbucket.org/pypy/pypy/downloads/pypy2-v6.0.0-linux64.tar.bz2
       tar xf pypy2-*.tar.bz2
       pypy2-*/bin/pypy -m ensurepip
       pypy2-*/bin/pypy -m pip install -U virtualenv)
      export PATH=$(echo $HOME/pypy2-*/bin):$PATH
      export TOXPYTHON=$(echo $HOME/pypy2-*/bin/pypy)
    fi
    if [[ $TRAVIS_PYTHON_VERSION == 'pypy3' ]]; then
      (cd $HOME
       wget https://bitbucket.org/pypy/pypy/downloads/pypy3-v6.0.0-linux64.tar.bz2
       tar xf pypy3-*.tar.bz2
       pypy3-*/bin/pypy3 -m ensurepip
       pypy3-*/bin/pypy3 -m pip install -U virtualenv)
      export PATH=$(echo $HOME/pypy3-*/bin):$PATH
      export TOXPYTHON=$(echo $HOME/pypy3-*/bin/pypy3)
    fi
    set +x
  - pip install -U tox pbr
  - virtualenv --version
  - easy_install --version
  - pip --version
  - tox --version

before_script:
  - curl -L https://codeclimate.com/downloads/test-reporter/test-reporter-latest-linux-amd64 > ./cc-test-reporter
  - chmod +x ./cc-test-reporter
  - ./cc-test-reporter before-build

script:
  - tox -v

after_failure:
  - more .tox/log/* | cat
  - more .tox/*/log/* | cat

after_script:
  - ./cc-test-reporter after-build --exit-code $TRAVIS_TEST_RESULT || true

deploy:
  provider: pypi
  user: demosdemon
  distributions: "sdist bdist_wheel"
  skip_existing: true
  password:
    ${secure("pypy_password")}
  on:
    tags: true
    branch: master

notifications:
  email:
    on_success: never
    on_failure: change

<%def name="secure(secret)">secure: ${secrets[secret]}</%def>
