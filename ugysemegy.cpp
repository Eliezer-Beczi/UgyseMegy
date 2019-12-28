#include <iostream>
#include <vector>
int main(){
	int n;
	std::cin >> n;
	std::vector<double> tomb( n );
	if  ( tomb.size() < n ) { std::cerr<<"Error, index bounds exception!\n"; exit(1);}
	for ( int i=0;i<n;++i){std::cin >> tomb [ i ]; };
	int i;
	i = 0;
	while( i < n - 1)
		{
		int j;
		j = i + 1;
		while( j < n)
			{
			if( tomb[j] < tomb[i])
				{
				double aux; aux = tomb[j];tomb[j]=tomb[i];tomb[i]=aux;
				}
			j = j + 1;
			}
		i = i + 1;
		}
	for(int i=1;i<=n / 2;++i){ std::cout<<tomb[ i ]<<std::endl;};
	return 0;
}
