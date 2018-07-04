all: clean setup

LDFLAGS := "-L/usr/local/lib"
CFLAGS := "-I/usr/local/include"

#
# Setting-up
#

.PHONY: setup

setup:
	pip install pipenv --upgrade
	env \
		LDFLAGS=$(LDFLAGS) \
		CFLAGS=$(CFLAGS) \
	pipenv install --dev $(ARGS)

clean:
	rm -f log.html
	rm -f output.xml
	rm -f report.html

#
# Testing
#

.PHONY: test

test: clean
	pipenv run robot --variablefile tests/variables.py tests
