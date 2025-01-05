CC          = gcc
CFLAGS      = -Wall -g
LDFLAGS     =
CPPFLAGS    = `getconf LFS_CFLAGS` `pkg-config --cflags glib-2.0`
LDLIBS      = `pkg-config --libs glib-2.0` `pkg-config --libs gio-2.0`
EXTRA       =

SOURCES = src/main.c # Add more source files as needed
OBJECTS = $(SOURCES:.c=.o)
APP_NAME = main
TARGET = $(APP_NAME)

.PHONY: clean check run

# Default target
all: check $(TARGET)

check:
	@echo -n "Checking for glib-2.0..."
	@pkg-config glib-2.0 || { echo "not found (install libglib2.0-dev or glib2-devel)"; false; }
	@echo ok

# Compile object files
%.o: %.c
	$(CC) $(CFLAGS) $(CPPFLAGS) $(LDLIBS) $(EXTRA) -c $< -o $@

# Link object files to create the executable
$(TARGET): $(OBJECTS)
	mkdir -p build
	$(CC) $(OBJECTS) -o build/$@ $(LDLIBS)

# Print application information (using variables from config.h)
info:
	@echo "Application Name: $(APP_NAME)"
	@echo "Compiler: $(CC)"
	@echo "Compiler Flags: $(CFLAGS)"
	@echo "Binary: $(PWD)build/$(TARGET)"

run:
	./build/$(TARGET)

clean:
	rm -rf build
	rm -rf src/*.o