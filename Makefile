# for compilation
CXXFLAGS = -std=c++11
INCFLAGS = -I$(SYSTEMC)/include
LDFLAGS  = -L$(SYSTEMC)/lib-$(ARCH) -lsystemc
# for project
SRCS = $(wildcard src/*.cpp)
OBJS = $(patsubst %.cpp, %.o, $(SRCS))
DEPS = $(patsubst %.cpp, %.d, $(SRCS))
# phony target name
.PHONY = all debug release clean help

all: debug ## compile in debug mode by default

debug: CXXFLAGS += -g -Wall -Werror -O0
debug: main ## debug mode setup

release: CXXFLAGS += -O2
release: main ## release mode setup

main: $(OBJS)
	$(CXX) $(CXXFLAGS) $(INCFLAGS) $(LDFLAGS) $^ -o main 

-include $(DEPS)

%.o: %.cpp
	$(CXX) $(CXXFLAGS) $(INCFLAGS) $(LDFLAGS) -MMD -MP -c $< 

clean: ## clean all file except for source codes
	$(RM) -rv main $(OBJS) $(DEPS)

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-15s\033[0m %s\n", $$1, $$2}'
