add_executable( test-independent-tasks
  test-independent-tasks.f90
)
target_link_libraries( test-independent-tasks
  PRIVATE team_scheduler
)
