cmake_minimum_required(VERSION 3.12)

project(TaskScheduler
  LANGUAGES Fortran
)

include(ExternalProject)
set(installDir ${CMAKE_CURRENT_BINARY_DIR}/install)

ExternalProject_Add(gFTL
 SOURCE_DIR ${PROJECT_SOURCE_DIR}/git-submodules/gFTL-shared/extern/gFTL
 INSTALL_DIR ${installDir}
 CMAKE_ARGS -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>
            -DCMAKE_PREFIX_PATH:PATH=<INSTALL_DIR>
)

ExternalProject_Add(gFTL_shared
 SOURCE_DIR ${PROJECT_SOURCE_DIR}/git-submodules/gFTL-shared
 INSTALL_DIR ${installDir}
 CMAKE_ARGS -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>
            -DCMAKE_PREFIX_PATH:PATH=<INSTALL_DIR>
 DEPENDS gFTL
)

ExternalProject_Add(yaFyaml
 SOURCE_DIR ${PROJECT_SOURCE_DIR}/git-submodules/yaFyaml
 INSTALL_DIR ${installDir}
 CMAKE_ARGS -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>
            -DCMAKE_PREFIX_PATH:PATH=<INSTALL_DIR>
 DEPENDS gFTL_shared gFTL
)

ExternalProject_Add(dag
 SOURCE_DIR ${PROJECT_SOURCE_DIR}/git-submodules/dag
 INSTALL_DIR ${installDir}
 CMAKE_ARGS -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>
            -DCMAKE_PREFIX_PATH:PATH=<INSTALL_DIR>
 DEPENDS yaFyaml
)

# Making the src directory an external project ensures that it is
# configured only after the dependencies are ready.
ExternalProject_Add(src
  SOURCE_DIR "${PROJECT_SOURCE_DIR}/src"
  BINARY_DIR "${PROJECT_BINARY_DIR}/src"
  DEPENDS dag yaFyaml
  CMAKE_ARGS -DYAFYAML_ROOT=${installDir} # YAFYAML case matches find_package call in src
             -DCMAKE_PREFIX_PATH:PATH=${installDir}
  INSTALL_COMMAND ""
)
