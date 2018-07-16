This repository contains acceptance tests for the [eWallet SDK](https://github.com/omisego/ewallet) written using [Robot Framework](http://robotframework.org/)

# Requirements

## Python

[Python 3.6](https://www.python.org/downloads/) is required to run the tests.

## Pipenv

[Pipenv](https://github.com/pypa/pipenv) is required in order to install the dependencies

## eWallet SDK

The tests rely on test data inserted in a clean instance of the eWallet SDK. Required data can be seeded following [these instructions](https://github.com/omisego/ewallet/blob/master/docs/tests/e2e.md).


# Setup

You first need to tell `pipenv` to use python 3.6. You can do this with the following command:

`pipenv --python 3.6`

Note: If you're running MacOs, you will need to specify the following environment variables:

```
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
```

You can then install the dependencies using:

`pipenv install`

Then launch the virtual environment using:

`pipenv shell`

And finally, navigate to the `tests` folder and run robot

`cd test`

`robot .`

# Variables

## Environment variables

There are 6 environment variables that need to be created in order to run the tests:

- `E2E_HTTP_HOST`: The base HTTP URL of the eWallet SDK (ie: http://example.com)
- `E2E_SOCKET_HOST`: The base socket URL of the eWallet SDK (ie: ws://example.com)

The following variables define the email/password of the 2 needed admins. They can be defined before seeding the test data in the eWallet using [these environment variables](https://github.com/omisego/ewallet/blob/master/docs/setup/env.md#e2e-tests)

- `E2E_TEST_ADMIN_EMAIL`
- `E2E_TEST_ADMIN_PASSWORD`
- `E2E_TEST_ADMIN_1_EMAIL`
- `E2E_TEST_ADMIN_1_PASSWORD`
