#include <iostream>
#include <vector>
int main(){
	int n;
	std::cin >> n;
	int i;
	i = 2;
	int prim;
	prim = 1;
	while( i * i < n + 1 && prim == 1)
		{
		if( (n / i) * i == n)
			{
			prim = 0;
			std::cout<<i<<std::endl;;
			}
		i = i + 1;
		}
	std::cout<<prim<<std::endl;;
	return 0;
}
