target_sources(${MVP_PUBLIC} PUBLIC
  ${CMAKE_CURRENT_LIST_DIR}/status.cc
  ${CMAKE_CURRENT_LIST_DIR}/api_impl.cc
  ${CMAKE_CURRENT_LIST_DIR}/mvp_context.cc
  ${CMAKE_CURRENT_LIST_DIR}/mvp_impl.cc
  ${CMAKE_CURRENT_LIST_DIR}/mvp_priv_impl.cc
  ${CMAKE_CURRENT_LIST_DIR}/internal.cc
  ${CMAKE_CURRENT_LIST_DIR}/fpga_handler.cc
  ${CMAKE_CURRENT_LIST_DIR}/mod_switch.cc
  ${CMAKE_CURRENT_LIST_DIR}/util/common.cc
)
