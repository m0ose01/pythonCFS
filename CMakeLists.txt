cmake_minimum_required(VERSION 3.22)
project(${SKBUILD_PROJECT_NAME} LANGUAGES C)

set(C_LIB_PATH "extern/CFS")
add_subdirectory("${C_LIB_PATH}")
set_property(TARGET cfsapi_static PROPERTY POSITION_INDEPENDENT_CODE ON)

find_package(
	Python
	COMPONENTS Interpreter Development.Module
	REQUIRED
	)


list(APPEND python_modules constants routines)
foreach(current_module_name IN LISTS python_modules)
set(cfsapi_path "src/CFS/${current_module_name}")

	add_custom_command(
		OUTPUT ${cfsapi_path}.c
		COMMAND Python::Interpreter -m cython
		"${CMAKE_CURRENT_SOURCE_DIR}/${cfsapi_path}.pyx" --output-file ${cfsapi_path}.c
		DEPENDS ${cfsapi_path}.pyx
		VERBATIM)

	python_add_library(${current_module_name} MODULE ${cfsapi_path}.c WITH_SOABI)
	target_link_libraries(${current_module_name} PUBLIC cfsapi_static)

	install(TARGETS ${current_module_name} DESTINATION ${SKBUILD_PROJECT_NAME})
endforeach()
