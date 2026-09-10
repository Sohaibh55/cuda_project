CXX := g++

TARGET := main 
SRC := main.cpp nbody.cpp bench.cpp
OBJ := $(SRC:.cpp=.o) 

all: $(TARGET)
	@./$<

$(TARGET): $(OBJ)
	$(CXX) $(OBJ) -o $@

%.o:%.cpp 
	$(CXX) -c $< -o $@

clean:
	@rm -f $(OBJ) $(TARGET)

.PHONY: all clean 