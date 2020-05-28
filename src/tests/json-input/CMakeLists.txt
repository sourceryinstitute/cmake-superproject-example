add_executable (test-json-input test-json-input.f90)

target_link_libraries (test-json-input
  PRIVATE yafyaml
)

file(COPY input.json DESTINATION ${CMAKE_CURRENT_BINARY_DIR})
