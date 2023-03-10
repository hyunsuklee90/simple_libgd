CMAKE_MINIMUM_REQUIRED(VERSION 3.7 FATAL_ERROR)
project(GD)
SET(PACKAGE GD)
SET(PACKAGE_NAME GD)

SET(CMAKE_MODULE_PATH "${GD_SOURCE_DIR}/cmake/modules")

include(gd)

# DO NOT CHANGE OPTION!
OPTION(ENABLE_CPP "Enable CPP GD API" 1)
# OPTION(ENABLE_GD_FORMATS "Enable GD image formats" 0)
# OPTION(ENABLE_PNG "Enable PNG support" 0)
# OPTION(ENABLE_LIQ "Enable libimagequant support" 0)
# OPTION(ENABLE_JPEG "Enable JPEG support" 0)
# OPTION(ENABLE_TIFF "Enable TIFF support" 0)
# OPTION(ENABLE_ICONV "Enable ICONV support" 0)
# OPTION(ENABLE_XPM "Enable XPM support" 0)
OPTION(ENABLE_FREETYPE "Enable Freetype2 support" 0)
# OPTION(ENABLE_FONTCONFIG "Enable FontConfig support" 0)
# OPTION(ENABLE_WEBP "Enable WebP support" 0)
# OPTION(ENABLE_HEIF "Enable HEIF support" 0)
# OPTION(ENABLE_AVIF "Enable AVIF support" 0)
# OPTION(ENABLE_RAQM "Enable RAQM support" 0)
# OPTION(ENABLE_ASAN "Enable (gcc) ASAN support" 0)
OPTION(VERBOSE_MAKEFILE "Enable CMAKE_VERBOSE_MAKEFILE" 1)

if (VERBOSE_MAKEFILE)
	set(CMAKE_VERBOSE_MAKEFILE ON)
endif (VERBOSE_MAKEFILE)

if (ENABLE_FREETYPE) 
    add_definitions(-DHAVE_LIBFREETYPE)
endif()
# if you would like to pass C flags to the compiler, then just
# - specify -DCMAKE_C_FLAGS=... on invocation of cmake, or
# - specify CFLAGS=... on invocation of make
IF(CMAKE_COMPILER_IS_GNUCC)
  # Re-enable sanitize once we find a way to filter out errors in external libraries (like HEIF)
  if (ENABLE_ASAN)
  	SET(CMAKE_C_FLAGS_DEBUG "-g -Wall -Wextra -O0 -fsanitize=address") # will be added to CMAKE_C_FLAGS when CMAKE_BUILD_TYPE is Debug
  else (ENABLE_ASAN)
  	SET(CMAKE_C_FLAGS_DEBUG "-g -Wall -Wextra -O0 ") # will be added to CMAKE_C_FLAGS when CMAKE_BUILD_TYPE is Debug
  endif (ENABLE_ASAN)
ENDIF(CMAKE_COMPILER_IS_GNUCC)
SET (CMAKE_LIBRARY_OUTPUT_DIRECTORY
  ${PROJECT_BINARY_DIR}/Bin
  CACHE PATH
  "Single Directory for all Libraries"
  )

# --------- Setup the Executable output Directory -------------
SET (CMAKE_RUNTIME_OUTPUT_DIRECTORY
  ${PROJECT_BINARY_DIR}/Bin
  CACHE PATH
  "Single Directory for all Executables."
  )

# --------- Setup the Executable output Directory -------------
SET (CMAKE_ARCHIVE_OUTPUT_DIRECTORY
  ${PROJECT_BINARY_DIR}/Bin
  CACHE PATH
  "Single Directory for all static libraries."
  )

SET(PKG_REQUIRES_PRIVATES "")

MACRO(GV VER VAR)
	file (STRINGS "src/gd.h" _VERSION_LINE REGEX "define[ ]+GD_${VER}_VERSION")
	if ( _VERSION_LINE )
		string ( REGEX REPLACE ".*define[ ]+GD_${VER}_VERSION[ ]+\"?([^ \"]*)\"?[ ]+.*" "\\1" ${VAR} "${_VERSION_LINE}" )
	endif ()
ENDMACRO(GV)

GV(MAJOR GDLIB_MAJOR)
GV(MINOR GDLIB_MINOR)
GV(RELEASE GDLIB_REVISION)
GV(EXTRA GDLIB_EXTRA)
SET(GDLIB_VERSION "${GDLIB_MAJOR}.${GDLIB_MINOR}.${GDLIB_REVISION}${GDLIB_EXTRA}")
MESSAGE(STATUS "gd version ${GDLIB_VERSION}")

MACRO(GV_LT VER VAR)
	execute_process(
		COMMAND sh ${CMAKE_CURRENT_SOURCE_DIR}/config/getlib.sh ${VER}
		OUTPUT_VARIABLE ${VAR}
	)
ENDMACRO(GV_LT)

GV_LT(SONAME GDLIB_LIB_SOVERSION)
GV_LT(VERSION GDLIB_LIB_VERSION)
MESSAGE(STATUS "gd shared lib version ${GDLIB_LIB_SOVERSION} (${GDLIB_LIB_VERSION})")

include(CheckIncludeFiles)
include(CheckIncludeFile)

SET(ENABLE_CPP_API 1)

IF (NOT WIN32)
	FIND_PACKAGE(PTHREAD)
ENDIF (NOT WIN32)

SET(ENABLE_GD_FORMATS ${ENABLE_GD_FORMATS})

SET(FONTCONFIG_LIBRARY "")
SET(FONTCONFIG_INCLUDE_DIR "")
SET(FONTCONFIG_LIB_DIR "")

string(REPLACE ";" ", " PKG_REQUIRES_PRIVATES "${PKG_REQUIRES_PRIVATES}")

SET(HAVE_CONFIG_H 1)

CHECK_INCLUDE_FILE("stdint.h"	HAVE_STDINT_H)
CHECK_INCLUDE_FILE("inttypes.h"	HAVE_INTTYPES_H)

ADD_DEFINITIONS(-DHAVE_CONFIG_H)
CONFIGURE_FILE(${GD_SOURCE_DIR}/src/config.h.cmake ${CMAKE_CURRENT_BINARY_DIR}/src/config.h ESCAPE_QUOTES)
include_directories(${CMAKE_CURRENT_BINARY_DIR}/src)

option(BUILD_SHARED_LIBS "Build shared libs" OFF )
option(BUILD_STATIC_LIBS "Build static libs" ON )

if (WIN32)
	SET(GD_LIB libgd)
	SET(GD_LIB gd)
	ADD_DEFINITIONS( -DWIN32 -D_WIN32 -DMSWIN32 -DBGDWIN32 -DWINVER=0x0500  -D_WIN32_WINNT=0x0500 -D_WIN32_IE=0x0600)

	if(NOT MINGW AND MSVC_VERSION GREATER 1399)
		ADD_DEFINITIONS("/D_CRT_SECURE_NO_DEPRECATE")
	endif(NOT MINGW AND MSVC_VERSION GREATER 1399)
	if (MINGW OR MSYS)
		SET(GD_LIB gd)
		ADD_DEFINITIONS("-mms-bitfields") # -m32
	endif (MINGW OR MSYS)
else (WIN32)
	SET(GD_LIB gd)
	# SET(GD_LIB libgd)
endif (WIN32)

SET(GD_LIB_STATIC "${GD_LIB}_static")

IF(PROFILE)
	add_definitions("-pg")
	set(CMAKE_EXE_LINKER_FLAGS ${LINK_FLAGS} "-pg")
ENDIF(PROFILE)

SET(GD_INCLUDE_DIR "${GD_SOURCE_DIR}/src" "${GD_SOURCE_DIR}")
INCLUDE_DIRECTORIES(before ${FONTCONFIG_INCLUDE_DIR})

add_subdirectory(src)

SET(CPACK_PACKAGE_NAME "libgd")
SET(CPACK_PACKAGE_DESCRIPTION_SUMMARY "libGD, powerful and easy to use graphic library")
SET(CPACK_PACKAGE_VENDOR "https://www.libgd.org")
SET(CPACK_PACKAGE_VERSION_MAJOR ${GDLIB_MAJOR})
SET(CPACK_PACKAGE_VERSION_MINOR ${GDLIB_MINOR})
SET(CPACK_PACKAGE_VERSION_PATCH ${GDLIB_REVISION}${GDLIB_EXTRA})

if(WIN32)
	set(CPACK_GENERATOR ZIP)
else(WIN32)
	set(CPACK_GENERATOR TGZ)
endif(WIN32)

# set(CPACK_RESOURCE_FILE_LICENSE "${CMAKE_SOURCE_DIR}/COPYING")

set(CPACK_SOURCE_GENERATOR TGZ)
set(CPACK_SOURCE_IGNORE_FILES
"~$"
"\\\\.swp$"
"\\\\.gitignore$"
"^${PROJECT_SOURCE_DIR}/debian/"
"^${PROJECT_SOURCE_DIR}/old/"
"^${PROJECT_SOURCE_DIR}/bld/"
)
# install(FILES ${top_level_DOCFILES} DESTINATION ${DOC_DIR})
INCLUDE(CPack)
