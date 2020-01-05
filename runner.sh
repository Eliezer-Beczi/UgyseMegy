if [ ! $# -eq 2 ]
then
    echo '[ FlexBison ] usage : '$0 ' bison.y  flex.l'
    exit 1
fi
echo "[ Bison ]"
bison -dvt $1
echo "[ Flex ]"
flex $2
echo "[ Bison-Flex ]"
g++ `echo $1 | sed 's/.y$//g'`.tab.c ugysemegytocpp.h lex.yy.c -ll -o a.out
echo "[ Ugysemegy->CPP ] transpiling ..."
./a.out
echo "[ Ugysemegy->CPP ] generated:"
cat ugysemegy.cpp | sed 's/^/[ Ugysemegy->CPP ]/g'
