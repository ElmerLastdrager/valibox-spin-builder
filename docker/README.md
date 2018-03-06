This directory contains the docker files to compile SPIN using a docker environment.
In this way, you do not need to install any dependencies that are needed to compile.

The following files were tested on MacOS 10.13 and Linux (Ubuntu 16.04).

# Quick start

Options needed:
- build all targets
- build cache
- 





# Bugs
- Cannot make openwrt on macos filesystem: case insensitive.
  -> need to make at linux and then move final files in place
- Distinguish intermediate directories (cache) and final output (build)
- Stop on error
- Gebruik git reset ipv checkout (checkout alleen branch, reset juist commit). Check op sha1 hash? Kan reset branch aan?
