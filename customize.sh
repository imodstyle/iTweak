SKIPUNZIP=1
SET_PERMISSION() {
ui_print "- Setting Permissions"
set_perm_recursive $MODPATH 0 0 0755 0644
set_perm_recursive $MODPATH/itweak.sh 0 0 0755 0700
}
MOD_EXTRACT() {
ui_print "- Extracting Module Files"
unzip -o "$ZIPFILE" itweak.sh -d $MODPATH >&2
unzip -o "$ZIPFILE" service.sh -d $MODPATH >&2
unzip -o "$ZIPFILE" module.prop -d $MODPATH >&2
}
MOD_PRINT() {
ui_print " --- Additional Notes ---"
ui_print ""
ui_print " * Reinstall to update the script"
ui_print " * Rebooting is not required"
ui_print " * Do not use with other optimizer modules"
}
set -x
MOD_PRINT
MOD_EXTRACT
SET_PERMISSION
