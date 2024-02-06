int teste1, teste2, teste3;

int main(int value1, int value2)
{
    value1 = 10;
    value2 = 20;

    while (value1 != 0)
    {
        value1 = value1 - 1;
        value2 = value2 + 1;
    }
    teste1 = value1 + value2;

    return teste1;
}