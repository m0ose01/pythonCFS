cmake_minimum_required(VERSION 3.22)
project(${SKBUILD_PROJECT_NAME} LANGUAGES C)

find_package(
	Python
	COMPONENTS Interpreter Development.Module
	REQUIRED
	)

set(C_LIB_PATH "extern/CFS")
add_subdirectory("${C_LIB_PATH}")
