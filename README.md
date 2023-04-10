# GitHub Action for Outpost
Track your Github Actions deployments with Outpost

## Features
 * Reports deployments into Outpost
 * Outpost errors are treated as errors

## Usage

### GitHub Actions
```
on: push
jobs:
  curl:
    runs-on: ubuntu-latest
    steps:
    - name: outpost
      uses: outpostso/outpost-github-action@main
```

```
on: push
jobs:
  curl:
    runs-on: ubuntu-latest
    steps:
    - name: outpost
      uses: outpostso/outpost-github-action@v1
      with:
        args: --version $(cat .version)
```

### Docker
```
docker run --rm $(docker build -q .) \
  --token 6532ced83edf275d...
```


## Author
[Outpost Team](https://github.com/outpostso) _github@outpost.so_


## License
[MIT](https://mit-license.org)