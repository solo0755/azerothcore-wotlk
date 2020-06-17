set(scripts_STAT_SRCS
  ${scripts_STAT_SRCS}
  ${AC_SCRIPTS_DIR}/Custom/example_command.cpp
  ${AC_SCRIPTS_DIR}/Custom/example_creature.cpp
  ${AC_SCRIPTS_DIR}/Custom/example_item.cpp
  ${AC_SCRIPTS_DIR}/Custom/example_world.cpp
)

AC_ADD_SCRIPT_LOADER("Custom" "ScriptLoader.h")

message("  -> Prepared: My custom scripts")