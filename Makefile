all: app0 app1 app2 app3 app4 app5

app0:
	g++ add_v0.cpp -o add_v0.exe

app1:
	nvcc add_v1.cu -o add_v1.exe

app2:
	nvcc add_v2.cu -o add_v2.exe

app3:
	nvcc add_v3.cu -o add_v3.exe

app4:
	nvcc add_v4.cu -o add_v4.exe

app5:
	nvcc add_v5.cu -o add_v5.exe

clean:
	rm -rf *.exe
