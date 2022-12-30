import pandas as pd
compare = [0,0,0,0,0,0,0,0]
input_file = "./vCPU-8/results.csv"
output_file = input_file[:-4] + ".xlsx"


df = pd.read_csv(input_file)
df = (df.drop(df.columns[0],axis=1))
df1 = df.copy()
new_col = 1
print(df.shape)
for i in range(df.shape[1]):
	col = [0]
	for j in range(1,df.shape[0]):
		print(j,i)
		col.append(round(((df.iloc[j,i]-df.iloc[compare[j],i])/df.iloc[compare[j],i]) * 100, 3))
	df1.insert(new_col,"Increase %",col, True)
	new_col+=2
df1.to_excel(output_file)
