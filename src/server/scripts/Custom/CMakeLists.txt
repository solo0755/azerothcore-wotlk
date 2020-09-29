set(scripts_STAT_SRCS
  ${scripts_STAT_SRCS}
  ${AC_SCRIPTS_DIR}/Custom/Reforging/Reforger.cpp
  ${AC_SCRIPTS_DIR}/Custom/example_command.cpp
  ${AC_SCRIPTS_DIR}/Custom/example_creature.cpp
  ${AC_SCRIPTS_DIR}/Custom/example_item.cpp
  ${AC_SCRIPTS_DIR}/Custom/example_world.cpp
  ${AC_SCRIPTS_DIR}/Custom/PzxMgr.cpp
  ${AC_SCRIPTS_DIR}/Custom/PzxMgr.h
  ${AC_SCRIPTS_DIR}/Custom/syntheisTrainerNpc.cpp
)

AC_ADD_SCRIPT_LOADER("Custom" "ScriptLoader.h")

message("  -> Prepared: My custom scripts")