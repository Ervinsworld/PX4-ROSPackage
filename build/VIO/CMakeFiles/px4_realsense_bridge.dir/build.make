# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.10

# Delete rule output on recipe failure.
.DELETE_ON_ERROR:


#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:


# Remove some rules from gmake that .SUFFIXES does not remove.
SUFFIXES =

.SUFFIXES: .hpux_make_needs_suffix_list


# Suppress display of executed commands.
$(VERBOSE).SILENT:


# A target that is always out of date.
cmake_force:

.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = /usr/bin/cmake

# The command to remove a file.
RM = /usr/bin/cmake -E remove -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /home/ervin/drone_ws/src

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /home/ervin/drone_ws/build

# Include any dependencies generated for this target.
include VIO/CMakeFiles/px4_realsense_bridge.dir/depend.make

# Include the progress variables for this target.
include VIO/CMakeFiles/px4_realsense_bridge.dir/progress.make

# Include the compile flags for this target's objects.
include VIO/CMakeFiles/px4_realsense_bridge.dir/flags.make

VIO/CMakeFiles/px4_realsense_bridge.dir/src/nodes/px4_realsense_bridge.cpp.o: VIO/CMakeFiles/px4_realsense_bridge.dir/flags.make
VIO/CMakeFiles/px4_realsense_bridge.dir/src/nodes/px4_realsense_bridge.cpp.o: /home/ervin/drone_ws/src/VIO/src/nodes/px4_realsense_bridge.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/ervin/drone_ws/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building CXX object VIO/CMakeFiles/px4_realsense_bridge.dir/src/nodes/px4_realsense_bridge.cpp.o"
	cd /home/ervin/drone_ws/build/VIO && /usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/px4_realsense_bridge.dir/src/nodes/px4_realsense_bridge.cpp.o -c /home/ervin/drone_ws/src/VIO/src/nodes/px4_realsense_bridge.cpp

VIO/CMakeFiles/px4_realsense_bridge.dir/src/nodes/px4_realsense_bridge.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/px4_realsense_bridge.dir/src/nodes/px4_realsense_bridge.cpp.i"
	cd /home/ervin/drone_ws/build/VIO && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/ervin/drone_ws/src/VIO/src/nodes/px4_realsense_bridge.cpp > CMakeFiles/px4_realsense_bridge.dir/src/nodes/px4_realsense_bridge.cpp.i

VIO/CMakeFiles/px4_realsense_bridge.dir/src/nodes/px4_realsense_bridge.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/px4_realsense_bridge.dir/src/nodes/px4_realsense_bridge.cpp.s"
	cd /home/ervin/drone_ws/build/VIO && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/ervin/drone_ws/src/VIO/src/nodes/px4_realsense_bridge.cpp -o CMakeFiles/px4_realsense_bridge.dir/src/nodes/px4_realsense_bridge.cpp.s

VIO/CMakeFiles/px4_realsense_bridge.dir/src/nodes/px4_realsense_bridge.cpp.o.requires:

.PHONY : VIO/CMakeFiles/px4_realsense_bridge.dir/src/nodes/px4_realsense_bridge.cpp.o.requires

VIO/CMakeFiles/px4_realsense_bridge.dir/src/nodes/px4_realsense_bridge.cpp.o.provides: VIO/CMakeFiles/px4_realsense_bridge.dir/src/nodes/px4_realsense_bridge.cpp.o.requires
	$(MAKE) -f VIO/CMakeFiles/px4_realsense_bridge.dir/build.make VIO/CMakeFiles/px4_realsense_bridge.dir/src/nodes/px4_realsense_bridge.cpp.o.provides.build
.PHONY : VIO/CMakeFiles/px4_realsense_bridge.dir/src/nodes/px4_realsense_bridge.cpp.o.provides

VIO/CMakeFiles/px4_realsense_bridge.dir/src/nodes/px4_realsense_bridge.cpp.o.provides.build: VIO/CMakeFiles/px4_realsense_bridge.dir/src/nodes/px4_realsense_bridge.cpp.o


VIO/CMakeFiles/px4_realsense_bridge.dir/src/nodes/px4_realsense_bridge_node.cpp.o: VIO/CMakeFiles/px4_realsense_bridge.dir/flags.make
VIO/CMakeFiles/px4_realsense_bridge.dir/src/nodes/px4_realsense_bridge_node.cpp.o: /home/ervin/drone_ws/src/VIO/src/nodes/px4_realsense_bridge_node.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/ervin/drone_ws/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Building CXX object VIO/CMakeFiles/px4_realsense_bridge.dir/src/nodes/px4_realsense_bridge_node.cpp.o"
	cd /home/ervin/drone_ws/build/VIO && /usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/px4_realsense_bridge.dir/src/nodes/px4_realsense_bridge_node.cpp.o -c /home/ervin/drone_ws/src/VIO/src/nodes/px4_realsense_bridge_node.cpp

VIO/CMakeFiles/px4_realsense_bridge.dir/src/nodes/px4_realsense_bridge_node.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/px4_realsense_bridge.dir/src/nodes/px4_realsense_bridge_node.cpp.i"
	cd /home/ervin/drone_ws/build/VIO && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/ervin/drone_ws/src/VIO/src/nodes/px4_realsense_bridge_node.cpp > CMakeFiles/px4_realsense_bridge.dir/src/nodes/px4_realsense_bridge_node.cpp.i

VIO/CMakeFiles/px4_realsense_bridge.dir/src/nodes/px4_realsense_bridge_node.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/px4_realsense_bridge.dir/src/nodes/px4_realsense_bridge_node.cpp.s"
	cd /home/ervin/drone_ws/build/VIO && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/ervin/drone_ws/src/VIO/src/nodes/px4_realsense_bridge_node.cpp -o CMakeFiles/px4_realsense_bridge.dir/src/nodes/px4_realsense_bridge_node.cpp.s

VIO/CMakeFiles/px4_realsense_bridge.dir/src/nodes/px4_realsense_bridge_node.cpp.o.requires:

.PHONY : VIO/CMakeFiles/px4_realsense_bridge.dir/src/nodes/px4_realsense_bridge_node.cpp.o.requires

VIO/CMakeFiles/px4_realsense_bridge.dir/src/nodes/px4_realsense_bridge_node.cpp.o.provides: VIO/CMakeFiles/px4_realsense_bridge.dir/src/nodes/px4_realsense_bridge_node.cpp.o.requires
	$(MAKE) -f VIO/CMakeFiles/px4_realsense_bridge.dir/build.make VIO/CMakeFiles/px4_realsense_bridge.dir/src/nodes/px4_realsense_bridge_node.cpp.o.provides.build
.PHONY : VIO/CMakeFiles/px4_realsense_bridge.dir/src/nodes/px4_realsense_bridge_node.cpp.o.provides

VIO/CMakeFiles/px4_realsense_bridge.dir/src/nodes/px4_realsense_bridge_node.cpp.o.provides.build: VIO/CMakeFiles/px4_realsense_bridge.dir/src/nodes/px4_realsense_bridge_node.cpp.o


# Object files for target px4_realsense_bridge
px4_realsense_bridge_OBJECTS = \
"CMakeFiles/px4_realsense_bridge.dir/src/nodes/px4_realsense_bridge.cpp.o" \
"CMakeFiles/px4_realsense_bridge.dir/src/nodes/px4_realsense_bridge_node.cpp.o"

# External object files for target px4_realsense_bridge
px4_realsense_bridge_EXTERNAL_OBJECTS =

/home/ervin/drone_ws/devel/lib/libpx4_realsense_bridge.so: VIO/CMakeFiles/px4_realsense_bridge.dir/src/nodes/px4_realsense_bridge.cpp.o
/home/ervin/drone_ws/devel/lib/libpx4_realsense_bridge.so: VIO/CMakeFiles/px4_realsense_bridge.dir/src/nodes/px4_realsense_bridge_node.cpp.o
/home/ervin/drone_ws/devel/lib/libpx4_realsense_bridge.so: VIO/CMakeFiles/px4_realsense_bridge.dir/build.make
/home/ervin/drone_ws/devel/lib/libpx4_realsense_bridge.so: VIO/CMakeFiles/px4_realsense_bridge.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/home/ervin/drone_ws/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_3) "Linking CXX shared library /home/ervin/drone_ws/devel/lib/libpx4_realsense_bridge.so"
	cd /home/ervin/drone_ws/build/VIO && $(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/px4_realsense_bridge.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
VIO/CMakeFiles/px4_realsense_bridge.dir/build: /home/ervin/drone_ws/devel/lib/libpx4_realsense_bridge.so

.PHONY : VIO/CMakeFiles/px4_realsense_bridge.dir/build

VIO/CMakeFiles/px4_realsense_bridge.dir/requires: VIO/CMakeFiles/px4_realsense_bridge.dir/src/nodes/px4_realsense_bridge.cpp.o.requires
VIO/CMakeFiles/px4_realsense_bridge.dir/requires: VIO/CMakeFiles/px4_realsense_bridge.dir/src/nodes/px4_realsense_bridge_node.cpp.o.requires

.PHONY : VIO/CMakeFiles/px4_realsense_bridge.dir/requires

VIO/CMakeFiles/px4_realsense_bridge.dir/clean:
	cd /home/ervin/drone_ws/build/VIO && $(CMAKE_COMMAND) -P CMakeFiles/px4_realsense_bridge.dir/cmake_clean.cmake
.PHONY : VIO/CMakeFiles/px4_realsense_bridge.dir/clean

VIO/CMakeFiles/px4_realsense_bridge.dir/depend:
	cd /home/ervin/drone_ws/build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/ervin/drone_ws/src /home/ervin/drone_ws/src/VIO /home/ervin/drone_ws/build /home/ervin/drone_ws/build/VIO /home/ervin/drone_ws/build/VIO/CMakeFiles/px4_realsense_bridge.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : VIO/CMakeFiles/px4_realsense_bridge.dir/depend

