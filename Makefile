# CXX = g++
# CXXFLAGS = -Wall -Werror -Wextra -Wpedantic  -D_FORTIFY_SOURCE=3 -g
# # NQP_THREAD = nqp_thread.o nqp_mlfq_sched.o # .o files needed to comple and use nqp_thread.c

# .PHONY: clean

# all: main

# main: main.o
# 	$(CXX) $(CXXFLAGS) -o main main.o

# clean:
# 	rm -rf *.o main



# --- IGNORE ---
# to compile and run in one command type:
# make run

# define which compiler to use
CXX := g++
OUTPUT := sfmlgame
OS := $(shell uname)

# linux compiler / linker flags
ifeq ($(OS), Linux)
	CXXFLAGS := -03 -std=c++20 -Wno-unused-result -Wno-deprecated-declarations
	INCLUDES := -I./src -I .src/imgui
	LDFLAGS := -03 -lsfml-graphics -lsfml-window -lsfml-system -lsfml-audio -lGL
endif

# macOS compiler / linker flags
ifeq ($(OS), Darwin)
	SFML_DIR := /opt/homebrew/Cellar/sfml/3.0.1/
	CXX_FLAGS := -03 -std=c++20 -Wno-unused-result -Wno-deprecated-declarations
	INCLUDES := -I./src -I .src/imgui -I$(SFML_DIR)/include
	LDFLAGS := -03 -lsfml-graphics -lsfml-window -lsfml-system -lsfml-audio -L$(SFML_DIR)/lib -framework OpenGL
endif

# the source files for the ecs game engine
SRC_FILES := $(wildcard src/*.cpp src/imgui/*.cpp)
OBJ_FILES := $(SRC_FILES:.cpp=.o)

# Include dependencies
DEP_FILES := $(OBJ_FILES:.o=.d)
-include $(DEP_FILES)

# all of these targets will be made if you just type make

all: $(OUTPUT)

# define the main executable requirements / command
$(OUTPUT): $(OBJ_FILES) Makefile
	$(CXX) $(OBJ_FILES) $(LDFLAGS) -o ./bin/$@

# specifies how the object files are compiled from cpp files
.cpp.o:
	$(CXX) -MMD -MP -c $< $(CXX_FLAGS) $(INCLUDES) $< -o $@

# typing 'make clean' will remove all intermediate build files
clean:
	rm -rf $(OBJ_FILES) $(DEP_FILES) ./bin/$(OUTPUT)

# typing 'make run' will compile and run the game
run: $(OUTPUT)
	cd bin && ./bin/$(OUTPUT) && cd ..
