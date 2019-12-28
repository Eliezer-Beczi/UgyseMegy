if [ ! $# -eq 2 ]
then
    echo '[FlexBison] usage : '$0 ' bison.y  flex.l'
    exit 1
fi

bison -dvt $1
flex $2

g++ `echo $1 | sed 's/.y$//g'`.tab.c ugysemegytocpp.h lex.yy.c -ll -o a.out
./a.out
echo "GENERATED:"
cat ugysemegy.cpp
echo "EOF GENERATED"
