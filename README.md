# Steps Omics Approach to Weightloss

This project uses data from a previously completed clinical trial, which provides a well characterized sample of overweight or obese Filipino individuals, outcomes of a mobile phone-based intervention for weight loss, continuous physical activity data, dietary pattern data, and previously collected gene expression data. This study proposes to develop and assess predictive models for weight loss using demographic, clinical, gene expression, step count, and dietary pattern data and evaluate gene expression levels that are associated with weight loss. The potential impact of this project is improved prediction of which individuals are most likely to lose weight in response to a physical activity and dietary intervention and generation of new knowledge about the mechanisms that underlie weight loss.

# Table of Contents: 
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

2.1 Feature Selection
Datasets with significantly large amounts of features relative to samples risk overfitting and therefore must be reduced in some way. In an effort to select the best features to be retained in the final model, two separate feature selection methods, Principal Components Analysis (PCA) and KEGG Pathways,  are adopted and additional behavioral features are incorporated into the final models.

2.1.1 PCA
There are two purposes for implementing PCA before modeling. First, PCA can reduce the number of features used in our model by creating principal components. Principal components are created by taking a combination of all genes and applying different weights to them. Each component represents a different transformation of the data; and the components that are included in the final model are the ones that capture the most variance. Secondly, PCA eliminates the correlation between two variables. An assumption in many models is that features are independent of each other; therefore, correlation between features violates this assumption and diminishes the reliability of a model’s performance.(K. Wagstaff, 2012) Although PCA does a great job in selecting genes of high importance in modeling, it transforms genes into a format that greatly lacks interpretability -- an area which KEGG Pathways for genes selection does exceptionally well in (Gage, B. F. et al, 2001). 

2.1.2 KEGG
KEGG Pathways is a public database that maps current understanding of known molecular interactions and reactions for human processes, including: metabolic, genetic information, environmental information, cellular, organismal systems, human diseases, and drug development. To elaborate, human processes such as how food is metabolized, include many complex interactions between hundreds of different genes for a given pathway. For each disease, there may be hundreds to thousands of pathways that influence disease susceptibility and outcome. To quantify the importance of a given gene’s influence on a particular disease, it is sometimes helpful to understand which pathways are most active in the processes that underlie the disease. In order to do that, the existing pathways from KEGG are matched to the genes that are measured in the patients during the study, to understand whether there is a correlation between a genetic pathway and weight loss. 

2.1.3 Behavioral Data
Risk factors contributing to obesity are much greater than the influence of genetic risks alone. Understanding the joint impact of human behavior and how these behaviors influence gene expression provide a much more robust and accurate portrayal of obesity as a whole. In the clinical trial from which the genetic data was collected, activity step-count data for each participant was gathered over an 18-month period and has been included as an additional set of features in our models. 


# Data Analysis Methods:

2.2.1 Logistic Regression, original and with cross-validation
Logistic regression is the most generally applicable model used in binary classification problems. Under logistic regression, a logistic function is developed to model a binary dependent variable; in this case, whether a patient will lose weight or not. The logistic function utilizes log-likelihood, which is a linear combination of input values with weighted coefficient factors. The log-likelihood is further incorporated into the logistic function with a general form of 1/(1+e^-value). This curve serves as a boundary that classifies two possible outcomes. Since logistic regression is relatively easy to implement and understand, it is generally utilized as a baseline model to measure prediction performance. (Jason Browniee, 2016)

Cross validation on logistic regression is an optimized method when dealing with a small sample size. With cross-validation, the final prediction accuracy will be based on the entire dataset rather than the test set (e.g. 30% ). The K-fold cross-validation method partitions the data into k equally sized dataset segments referred to as a fold. Each fold is held out as test set while the other k-1 folds are used to train the model. This process repeats k times and creates k models; and the final prediction result is made on the average prediction results for all k models, in which case maximizes the utility of all data.

2.2.2 Support Vector Machines (SVMs)
Support Vector Machines (SVMs) work differently than Logistic Regression models because they can perform both linear and non-linear classifications. This works by implicitly mapping the inputs into high-dimensional feature spaces corresponding to the selection of a “kernel” so that they can be approached as linear problems.
The tuning parameters for SVMs include: kernel, regularization value, and a gamma value which can be altered to achieve different levels of accuracy. Models were constructed from a combination of input features including: demographic, step-count, pathways, and PCA features. During preprocessing for demographic and step-count data, continuous variables were converted into binned categorical variables and the performance of models with discrete “binned” features were compared against performance of models using continuous variables. Surprisingly, this alteration only enhanced the performance of the most basic models using only demographic data and the demographic and  step-count data. 

2.2.3 Random Forests 
Random Forests use a “bagging method”; meaning, they use a combination of learning models, rather than just one, to increase performance. Random Forests build multiple decision trees and merge them together to get a more accurate and stable prediction. Random Forests are different from Logistic Regression and SVMs because there is no assumption of normality -- it is a non-parametric model meaning that there are no hyperparameters that need to be tuned. 

In the Random Forest modeling process, we set a parameter m, which is smaller than p(number of all features) as the optimizer. While training each individual tree, at each potential split we consider m randomly selected features and add the best available split. Each model finds patterns in its data subset and then combines pattern observations to find very complex but accurate patterns to describe the model overall. The method to generate the parameter mis through k-fold cross validation, during which process we record the averaged cross-validated R2over the k folds using the current mvalue, then set the mvalue to be the one that yielded the highest R2value.

Random Forest models usually generate results with very high accuracy, but the form of these results are very diverse; and discorrelated trees usually consist of hundreds of large decision trees. One possible approach to interpret the modeling results from Random Forest models is to calculate the relative importance of variables through variable importance measures, which can provide an ordering of variables by importance. From here, a threshold is set to select the top number of variables by importance (Donges Niklas, 2018). Random Forests are especially interesting in the case of high dimensional data, as there are many attributes whose importance needs to be examined and less observations. 

2.2.4 Mediboost
Since Random Forest models cannot directly plot out how the tree is built, Mediboost is introduced to balance the interpretability and prediction accuracy. Mediboost is a “boosting method”, which excels at reducing bias and variance and generally has higher interpretability compared to Random Forests. As such, it is widely used in predictive applications for precision medicine because it helps to accurately stratify patients into different subpopulations from features which increases model performance. 

Mediboost derives from traditional boosting methods such as Adaboost; which combines several weak classifiers whose prediction is only slightly better than guessing, via a weighted-sum method to produce a strong classifier. Adaboost trains the data iteratively and creates T decision stumps({h1,h2,...,ht}), which are single node decision trees as weak learners in a stage-wise approach. Each decision stump splits the data via a predicate t that focuses on a particular attribute, which calculates the corresponding distance between the data. At the end, given new data (represented by a vector x), Adaboost predicts its class label by calculating these distances using the below equation: F(x)=signt=1Ttht(x,t)

The Mediboost method rewrites the decision tree by considering all possible combinations of predictions made by each ensemble member. Each path in the Mediboost decision tree, from the root to the terminal node, contains T nodes and represents a particular combination of the prediction of ensemble members. The tree recursively adds branches such that for each branch, from the root to the terminal node, the stumps {h1,h2,...,ht}from the Adaboost ensemble are assigned, and it pairs each node of the decision tree with a particular attribute and the corresponding threshold.

Within the scope of this project, two Mediboost methods are considered: MediAdaboost and LikelihoodMediboost. The differences between these two algorithms are the methods used to build the boosting framework -- MediAdaboost (MAB), uses additive Logistic Regression and LikelihoodMediboost (LMB), uses gradient boosting. MAB is more basic and similar to the original Adaboost algorithm, while LMB generally has more accurate trees  (Valdes, G. et al.,2016).


# Results:

3.1 Feature Engineering Results
3.1.1 PCA Results
Principal components (PCs) are sorted by the percentage of variance each component includes for the entire dataset. The percentage of total variance each PC contains is shown in Figure 1 below. The first PC contains 58.7% of total variance and the second PC contains 3.7% of total variances, and so on. For example, if 90 percent of total variance should be retained, first 28 PCs can be chosen as features. As a result, five thousand genes are reduced to 28 PCs which describe 90% of the total variance within our dataset. After the quantity of PCs is determined, we examined the relationship between selected PCs and corresponding genes.

For each PC, the sum of square of each genes equals 1 and the sign of each gene reflects their effect. For example, -0.0016 means that this gene has negative effect on PC1 while 0.0024 denotes that it has positive effect. In addition, larger absolute values of each gene indicates greater influence on the PC (Michael K. K. Leung, Andrew Delong, Babak Alipanahi, and Brendan J. Frey, 2016). This covariance matrix identifies genes of high significance in relation to weight loss which can be utilized in further studies.

3.1.2 KEGG results
From this process, 302 pathways were identified in the KEGG database that contained the genes that were expressed and measured in the study. Once the number of genes that were expressed during the study were counted in each pathway, we converted these counts to percentages of expressed genes per pathway. At this point it was decided that the pathways that were going to be used as features in the modeling process were the ones that contained more than 70% of the genes of the pathway. These pathways were filtered out and then included as features in the modeling process to quantify importance in weight loss.

3.2 Results from Machine Learning Models
3.2.1 Logistic Regression with 10 random states
Logistic regression was applied to predict weight loss based on demographic information, step-count, and gene expression. The training and testing data ratio was set to 7:3. Due to small sample size of the dataset, training and test data were split with 10 different random states. The preliminary prediction was performed on demographic information of each patient, and it presented a prediction accuracy of 60.8%. After adding step-count data into the modeling, the accuracy increased slightly to 64.2% since daily exercise is one of the key factors during weight loss process. Furthermore, both PCA and KEGG features of gene expression were incorporated into the model. For logistic regression, feature selection using PCA enhances prediction accuracy to 72.5% while KEGG feature selection decreases prediction accuracy to 60.8%.
3.2.2 Logistic Regression with Cross-Validation
To ensure the reliability of the prediction model accuracy, cross validation was performed on logistic regression model (with fold=3, same as in Random Forest). For the KEGG feature engineering data, the cross-validation Logistic Regression method achieves an accuracy of 71% for correctly predicting a person to be in class 0. In comparison, the accuracy is 43% when predicting a person to be in class 1, which is not a valid result (worse than random guess).

For the PCA data, the cross-validation method gives an accuracy of 77% for correctly predicting a person in class 0. The accuracy for predicting person in class 1 is 59%. We expect Logistic Regression using cross validation to be more accurate compared to Logistic Regression without because it gives prediction results on the basis of larger data evaluation. On the other hand, cross validation hinders interpretability in regards to comparing feature importance between models.

3.2.4 Support Vector Machines
To select the optimal hyperparameters for the SVM models, a grid search cross validation algorithm was used to compare approximate performance of SVM models considering a linear kernel, a polynomial kernel, and rbf kernel using C-values ranging from 0.1 - 100, gamma options between ‘scale’ or ‘auto’, and degree values ranging from 1 -10. The highest mean test performance for SVM amongst KEGG models utilized continuous demographic, step-count, and pathway values. The highest mean test performance amongst PCA models used continuous input and had been normalized using StandardScaler() prebuilt function in Scikit Learn. A total of twelve SVM models were ran to examine effects of binning, normalization, and feature combinations. The modeling results were evaluated using Accuracy, Precision, Recall, f1 scoring metrics and the test accuracy, which were computed using prebuilt packages in Scikit-Learn.

For each model, test scores were summarized as the average performance of each model summed across 300 different random states. Surprisingly, the top performing models are the most basic - the ones containing only demographic data or demographic data and step-count data. Models constructed from KEGG features performed very poorly in both precision and recall which makes them unreliable. A PCA model that incorporates normalized continuous input performs the best of all feature selection models and is in comparable performance to the more basic models. These test results indicate that an SVM model that uses KEGG pathways or PCA for feature selection is unlikely to perform better than a baseline SVM model using only demographic or demographic and step-counts data.

3.2.5 Random Forests
Random Forests are used to uncover the importances of the features. In order to identify the hyperparameters that would maximize the predicting accuracy, 5-fold cross validation was performed on the data. The decrease in impurity in the nodes is calculated by the reduction of  entropy in the model as the splits occur on an attribute. Random Forests were applied to an increasing number of features. At first, the model was applied to only the demographic data (BMI, Age, Sex) and the behavioral group (Blue/Red). As a next step the step-counts were incorporated into the model. From this analysis, it was found that the most important demographic and behavioral features were the number of steps, the age and the BMI of the subject, and that the gender did not play a significant role when determining weight loss. 

When using the PC’s as features, there was an increase in the prediction accuracy in comparison to when pathway metrics were used as features. The reason behind the lower than expected accuracies is due to an imbalance of classes in the dataset used for analysis. Specifically, there were twice as many subjects in the dataset that did not lose weight, than those who did. Random Forests are known to not be well suited for problems in which classes are imbalanced given the way its decision function is formulated. When the dataset was balanced using oversampling, the accuracies increased dramatically, but this idea was abandoned because oversampling might not reflect the real weight loss percentages in the population. 

3.2.7 MediBoost
The output for the Mediboost models include training and test accuracies and a tree graph for decision splits. In the Mediboost models, one tunable parameter is ‘DepthLimit’, which decides the maximum depth of the classification tree. By changing DepthLimit from 1 to 7, the model generates different classification trees with different accuracy scores. This process is applied to both demographic data using PCA for feature selection and demographic data using KEGG for feature selection.

From the table it can be seen that the accuracy tends to increase as depth limit increases. While, in the Mediboost model, as cross validation is not applicable, there’s a limitation that the reliability of test accuracies are not high because of small test dataset.
When it comes to interpretability in Mediboost models, features in higher branches in the tree graph (the upper nodes) are considered to be more important.

# Discussion:

After performing hyperparameter tuning to all the models, their performances were measured with accuracy, precision, recall, F1 score and AUC scores. Since there was an imbalance in the dataset (30% in class 1 and 70% in class 0), precision and recall were calculated to understand whether the models were successful in predicting true positives, which is a more reliable method for evaluating scenarios with such class imbalance. By calculating these values, it was apparent that Mediboost had greater accuracy predictions than the other models, both in using the PC’s and the pathways as features. 

To interpret the results of all models, cross comparison of feature importance from different models are done. It gives a rough idea about which features are most significant in this weight loss classification problem. Furthermore, if there exists some important PC features or KEGG features, what genes are relevant to those features, and what are the biological meanings of these features are both very important and interesting questions.


# Future Steps:
After modeling accuracy comparison and interpretation, the most important genes and demographic feature and KEGG features are pulled out from the perplexing raw data. Some models perform well from a prediction accuracy perspective, and others can be interpreted more directly. Here is a brief overview of future steps based on the current process:

## Get caloric intake in the 18-month trial as another feature and get more samples.
Data limitation is the main problem from the beginning to the end. 60 people’s demographic data plus genomic data is a very small sample size for machine learning tasks. Caloric intake, although hard to measure, is an important feature in the weight loss process. The lack of this information will decrease the conviction of the modeling results.

## Increase interpretation for models.
The first round interpretations are influenced by some ambiguous factors, which can be caused by different training and test set split processes (different random states will result in different data split results). In this case, try multiple times to get an average accuracy and summarize the most frequently appeared features as more important ones is the chosen way. Maybe smarter methods can be explored to deal with such case resulting from small dataset for better interpretation. Also, in this case, positive or negative influences are not distinguished in interpretation part. As the listed important features can have either positive or negative influence towards one’s weight loss progress and here we can do a preciser interpretation.

## Modeling with different feature selection processes
In the modeling part, same genomic features are applied to different models, namely 5 principle components or 7 pathways. The reason for such selection is because they can represent over 70% of the genomic information which is considered to be enough. If possible, different feature combinations can be selected for same the modeling processes, and accuracies or interpretation may vary in those cases.








# Credits: 
Authors: India Bergeland, Marikita Marinaki, Lan Wei, Yiran Li, Siyuan Xue
Advisors: Elena Flowers, Kord Kober, Anil Answani
