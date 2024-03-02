#!/bin/bash
#|---/ /+--------------------------+---/ /|#
#|--/ /-| Drivers List             |--/ /-|#
#|-/ /--| @_patrick.js             |-/ /--|#
#|/ /---+--------------------------+/ /---|#

# ------------------------------------------------------
# ? Intel drivers
# ------------------------------------------------------

intel_drivers_lst=(
  "mesa"
  "lib32-mesa"
  "libva-mesa-driver"
  "lib32-libva-mesa-driver"
  "vulkan-intel"
  "lib32-vulkan-intel"
  "intel-media-driver"
)

install_package_pacman "${intel_drivers_lst[@]}"

# ------------------------------------------------------
# ? Media codecs
# ------------------------------------------------------

codecs_lts=(
  "ffmpeg"
  "gst-plugins-base"
  "gst-plugins-good"
  "gst-plugins-ugly"
  "gst-plugins-bad"
  "gst-libav"
  "gstreamer"
  "libvorbis"
  "libdv"
  "libjpeg-turbo"
  "libpng"
  "giflib"
  "libwebp"
  "ffmpegthumbs"
)

install_package_pacman "${codecs_lts[@]}"
