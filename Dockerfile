FROM ghcr.io/rust-cross/manylinux_2_28-cross:x86_64

ARG MATURIN_VERSION=1.8

RUN apt-get update && \
    apt-get install --no-install-recommends -y \
    build-essential \
    mingw-w64

# Get Rust; NOTE: using sh for better compatibility with other base images
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y

# Add .cargo/bin to PATH
ENV PATH="/root/.cargo/bin:${PATH}"

RUN CC_x86_64_unknown_linux_gnu=gcc \
    AR_x86_64_unknown_linux_gnu=ar \
    CARGO_TARGET_X86_64_UNKNOWN_LINUX_GNU_LINKER=gcc \
    cargo install --locked cargo-xwin

RUN rustup component add llvm-tools-preview \
  && rustup target add x86_64-pc-windows-gnu x86_64-unknown-linux-gnu

RUN set -e; \
    for VER in 3.14 3.13 3.12 3.11 3.10; do "python$VER" -m pip install --no-cache-dir maturin==${MATURIN_VERSION}; done \
  && mkdir /io

WORKDIR /io
