PYTHON ?= python3
ARGSTR ?= --argstr python $(PYTHON)

TEST = $(wildcard tests/*.py)
SRC = $(wildcard src/sphinxcontrib/httpexample/*.py)

all: test coverage

nix-%: requirements.nix
	nix-shell setup.nix $(ARGSTR) -A develop --run "$(MAKE) $*"

nix-env: requirements.nix
	nix-build setup.nix $(ARGSTR) -A env

nix-shell: requirements.nix
	nix-shell setup.nix $(ARGSTR) -A develop

docs: requirements.nix
	nix-build release.nix $(ARGSTR) -A docs

coverage: .coverage
	coverage report --fail-under=80

coveralls: .coverage
	coveralls

test:
	flake8 src
	py.test

.PHONY: all coverage coveralls test nix-%

###

.coverage: $(TEST) $(SRC)
	coverage run setup.py test

requirements.nix: requirements.txt
	nix-shell setup.nix -A pip2nix \
	  --run "pip2nix generate -r requirements.txt --output=requirements.nix"
