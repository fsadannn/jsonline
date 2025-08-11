PROJECT=jsonline

.PHONY: install-uv
install-uv:
	pip install uv

.PHONY: install
install:
	uv pip sync pyproject.toml

.PHONY: update
update:
	uv pip compile pyproject.toml -o requirements.txt

.PHONY: lock
lock:
	uv pip compile pyproject.toml -o requirements.txt

.PHONY: build
build:
	uv build

.PHONY: publish
publish: release

.PHONY: publish-token
publish-token: release

.PHONY: release
release: build
	twine upload dist/*

.PHONY: release-test
release-test: build
	twine upload --repository-url https://test.pypi.org/legacy/ dist/*

docs-serve:
	cp docs/index.md Readme.md --update && uv run mkdocs serve

docs-deploy:
	uv run mkdocs gh-deploy && cp docs/index.md Readme.md --update

# Below are the commands that will be run INSIDE the development environment, i.e., inside Docker or GitHub Actions
# These commands are NOT supposed to be run by the developer directly, and will fail to do so.

.PHONY: dev-install
dev-install:
	pip install uv twine
	uv pip sync pyproject.toml

.PHONY: dev-deploy
dev-deploy: release

.PHONY: dev-test-deploy
dev-test-deploy: release-test
