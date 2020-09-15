add_library(team_scheduler
  scheduled-team-mod.f90
  scheduled-team-submod.f90
  task-mod.f90
  task-submod.f90
)
target_link_libraries(team_scheduler
  PRIVATE dag
)
