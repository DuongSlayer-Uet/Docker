CC=aarch64-linux-gnu-gcc
TARGET=check_python

all:
	$(CC) src/check_python.c -o $(TARGET)

run:
	./$(TARGET)

clean:
	rm -f $(TARGET)

package:
	mkdir -p package/python-check/usr/bin
	cp $(TARGET) package/python-check/usr/bin/
	tar -czf python-check.ipk package/
