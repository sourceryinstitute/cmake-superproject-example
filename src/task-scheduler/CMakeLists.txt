add_library(team_scheduler
  scheduled-team-interface.f90
  scheduled-team-implementation.f90
)
target_link_libraries(team_scheduler
  PRIVATE dag
)
