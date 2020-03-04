add_library(star ${CMAKE_CURRENT_SOURCE_DIR}/star.f90)
add_executable(helloworld ${CMAKE_CURRENT_SOURCE_DIR}/helloworld.f90)
target_link_libraries(helloworld star)
install(FILES ${CMAKE_CURRENT_BINARY_DIR}/helloworld 
  PERMISSIONS OWNER_EXECUTE WORLD_EXECUTE GROUP_EXECUTE
  DESTINATION /opt)
