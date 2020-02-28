# Python

## Setup new project

```bash
# in created project folder
poetry init
poetry add -D flake8 flake8-bugbear black isort
# add flake8
wget https://raw.githubusercontent.com/pinutz23/dotfiles/master/python.exclude/.flake8
# append pyproject.toml
wget https://raw.githubusercontent.com/pinutz23/dotfiles/master/python.exclude/pyproject.toml -q -O ->> pyproject.toml
# poetry install ...
poetry shell
```