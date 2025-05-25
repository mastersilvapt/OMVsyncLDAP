import sys
import ast

try:
    a=set(ast.literal_eval(sys.argv[1]))
    b=set(ast.literal_eval(sys.argv[2]))

#    print(list(a-b))
    for i in list(a-b):
        print(i, end=' ')
    print()

except Exception as e:
    print(e)
    print([])
