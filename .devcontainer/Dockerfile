ARG UBUNTU_VERSION="24.04"


FROM ubuntu:${UBUNTU_VERSION} AS build
ENV DEBIAN_FRONTEND noninteractive

ARG GLIB_MAJOR_VERSION="2.83"
ARG GLIB_MINOR_VERSION="2"

RUN apt update \
    && apt install -y git build-essential wget python3 python3-pip python3-setuptools \
    python3-wheel ninja-build pkg-config \
    && pip3 install meson --break-system-packages

# https://download.gnome.org/sources/glib/?C=M&O=D
RUN wget https://download.gnome.org/sources/glib/${GLIB_MAJOR_VERSION}/glib-${GLIB_MAJOR_VERSION}.${GLIB_MINOR_VERSION}.tar.xz \
    && tar -xvf glib-${GLIB_MAJOR_VERSION}.${GLIB_MINOR_VERSION}.tar.xz \
    && cd glib-${GLIB_MAJOR_VERSION}.${GLIB_MINOR_VERSION} \
    && meson setup --prefix=/usr -Ddefault_library=both _build \
    && meson compile -C _build \
    && meson install -C _build



FROM ubuntu:${UBUNTU_VERSION}

ENV DEBIAN_FRONTEND noninteractive

RUN apt update \
    && apt install -y clang clangd cmake \
    curl file gdb git make wget pkg-config

COPY --from=build /usr/include/glib-2.0/ /usr/include/glib-2.0
COPY --from=build /usr/lib/x86_64-linux-gnu/ /usr/lib/x86_64-linux-gnu
COPY --from=build /usr/share/glib-2.0/ /usr/share/glib-2.0

ENTRYPOINT [ "/bin/bash" ]