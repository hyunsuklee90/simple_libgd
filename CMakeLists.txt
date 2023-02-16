
cmake_minimum_required( VERSION 3.3.2)

# set compilers
# set (CMAKE_FORTRAN_COMPILER       ifort      )

set (PROJECT "fort_call_c")

project (${PROJECT} Fortran)

file(GLOB SRC ${PROJECT_SOURCE_DIR}/src/*.f90 )

include_directories (${CMAKE_SOURCE_DIR}/include )

add_executable(${PROJECT} ${SRC})

add_subdirectory (${PROJECT_SOURCE_DIR}/simple_libgd)
target_link_libraries(${PROJECT} gd_static)
# set_target_properties (gd PROPERTIES)
set_target_properties (gd_static PROPERTIES LINKER_LANGUAGE C)
include_directories(${PROJECT_BINARY_DIR}/simple_libgd/Bin)

