! scheduler-algorithm-sketch.f90
!
! -- A Parallel team scheduler demonstration program in Fortran 2018:
!    Image 1 asynchronously gets and prints task_results defined by every image.
!
! The program uses event post, query, and wait defined by a  Fortran 2018.

module task_interface
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

submodule(task_interface) task_implementation
  implicit none

contains

  module procedure new_task
    new_task%identifier_ = identifier
  end procedure

  module procedure do_work
    if (present(verbose)) then
      if (this%identifier_ == no_work) then
        print *, "Image", this_image(), "does no work"
      else
        print *, "Image", this_image(), "does work on task", this%identifier_
      end if
    end if
  end procedure

end submodule

program main
  use iso_fortran_env, only : event_type
  use task_interface, only : task_t
  implicit none

  type(event_type) :: task_assignment[*] ! used by scheduler to notify a compute image of an assigned task
  type(event_type), allocatable :: ready_for_next_task(:)[:] ! used by compute image to notify scheduler of work availbility

  type(task_t) inbox[*] ! scheduler image places a task on a remote compute image for pick-up
  type(task_t), allocatable :: task_list(:) ! scheduler allocats the array of tasks for distribution
  integer, parameter :: scheduler_image=1

  associate( me=>this_image(), ni=>num_images() )

    allocate(ready_for_next_task(ni)[*])

    if (me/=scheduler_image) then

      event wait( task_assignment ) ! atomically decrement task_assingment count
      call inbox%do_work()
      event post(ready_for_next_task(me)[scheduler_image])  ! atomically increments my ready_for_next_task on the scheduler image

    else ! scheduler

      block
        integer i, task_num, image
        integer, parameter :: num_tasks = 3

        task_list = [(task_t(identifier=i), i=1,num_tasks)]

        task_num = 1
        do image = 1, ni
          if (image /= scheduler_image) then
            if (task_num > size(task_list)) then
              inbox[image] = task_t() ! Put no-work tasks on remote image
            else
              inbox[image] = task_list(task_num) ! Put task on remote image
            end if
            event post(task_assignment[image]) ! Notify compute image of assigned task
            task_num = task_num + 1
          end if
        end do
      end block

    end if

    if (me==scheduler_image) then
      block
        integer image

        do image=1, ni
          if (image /= scheduler_image) event wait(ready_for_next_task(image))
        end do
      end block
      print *,"Test passed."
    end if

  end associate


end program
