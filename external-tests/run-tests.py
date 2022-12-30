import pandas as pd
import os

df = pd.read_csv("./tests.csv")
df = df.iloc[: , 2:]
df["CoOp(New)"] = 0

operation = {
	"ENCRYPT": 1,
	"DECRYPT": 2,
	"BOTH": 3
}

for i in range(df.shape[0]):
	command = f"./EncryptDecryptPerfTest {df.iloc[i,1]} {operation[df.iloc[i,2]]} {df.iloc[i,3]} {df.iloc[i,4]} {df.iloc[i,5]} > results.txt"
	print(command)
	os.system(command)
	with open("results.txt", 'r') as f:
		CoOp = int(f.readline())
		df.iloc[i,7] = CoOp

print(df)
df.to_csv("results.txt")