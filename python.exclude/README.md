# Python

## Setup new project

```bash
# in created project folder
poetry init
poetry add -D flake8 flake8-bugbear black isort
wget https://raw.githubusercontent.com/pinutz23/dotfiles/master/python.exclude/.flake8
# copy desired settings to projects pyproject.toml
# poetry install ...
poetry shell
```