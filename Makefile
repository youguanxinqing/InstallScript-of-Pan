# gcc -o app *.c -I/usr/include/fastdfs/ -I/usr/include/fastcommon/ -lfdfsclient
# gcc -o bin/app src/main.c -I/usr/local/include/hiredis

all:
	rm ./bin -rf; mkdir bin
	gcc -o bin/you_upload src/*.c -Iinclude \
							   -I/usr/include/fastdfs/ \
							   -I/usr/include/fastcommon/ \
							   -lpthread -lfdfsclient \
							   -lfcgi \
							   -std=c99 -D_SVID_SOURCE
clean:
	rm ./bin -r
