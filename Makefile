# ---------- ---------- ---------- ---------- ---------- ----------
#
# hexoshi
#
#    1) config, vars, and target
#    2) functions
#    3) phonies
#
# ---------- ---------- ---------- ---------- ---------- ----------

NAME=hexoshi

target: help


# ---------- ---------- ---------- ---------- ---------- ----------
# functions
# ---------- ---------- ---------- ---------- ---------- ----------

define fix-python
	@isort . || echo "isort returned nonzero"
	@black . || echo "black returned nonzero"
endef


define lint
	@flake8 . || echo "flake8 returned nonzero"
endef


define lint-types
	@mypy . || echo "mypy returned nonzero"
endef


define requirements
	@poetry --version
	@poetry export -f requirements.txt --output requirements.txt \
            --without-hashes --without-urls
endef


define run-security-checks
	@echo "stub for missing package"
endef


# ---------- ---------- ---------- ---------- ---------- ----------
# phonies
# ---------- ---------- ---------- ---------- ---------- ----------

.PHONY: help
help:
	@echo "Usage: make [PHONY]"
	@sed -n -e "/sed/! s/\.PHONY: //p" Makefile
	@echo ""
	@echo "Help with docker:"
	@echo "    service docker restart"
	@echo "    docker build -t $(NAME) ."
	@echo "    docker run --name local_$(NAME) -d $(NAME)"


.PHONY: clean
clean:
	@py3clean . || echo "executing py3clean returned nonzero"
	@rm -rf .coverage ./.mypy_cache


.PHONY: fix-python
fix-python:
	@$(call fix-python)


.PHONY: fix-all
fix-all: fix-python


.PHONY: lint
lint:
	@$(call lint)


.PHONY: lint-types
lint-types:
	@$(call lint-types)


.PHONY: run-security-checks
run-security-checks:
	@$(call run-security-checks)


.PHONY: dev
dev: lint lint-types show-lacking-coverage


.PHONY: requirements
requirements:
	@$(call requirements)


.PHONY: test-coverage
test-coverage:
	@coverage run --source='.' -m unittest discover -s tests -t .


.PHONY: test-coverage-report
test-coverage-report: test-coverage
	@coverage report -m


.PHONY: show-lacking-coverage
show-lacking-coverage: test-coverage
	@coverage report -m | grep -v '100\%'


.PHONY: test
test:
	@python -m unittest discover -s tests -t .||\
            echo "unit tests failed"
