if [ ! $# -eq 2 ]
then
    echo '[FlexBison] usage : '$0 ' bison.y  flex.l'
    exit 1
fi

bison $1
flex $2

g++ `echo $1 | sed 's/.y$//g'`.tab.c lex.yy.c -ll -o a.out
./a.out
