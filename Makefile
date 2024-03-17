foo: foo.cu
	nvcc foo.cu -o foo

bar: bar.c
	gcc bar.c -o bar

.PHONY: profile
profile: foo
	nsys nvprof --print-gpu-trace -f -o /tmp/report ./foo
