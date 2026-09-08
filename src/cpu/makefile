# === Config ===
CXX      := g++
CXXFLAGS := -std=c++17 -Wall -Wextra -O2
LDFLAGS  :=

TARGET   := main
SRCS     := main.cpp nbody.cpp bench.cpp
OBJS     := $(SRCS:.cpp=.o)
DEPS     := $(OBJS:.o=.d)



# === Default target ===

all: $(TARGET)

# === Link ===
$(TARGET): $(OBJS)
	@$(CXX) $(OBJS) -o $@ $(LDFLAGS)

# === Compile with auto dependency generation ===
%.o: %.cpp
	@$(CXX) $(CXXFLAGS) -MMD -MP -c $< -o $@

-include $(DEPS)

# === Run ===

run: $(TARGET)
	@./$(TARGET) 


# === Debug build ===
debug: CXXFLAGS := -std=c++17 -Wall -Wextra -g -O0 -fsanitize=address,undefined
debug: LDFLAGS  := -fsanitize=address,undefined
debug: clean $(TARGET)


# === Cleanup ===
clean:
	@rm -f $(TARGET) $(OBJS) $(DEPS)

rebuild: clean all

.PHONY: all run debug clean