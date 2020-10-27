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
|--dag
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

Downloading, Building, Installing, and Testing
----------------------------------------------
On Linux, macOS, or Windows Subsystem for Linux, execute the following
commands inside `bash` or Z shell or equivalent commands in another shell:
```bash
git clone --recursive git@github.com:sourceryinstitute/task-scheduler
mkdir -p task-scheduler/build
cd task-scheduler/build
export FC=gfortran
cmake .. -DCMAKE_INSTALL_PREFIX=${PWD}/install
make -j 8
cd src
ctest
make install
```
where the `-D` argument may be omitted if the user has the write
privileges for the default installation path, which might necessitate
replacing the final line with `sudo make install`.  If any of the
above steps fails, including if any tests fail, please submit an [issue].

[dag]: https://github.com/sourceryinstitute/dag
[yaFyaml]: https://github.com/Goddard-Fortran-Ecosystem/yaFyaml
[gFTL]: https://github.com/Goddard-Fortran-Ecosystem/gFTL
[gFTL-shared]: https://github.com/Goddard-Fortran-Ecosystem/gFTL-shared
[superbuild]: https://blog.kitware.com/cmake-superbuilds-git-submodules
[issue]: https://github.com/sourceryinstitute/task-scheduler/issues
