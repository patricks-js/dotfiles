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

for driver in "${intel_drivers_lst[@]}"; do
  install_package_pacman "$driver"
done

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
  "webp"
  "ffmpegthumbs"
)

for codec in "${codecs_lts[@]}"; do
  install_package_pacman "$codec"
done
