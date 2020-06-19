foreach(name nested-objects)
  add_executable (test-${name} test-${name}.f90)

  target_link_libraries (test-${name}
    PRIVATE yafyaml
  )

  file(COPY ${name}.json DESTINATION ${CMAKE_CURRENT_BINARY_DIR})
endforeach()
