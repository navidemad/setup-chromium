# https://github.com/joshcangit/chromium-latest-linux
# https://github.com/GoogleContainerTools/skaffold
# https://github.com/earthly/earthly
# https://juliusgamanyi.com/2022/04/27/run-github-actions-workflows-locally-using-act/

brew install act --HEAD

docker-compose up --build --force-recreate

# Development

Here's a step-by-step guide:

Having bash 5+

Enable Docker's Experimental Features: Ensure Docker's experimental features are enabled. This can usually be done by setting "experimental": true in your Docker configuration file or by using the environment variable DOCKER_CLI_EXPERIMENTAL=enabled.

Install and Set Up QEMU: QEMU is a generic and open-source machine emulator and virtualizer, which Docker can use to emulate different architectures. This step might already be covered if you're using Docker Desktop or a recent version of Docker on Linux with binfmt_misc support.

bash
```
docker run --rm --privileged multiarch/qemu-user-static --reset -p yes
```
Create a Buildx Instance: Create a new buildx instance that uses the docker-container driver, which allows Docker to use containers for builds, enabling more advanced features like building for multiple architectures.

bash
```
docker buildx create --name mybuilder --use
```
Start Building for Multiple Architectures: Modify your build command to specify multiple platforms. This is where you define the architectures you want to build for. For example, to build for linux/amd64 and linux/arm64, you would modify the build step in your docker-compose.yml or use a Docker command directly. Since docker-compose does not directly support buildx at the time of writing, you'll likely need to use a Docker command directly or a script to manage this.

Here's an example Docker command:

bash
```
docker buildx build --platform linux/amd64,linux/arm64 -t your-image-name:tag .
```
Running the Container: Running a container for a specific architecture other than your host's might require emulation to be set up (as described in step 2). Docker will automatically use QEMU to emulate the architecture if everything is set up correctly. However, be aware that running an emulated architecture might be significantly slower than native execution.

Using in docker-compose.yml: Since docker-compose may not directly support all buildx functionalities, you might need to build your images separately using docker buildx and then reference the built images in your docker-compose.yml file.
