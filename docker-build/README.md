
![Test the docker-build action](https://github.com/r-hub/actions/workflows/Test%20the%20docker-build%20action/badge.svg)

> Build and publish R Docker Images

## Example

```yaml
name: Docker build, all supported versions
on: [push]
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v1
    - name: Docker build
      uses: r-hub/actions/docker-build@master
      with:
        r_version: '3.6.2'
        docker_name: user/repo
        github_name: user/repo/image
        docker_username: ${{ secrets.DOCKER_USERNAME }}
        docker_password: ${{ secrets.DOCKER_PASSWORD }}
        github_username: ${{ secrets.GITHUB_USERNAME }}
        github_token: ${{ secrets.GITHUB_TOKEN }}
        extra_tags: 'latest'
```

See the [r-minimal](https://github.com/r-hub/r-minimal) project for a
[real example](https://github.com/r-hub/r-minimal/blob/master/.github/workflows/docker-build.yml).

## Input parameters

* `r_version`: The R version number, or `patched` or `devel`. Required.
  If it is `patched` then the `x.y-patched` and `x.y.z-patched` tags are
  added to the image. If an `x.y.z` version number, then the `x.y` tag
  is also added to the image.
* `docker_name`: Name of the image on Docker Hub, e.g. `rhub/r-minimal`.
  Required.
* `github_name`: Name of the image on GitHub Packages. This also
  contains the repository name, e.g. `r-hub/r-minimal/r-minimal`.
  Required.
* `docker_username`: Username on Docker Hub. Required.
* `docker_password`: Password on Docker Hub. Required.
* `github_username`: Username on GitHub (Packages). Required.
* `github_token`: Token (used as password in `docker login`) on GitHub
  (Packages). Required.
* `extra_tags`: Extra tags to add to the image, on both Docker Hub and
  GitHub Packages, separeted space. Optional.

## Output parameters

* `digest`: Digest of the built image.
* `tags`: A list of all tags added to the image.

## Related tools and projects

* See https://github.com/elgohr/Publish-Docker-Github-Action for a generic
action that pushes Docker images to registries.

## License

MIT @ [R Consortium](https://www.r-consortium.org/)
