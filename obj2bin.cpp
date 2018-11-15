#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <sstream>
#include <cstdlib>
#include <iomanip>

struct Vertex {
	float x,y,z;
	Vertex(float x, float y, float z) : x(x), y(y), z(z) {}
};

struct Triangle {
	int v1,v2,v3;
	Triangle(int v1, int v2, int v3) : v1(v1), v2(v2), v3(v3) {}
};

using namespace std;

int main() {
	ifstream objfile;
	objfile.open("cube.obj");

	ofstream facesfile;
	facesfile.open("faces.data");

	ofstream vfile;
	vfile.open("vertex.data");

	
	vector<Vertex> verticies;
	vector<Triangle> triangles;

	string line;
	if (objfile.is_open()) {
		while (getline(objfile, line)) {
			stringstream ss(line);
			string n,x,y,z;
			ss >> n >> x >> y >> z;
			if (n == "v") {
				verticies.push_back(Vertex(atof(x.c_str()), atof(y.c_str()), atof(z.c_str())));
				//cout << x << y << z << endl;
			}
			else if (n == "f") {
				triangles.push_back(Triangle(atoi(x.c_str()), atoi(y.c_str()), atoi(z.c_str())));
				//cout << x << y << z << endl;
			}
		}
	}

	if (vfile.is_open()) {
		for (int i=0; i < verticies.size(); i++) {
			cout << verticies[i].x << ' ' << verticies[i].y << ' ' << verticies[i].z << endl;
		}
	}
	
	if (facesfile.is_open()) {
		for (int i=0; i < triangles.size(); i++) {
			facesfile << setfill('0') << setw(2) << hex << triangles[i].v1 
			<< setfill('0') << setw(2) << hex << triangles[i].v2 
			<< setfill('0') << setw(2) << hex << triangles[i].v3 << endl;
		}
	}

	return 0;
}



