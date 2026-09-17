CXX := g++

TARGET := main 
SRC := main.cpp nbody.cpp bench.cpp
OBJ := $(SRC:.cpp=.o) 

cpu: $(TARGET)
	@./$<

$(TARGET): $(OBJ)
	$(CXX) $(OBJ) -o $@

%.o:%.cpp 
	$(CXX) -c $< -o $@

gpu: $(main)




clean:
	@rm -f $(OBJ) $(TARGET)




.PHONY: all clean 