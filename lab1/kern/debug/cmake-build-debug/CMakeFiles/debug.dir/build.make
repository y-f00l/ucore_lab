# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.17

# Delete rule output on recipe failure.
.DELETE_ON_ERROR:


#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:


# Disable VCS-based implicit rules.
% : %,v


# Disable VCS-based implicit rules.
% : RCS/%


# Disable VCS-based implicit rules.
% : RCS/%,v


# Disable VCS-based implicit rules.
% : SCCS/s.%


# Disable VCS-based implicit rules.
% : s.%


.SUFFIXES: .hpux_make_needs_suffix_list


# Command-line flag to silence nested $(MAKE).
$(VERBOSE)MAKESILENT = -s

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
CMAKE_COMMAND = /home/g1ft/Desktop/CLion-2020.2/clion-2020.2/bin/cmake/linux/bin/cmake

# The command to remove a file.
RM = /home/g1ft/Desktop/CLion-2020.2/clion-2020.2/bin/cmake/linux/bin/cmake -E rm -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /home/g1ft/Desktop/os_kernel_lab-master/labcodes/lab1/kern/debug

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /home/g1ft/Desktop/os_kernel_lab-master/labcodes/lab1/kern/debug/cmake-build-debug

# Include any dependencies generated for this target.
include CMakeFiles/debug.dir/depend.make

# Include the progress variables for this target.
include CMakeFiles/debug.dir/progress.make

# Include the compile flags for this target's objects.
include CMakeFiles/debug.dir/flags.make

CMakeFiles/debug.dir/kdebug.c.o: CMakeFiles/debug.dir/flags.make
CMakeFiles/debug.dir/kdebug.c.o: ../kdebug.c
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/g1ft/Desktop/os_kernel_lab-master/labcodes/lab1/kern/debug/cmake-build-debug/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building C object CMakeFiles/debug.dir/kdebug.c.o"
	/usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -o CMakeFiles/debug.dir/kdebug.c.o   -c /home/g1ft/Desktop/os_kernel_lab-master/labcodes/lab1/kern/debug/kdebug.c

CMakeFiles/debug.dir/kdebug.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing C source to CMakeFiles/debug.dir/kdebug.c.i"
	/usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -E /home/g1ft/Desktop/os_kernel_lab-master/labcodes/lab1/kern/debug/kdebug.c > CMakeFiles/debug.dir/kdebug.c.i

CMakeFiles/debug.dir/kdebug.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling C source to assembly CMakeFiles/debug.dir/kdebug.c.s"
	/usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -S /home/g1ft/Desktop/os_kernel_lab-master/labcodes/lab1/kern/debug/kdebug.c -o CMakeFiles/debug.dir/kdebug.c.s

# Object files for target debug
debug_OBJECTS = \
"CMakeFiles/debug.dir/kdebug.c.o"

# External object files for target debug
debug_EXTERNAL_OBJECTS =

debug: CMakeFiles/debug.dir/kdebug.c.o
debug: CMakeFiles/debug.dir/build.make
debug: CMakeFiles/debug.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/home/g1ft/Desktop/os_kernel_lab-master/labcodes/lab1/kern/debug/cmake-build-debug/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Linking C executable debug"
	$(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/debug.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
CMakeFiles/debug.dir/build: debug

.PHONY : CMakeFiles/debug.dir/build

CMakeFiles/debug.dir/clean:
	$(CMAKE_COMMAND) -P CMakeFiles/debug.dir/cmake_clean.cmake
.PHONY : CMakeFiles/debug.dir/clean

CMakeFiles/debug.dir/depend:
	cd /home/g1ft/Desktop/os_kernel_lab-master/labcodes/lab1/kern/debug/cmake-build-debug && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/g1ft/Desktop/os_kernel_lab-master/labcodes/lab1/kern/debug /home/g1ft/Desktop/os_kernel_lab-master/labcodes/lab1/kern/debug /home/g1ft/Desktop/os_kernel_lab-master/labcodes/lab1/kern/debug/cmake-build-debug /home/g1ft/Desktop/os_kernel_lab-master/labcodes/lab1/kern/debug/cmake-build-debug /home/g1ft/Desktop/os_kernel_lab-master/labcodes/lab1/kern/debug/cmake-build-debug/CMakeFiles/debug.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : CMakeFiles/debug.dir/depend

