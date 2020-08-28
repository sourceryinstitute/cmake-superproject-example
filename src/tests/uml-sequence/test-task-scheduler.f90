program task_scheduler
  use scheduled_team_interface, only : scheduled_team_t
  implicit none

  type(scheduled_team_t) squad
  integer, parameter :: all_images=1

  squad = scheduled_team_t( dag_t( reshape([integer::], [0,0]) )

  form team(all_images, squad)
  change team(squad)

    if (this_image_schedules()) then

    else

    end if

  end team

  sync all
  if (this_image()==1) print *,"Test passed."

end program
