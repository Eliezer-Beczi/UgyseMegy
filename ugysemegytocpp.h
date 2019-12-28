#ifndef UGYSEMEGY_TO_CPP
#define UGYSEMEGY_TO_CPP
#define OUTPUT_FILENAME "ugysemegy.cpp"
#include <fstream>
#include <iostream>
std::ofstream output;
int indentation = 1;

void writeMain()
{
    output.open(OUTPUT_FILENAME);
    if (!output.is_open())
    {
        std::cerr << "Sikertelen fajl generalas!";
        exit(1);
    }

    output << "#include <iostream>\n";
    output << "#include <vector>\n";
    output << "int main(){\n";
}

std::string getIndentation(int indentation)
{
    return std::string(indentation, '\t');
}

void writeEnd()
{
    output << getIndentation(indentation) << "return 0;\n}\n";
    output.close();
}

void closeBlock()
{
    output << getIndentation(indentation) << "}\n";
    indentation--;
}

void dot()
{
    output << ";\n";
}

void openIf()
{
    output << getIndentation(indentation) << "if( ";
}

void openBlock()
{
    indentation++;
    output << ")\n"
           << getIndentation(indentation) << "{\n";
}
void openBracket()
{
    output << "( ";
}
void closeBracket()
{
    output << " )";
}
void writeElse()
{
    output << getIndentation(indentation) << "else\n"
           << getIndentation(indentation) << "{\n";
    indentation++;
}

void openWhile()
{
    output << getIndentation(indentation) << "while( ";
}

std::string getEquals()
{
    return " == ";
}

std::string getNotEquals()
{
    return " != ";
}

std::string getLessThan()
{
    return " < ";
}

std::string getGreaterThan()
{
    return " > ";
}

std::string getOr()
{
    return " || ";
}

std::string getAnd()
{
    return " && ";
}

std::string getNot()
{
    return " !";
}

void declareInt(std::string id)
{
    output << getIndentation(indentation) << "int " + id;
}

void declareDouble(std::string id)
{
    output << getIndentation(indentation) << "double " + id;
}

void declareIntArray(std::string id, std::string sizeExpression)
{
    output << getIndentation(indentation) << "std::vector<int> " + id + "( " + sizeExpression + " )";
}

void declareDoubleArray(std::string id, std::string sizeExpression)
{
    output << getIndentation(indentation) << "std::vector<double> " + id + "( " + sizeExpression + " )";
}
void writeAssignment(std::string id, std::string valueExpression)
{
    output << getIndentation(indentation) << id + " = " + valueExpression;
}
void writeExpression(std::string expression)
{
    output << expression;
}
void swap(std::string id1, std::string id2, std::string type, bool array)
{
    if (array)
    {
        output << getIndentation(indentation) << id1 << ".swap ( " + id2 + " )";
    }
    else
    {
        output << getIndentation(indentation) << type << " aux; aux = " << id1 << ";" << id1 << "=" << id2 << ";" << id2 << "=aux";
    }
}

void readVar(std::string id)
{
    output << getIndentation(indentation) << "std::cin >> " << id;
}

void readArray(std::string id, std::string sizeExpression)
{
    output << getIndentation(indentation) << "if  ( " << id << ".size() < " << sizeExpression << " ) { std::cerr<<\"Error, index bounds exception!\\n\"; exit(1);}\n";
    output << getIndentation(indentation) << "for ( int i=0;i<" << sizeExpression << ";++i){std::cin >> " << id << " [ i ]; }";
}

void rangePrint(std::string id, std::string startExpression, std::string endExpression)
{
    output << getIndentation(indentation) << "for(int i=" << startExpression << ";i<" << endExpression << ";++i){ std::cout<<" << id << "[ i ]<<std::endl;}";
}

void rangePrintEq(std::string id, std::string startExpression, std::string endExpression)
{
    output << getIndentation(indentation) << "for(int i=" << startExpression << ";i<=" << endExpression << ";++i){ std::cout<<" << id << "[ i ]<<std::endl;}";
}

void printAll(std::string id)
{
    output << getIndentation(indentation) << "for(int i=0; i<"  <<id<< ".size();++i){ std::cout<<" << id << "[ i ]<<std::endl;}";
}

void printVar(std::string id)
{
    output << getIndentation(indentation) << "std::cout<<" << id << "<<std::endl;";
}

#endif
