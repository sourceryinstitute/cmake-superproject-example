
program main
  !!  Test the distribution and execution of independent tasks:
  !!  A scheduler image asynchronously puts tasks on the compute images, which
  !!  complete the task by invoking its do_work type-bound procedure.  Each
  !!  compute awaits a task, completes the task, and then notifies the scheduler
  !!  image that the compute image is ready for the next task.
  use iso_fortran_env, only : event_type
  use task_mod, only : task_t
  implicit none

  type(event_type), allocatable :: ready_for_next_task(:)[:] ! used by compute image to notify scheduler of work availbility
  type(event_type), save :: task_assignment[*] ! used by scheduler to notify a compute image of an assigned task

  type(task_t) mailbox[*] ! scheduler image places a task on a remote compute image for pick-up
  integer, parameter :: scheduler=1, num_tasks = 3
  type(task_t) tasks(num_tasks) ! scheduler allocates the array of tasks for distribution


  associate( me=>this_image(), ni=>num_images() )

    allocate(ready_for_next_task(ni)[*])

    if (me/=scheduler) then
      call work_and_notify(mailbox, scheduler, task_assignment, ready_for_next_task)
    else ! scheduler
      tasks = [(task_t(identifier=i), i=1,size(tasks))]
      call distribute_initial_tasks(tasks, task_assignment, scheduler, mailbox)
    end if

    if (me==scheduler) then
      call verify_task_completion(scheduler, ready_for_next_task)
      print *,"Test passed."
    end if

  end associate

contains

  subroutine verify_task_completion(scheduler_image, ready)
    integer, intent(in) :: scheduler_image
    type(event_type), allocatable :: ready(:)[:] ! used by compute image to notify scheduler of work availbility
    integer image

    do image=1, num_images()
      if (image /= scheduler_image) event wait(ready(image))
    end do
  end subroutine

  subroutine work_and_notify(inbox, scheduler_image, my_assignment, ready)
    type(task_t), intent(in) :: inbox ! scheduler image places a task on a remote compute image for pick-up
    integer, intent(in) :: scheduler_image
    type(event_type), intent(inout) :: my_assignment[*] ! used by scheduler to notify a compute image of an assigned task
    type(event_type), intent(inout) :: ready(:)[:] ! used by compute image to notify scheduler of work availbility

    event wait( my_assignment ) ! atomically decrement task_assingment count
    call inbox%do_work()
    event post(ready(this_image())[scheduler_image])  ! atomically increments my ready_for_next_task on the scheduler image

  end subroutine

  subroutine distribute_initial_tasks(task_list, your_assignment, scheduler_image, inbox)
    use iso_fortran_env, only : event_type
    use task_mod, only : task_t
    type(task_t), intent(in) :: task_list(:)
    type(event_type), intent(inout) :: your_assignment[*] ! used by scheduler to notify a compute image of an assigned task
    type(task_t), intent(inout) :: inbox[*] ! scheduler image places a task on a remote compute image for pick-up
    integer, intent(in) :: scheduler_image
    integer task_num, image

    call assert(image == scheduler_image, "image == scheduler_image")

    task_num = 1
    do image = 1, num_images()
      if (scheduler_image==image) cycle
      if (task_num > size(task_list)) then
        inbox[image] = task_t() ! Put no-work tasks on remote image
      else
        inbox[image] = task_list(task_num) ! Put task on remote image
      end if
      event post(your_assignment[image]) ! Notify compute image of assigned task
      task_num = task_num + 1
    end do
  end subroutine

end program
