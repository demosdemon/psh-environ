language: python
sudo: false
cache: pip

env:
  global:
    - LD_PRELOAD=/lib/x86_64-linux-gnu/libSegFault.so
    - SEGFAULT_SIGNALS=all
    # CODECOV_TOKEN
    - secure: "dITR0yOLfz8Er/kfI+YeCE9PngyLFucywxH1zBNzujri9BBLQQJKeqrsziT2wStP3SV0eaVifwEne+0H1H/Hvio/nyxUwhmvNQOZ+EzKlz4xjh6Sh4BLetzF2EX/4VIjFHOjQCttXjOBVGN0UeoLJT9zCLbx7qnrt1CxsveOs/8CX1qgnvMVHLgO2UdNwI6OSPbgf7/rmEU5gE0/lTHZXGlbpzcB4H51qYjZRW9qWhuZYyXcn/0DcZZUmC5NC60i0uH/RqYFIGnP9ljISE5ul/OaBtJgxDvGIBe1WLOAF0S8C30/pi7vVmx8+NdKp1YDGm4Dl4IsEAbBIROzvzIbRa/YpVT1bmlVhjuNH3ifztN1P7VYq6FImR7M5oUHxvP2hI9itc2o57yvtJRHZGgeXGQQR9vVFG2un+8Kv9qzuhvPdUehRokbLzxmtaft0T5VZq8WPF5J814Kag3vz3f08Nb2285upfE5l1grpXLXxi8H54dn/OyEBfkmFDEAKVgccZiJqREGean5E6GrqoYvE8wqXKlPicPyUOesuNgv5K5WVGaqr4fWLUV5ZxQZtRXfMjrbb3WthMj/9Sg5XRTOiVoOBtAFE6vsH8VXYt7HTXg91+XxgLp61eMdKTx0nYzWRwZMV6B+7ycwS+5Gi2S6YF/SglTr7/rr8txR5IywC4Q="
    # CC_TEST_REPORTER_ID
    - secure: "Fm6ICiw0uKHGJlz1isdQYscJhqHJ769q/esRZ0VOMyqo6nXySQokOIgTlgF8Anbjd8IbL5A6vL4tb6BSwqHZrQsKh3V8jM0jvhjOrlwp45sZna/1YipI/kXkJUMJhc1uYPoLiTI2loa3ypLaI4rSPR+uqjczNfa4ficBrXFE+D44h2XOqMjj+/WVADoMYcWSKcbY2rKeKjSe1peE5y4C12dnTMglXXoAXdb+3d+nCTwl2VIpUXY6cO0Ideiabrwb/LSwo0VyYU1z05K3/VvAtnLQvs8jqQrsbJg6ejAEXoEEmmQNiQP6CoALdJWU3ajfRIyDRlhsmgIlVPJzNpRclb3DP5qiJTQ1I7bxSL6ApBwb5vraVbfDHUJFa0FyYN3n+OrDgLgKXvq+H0dLpqzt6XlyPCfk4THyjqXUWtdFZVSENFJnEJuxfQ/wKFG9r8I95J+XYZn1qJRcH/UFaji9JTVqTCl+d7/ydxanmlQqr82lCrfKDgNFZN/GKCpOsnQSYTQc7SRZq0dev7sFPOf92GOsQQUBu7Eq1QYDP2EeQLBTSIjXsVeKOu9kt0ecFsgAp9xP0ZLcihS+If3rbiE+lTPxiYyQD3VvJXm2KGJJNwsnHgkgRNM9SyMfYqH7GvFnnthGEW7DJm9vVDcFq7XdcR00xXOVNokbwOBSiq+aSSA="
    # COVERALLS_REPO_TOKEN
    - secure: "R+qtPNrJNlInzil0fB37/un9raWqXUZbALzZmz2ut4wUzWQ1VFHA6HiF3MDb7D1mBNB8h1LXnJyOEo2zdRay9UcZh84vaelBxtCsL5RdFWx1dp2rOiV9SoXwp6ndmaMnPLzjSokcwbiJkBYXPohgOo4yyyFLeWGdiX6V916qvwhiIkPZyJiPTIjLBITew5+URRacLCM032HgryyCfcBtLf/vFP3v0bfGWaQO3r0CQRr9xpqqLiIy7PYDYS3SBMCe87vhCi9FNvatBO3ghSJUWlqYvTLyY/bP/2WfNfo0GyUkuBxal1B0fKy/nK2YRew7bDtPkCwu6It0E1IZesSGuK8IUD6UZPTdZ3gy5mSX5FOXs+O160G5HPdg+aLKJjg5VT3grGbZvROy+tDPMSJd/uN9HIF2xF2BlaP23uUSBWe2lfy7RFs4RFYRBm4PgY5cxp7EyP0m9zvXENbOPpgvd5DHL+3vH1F1HCpbvhm/DNGLUMba4KbjxsOmxnUXL1DgR58v3Mr0TtPRdFzE2Y9Iy1o3WQCDXc8tDaYGOdujkjwdcZI/7DrUF1iU5/3m32eo0UIL1trHNXR2M3EZgI/CFSfkwl3ewFSukYtlvKURzPF1NedJh7yh3tNmoOiZojDQRq4UQihP3AlBLP0mTOUgxc5hptOMjAR1x/4YJRuhKdU="

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
    secure: "HWnCM36GfIjpSnD2ikBwVTRIQS/4sNG798YUPTPEdFER4KM7PzMMLyUuFN5SppVZXF+21xwTOdcxNlBVaKpZyD+jzTbWHgao3SiuG6ARThCz38i6UZXPIJBWnv639tRf2Kz8wE/OuSS1vvnhjGVjWOpqrpsGbfu0RZy/6+eLwQkcv4oFxzHQ+KTexeFJ7effnpM/EF1eSEXa9BhULP/fLnv2qsXNMZCpQY6h7dmdlJgR3ykF9cz3NnYFefiTgXwgsmINPymRUNzZQKn970mZgzKh7uhBzpFhMNaEZKam8auchAJO1PKfEWhOkbAzW3L96Rp9PmYj6jOjIXD+jN6ceIBHxfBQ06blijlRp86rtl8vQOTbn7GKyvY+n8yPm99pGqxVu/ch0kWI1Sk3RQr/y0zBLqsdPtPtGW1pZm/1C9h9B2xd/yt0y7aJZ8/xOblgIeOQHPbDQQeNjd6mu63CnRWR7kpvDgGYjhVnVlPZj09+in1HqWixe15BmgIrYheUt/IWCMnlbGuiPLWyT46Avm4IAmuxUjB84zH06Xq0N+yrV1fSFwz1hOk/YzAMUinHGlB4NKPi8Wk/IuaH5eqVVa67wNN4DFoETvfGF7aOsjLppYmyBKkTVCB69w/K9SJZmqkn99mNzaTBgepI4lsS+exSGyCOkgBT0H0E5lSz26c="
  on:
    tags: true
    branch: master

notifications:
  email:
    on_success: never
    on_failure: change
