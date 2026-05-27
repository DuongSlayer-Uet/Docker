CC=/openwrt-sdk/staging_dir/toolchain-aarch64_cortex-a72_gcc-12.3.0_musl/bin/aarch64-openwrt-linux-gcc
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
