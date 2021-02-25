init:
	pip install pip pipenv
	pipenv lock
	pipenv install --dev
lint:
	pipenv run flake8 pysnoo
	pipenv run pydocstyle pysnoo
	pipenv run pylint pysnoo
publish:
	pipenv run python setup.py sdist bdist_wheel
	pipenv run twine upload dist/*
	rm -rf dist/ build/ .egg simplisafe_python.egg-info/
typing:
	pipenv run mypy --ignore-missing-imports pysnoo
