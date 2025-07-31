# How to release new Go version

1. Sync the latest changes from the upstream repository
   ```bash
   git submodule update --init --recursive
   git fetch upstream
   git merge upstream/main
   ```
2. Check if the latest Go version is actually the latest version e.g. for `1.24` check file `1.24/Dockerfile` 
and see if the `ENV GO_VER` line has the latest Go version.

3. Ensure that `GOVERSION` matches the expected major version of Go you intend to use (e.g. `1.24`). File: `build-images.sh`

4. Open PR with the changes to the `cimg-go` repository. Merge the PR once it is approved.

5. Release the new version of the `cimg-go` image: 
    ```bash
    zutano release patch -t OAS-XXX
    ```

6. You will get `arangodboasis/cimg-go:${GOVERSION}-${RELEASE_VER}` and `arangodboasis/cimg-go:${GOVERSION}-latest` images pushed to Docker Hub.
