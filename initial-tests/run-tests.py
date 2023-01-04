import os
import re
import pandas as pd

def run_tests(block):
    os.system(f'taskset 0x1 openssl speed -evp aes-{block}-gcm > results/results1.txt')
    os.system(f'taskset 0x1 openssl speed -engine qatengine -evp aes-{block}-gcm > results/results2.txt')

def interpret_results():
    with open('results/results1.txt') as file:
        lines1 = file.readlines()[-2:]

    with open('results/results2.txt') as file:
        lines2 = file.readlines()[-2:]

    lines1[0] = re.sub(' +', ' ', lines1[0])
    lines1[1] = re.sub(' +', ' ', lines1[1])
    lines2[0] = re.sub(' +', ' ', lines2[0])
    lines2[1] = re.sub(' +', ' ', lines2[1])

    cols1 = lines1[0].split(' ')
    cols1 = [i for i in cols1 if i != 'bytes' and i != 'bytes\n']
    cols2 = lines2[0].split(' ')
    cols2 = [i for i in cols2 if i != 'bytes' and i != 'bytes\n']
    if (cols1 != cols2):
        print('Error')

    cols1 = cols1[1:]

    values1 = lines1[1].split(' ')
    values2 = lines2[1].split(' ')

    data = {}
    index = [values1[0], values2[0] + '-opt']
    for i in range(len(cols1)):
        val1 = float(values1[i+1].replace('k', '').replace('\n', ''))
        val2 = float(values2[i+1].replace('k', '').replace('\n', ''))
        data[int(cols1[i])] = [val1, val2]

    df = pd.DataFrame(data, index=index)
    print(df)

run_tests(128)
interpret_results()
run_tests(256)
interpret_results()