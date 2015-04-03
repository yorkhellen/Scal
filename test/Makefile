CC = gcc
INCLUDE = /usr/local/pvfs2/include
LIBPATH = /usr/local/pvfs2/lib
CFLAGS = -I$(INCLUDE) -L$(LIBPATH)
CXXFLAGS = $(CFLAGS)
EXES = read write
OBJS = read.o write.o

.PHONY : all cleanall clean cleanobjs clean~

all : $(EXES)

$(EXES) : % : %.o
	$(CC) $(CFLAGS) -o $@ $< -lpvfs2 -lpthread -lcrypto

$(OBJS) : %.o : %.c
	$(CC) $(CFLAGS) -c $<
	
cleanall : clean clean~

clean : cleanobjs
	-rm $(EXES)
	
cleanobjs : 
	-rm $(OBJS)
	
clean~ :
	-rm *~

