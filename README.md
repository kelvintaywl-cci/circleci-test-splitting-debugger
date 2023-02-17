```console

# optional; if using Pyenv
$ pyenv install

# generated updated requirements.txt
$ poetry export --without-hashes --format=requirements.txt > requirements.txt

# install dependencies
$ poetry install
```

```
# generated updated requirements.txt
# ignore dev dependenices
$ poetry export --without-hashes --format=requirements.txt > requirements.txt

# build image
$ PYTHON_VERSION=$(cat .python-version) docker build --build-arg "python_version=$PYTHON_VERSION" --tag debugger .
```
