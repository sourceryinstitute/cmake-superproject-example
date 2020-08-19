module scheduled_team_interface
  use iso_fortran_env, only : team_type
  implicit none

  type, extends(team_type) :: scheduled_team_t
  end type

  interface scheduled_team_t
    module procedure new_scheduled_team_t
  end interface

  interface
    module function construct_from_dag(team_dag)  result(new_scheduled_team_t)
      use dag_interface, only : dag
      type(dag), intent(in) :: team_dag
      type(scheduled_team_t) construct_from_dag
    end function
  end interface
end module scheduled_team_interface
