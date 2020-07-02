cmake_minimum_required(VERSION 3.12)

project(task_scheduler
  LANGUAGES Fortran
)

find_package(DAGLIB REQUIRED)
find_package(GFTL REQUIRED)
find_package(GFTL_SHARED REQUIRED VERSION 1.0.4)
find_package(YAFYAML REQUIRED)

get_filename_component(barename ${CMAKE_Fortran_COMPILER} NAME)

if(CMAKE_Fortran_COMPILER_ID MATCHES GNU)
  set(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -Wall -std=f2018")
  if("${barename}" MATCHES gfortran)
    set(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -fcoarray=single")
  endif()
endif()

set(CMAKE_Fortran_MODULE_DIRECTORY "${PROJECT_BINARY_DIR}/mod")

enable_testing()

add_subdirectory(tests)
