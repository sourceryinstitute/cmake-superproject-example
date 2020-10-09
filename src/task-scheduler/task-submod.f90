submodule(task_mod) task_submod
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
