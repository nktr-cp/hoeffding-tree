CXX = g++
CXXFLAGS = -std=c++20 -O2 -g -Wall -Iinc

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

.PHONY: tidy
tidy:
	echo "--- Generating compile database and running clang-tidy ---"
	bear -- make
	clang-tidy -p . $(SOURCES)

.PHONY: tidy-fix
tidy-fix:
	@echo "--- Generating compile database and applying fixes with clang-tidy ---"
	@bear -- make > /dev/null 2>&1
	@run-clang-tidy.py -p . -fix
	@echo "--- Applying clang-format for consistency ---"
	@clang-format -i -style=file $(SOURCES)

.PHONY: clean
clean:
	rm -rf $(BUILD_DIR) $(TARGET)

.PHONY: run
run: all
	./$(TARGET)
