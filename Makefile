CXX = g++
CXXFLAGS = -std=c++20 -O3 -g -Wall -Iinc

TARGET = vfdt

SRC_DIR = src
BUILD_DIR = build
INCLUDE_DIR = inc

SOURCES = $(wildcard $(SRC_DIR)/*.cc)
OBJECTS = $(patsubst $(SRC_DIR)/%.cc,$(BUILD_DIR)/%.o,$(SOURCES))

.PHONY: all
all: $(TARGET)

$(TARGET): $(OBJECTS)
	$(CXX) $(CXXFLAGS) -o $(TARGET) $(OBJECTS)

$(BUILD_DIR)/%.o: $(SRC_DIR)/%.cc
	@mkdir -p $(BUILD_DIR)
	$(CXX) $(CXXFLAGS) -c $< -o $@

.PHONY: clean
clean:
	rm -rf $(BUILD_DIR) $(TARGET)

.PHONY: re
re: clean all

.PHONY: run
run: all
	./$(TARGET)

.PHONY: lint
lint:
	clang-tidy --config-file=.clang-tidy $(SOURCES) -- $(CXXFLAGS)

.PHONY: fix
fix:
	clang-tidy --fix --config-file=.clang-tidy $(SOURCES) -- $(CXXFLAGS)
