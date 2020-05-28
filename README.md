Task Scheduler
==============

Overview
--------
Task Scheduler is a Fortran 2018 event-driven, asynchronous framework
that directs the parallel execution of Fortran subroutines in a
manner that respects various task dependencies described in a
directed acyclic graph.

Structure
---------
Task Scheduler is organized as a CMake [superbuild] of ExternalProjects
depicted in the following dependency tree:

```
task-scheduler
|--daglib
|  |
|--yaFyaml
   |-- gFTL-shared
       |-- gFTL
```

where

* [daglib] is a directed acyclic graph library,
* [yaFyaml] is a Fortran YAML API,
* [gFTL-shared] contains common gFTL containers of Fortran intrinsic types.
* [gFTL] is the Goddard Fortran Template Library, and

Each of the above packages is its own CMake `project` in a git submdodule
of task-scheduler.  As such, obtaining a useful copy of the current
repository requires a recursive git clone as shown below.

Downloading, Building, and Testing
----------------------------------
On Linux, macOS, or Windows Subsystem for Linux, execute the following
commands inside a `bash` shell or equivalent commands in another shell:

```bash
git clone --recursive git@github.com:sourceryinstitute/task-scheduler
mkdir -p task-scheduler/build
cd task-scheduler/build
export FC=gfortran
cmake ..
make -j -8
cd src/tests
ctest
```

[daglib]: https://github.com/sourceryinstitute/yaFyaml
[yaFyaml]: https://github.com/Goddard-Fortran-Ecosystem/yaFyaml
[gFTL]: https://github.com/Goddard-Fortran-Ecosystem/gFTL
[gFTL-shared]: https://github.com/Goddard-Fortran-Ecosystem/gFTL-shared
[superbuild]: https://blog.kitware.com/cmake-superbuilds-git-submodules
