#!/usr/bin/env bash
# Build GuppyScreen and guppybeep for MIPS (Ingenic X2000) using rosette-build container
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

DOCKER_IMAGE="${ROSETTEOS_BUILD_IMAGE:-rosette-build:latest}"

build_inside_container() {
    echo "=== Building GuppyScreen for MIPS (inside build environment) ==="
    if [ -n "${GUPPYSCREEN_TOOLCHAIN_BIN:-}" ]; then
        export PATH="${GUPPYSCREEN_TOOLCHAIN_BIN}:${PATH}"
    fi

    export ROSETTEOS_VERSION="${ROSETTEOS_VERSION:-1.0.0}"
    export GUPPY_THEME="${GUPPY_THEME:-blue}"

    echo "== Building native client and logging libraries =="
    make wpaclient
    make libhv.a
    make libspdlog.a

    echo "== Cross-compiling for MIPS =="
    bash scripts/build-mips.sh

    echo "== Stripping MIPS binaries =="
    mipsel-linux-strip build/bin/guppyscreen build/bin/guppybeep

    echo "=== Build finished successfully ==="
    file build/bin/guppyscreen
    file build/bin/guppybeep
}

# If already inside the container with MIPS toolchain available
if [ -n "${GUPPYSCREEN_TOOLCHAIN_BIN:-}" ] || [ -f /.dockerenv ]; then
    build_inside_container
    exit 0
fi

# Otherwise, run inside rosette-build Docker container
if ! command -v docker >/dev/null 2>&1; then
    echo "ERROR: Docker is required to build with the rosette-build toolchain." >&2
    exit 1
fi

echo "=== Launching GuppyScreen MIPS build in ${DOCKER_IMAGE} ==="
# Check if docker image exists locally or fallback to canonical ghcr image
if ! docker image inspect "${DOCKER_IMAGE}" >/dev/null 2>&1; then
    if docker image inspect ghcr.io/rosetteos/rosetteos-build >/dev/null 2>&1; then
        DOCKER_IMAGE="ghcr.io/rosetteos/rosetteos-build"
    elif docker image inspect ghcr.io/openklipperedition/openke-build >/dev/null 2>&1; then
        DOCKER_IMAGE="ghcr.io/openklipperedition/openke-build"
    else
        echo "Pulling ${DOCKER_IMAGE}..."
        docker pull "${DOCKER_IMAGE}" || true
    fi
fi

docker run --rm \
    -u "$(id -u):$(id -g)" \
    -v "${SCRIPT_DIR}:/work" \
    -w /work \
    -e ROSETTEOS_VERSION="${ROSETTEOS_VERSION:-1.0.0}" \
    -e GUPPY_THEME="${GUPPY_THEME:-blue}" \
    "${DOCKER_IMAGE}" \
    "export PATH=\"\$GUPPYSCREEN_TOOLCHAIN_BIN:\$PATH\" && make wpaclient && make libhv.a && make libspdlog.a && bash scripts/build-mips.sh && mipsel-linux-strip build/bin/guppyscreen build/bin/guppybeep"

echo "=== MIPS build completed successfully ==="
file build/bin/guppyscreen
file build/bin/guppybeep
