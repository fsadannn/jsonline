docs-serve:
	uv run mkdocs serve

docs-deploy:
	uv run mkdocs gh-deploy && cp docs/index.md Readme.md --update
