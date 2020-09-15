
program main
  !!  Test the distribution and execution of independent tasks:
  !!  A scheduler image asynchronously puts tasks on the compute images, which
  !!  complete the task by invoking its do_work type-bound procedure.  Each
  !!  compute awaits a task, completes the task, and then notifies the scheduler
  !!  image that the compute image is ready for the next task.
  use iso_fortran_env, only : event_type
  use task_mod, only : task_t
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

        verify_task_completion: &
        do image=1, ni
          if (image /= scheduler_image) event wait(ready_for_next_task(image))
        end do verify_task_completion
      end block

      print *,"Test passed."
    end if

  end associate

end program
