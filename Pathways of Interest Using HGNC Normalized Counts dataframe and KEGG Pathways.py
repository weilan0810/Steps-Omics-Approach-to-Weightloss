
# coding: utf-8

# In[232]:


#Imports pandas and numpy packages
import pandas as pd
import numpy as np

df = pd.read_csv('df-geneid1.csv')


# In[233]:


#Pathways that we want to check
df 


# In[234]:


#Turning pathway names into a list to have it in a column in the final dataframe later

pathways = df.pathways.tolist()
pathways


# In[251]:


#Turning row values, consisting of HGNC_ID values, into a list to have it in a column in the final dataframe later
#rows = df.values.tolist()
#rows


# In[252]:


#Imports newest version of counts file
counts = pd.read_csv('counts_by_HGNCid.csv')

#Renames gene_sliced column to HGNC_ID
counts.rename(columns={'gene_sliced': 'HGNC_ID'}, inplace=True)
counts


# In[253]:


#Converts the column HGNC_ID in the counts dataframe to a list and then converts to a set of values
genesofinterest = counts['HGNC_ID'].tolist()
genes = set(genesofinterest)

genes


# In[241]:


#Converts the row values in the pathways (df) dataframe to a list as a string, and then puts these values in a set

listofdf = df.values.astype(str).tolist()
value = [set(v) for v in listofdf]
value


# In[242]:


#Test code to see if any values in set_i (the first set of list) has any values that match with values in genes df
set_i = value[1]
display = (set_i & genes)
display


# In[257]:


#Finds matching values contained in both 'gene' and 'value' sets
result = [[j for j in i if j in genes] for i in value]
result


# In[261]:


#Creates a dataframe with data populated from list of lists "result"  with index from pathways
df2 = pd.DataFrame(data=result,index=pathways)
df2.dropna(axis=0,how='all')
df2


# In[262]:


#Testing code
'6389' in value[1]


# In[270]:


Non_nan_values=df2.count(axis=1)
non_nan=pd.DataFrame(Non_nan_values)
non_nan.index.name='Pathway'
non_nan.columns=['Number genes represented in pathway']
non_nan


# In[273]:


df2.fillna(value=pd.np.nan, inplace=True)
df2.append(ignore_index=True,other=Non_nan_values)
pathwayscount= df2.merge(non_nan, on='Pathway')
pd.set_option('display.max_columns',100)
pathwayscount


# In[275]:


pathwayscount.to_csv('GeneCount_in_Pathways')

