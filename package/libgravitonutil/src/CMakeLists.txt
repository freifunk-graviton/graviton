cmake_minimum_required(VERSION 2.6)

set(CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR})

project(libgravitonutil C)

set(LIBDIR "lib${LIB_SUFFIX}")

find_package(JSON_C REQUIRED)

set_property(DIRECTORY PROPERTY COMPILE_DEFINITIONS _GNU_SOURCE)

add_library(gravitonutil SHARED libgravitonutil.c)
set_property(TARGET gravitonutil PROPERTY COMPILE_FLAGS "-Wall -std=c99 ${JSON_C_CFLAGS_OTHER}")
set_property(TARGET gravitonutil PROPERTY LINK_FLAGS "${JSON_C_LDFLAGS_OTHER}")
set_property(TARGET gravitonutil APPEND PROPERTY INCLUDE_DIRECTORIES ${JSON_C_INCLUDE_DIR})
target_link_libraries(gravitonutil ${JSON_C_LIBRARIES})
install(TARGETS gravitonutil
  ARCHIVE DESTINATION ${LIBDIR}
  LIBRARY DESTINATION ${LIBDIR}
)


install(FILES ${CMAKE_CURRENT_SOURCE_DIR}/libgravitonutil.h DESTINATION include)
