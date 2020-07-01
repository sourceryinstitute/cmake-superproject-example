add_executable(test-dependency-tree
  test-dependency-tree.f90
)
target_link_libraries(test-dependency-tree
  PRIVATE yafyaml
)
target_link_libraries(test-dependency-tree
  PRIVATE dag
)
