cmake_minimum_required(VERSION 3.22)
project(${SKBUILD_PROJECT_NAME} LANGUAGES C)

set(C_LIB_PATH "extern/CFS")
add_subdirectory("${C_LIB_PATH}")

find_package(
	Python
	COMPONENTS Interpreter Development.Module
	REQUIRED
	)


set(api_module_name api)
set(cfsapi_path "src/CFS/${api_module_name}")

add_custom_command(
  OUTPUT ${cfsapi_path}.c
  COMMAND Python::Interpreter -m cython
  "${CMAKE_CURRENT_SOURCE_DIR}/${cfsapi_path}.pyx" --output-file ${cfsapi_path}.c
  DEPENDS ${cfsapi_path}.pyx
  VERBATIM)

python_add_library(${api_module_name} MODULE ${cfsapi_path}.c WITH_SOABI)
set_property(TARGET cfsapi_static PROPERTY POSITION_INDEPENDENT_CODE ON)
target_link_libraries(${api_module_name} PUBLIC cfsapi_static)

install(TARGETS ${api_module_name} DESTINATION ${SKBUILD_PROJECT_NAME})
