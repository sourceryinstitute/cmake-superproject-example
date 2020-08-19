add_executable(test-ordered-compute
  test-ordered-compute.f90
)
target_link_libraries(test-ordered-compute
  PRIVATE yafyaml
)
target_link_libraries(test-ordered-compute
  PRIVATE dag
)
