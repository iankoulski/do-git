# do-git 
A [do-framework](https://bit.ly/do-framework) [project](https://github.com/iankoulski/do-git) to build a git container based on Alpine and run git commands. This container also has a utility to download folders from github to a specified destination.

# Build

Build the do-git container image

```bash
./build.sh
```

# Run

Run a do-git container

```bash
./run.sh

or 

./run.sh <git_command>
```

# Status

Check the status of your do-git container

```bash
./status.sh
```

# Exec

Open a do-git container shell or execute a command into a running do-git container

```bash
./exec.sh

or 

./exec.sh <git_command>
```

# Stop

Remove a running do-git container

```bash
./stop.sh
```

# Download folder from github repo using sparse-checkout

An embedded [script](Container-Root/gitcp.sh) within this container enables users to copy content of a specified path from a github repository to a destination folder. This functionality is implemented the github native [sparse-checkout](https://git-scm.com/docs/git-sparse-checkout) feature. 

The following example downloads the [linux](https://github.com/iankoulski/depend-on-docker/tree/master/linux) folder from the master branch of the [depend-on-docker](https://github.com/iankoulski/depend-on-docker) github repo:  

```bash
docker run -it --rm -v $(pwd)/..:/wd iankoulski/do-git /gitcp.sh https://github.com/iankoulski/depend-on-docker/tree/master/linux /wd/linux"
```

# License
Please see the [LICENSE](LICENSE) file for project license details
