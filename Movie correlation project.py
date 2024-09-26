#!/usr/bin/env python
# coding: utf-8

# In[56]:


# import libraries 

import pandas as pd 
import seaborn as sns
import numpy as np

import matplotlib
import matplotlib.pyplot as plt 
plt.style.use('ggplot')
from matplotlib.pyplot import figure

get_ipython().run_line_magic('matplotlib', 'inline')
matplotlib.rcParams['figure.figsize'] = (12,8) # Adjusts the configuration of the plots we will create


#read in the data

df = pd.read_csv('/Users/incharan/Downloads/ProtfolioProjects/movies.csv')


# In[6]:


# data

df.head()


# In[18]:


# missing data

for col in df.columns: 
    pct_missing = np.mean(df[col].isnull())
    print('{} - {}%'.format(col, pct_missing))  


# In[20]:


df.dtypes


# In[60]:


print(df['budget'].isna().sum())  # Count of NaN values in 'budget'
print(df['gross'].isna().sum())   # Count of NaN values in 'gross'


# In[62]:


df['budget'] = df['budget'].fillna(0)  # Fill NaNs with 0
df['gross'] = df['gross'].fillna(0)    # Fill NaNs with 0


# In[64]:


df['budget'] = df['budget'].astype('int64')
df['gross'] = df['gross'].astype('int64')


# In[66]:


df


# In[82]:


df['date_clean'] = df['released'].str.extract(r'([A-Za-z]+ \d{1,2}, \d{4})')


# In[84]:


df['date_clean'] = pd.to_datetime(df['date_clean'])


# In[86]:


df['formatted_date'] = df['date_clean'].dt.strftime('%Y-%m-%d')


# In[90]:


df


# In[104]:


df.drop(columns=['released', 'yearcorrect'], inplace=True)

df


# In[106]:


df.drop(columns=['date_clean'], inplace=True)


# In[108]:


df


# In[120]:


df.rename(columns={'release': 'released'}, inplace=True)


# In[122]:


df


# In[124]:


df['yearcorrect'] = df['released'].astype(str).str[ :4]


# In[126]:


df


# In[146]:


df = df.sort_values(by=['gross'], inplace=False, ascending=False)


# In[134]:


pd.set_option('display.max_rows', None)


# In[136]:


df.sort_values(by=['gross'], inplace=False, ascending=False)


# In[138]:


# drop any duplicates

df['company'].drop_duplicates().sort_values(ascending=False)


# In[152]:


#scatter plot with budget vs gross

plt.scatter(x=df['budget'], y=df['gross'])

plt.title('budget vs gross Earnings')

plt.xlabel('budget for films')

plt.ylabel('gross Earnings')

plt.show()


# In[148]:


df.head()


# In[164]:


#plot budget vs gross using seaborn 

sns.regplot(x='budget', y='gross', data=df, scatter_kws={"color":"red"}, line_kws={"color":"blue"})


# In[185]:


numeric_df = df.select_dtypes(include=['number'])
correlation_matrix = numeric_df.corr(method='pearson')
print(correlation_matrix)


# In[205]:


numeric_df = df.select_dtypes(include=['number'])
correlation_matrix = numeric_df.corr(method='pearson')

sns.heatmap(correlation_matrix, annot=True, cmap='coolwarm', linewidths=0.5)
plt.title('Correlation Matrix for numeric features')
plt.xlabel('movie features')
plt.ylabel('movie features')
plt.show()




# In[207]:


#looking at company
df.head()


# In[218]:


df_numerized = df

for col_name in df_numerized.columns:
    if df_numerized[col_name].dtype == 'object':
        df_numerized[col_name] = df_numerized[col_name].astype('category')
        df_numerized[col_name] = df_numerized[col_name].cat.codes


df_numerized


# In[222]:


numeric_df = df.select_dtypes(include=['number'])
correlation_matrix = numeric_df.corr(method='pearson')

sns.heatmap(correlation_matrix, annot=True, cmap='coolwarm', linewidths=0.5)
plt.title('Correlation Matrix for numeric features')
plt.xlabel('movie features')
plt.ylabel('movie features')
plt.show()


# In[224]:


df.corr()


# In[234]:


correlation_mat = df.corr()
corr_pairs = correlation_mat.unstack()
corr_pairs


# In[236]:


sorted_pairs = corr_pairs.sort_values()
sorted_pairs


# In[244]:


high_corr = sorted_pairs[(sorted_pairs) > 0.5]
high_corr


# In[ ]:


# Votes and Gross Earnings: Movies with more votes tend to earn more money at the box office.
# Budget and Gross Earnings: Movies with bigger budgets usually make more money.
# Released and Year: The year a movie is released is very closely related to the year recorded in the dataset.
# Yearcorrect and Released: The corrected year of a movie matches the release year almost perfectly.
# Self-Correlations: Each variable perfectly matches itself (like a movie's title matches itself).

