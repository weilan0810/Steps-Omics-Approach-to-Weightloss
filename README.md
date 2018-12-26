# Steps Omics Approach to Weightloss

This project uses data from a previously completed clinical trial, which provides a well characterized sample of overweight or obese Filipino individuals, outcomes of a mobile phone-based intervention for weight loss, continuous physical activity data, dietary pattern data, and previously collected gene expression data. This study proposes to develop and assess predictive models for weight loss using demographic, clinical, gene expression, step count, and dietary pattern data and evaluate gene expression levels that are associated with weight loss. The potential impact of this project is improved prediction of which individuals are most likely to lose weight in response to a physical activity and dietary intervention and generation of new knowledge about the mechanisms that underlie weight loss.

Table of Contents: 
1. Dataset Description
2. Methods
3. Data Analyses
4. Results
5. Discussion
6. Limitations
7. Conclusion

# Data Description: 
Data was collected using the methods...

From original datasets, data was organized into four datasets: Step Count, Anthropometrics, F&T Labs, and Gene Expression.

Step Count - this dataset contains 90 days worth of step count data collected for each of the 84 participants depending on their assigned study group. Participants in "Blue" study group retained 90 days worth data taken from baseline whereas participants in "Red" study group retained 90 days worth of data taken starting from day 90. Data considered for each group were: Date, weight, BMI, and step count.

Anthropemetrics - this dataset contains the studyID for each of the 84 participants as well as the check-in dates established baseline, 3 months, and 6 months. There is a "Red" or "Blue" study group associated with each participant that is used as a mapping for the other datasets.

F&T Labs - this dataset contains demographic information such as: age, gender, baseline glucose and baseline A1C measurements taken for each of the 84 participants. Additionally there is the associated "Red" or "Blue" study group that we use to map between datasets.

Gene Expression - this dataset contains the ensemble geneID gene expression for each of the 84 participants taken at baseline, 3 months, and 6 months. We normalized this dataset during feature engineering to contained normalized counts per million of gene expression data. We utilized the external HUGO Database to rename ensemble geneID's into HGNC gene ID's so that would could implement KEGG Pathways analysis of our gene expression data.

# Methods:

Missing Data: 
In the case of missing data, study participants were either dropped from the entire study or data was imputed depending on if there was too much data missing or if step count data was missing. 

Feature Engineering Methods:

PCA - PCA indicates which genes within our dataset have the highest variance between different studyID's. By identifying which genes are variant, we can discard other genes (dimensional reduction) in our dataset that are consistent across individuals, and hone in on understanding why some variables contain high variance. After PCA, there were 5 principle components that explaired roughly 90% of the variability.
KEGG Pathways - KEGG provides context to genetic interactions; and, therefore, will provide additional information about our PCA results by summarizing which pathways are involved in specific weight loss interactions. We retained only pathways that displayed counts for two or more genes in each pathways and discarded the others (dimensional reduction).

# Data Analysis Methods:

Logistic Regression:
SVM:
Random Forest:
MediBoost:

# Results
# Discussion
# Limitations
# Conclusion

# Credits: Include a section for credits in order to highlight and link to the authors of your project.
