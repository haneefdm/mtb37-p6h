# Thin devcontainer layer on top of the base MTB tools image.
# Rebuild the base separately from the generated Dockerfile:
#   docker build --platform linux/amd64 \
#     -f /path/to/Dockerfile_generated -t mtb-tools:3.7-base .
#
# This layer adds only what's needed for VS Code Dev Containers:
#   - A non-root "vscode" user (required by remoteUser)
#   - /workspaces/mtb_shared with correct ownership (MTB puts shared libs here)
#   - PATH additions for MTB tools
FROM hdmdocker/mtb-tools:3.7-base

# Newer base images may default to a non-root user; switch to root for setup.
USER root

# ── Non-root user for VS Code ────────────────────────────────────────────────
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=${USER_UID}
RUN getent group ${USER_GID} >/dev/null || groupadd --gid ${USER_GID} ${USERNAME} \
    && id -u ${USERNAME} >/dev/null 2>&1 || useradd --uid ${USER_UID} --gid ${USER_GID} -m ${USERNAME} -s /bin/bash \
    && mkdir -p /etc/sudoers.d \
    && echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/${USERNAME} \
    && chmod 0440 /etc/sudoers.d/${USERNAME}

# ── Shared library directory for MTB build system ────────────────────────────
RUN mkdir -p /workspaces/mtb_shared \
    && chown ${USERNAME}:${USERNAME} /workspaces/mtb_shared

# ── PATH: MTB tools + GCC toolchain + programming tools ──────────────────────
ENV PATH="/opt/Tools/ModusToolbox/tools_3.7/bin:\
    /opt/Tools/mtb-gcc-arm-eabi/14.2.1/gcc/bin:\
    /opt/Tools/ModusToolboxProgtools-1.7/openocd/bin:\
    ${PATH}"
