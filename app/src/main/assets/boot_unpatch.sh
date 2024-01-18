#!/system/bin/sh
#######################################################################################
# APatch Boot Image Unpatcher
#######################################################################################

getdir() {
  case "$1" in
    */*)
      dir=${1%/*}
      if [ ! -d $dir ]; then
        echo "/"
      else
        echo $dir
      fi
    ;;
    *) echo "." ;;
  esac
}

# Switch to the location of the script file
cd "$(getdir "${BASH_SOURCE:-$0}")"

# Load utility functions
. ./util_functions.sh

echo "APatch Boot Image Unpatcher"

BOOTIMAGE=$1
BACKUPDIR="../backup"
BACKUPIMAGE="$BACKUPDIR/boot.img"

if [ -z "$BOOTIMAGE" ]; then
  if [ ! -f "$BACKUPIMAGE" ]; then
    echo "Boot unpatch is not possible!"
    exit 1
  fi
  find_boot_image
fi

[ -e "$BOOTIMAGE" ] || { echo "$BOOTIMAGE does not exist!"; exit 1; }

echo "- Target image: $BOOTIMAGE"

echo "- Flashing original boot image"
flash_image "$BACKUPIMAGE" "$BOOTIMAGE"

if [ $? -ne 0 ]; then
  echo "Flash error: $?"
  exit $?
fi

# Reset any error code
true
