! scheduler-algorithm-sketch.f90
!
! -- A Parallel team scheduler demonstration program in Fortran 2018:
!    Image 1 asynchronously gets and prints task_results defined by every image.
!
! The program uses event post, query, and wait defined by a  Fortran 2018.

module task_mod
  implicit none

  private

  integer, parameter :: no_work = 0

  type, public :: task_t
    private
    integer :: identifier_ = no_work
  contains
    procedure do_work
  end type

  interface task_t
    module procedure new_task
  end interface

  interface

    module function new_task(identifier)
      implicit none
      integer, intent(in) :: identifier
      type(task_t) new_task
    end function

    module subroutine do_work(this, verbose)
      implicit none
      class(task_t), intent(in) :: this
      logical, intent(in), optional :: verbose
    end subroutine

  end interface

end module
