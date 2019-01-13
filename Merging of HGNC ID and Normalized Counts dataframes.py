
# coding: utf-8

# In[863]:


#Imports pandas and numpy packages
import pandas as pd
import numpy as np

#Imports HGNC dataframe
HGNC = pd.read_csv('HGNC.csv')


# In[864]:


#Displays HGCN dataframe containing all human gene ID's taken from the HGNC database
HGNC


# In[865]:


#Lists HGNC column values
list(HGNC.columns.values)


# In[866]:


#Renames 'Ensembl gene ID' column to 'gene_sliced' and displays first 5 rows of the dataframe
HGNC.columns = ['HGNC_ID', 'Approved_Symbol', 'Approved_name','gene_sliced']
HGNC.head()


# In[884]:


#Renames 'Ensembl gene ID' column to 'gene_sliced' and displays first 5 rows of the dataframe

HGNC_map = HGNC.drop(['Approved_Symbol', 'Approved_name'], axis = 1)


HGNC_map.head()


# In[885]:


#Checks index value 'gene_sliced' is no longer listed as a column
list(HGNC_map.columns.values)


# In[886]:


#Creates list of Ensemble gene ID's
HGNC_id = list(HGNC_map.iloc[: , 0])
HGNC_id


# In[887]:


#Creates an empty list and fills with Ensemble gene ID's after removing any numbers from Ensemble ID following decimal 

gene_sliced=[]
for gene in gene_id:
    gene_new=gene.split('.')[0]
    
    gene_sliced.append(gene_new)
    
print(gene_sliced)


# In[888]:


#Imports normalized gene counts dataframe with Ensemble ID as index
counts = pd.read_csv('cpm_renamed_original.csv')

#Adds 'gene_sliced' as a new column in Counts dataframe and sets as an index 
counts['gene_sliced'] = gene_sliced
counts


# In[889]:


##MAPPING HGNC and Counts dataframes

#Creates a dictionary from HGNC_map dataframe to connect 'gene_sliced' to 'HGNC_ID'
mapping = dict(HGNC_map[['gene_sliced', 'HGNC_ID']].values)

#Creates new column in counts dataframe with HGNC_ID label
counts['HGNC_ID'] = counts.gene_sliced.replace(mapping, inplace = True)
counts = counts.set_index('gene_sliced', drop=True, inplace = False)


# In[890]:


list(counts.columns.values)
counts = counts.drop(['Unnamed: 0', 'HGNC_ID'], axis = 1)


# In[850]:


counts.to_csv('counts_by_HGNCid.csv')

